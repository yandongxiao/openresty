--[[
-- rawget是绕过metamethod __index的方式之一
--]]

local meta = {}
meta.__index = {
    name="terry"
}

foo = {1, 2, 3}
setmetatable(foo, meta)
assert(foo.name == "terry")

-- 如果table中不存在该元素，直接返回nil
assert(rawget(foo, 1) == 1)
assert(rawget(foo, "name") == nil)
