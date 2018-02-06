#! /usr/local/bin/lua
--[[
--
-- 通过ffi，提供面向对象的使用方法
--
--]]

local ffi = require("ffi")
ffi.cdef[[
  typedef struct { double x, y; } point_t;
]]

-- cdata 不能在 Lua 中创建出来，也不能在 Lua 中修改。这样的操作只能通过 C API。
-- 这一点保证了宿主程序完全掌管其中的数据。
local point
local mt = {
    -- 可以将这些lua函数换成C的函数
    __add = function(a, b) return point(a.x+b.x, a.y+b.y) end,
    __len = function(a) return math.sqrt(a.x*a.x + a.y*a.y) end,
    __index = {
        area = function(a) return a.x*a.x + a.y*a.y end,
    },
}
point = ffi.metatype("point_t", mt)     -- 将point_t与一堆函数关联起来

local a = point(3, 4)   --> x=3, y=4
print(a.x, a.y)  --> 3  4
print(#a)        --> 5
print(a:area())  --> 25         -- 面向对象的调用方法
local b = a + point(0.5, 8)
print(#b)        --> 12.5
