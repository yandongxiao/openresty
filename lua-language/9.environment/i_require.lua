--[[
-- 与load类函数的区别:
-- 1. require 可以通过LUA_PATH寻找合适的LUA文件进行加载；
-- 2. loadfile将LUA文件封装成了匿名函数，但是require将LUA文件封装成
--]]

m1 = require("p")   -- 参见package.path来设置搜索路径
assert(type(m1) == "table")
m1.add()
m1.add()
assert(m1.val() == 3)

m2 = require("p")
assert(m1 == m2)
assert(m1.val() == 3)   -- 共享一个table
