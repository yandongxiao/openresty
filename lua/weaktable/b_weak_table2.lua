#! /usr/local/bin/lua

a = {}
b = {}
setmetatable(a, b)

-- __mode字段可以取以下三个值：k、v、kv。
-- k表示table.key是weak的，也就是table的keys能够被自动gc；
-- v表示table.value是weak的，也就是table的values能被自动gc；
-- kv就是二者的组合。任何情况下，只要key和value中的一个被gc，那么这个key-value pair就被从表中移除了
b.__mode = "v"         -- now `a' has weak keys

-- weak table的value如果是值类型，则不会被回收，与正常的table元素一样
k = {1}
a[1] = k

k = {2}
a[2] = k
collectgarbage()       -- forces a garbage collection cycle

for k, v in pairs(a) do print(k, v) end
