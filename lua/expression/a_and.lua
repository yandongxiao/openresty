#! /usr/local/bin/lua
--[[
--  逻辑操作符返回的并非是true或false
--  而是逻辑运算过程中最后一个对象
--]]

if 1 == 1 and 2 == 2 then
    assert(1 == 1)
else
    assert(1 ~= 1)
end

a = (1 == 1)
assert(a == true)

-- true
a = 1 and 2
assert(a == 2)

-- nil front
a = nil and 2
assert(a == nil)
a = false and 2
assert(a == false)

-- nil end
a = 1 and nil
assert(a == nil)
a = 1 and false
assert(a == false)
