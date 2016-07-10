use Test::Nginx::Socket::Lua "no_plan";
no_long_string();
run_tests();

__DATA__

=== TEST 1.0 set指令创建变量，但未初始化时，变量的类型为string，值为空
--- config
    location /lua {
        content_by_lua_block {
            ngx.print(ngx.var.num)
            ngx.say(type(ngx.var.num))
        }
    }
    location /bar {
        set $num 0;
    }

--- request
GET /lua
--- response_body
string
--- no_error_log
[error]

=== TEST 1.1 利用set指令创建的任何变量，变量类型都是string
--- config
    location /lua {
        set $num 10;
        content_by_lua_block {
            ngx.say(type(ngx.var.num))
        }
    }

--- request
GET /lua
--- response_body
string
--- no_error_log
[error]

=== TEST 1.2 Nginx下使用未创建的变量，Nginx直接拒绝启动
--- config
    location /lua {
        echo $num;
    }

--- request
GET /lua
--- must_die
--- error_log
unknown "num" variable

=== TEST 1.2.1 openresty下使用未创建的变量，返回nil字符串
--- config
    location /lua {
        content_by_lua_block {
            ngx.say(num)
        }
    }

--- request
GET /lua
--- response_body
nil
--- no_error_log
[error]

=== TEST 1.2.1 openresty通过ngx.var.xxx使用未创建的变量，也返回nil
--- config
    location /lua {
        content_by_lua_block {
            ngx.say(ngx.var.num)
        }
    }

--- request
GET /lua
--- error_code: 200
--- no_error_log
[error]

=== TEST 1.3: Nginx 变量的生命期是不可能跨越请求边界的，也包括Openresty定义的全局变量
--- config
    set $num 100;

    location /foo {
        set $num 1;
        echo $num;
    }
    location /bar {
        echo $num;
    }

--- pipelined_requests eval
["GET /foo", "GET /bar"]
--- response_body chop eval
["1\n", "100\n"]
--- no_error_log
[error]

=== TEST 2.0: 全局变量可跨越两个location（发生内部跳转），局部变量则不可以
发生内部跳转的指令有：rewrite指令，echo_exec指令和ngx.exec

--- config
    location /foo {
        set $num 1;
        rewrite /foo /bar last;
    }
    location /bar {
        echo $num;
    }
--- request
GET /foo
--- response_body
1
--- no_error_log
[error]

=== TEST 2.0.1: 全局变量可跨越两个location（发生内部跳转），局部变量则不可以
发生内部跳转的指令有：rewrite指令，echo_exec指令和ngx.exec

--- config
    location /foo {
        set $num 1;
        content_by_lua 'ngx.exec("/bar", {})';
    }
    location /bar {
        echo $num;
    }
--- request
GET /foo
--- response_body
1
--- no_error_log
[error]

=== TEST 2.0.2: 全局变量可跨越两个location（发生内部跳转），局部变量则不可以
发生内部跳转的指令有：rewrite指令，echo_exec指令和ngx.exec

--- config
    location /foo {
        set $num 1;
        echo_exec /bar;
    }
    location /bar {
        echo $num;
    }
--- request
GET /foo
--- response_body
1
--- no_error_log
[error]

=== TEST 2.1 内建变量 $uri 和 $request_uri 变量的区别
$uri只包含路径部分，$request_uri包含了路径和参数
$uri包含的路径已解码（unescaped）,  $request_uri则没有

--- config
    location ~ /fo.o {
        echo $uri;
        echo $request_uri;
    }
--- request
GET /fo%20o?name=hello%20world
--- response_body
/fo o
/fo%20o?name=hello%20world
--- no_error_log
[error]

=== TEST 2.2 变量arg_name可以引用 request argument name
注意name不管大小写如何变化，都是通过arg_name来引用的
--- config
    location ~ /foo {
        echo $arg_name;
    }
--- request
GET /foo?NaMe=hello
--- response_body
hello
--- no_error_log
[error]

=== TEST 2.2.1 变量arg_name如果有多个值，通过arg_name只能访问到第一个参数值
--- config
    location ~ /foo {
        echo $arg_name;
    }
