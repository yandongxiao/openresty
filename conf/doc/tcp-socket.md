# Tcp Socket


## receive

### 文档简介

以下函数调用失败时，会在error.log中记录相关的日志。

#### receive

- 可以指定read pattern 和 read size；
- 如果是数字或数字字符串，则读区指定size大小的内容；如果size为0，程序正常执行，返回值空
- 如果是非数字，那么认为是pattern。```*l```：读取一行的内容，末尾的\r\n丢弃掉； ```*a```读取所有的内容，直到connection关闭。
- 默认的pattern是```*l```
- 和send方法类似，是同步操作，但是非阻塞；
- In case of success, it returns the data received; in case of error, it returns nil with a string describing the error and the partial data received so far. 所以通过第一个参数来判断是否读取完毕是正确的，其次，注意第三个参数。
- 当出现读取错误，一般read操作返回之前会close connection；唯一一个例外的错误是timeout。 此时会在日志中有alert日志.

#### connect
- 在connect之前会进行hostname resolve操作
- 在connect之前会查看连接池
- 如果connect指定的第一个参数是domain name， 那么需要借助resolver指令来完成IP地址解析，如```resolver 8.8.8.8;```。否则，返回错误。
- In case of error, the method returns nil followed by a string describing the error. ***在进行LUA编程时注意，一般通过第一个参数来断定操作是否成功。***
- Calling this method on an already connected socket object will cause the original connection to be closed first. 所以connect操作时不可重入的。

## sock:receive

```
=== TEST 1: sanity
--- config
    server_tokens off;
    location /t {
        #set $port 5000;
        set $port $TEST_NGINX_SERVER_PORT;

        content_by_lua '
            local sock = ngx.socket.tcp()
            local port = ngx.var.port
            local ok, err = sock:connect("127.0.0.1", port)
            if not ok then
                ngx.say("failed to connect: ", err)
                return
            end

            ngx.say("connected: ", ok)

            local req = "GET /foo HTTP/1.0\\r\\nHost: localhost\\r\\nConnection: close\\r\\n\\r\\n"
            -- req = "OK"

            local bytes, err = sock:send(req)
            if not bytes then
                ngx.say("failed to send request: ", err)
                return
            end

            ngx.say("request sent: ", bytes)

            while true do
                local line, err, part = sock:receive()
                if line then
                    ngx.say("received: ", line)
                else
                    ngx.say("failed to receive a line: ", err, " [", part, "]")
                    break
                end
            end
            ok, err = sock:close()
            ngx.say("close: ", ok, " ", err)
        ';
    }

    location /foo {
        content_by_lua 'ngx.say("foo")';
        more_clear_headers Date;
    }

--- request
GET /t
--- response_body
connected: 1
request sent: 57
received: HTTP/1.1 200 OK
received: Server: nginx
received: Content-Type: text/plain
received: Content-Length: 4
received: Connection: close
received:
received: foo
failed to receive a line: closed []
close: 1 nil
--- no_error_log
[error]
```
> 注意
> - 这是一个TCP Socket，所以是流数据. 需要通过while循环的方式读取响应(或指定```*a```模式)。
> - ```local line, err, part = sock:receive()```通过第一个参数line来判断是否还存有数据。
> - 最后的error表明，是对端关闭了套接字。
> - 如果将foo location当中的ngx.say修改为ngx.print，那么最后一次tcp socket最后一次读取到的数据存在part当中。


### lua_socket_buffer_size

```
=== TEST 14: receive by chunks (very small buffer)
--- timeout: 5
--- config
    server_tokens off;
    lua_socket_buffer_size 1;
    location /t {
        #set $port 5000;
        set $port $TEST_NGINX_SERVER_PORT;

        content_by_lua '
            local sock = ngx.socket.tcp()
            local port = ngx.var.port
            local ok, err = sock:connect("127.0.0.1", port)
            if not ok then
                ngx.say("failed to connect: ", err)
                return
            end

            ngx.say("connected: ", ok)

            local req = "GET /foo HTTP/1.0\\r\\nHost: localhost\\r\\nConnection: close\\r\\n\\r\\n"
            -- req = "OK"

            local bytes, err = sock:send(req)
            if not bytes then
                ngx.say("failed to send request: ", err)
                return
            end

            ngx.say("request sent: ", bytes)

            while true do
                local data, err, partial = sock:receive(10)
                if data then
                    local len = string.len(data)
                    if len == 10 then
                        ngx.print("[", data, "]")
                    else
                        ngx.say("ERROR: returned invalid length of data: ", len)
                    end

                else
                    ngx.say("failed to receive a line: ", err, " [", partial, "]")
                    break
                end
            end

            ok, err = sock:close()
            ngx.say("close: ", ok, " ", err)
        ';
    }

    location /foo {
        content_by_lua 'ngx.say("foo")';
        more_clear_headers Date;
    }
--- request
GET /t
--- response_body eval
"connected: 1
request sent: 57
[HTTP/1.1 2][00 OK\r
Ser][ver: nginx][\r
Content-][Type: text][/plain\r
Co][ntent-Leng][th: 4\r
Con][nection: c][lose\r
\r
fo]failed to receive a line: closed [o
]
close: 1 nil
"
--- no_error_log
[error]
```
> 注意
> sock:receive(10)起到了作用，而不是lua_socket_buffer_size；
> sock:receive()也祈祷了作用，而不是lua_socket_buffer_size 1;
> 所以，lua_socket_buffer_size随然每次只是缓存1个字节，但是上层的函数时无感的。

