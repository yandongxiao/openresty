--[[
-- 模块bar.lua只会被加载一次，而且：所有的worker共享这个被加载的bar.lua模块
-- 所有这个bar模块不适合存放请求的个性化信息
--]]
bar = require "conf/lua-nginx-module/bar"
bar.num = bar.num + 1
ngx.say(bar.num)
