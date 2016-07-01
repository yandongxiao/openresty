--[[
--  http redis 模块的set_timeout函数都是基于tcpsock的settimeout函数实现的
--  该connect对于connect, send, receive 都起作用
--  对于receive来说，timeout是指在指定的时间内没有收到任何数据。它不是指必须在这个时间内读完数据
--  对于send来说, 并非指以下两种情况：1.指定时间内写完数据；2.在指定时间内对端接收数据; 只是指发送出去k
--  connect就是连接超时的时间
--
--  我们可以阅读测试代码，来学习API
--]]
local http = require "resty.http"

local function do_exit(status, errmsg)
    ngx.status = status
    ngx.say(errmsg)
    ngx.exit(ngx.HTTP_OK)
end

local function check_err(err)
    if err then do_exit(500, err) end
end

-- create the http client
local httpc, err = http:new()
check_err(err)

-- set the attribute: timeout
local ok, err = httpc:set_timeout(100)
check_err(err)

-- connect to the server
local ok, err = httpc:connect("127.0.0.1", 8001)
--local ok, err = httpc:connect("agentzh.org", 12345)
check_err(err)

-- send request and receive reply
res, err = httpc:request({method="POST", path=ngx.var.uri, body="helloworld"})
check_err(err)

ngx.print(res:read_body())

--ok, err = httpc:close()
--check_err(err)
