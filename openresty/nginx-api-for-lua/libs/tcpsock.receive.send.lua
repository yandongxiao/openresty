-- 发送响应头部, 默认包含Transfer-Encoding: chunked
-- 所以有两种处理响应的方式：添加Content-Length头或模拟chunked的响应体
ngx.send_headers()
ngx.flush(true)

-- 获取tcpsock
-- NOTE: 如果使用ngx.req.socket(true), 那么必须使用sock:send的方式发送数据!
-- NOTE: 如果使用ngx.req.socket(true), 那么sock:receive("*l")等循环读取方式会导致sock:receive无法返回。
--       在只读套接字的情况下，它会通过partial的方式返回。但是读写套接字的情况下不会。
-- ngx_lua将tcp层的套接字返回给了开发者，HTTP通信协议只是承载body的壳，但是传输控制完全掌握在
-- NOTE: 如果request body此时已经读取完毕，sock:receive(1)将会一直阻塞.
local sock = ngx.req.socket(true)
if sock then
    ngx.log(ngx.INFO, "get socket successfully")
else
    ngx.log(ngx.ERR, "faile to get socket")
end

-- 根据数字的方式读取数据
local left_to_read = ngx.var.http_content_length or 0
while true do
    if left_to_read == 0 then
        sock:send("0\r\n\r\n")
        break
    end

    -- 注意指定的size需要小于等于left_to_read的值, 为了方便设置为1. 否则receive函数无法返回
    -- 改进：每次读一半
    read = math.floor(left_to_read / 2)
    if read < 1 then
        read = 1
    end

    local data, err, partial = sock:receive(read)
    if data == nil then
        ngx.log(ngx.ERR, err)
        left_to_read = 0
    else
        local len = string.len(data)
        local str = string.format("%x", len) .. "\r\n" .. data .. "\r\n"
        sock:send(str)
        left_to_read = left_to_read - read
    end
end
