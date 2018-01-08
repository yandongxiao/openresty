--[[
-- LUA 存在weak key、weak value、weak kv
--]]

a = {}
b = {}
setmetatable(a, b)

-- __mode字段可以取以下三个值：k、v、kv。
-- k表示table.key是weak的，也就是table的keys能够被自动gc；
-- v表示table.value是weak的，也就是table的values能被自动gc；
-- kv就是二者的组合。任何情况下，只要key和value中的一个被gc，那么这个key-value pair就被从表中移除了
b.__mode = "k"         -- now `a' has weak keys

key = {}               -- creates first key
a[key] = 1
key = {}               -- creates second key
a[key] = 2
collectgarbage()       -- forces a garbage collection cycle

-- 只返回了元素2
-- 因为第一个元素的key已经被垃圾回收了, 第二个元素的key还被变量key引用，所以没有被回收
for k, v in pairs(a) do print(v) end
