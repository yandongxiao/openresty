local redis = require "resty.redis"

local red = redis:new()
local ok, err = red:connect("172.16.9.21", 6379)
if not ok then
    ngx.say("failed to connect: ", err)
    return
end

-- 字符串如何进行转义是一个难点, 主要就是问号的处理
-- local res, err = red:get("img-sample.cos-beta.chinac.com/love.ac3?vinfo")
local res, err = red:get("foo")
if not res then
    ngx.say("failed to get <data>:", err)
    return
end
ngx.say(res)