### test 19
```
=== TEST 19: cannot survive across request boundary (send)
--- http_config eval
    "lua_package_path '$::HtmlDir/?.lua;./?.lua';"
--- config
    server_tokens off;
    location /t {
        #set $port 5000;
        set $port $TEST_NGINX_MEMCACHED_PORT;

        content_by_lua '
            local test = require "test"
            test.go(ngx.var.port)
        ';
    }
--- user_files
>>> test.lua
module("test", package.seeall)

local sock
function go(port)
    if not sock then
        sock = ngx.socket.tcp()
        local port = ngx.var.port
        local ok, err = sock:connect("127.0.0.1", port)
        if not ok then
            ngx.say("failed to connect: ", err)
            return
        end

        ngx.say("connected: ", ok)
    end

    local req = "flush_all\r\n"

    local bytes, err = sock:send(req)
    if not bytes then
        ngx.say("failed to send request: ", err)
        return
    end
    ngx.say("request sent: ", bytes)

    local line, err, part = sock:receive()
    if line then
        ngx.say("received: ", line)

    else
        ngx.say("failed to receive a line: ", err, " [", part, "]")
    end
end
--- request
GET /t
--- response_body_like eval
"^(?:connected: 1
request sent: 11
received: OK|failed to send request: closed)\$"
--- ONLY
```

注意：以上代码生成的nginx.conf文件，执行curl命令两次，第二次输出内容如下：
```
failed to send request: closed
```
> 在LUA模块内创建了一个tcp socket，由于LUA code缓存，第一次执行curl命令后，sock不再等于nil；但是sock的生命周期也是当前请求，所以该socket实际上已经被close掉了
> 第二次执行curl命令，并没有重新connect，而是直接发送请求，所以返回了上面的错误。


## Test 35
```
=== TEST 35: connection refused (tcp) - lua_socket_log_errors off
--- config
    location /test {
        lua_socket_log_errors off;
        content_by_lua '
            local sock = ngx.socket.tcp()
            local ok, err = sock:connect("127.0.0.1", 16787)
            ngx.say("connect: ", ok, " ", err)

            local bytes
            bytes, err = sock:send("hello")
            ngx.say("send: ", bytes, " ", err)

            local line
            line, err = sock:receive()
            ngx.say("receive: ", line, " ", err)

            ok, err = sock:close()
            ngx.say("close: ", ok, " ", err)
        ';
    }
--- request
    GET /test
--- response_body
connect: nil connection refused
send: nil closed
receive: nil closed
close: nil closed
--- no_error_log eval
[qr/connect\(\) failed \(\d+: Connection refused\)/]
```
默认情况下，lua socket返回错误时，会向日志文件写内容。通过lua_socket_log_errors即可关闭。

## Test 50

```
=== TEST 50: cosocket resolving aborted by coroutine yielding failures (require)
--- http_config
    lua_package_path "$prefix/html/?.lua;;";
    #resolver $TEST_NGINX_RESOLVER;
    resolver "8.8.8.8";

--- config
    location = /t {
        content_by_lua '
            package.loaded.myfoo = nil
            require "myfoo"
        ';
    }
--- request
    GET /t
--- user_files
>>> myfoo.lua
local sock = ngx.socket.tcp()
local ok, err = sock:connect("agentzh.org")
if not ok then
    ngx.log(ngx.ERR, "failed to connect: ", err)
    return
end

--- response_body_like: 500 Internal Server Error
--- wait: 0.3
--- error_code: 500
--- error_log
resolve name done
runtime error: attempt to yield across C-call boundary
--- no_error_log
[alert]
--- ONLY
```

```
=== TEST 51: cosocket resolving aborted by coroutine yielding failures (xpcall err)
--- http_config
    lua_package_path "$prefix/html/?.lua;;";
    resolver $TEST_NGINX_RESOLVER;

--- config
    location = /t {
        content_by_lua '
            local function f()
                return error(1)
            end
            local function err()
                local sock = ngx.socket.tcp()
                local ok, err = sock:connect("agentzh.org")
                if not ok then
                    ngx.log(ngx.ERR, "failed to connect: ", err)
                    return
                end
            end
            xpcall(f, err)
            ngx.say("ok")
        ';
    }
--- request
    GET /t
--- response_body
ok
--- wait: 0.3
--- error_log
resolve name done
--- no_error_log
[error]
[alert]
could not cancel
```

Test 50和51想证明什么？