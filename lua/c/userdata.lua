--[[
--问题一：
--  如何实现
--
--问题二:
-- array模块的最大问题在于：数据和操作是分离的
-- 数据永远是作为array的第一个参数传递过来的
-- 分离的最大问题在于：操作和数据之间不匹配
--
-- 解决办法：userdata在LUA中是可以拥有metadata的，基于这个特性，可以为array.new的每个对象添加metadata
-- 在每个函数操作中检查metadata是否匹配
-- 相当于对出厂的内容打上LOGO，函数就是检查LOGO在不在，对不对
-- NOTICE: Lua code cannot change the metatable of a userdatum
--
-- 1. 如何创建一个metatable -->luaL_newmetatable table有的操作，metatable也是有的
-- 2. 如何保存metatable，它应该是C的“全局变量”. --> registry
--
-- 问题三：
-- 调用方式改进，array.size(arr) --> arr:size()
-- 参考: https://zilongshanren.com/blog/2014-08-11-bind-a-simple-cpp-class-in-lua.html
--
-- 问题四：
-- 调用方式改进，arr[i] = v
--]]

array = require "array"

-- 通过下面的技术手段也是可以解决第二个问题的
-- NOTICE: arr:size --> userdata.size(arr)；
-- 因为userdata没有任何key, 所以转而去metatable的 __index寻求帮助，发现了metaarray的size属性
-- 于是最终调用的是array.size(arr)

arr = array.new(1000)
--[[
local metaarray = getmetatable(arr)
metaarray.__index = metaarray
metaarray.set = array.set
metaarray.get = array.get
metaarray.size = array.size
--]]

assert(type(arr) == "userdata")
assert(array.size(arr) == 1000)
for i=1,1000 do
    arr[i] = 1/i
end
assert(arr[10] == 0.1)

-- print(arr)
-- array.set(io.stdin, 2, 0)
