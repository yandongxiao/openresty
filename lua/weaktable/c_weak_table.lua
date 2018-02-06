--[[
-- NOTICE: only objects can be collected from a weak table.
-- weak table的key如果是值类型，则与正常的table元素一样
--]]
a = {}
b = {}

setmetatable(a, b)
b.__mode = "k"          -- now `a' has weak keys

-- 因为key是数字类型，是值类型
key = 1                 -- creates first key
a[key] = 1
key = 2                -- creates second key
a[key] = 2
collectgarbage()       -- NOTICE: Notice that only objects can be collected from a weak table.

for k, v in pairs(a) do print(v) end
