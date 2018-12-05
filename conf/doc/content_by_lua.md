# Content_by_lua 指令

点击[这里](https://github.com/openresty/lua-nginx-module#content_by_lua)查看官方文档

##  文档简介

- 在独立的coroutine中运行，可以调用大部分的Nginx API
- 不可与其他content handler混合使用，例如proxy_pass
- 可以通过ngx.location.capture发起Subrequest

## 测试文件002-content.t

### Test 6

```
  === TEST 6: calc expression
  --- config
      location /lua {
          content_by_lua_file html/calc.lua;
      }
  --- user_files
  >>> calc.lua
  local function uri_unescape(uri)
      local function convert(hex)
          return string.char(tonumber("0x"..hex))
      end
      local s = string.gsub(uri, "%%([0-9a-fA-F][0-9a-fA-F])", convert)
      return s
  end

  local function eval_exp(str)
      return loadstring("return "..str)()
  end

  local exp_str = ngx.var["arg_exp"]
  -- print("exp: '", exp_str, "'\n")
  local status, res
  status, res = pcall(uri_unescape, exp_str)
  if not status then
      ngx.print("error: ", res, "\n")
      return
  end
  status, res = pcall(eval_exp, res)
  if status then
      ngx.print("result: ", res, "\n")
  else
      ngx.print("error: ", res, "\n")
  end
  --- request
  GET /lua?exp=1%2B2*math.sin(3)%2Fmath.exp(4)-math.sqrt(2)
  --- response_body
  result: -0.4090441561579
```
> 注意
> - ngx.var["xxx"] 是没有进行URL Decode的
> - eval_exp 执行一个表达式并返回结果
> - 通过pcall，防止因为输入的非法性，而导致Lua抛出异常。

### Test 9

```
ei= TEST 9: capture non-existed location
--- config
    location /lua {
        content_by_lua 'res = ngx.location.capture("/other"); ngx.print("status=", res.status)';
    }
--- request
GET /lua
--- response_body: status=404
```

- ngx.location.capture发起的subrequest不存在，此时返回404错误。
- 不能传递nil值给ngx.location.capture，否则发生500错误，详情参见test 12.

### Test 14

```
=== TEST 14: capture location
--- config
 location /recur {
       content_by_lua '
           local num = tonumber(ngx.var.arg_num) or 0;
           ngx.print("num is: ", num, "\\n");

           if (num > 0) then
               res = ngx.location.capture("/recur?num="..tostring(num - 1));
               ngx.print("status=", res.status, " ");
               ngx.print("body=", res.body);
           else
               ngx.print("end\\n");
           end
           ';
   }
--- request
GET /recur?num=3
--- response_body
num is: 3
status=200 body=num is: 2
status=200 body=num is: 1
status=200 body=num is: 0
end
```
> 注意
> - ngx.location.capture 可以发起递归调用
> - 递归调用会不会导致堆栈缓冲区溢出？ 可能要到ngx.location.capture中寻找答案。

### Test 15

```
=== TEST 15: setting nginx variables from within Lua
--- config
 location /set {
       set $a "";
       content_by_lua 'ngx.var.a = 32; ngx.say(ngx.var.a)';
       add_header Foo $a;
   }
--- request
GET /set
--- response_headers
Foo: 32
--- response_body
32
```
> 注意
> - add_header 执行的阶段是在output-header-filter，而且它不是ngx_lua_module
> - 注意与header_filter_by_lua的比较，等价形式如下```header_filter_by_lua 'ngx.header.Foo=ngx.var.a';```


### test 19

```
=== TEST 19: subrequests do not share variables of main requests by default
--- config
location /sub {
    content_by_lua 'ngx.print(ngx.var.a)';
}
location /parent {
    set $a 12;
    content_by_lua 'res = ngx.location.capture("/sub"); ngx.say(res.body)';
}
--- request
GET /parent
--- response_body eval: "\n"
--- ONLY
```
> 注意
> - 在subrequest /sub中， a并不是undefined，而是为空。证明：给ngx.print直接传递nil，返回nil字符串。而上面的case表明子请求返回为空
> - 注意如果response只返回一个换行符时，Test::Nginx是如何表达的response_body。

### test 27

```
=== TEST 27: HTTP 1.0 response
--- config
    location /lua {
        content_by_lua '
            data = "hello, world"
            -- ngx.header["Content-Length"] = #data
            -- ngx.header.content_length = #data
            ngx.print(data)
        ';
    }
    location /main {
        proxy_pass http://127.0.0.1:$server_port/lua;
    }
--- request
GET /main
--- response_headers
Content-Length: 12
--- response_body chop
hello, world
--- ONLY
```
> 注意
> - 作为代理，它向后端默认发起了HTTP 1.0的请求，即总是返回Content-length字段
> - 同理，代理本身也会把Content-Length返回给客户端, 虽然它们之间通信采用的是HTTP 1.1
> - 如果Nginx直接作为HTTP Server，那么与客户端之间的通信默认采用HTTP 1.1，一个重要的字段就是Transfer-Encoding: chunked.
> - Nginx若希望以HTTP 1.0协议发送相应，只需要添加Content-length头部即可
> - chop 与 chomp 是类似的filter

### echo_location

```
location /main {
     echo_reset_timer;
     echo_location /sub1;
     echo_location /sub2;
     echo "took $echo_timer_elapsed sec for total.";
 }
 location /sub1 {
     echo_sleep 2;
     echo hello;
 }
 location /sub2 {
     echo_sleep 1;
     echo world;
 }
```
> 注意
> - echo_location 发起的是同步的subrequest
> - 通过echo_reset_timer可以判断子请求所消耗的时间，以秒为单位，但是能精确到毫秒

### Test 34

```
=== TEST 34: HEAD & ngx.say
--- config
    location /lua {
        content_by_lua '
            ngx.send_headers()
            local ok, err = ngx.say(ngx.headers_sent)
            if not ok then
                ngx.log(ngx.WARN, "failed to say: ", err)
                return
            end
        ';
    }
--- request
HEAD /lua
--- response_body
--- no_error_log
[error]
--- error_log
failed to say: header only
```
> 注意
> - 发送HEAD请求时，ngx.say、ngx.print等函数就会执行失败
> - 但是，以上函数失败并不会想error.log中写日志内容

## Test 36

```
=== TEST 36: headers_sent + GET
--- config
    location /lua {
        content_by_lua '
            -- print("headers sent: ", ngx.headers_sent)
            ngx.say(ngx.headers_sent)
            ngx.say(ngx.headers_sent)
            -- ngx.flush()
            ngx.say(ngx.headers_sent)
        ';
    }
--- request
GET /lua
--- response_body
false
true
true
```
> 注意： response header发送的时机

### Test 38

```
=== TEST 38: ngx.print table arguments (github issue #54)
--- config
    location /t {
        content_by_lua 'ngx.print({10, {0, 5}, 15}, 32)';
    }
--- request
    GET /t
--- response_body chop
10051532
```
> 注意，ngx.print or ngx.say可以接收一个table作为参数


### Test 40

```
=== TEST 40: Lua file does not exist
--- config
    location /lua {
        content_by_lua_file html/test2.lua;
    }
--- user_files
>>> test.lua
v = ngx.var["request_uri"]
ngx.print("request_uri: ", v, "\n")
--- request
GET /lua?a=1&b=2
--- response_body_like: 404 Not Found
--- error_code: 404
--- error_log eval
qr/failed to load external Lua file ".*?test2\.lua": cannot open .*? No such file or directory/
```
> 注意：当content_by_lua_file指定的文件不存在，返回的错误是404。