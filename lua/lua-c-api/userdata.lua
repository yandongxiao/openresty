#! /usr/local/bin/lua
--[[
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

array = require "narray"
arr = array.new(1000)
assert(type(arr) == "userdata")
-- assert(array.size(arr) == 1000)
for i=1, 1000 do
    array.set(arr, i, 1/i)
    -- arr:set(i, 1/i)   -- 以对象的方式访问数据
    -- arr[i] = 1/i      -- 数组访问方式
end

v = array.get(arr, 10)
-- v = arr:get(10)      -- 对象访问方式
-- v = arr[10]      -- 数组访问方式
assert(v == 0.1)
