--[[
-- Notice that only objects can be collected from a weak table.
-- 可以被收集的类型都是引用类型
--]]
a = {}
b = {}

setmetatable(a, b)
b.__mode = "k"          -- now `a' has weak keys
key = 1                 -- creates first key
a[key] = 1
key = 2                -- creates second key
a[key] = 2
collectgarbage()       -- NOTICE: Notice that only objects can be collected from a weak table.
for k, v in pairs(a) do print(v) end    -- 只返回了元素2
