--[[
--  与b_use_sum.lua相比，主要区别在于调用t.sum时，传递了两个cdata数据类型的值.
--  b_use_sum.lua方法仅限于基本类型，lua 会将其基本类型转换为 cdata 的基本类型
--
--]]
local ffi = require('ffi')
local t = ffi.load("sum", true)

ffi.cdef[[
    int sum(int x, int y);
]]

ti = ffi.typeof("int")
a = ffi.new(ti, 10)
b = ffi.new("int", 11)
print(type(a), type(b))
print(t.sum(a, b))
