# set_by_lua 指令

通过官方文档和测试代码，[文档](https://github.com/openresty/lua-nginx-module#set_by_lua)地址。

## 内容简介

- 该指令可以接受参数```set_by_lua $res <lua-script-str> [$arg1 $arg2 ...]```，注意参数的位置是在最后;
- 可以调用大部分的[Nginx API](https://github.com/openresty/lua-nginx-module#nginx-api-for-lua)，即以ngx.xxx开头的接口，如ngx.var.num;
- set_by_lua指定的code并没有在自己的coroutine当中运行，而是在主线程中运行，所以并不适合调用网络IO操作，也不适合执行耗时的操作;
- 可以其它rewrite阶段的指令糅合在一起运行，执行顺序是配置文件书写的顺序;
- 可以直接使用$符号。

## 测试文件总结

### test case 4

```
 === TEST 4: inlined script with arguments
--- config
    location /lua {
        set_by_lua $res "return ngx.arg[1] + ngx.arg[2]" $arg_a $arg_b;
        echo $res;
    }
--- request
GET /lua?a=1&b=2
--- response_body
3
--- no_error_log
[error]
```
> 注意set是如何引用参数的。
> - 发送的请求包含请求参数a和b，那么在Nginx下被引用的方法是$arg_a和$arg_b；
> - 传递给set_by_lua以后，通过ngx.arg[1]和ngx.arg[2]方法引用；
> -  set_by_lua 可以直接饮用外部变量，通过 ngx.var.xxx的方法。；
> － set_by_lua_file 也是可以接收参数的，但是set_by_lua_block就不可以；
> - 传递给set_by_lua的参数类型是字符串，不过如果a+b都是数字，LUA会自动进行类型转换。

### test case 9

```
=== TEST 9: set non-existent nginx variables
--- config
    location = /set-both {
        #set $b "";
        set_by_lua $a "ngx.var.b = 32; return 7";

        echo "a = $a";
    }
--- request
GET /set-both
--- response_body_like: 500 Internal Server Error
--- error_code: 500
--- error_log
variable "b" not found for writing; maybe it is a built-in variable that is not changeable or you forgot to use "set $b '';" in the config file to define it first

```

> 注意
> - set_by_lua 可以直接对外部变量进行SET操作
> - 但是，SET一个外部不存在的变量，那么脚本会崩溃，返回500
> - 但是，GET操作不受第二条的影响；

### 调用IO相关的API
```
=== TEST 13: no ngx.say
--- config
    location /lua {
        set_by_lua $res "ngx.say(32) return 1";
        echo $res;
    }
--- request
GET /lua
--- response_body_like: 500 Internal Server Error
--- error_code: 500
--- error_log
API disabled in the context of set_by_lua*
```

> 注意
> - 任何与网络IO相关的函数调用都会导致500错误
> - ngx.location.capture, ngx.exita, ngx.redirect, ngx.exec, ngx.req.set_uri(uri, true), ngx.req.read_body。不允许发起重定向、子请求、内部重定向；
> - 在rewrite阶段是可以发起请求的， 参见[ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)模块的rewrite指令。

### test case 37

```
=== TEST 37: globals get cleared for every single request
--- config
    location /lua {
        set_by_lua $res '
            if not foo then
                foo = 1
            else
                foo = foo + 1
            end
            return foo
        ';
        echo $res;
    }
--- request
GET /lua
--- response_body
1
--- no_error_log
[error]
```
> 注意
> - 在set_by_lua中定义的全局变量，只是针对这个请求；
> - 在server{}中可以使用set_by_lua函数，它的声明周期也是一个请求的；
> - 可以于if指令一起使用


## 练习

在server{}内通过set_by_lua指令，设置的全局变量或这局部变量的生命周期是什么?

```
=== TEST 301: server scope (file)
--- config
    location /foo {
        set_by_lua_block $ret{
            if ngx.var.val then
                ngx.var.val = ngx.var.val + 1
                return ngx.var.val
            end
            return "foo"
        }
        content_by_lua 'ngx.print(ngx.var.ret)';
    }

    location /bar {
        set_by_lua_block $ret {
            if ngx.var.val then
                ngx.var.val = ngx.var.val + 1
                return ngx.var.val
            end
            return "bar"
        }
        content_by_lua 'ngx.print(ngx.var.ret)';
    }

    set_by_lua_file $val html/a.lua;

--- user_files
>>> a.lua
ngx.log(ngx.ERR, "AAA")
return 1+1
--- pipelined_requests eval
["GET /foo", "GET /bar"]
--- response_body eval
[3, 3]

```
答案应该是当前请求。所以：无论在何处设置的全局变量，它的生命周期只会与当前请求一致。

那么是不是每次请求到来都会执行一次set_by_lua的代码呢，即使它是在server返回内？通过人工观察发现执行了两次set_by_lua_block.

本来打算通过grep_error_log和grep_error_log_out指令进行测试：
```
=== TEST 301: server scope (file)
--- config
    location /foo {
        set_by_lua_block $ret{
            if ngx.var.val then
                ngx.var.val = ngx.var.val + 1
                return ngx.var.val
            end
            return "foo"
        }
        content_by_lua 'ngx.print(ngx.var.ret)';
    }

    location /bar {
        set_by_lua_block $ret {
            if ngx.var.val then
                ngx.var.val = ngx.var.val + 1
                return ngx.var.val
            end
            return "bar"
        }
        content_by_lua 'ngx.print(ngx.var.ret)';
    }

    set_by_lua_file $val html/a.lua;

--- user_files
>>> a.lua
ngx.log(ngx.ERR, "AABB")
return 1+1
--- pipelined_requests eval
["GET /foo", "GET /bar"]
--- response_body eval
[3, 3]
--- grep_error_log: AABB
--- grep_error_log_out
AABB
AABB
--- ONLY
```

报告的错误如下：
```
#   Failed test 'TEST 301: server scope (file) - grep_error_log_out (req 0)'
#   at /usr/local/share/perl5/Test/Nginx/Socket.pm line 1048.
#          got: ""
#       length: 0
#     expected: "AABB\x{0a}AABB\x{0a}"
#       length: 10
#     strings begin to differ at char 1 (line 1 column 1)
# Looks like you failed 1 test of 6.
t/001-set.t .. Dubious, test returned 1 (wstat 256, 0x100)
Failed 1/6 subtests
```
但是仔细观察error.log，却是存在AABB两行内容的。

