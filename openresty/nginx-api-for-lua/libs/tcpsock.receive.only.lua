-- 获取tcpsock
-- NOTE: 如果使用ngx.req.socket(true), 那么必须使用sock:send的方式发送数据!
local sock = ngx.req.socket()
if sock then
    ngx.log(ngx.INFO, "get socket successfully")
else
    ngx.log(ngx.ERR, "faile to get socket")
end

-- '*a': reads from the socket until the connection is closed.
-- 根据HTTP协议规范，连接不会被断开，所以receive不会返回，但是不影响nginx的时间驱动模型
-- '*l':` 读取一行，最后一行数据时data==nil, 数据存储在patital当中
while true do
    local data, err, partial = sock:receive("*l")
    ngx.log(ngx.INFO, data, partial)
    if data == nil then
        ngx.log(ngx.ERR, err)
        if partial ~= nil then
            ngx.print(partial)
        end
        break
    else
        ngx.say(data)
    end
end
