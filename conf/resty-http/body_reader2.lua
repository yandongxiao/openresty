local http = require "resty.http"

local function do_exit(status, errmsg)
    ngx.status = status
    ngx.say(errmsg)
    ngx.exit(ngx.HTTP_OK)
end

local httpc, err = http:new()
if httpc == nil then do_exit(ngx.HTTP_INTERNAL_SERVER_ERROR, err) end

--[[
-- 相比于1，我们采用了 connect ＋ request 两个方法，可以更多的控制连接
--]]
local ok , err = httpc:connect("192.168.1.76", 80)  -- 注意这里没有scheme，其次要指定端口号
if not ok then do_exit(ngx.HTTP_INTERNAL_SERVER_ERROR, err) end

local res, err = httpc:request({path=ngx.var.uri})
if res == nil then do_exit(ngx.HTTP_INTERNAL_SERVER_ERROR, err) end

ngx.header["Content-Type"] = res.headers["Content-Type"]
ngx.header["Content-Length"] = res.headers["Content-Length"]
ngx.header["Connection"] = res.headers["Connectione"]
ngx.header["Last-Modified"] = res.headers["Last-Modified"]
ngx.header["Accept-Ranges"] = res.headers["Accept-Ranges"]

--[[
-- 上一个模块的最大问题在于：它有点像代理，但是又很笨拙。需要把请求获取完毕以后，才能返回给客户端
-- 能否流式地返回数据，是这次试验的重点.
--
if res.has_body then
    -- res.status == 200
    -- res.reason == OK
    -- res.headers 是在上面进行了输出
    ngx.log(ngx.ERR, res.reason)
end
--]]

--一次性把所有数据读取到内存
--body, err = res:read_body()
--    if body == nil then do_exit(500, "") end
--ngx.print(body)

--
-- 部分读取数据内容，确保body占用的内存可控
--
local reader = res.body_reader
repeat
    local chunk, err = reader(1024000) -- 到这边就block住了
    if err then
        ngx.log(ngx.ERR, err)
        break
    end
    if chunk then
        ngx.log(ngx.ERR, ngx.md5(chunk))
        ngx.print(chunk)
    end
until not chunk
