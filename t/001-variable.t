use Test::Nginx::Socket::Lua "no_plan";
no_long_string();
run_tests();

__DATA__

=== TEST 1: can be accumulative (from module)
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

=== TEST 2: can not be accumulative(from set command)

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

=== TEST 3: can not be accumulative(from global variable)
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

=== TEST 4: global value is deleted before log_by_lua
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

=== TEST 5: the module vvariable can ben accessed by different phase
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
