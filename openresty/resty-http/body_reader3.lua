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

for k,v in pairs(res.headers) do
    ngx.header[k] = v
    ngx.log(ngx.ERR, tostring(k), ": ",tostring(v))
    if (k =="Transfer-Encoding") then   -- 是一个数组，value都是chunked字符串。
        for kk, vv in pairs(v) do
            ngx.log(ngx.ERR, kk, vv)
        end
    end
end

--[[
-- 上一个模块的最大问题在于：它有点像代理，但是又很笨拙。需要把请求获取完毕以后，才能返回给客户端
-- 能否流式地返回数据，是这次试验的重点.
--
-- 上层添加transfer－encoding头，对数据内容分块传输
-- 通过curl直接请求上层，结果是可以的。
-- 但是通过http模块却无法得到所有内容，hash_body显示存在响应数据
--
--]]
if res.has_body then
    -- res.status == 200
    -- res.reason == OK
    -- res.headers 是在上面进行了输出
    ngx.log(ngx.ERR, res.reason)
end

--
-- 结论：http－resty目前还暂时不支持从chunked server的输出形式
--
local reader = res.body_reader
repeat
    local chunk, err = reader(2) -- 到这边就block住了
    ngx.exit(ngx.HTTP_OK)
    if err then
        ngx.log(ngx.ERR, err)
        break
    end
    if chunk then
        ngx.print(chunk)
    end
until not chunk

