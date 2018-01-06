local function do_exit(status, errmsg)
    ngx.status = status
    ngx.say(errmsg)
    ngx.exit(ngx.HTTP_OK)
end


local http = require "resty.http"
local httpc = http:new()
local res, err = httpc:request_uri("http://192.168.1.76" .. ngx.var.uri)

if not res then do_exit(ngx.HTTP_INTERNAL_SERVER_ERROR, err) end

--[[
-- 发起request_uri请求时，不会继承上一个请求的任何内容
-- 返回的Header和body也需要自己来设置
--]]

--
-- 问题，比较奇怪的是，一个头部会在响应中出现两次！！
-- 从输出内容可以看出，ngx.header目前是一个空表
--[[
for k,v in pairs(ngx.header) do
    ngx.log(ngx.ERR, k, v)
end
ngx.log(ngx.ERR, "--")
for k,v in pairs(res.headers) do
    ngx.log(ngx.ERR, k, v)
end
]]

-- 这样的设置就可以
--ngx.header["Content-Length"] = #res.body
ngx.header["Content-Type"] = res.headers["Content-Type"]

ngx.print(res.body)