--- request
GET /foo?NaMe=hello&name=world
--- response_body
hello
--- no_error_log
[error]

=== TEST 2.2.2 变量arg_name如果有多个值，通过ngx.var.arg_name得到的值跟$arg_name一样
--- config
    location ~ /foo {
        content_by_lua_block {
            ngx.say(type(ngx.var.arg_name))
            ngx.say(ngx.var.arg_name)
        }
    }
--- request
GET /foo?NaMe=hello&name=world
--- response_body
string
hello
--- no_error_log
[error]

=== TEST 2.2.3 变量arg_name如果有多个值，通过ngx.req.get_uri_args()["name"]可以获得一个table
--- config
    location ~ /foo {
        content_by_lua_block {
            ngx.say(type(ngx.req.get_uri_args()["name"]))
            ngx.say(ngx.req.get_uri_args()["name"])
        }
    }
--- request
GET /foo?name=hello&name=world
--- response_body
table
helloworld
--- no_error_log
[error]

=== TEST 3.0 内置变量在大多数情况下是不能被修改的，但是$args是一个例外
$args也被成为URL参数串
--- config
    location ~ /foo {
        set $args a=1&b=2;
        echo $arg_a;
        echo $arg_b;
    }
--- request
GET /foo?a=a&b=b
--- response_body
1
2
--- no_error_log
[error]

=== TEST 4.0 变量可以设置set handler, 并选择利用容器缓存结果。
--- http_config
map $key $val {
    default 0;
    key 1;
}

--- config
    location /foo {
        set $origin_val $val;
        set $key key;
        echo $origin_val;
        echo $val;  # 从缓存当中去数据
    }
--- request
GET /foo
--- response_body
0
0
--- no_error_log
[error]

=== TEST 5.0 变量在主请求和子请求是相互隔离的
--- config
    location /main {
        set $var main;
        content_by_lua_block {
            res = ngx.location.capture("/foo")
            ngx.print(res.body)
            res = ngx.location.capture("/bar")
            ngx.print(res.body)
            ngx.say("main: ", ngx.var.var)
        }
    } 

    location /foo {
        set $var foo;
        echo "foo: $var";
    }
 
    location /bar {
        set $var bar;
        echo "bar: $var";
    }
--- request
GET /main
--- response_body
foo: foo
bar: bar
main: main
--- no_error_log
[error]

=== TEST 6.0 大部分的内建变量是作用与当前请求的，比如说args和uri
--- config
    location /main {
        echo "main args: $args";
        echo "main uri: $uri";
        echo_location /sub name=sub;
    } 

    location /sub {
        echo "sub args: $args";
        echo "sub uri: $uri";
    }
 
--- request
GET /main?name=main
--- response_body
main args: name=main
main uri: /main
sub args: name=sub
sub uri: /sub
--- no_error_log
[error]

=== TEST 6.1 例外的内置变量有，比如request_method, request_uri
--- config
    location /main {
        echo "main request_uri: $request_uri";
        echo_location /sub;
    } 

    location /sub {
        echo "sub request_uri: $request_uri";
    }
 
--- request
GET /main
--- response_body
main request_uri: /main
sub request_uri: /main
--- no_error_log
[error]

=== TEST 7.0 变量分为三类：未定义的（lua nil），定义但未赋值的，定义且赋值的
直接使用为定义的变量，会导致Nginx启动不起来，并报错，这在之前的case已经介绍过了
变量被定义，但是当去读取缓存数据时，发现数据“不合法”；于是触发了get handler的调用，get handler
输出了下面的错误日志；返回空字符串并更新容器值.
--- config
    location /foo {
        echo $data;
    } 
    location /bar {
        set $data 1;
    }
--- request
GET /foo
--- response_body eval
"\n"
--- error_log
using uninitialized "data" variable

=== TEST 7.1 对于内置变量，例如arg_xxx，它的值为空字符串和“不存在”是无法在Nginx中区分的
--- config
    location /foo {
        echo $arg_a;
    } 
--- pipelined_requests eval
["GET /foo", "GET /foo?a="]
--- response_body eval
["\n", "\n"]

