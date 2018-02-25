#! /usr/local/bin/lua

-- 垃圾收集器不是万能的
-- 比如，t = {c = t}，即使t=nil，但该表仍然不会被清除。
-- Weak tables are the mechanism that you use to tell Lua that a reference should not prevent the reclamation of an object.

a = {}
b = {}
-- NOTE: 只有table类型的对象才能使用setmetatable被指定为弱引用
-- LUA 存在weak key、weak value、weak kv
setmetatable(a, b)

-- __mode字段可以取以下三个值：k、v、kv。
-- k表示table.key是weak的，也就是table的keys能够被自动gc；
-- v表示table.value是weak的，也就是table的values能被自动gc；
-- kv就是二者的组合。任何情况下，只要key和value中的一个被gc，那么这个key-value pair就被从表中移除了
b.__mode = "k"         -- now `a' has weak keys

-- NOTE: weak table的key如果是值类型，则与正常的table元素一样
key = {1}               -- creates first key
a[key] = 1
key = {2}               -- creates second key
a[key] = 2
collectgarbage()       -- forces a garbage collection cycle

-- 只返回了元素2
-- 因为第一个元素的key已经被垃圾回收了, 第二个元素的key还被变量key引用，所以没有被回收
for k, v in pairs(a) do print(v) end