=== TEST 7.2 对于上面的问题，在Openresty下面是可以轻易解决
--- config
    location /foo {
        content_by_lua_block {
            if ngx.var.arg_a == nil then
                ngx.print("undefined")
            else
                ngx.print(ngx.var.arg_a)
            end
        }
    } 
--- pipelined_requests eval
["GET /foo", "GET /foo?a="]
--- response_body eval
["undefined", ""]

=== TEST 7.3  7.2的测试例子对与"GET /foo?a"无效
--- config
    location /foo {
        content_by_lua_block {
            if ngx.var.arg_a == nil then
                ngx.print("undefined")
            else
                ngx.print(ngx.var.arg_a)
            end
        }
    } 
--- pipelined_requests eval
["GET /foo", "GET /foo?a"]
--- response_body eval
["undefined", "undefined"]

=== TEST 7.4 7.3的解决办法如下
--- config
    location /foo {
        content_by_lua_block {
            if ngx.req.get_uri_args()["a"] == nil then
                ngx.print("undefined")
            else
                ngx.print(ngx.req.get_uri_args()["a"])
            end
        }
    } 
--- pipelined_requests eval
["GET /foo", "GET /foo?a"]
--- response_body eval
["undefined", "true"]	# 将/foo?a 当中的a当作一个boolean类型来处理

=== TEST 8.0 对于定义却未初始化的变量，与空字符串变量，无法区分
--- config
    location /foo {
        content_by_lua '
            if ngx.var.foo == nil then
                ngx.say("foo is nil")
            else
                ngx.say("foo = (", ngx.var.foo, ")")
            end
        ';
    }
    location /bar {
        set $foo 10;
    }
--- request
GET /foo
--- response_body
foo = ()
--- ONLY

=== TEST 9: 模块内定义的变量可以在多个请求之间共享
--- http_config
lua_package_path "${prefix}/html/?.lua";

--- config
    location /lua {
        content_by_lua '
            local m = require "a"
            m.num = m.num + 1
            ngx.print(m.num)
        ';
    }
--- user_files
>>> a.lua
local _M = {}
_M.num = 0
return _M

--- pipelined_requests eval
["GET /lua", "GET /lua"]
--- response_body eval 
[1, 2]
--- no_error_log
[error]


=== TEST 10: can not be accumulative(from set command)

--- config
    location /lua {
        content_by_lua_block {
            if ngx.var.num == "" then
                ngx.var.num = 0
            end
            ngx.var.num = ngx.var.num + 1
            ngx.print(ngx.var.num)
        }
    }
    location /bar {
        set $num 0;
    }

--- pipelined_requests eval
["GET /lua", "GET /lua"]
--- response_body eval 
[1, 1]
--- no_error_log
[error]

=== TEST 11: can not be accumulative(from global variable)
--- config
    location /lua {
        content_by_lua_block {
            num = num or 0 
            num = num + 1
            ngx.print(num)
        }
    }
--- pipelined_requests eval
["GET /lua", "GET /lua"]
--- response_body eval 
[1, 1]
--- no_error_log
[error]

=== TEST 12: global value is deleted before log_by_lua
--- config
    location /lua {
        content_by_lua_block {
            num = num or 0 
            num = num + 1
            ngx.print(num)
        }

        log_by_lua_block {
            ngx.log(ngx.ERR, "num is:", num)
        }
    }
--- request
GET /lua
--- error_code: 200
--- response_body: 1
--- error_log
num is:nil

=== TEST 13: the module vvariable can ben accessed by different phase
--- http_config
lua_package_path "${prefix}/html/?.lua";

--- config
    location /lua {
        content_by_lua '
            local m = require "a"
            if m.name == "" then
                m.name = "ydx"
            end
        ';
        
         log_by_lua_block {
            local m = require "a"
            ngx.log(ngx.ERR, "m.name=", m.name)
         }
    }
--- user_files
>>> a.lua
local _M = {}
_M.name = ""
return _M

--- request
GET /lua
--- error_code: 200
--- error_log
m.name=ydx
