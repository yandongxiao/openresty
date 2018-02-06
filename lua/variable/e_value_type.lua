#! /usr/local/bin/lua
--[[
-- 变量的值的类型有：
--    nil
--    boolean
--    number
--    string
--    table
--    function
--    userdata
--]]

-- 1. nil
assert(type(use_undefined) == "nil")

-- 2. boolean
-- 除了false 和 nil 其它情况全为真
f = false
t = true
assert(type(t) == "boolean")
if (0) then
    assert(1 == 1);
else
    assert(1 == 2);
end

-- 3. number
a = 1
b = -2
c = 1.1
assert(type(a) == "number")
assert(type(b) == "number")
assert(type(c) == "number")

-- 4. string
x = "x\n" -- 转义字符有效
assert(type(x) == "string")
print(x)

y = 'y\n' -- 转义字符有效
assert(type(y) == "string")
print(y)

print("helloworld") -- NOTE：print函数本身会删除一个换行符

-- 转义字符无效
-- [[后面的字符串无论是另起一行，还是append字符串，输出效果都一样。
z = [[
--hello
world\n]] -- ]] 前面一定有隐藏的换行符
-- 上面的换行符有效
assert(type(z) == "string")
print(z)

-- 5. table
-- table是Lua世界中唯一的复杂数据结构

-- 使用它可以定义列表, 注意列表的起始索引是1.
t = { 1, 2, 3 }
assert(t[1] == 1)

-- 使用字符串作为索引
-- 值可以是不同类型
t = {}
t.name = "hello"
t.value = 3
assert(type(t) == "table")
assert(t.name == "hello")
assert(t.value == 3)

-- 任何非nil值都可以作为key
t[false] = "F"
assert(t[false] == "F")

-- 6. function
-- function也是变量（与python中一切皆对象有些相似）
f = function(num1, num2)
    return num1 + num2
end
assert(type(f) == "function")
f1 = f
assert(f1(1, 2) == 3)

-- 7. userdata
--[[
-- userdata提供了一块原始的内存区域，可以用来存储任何东西
-- 在Lua中userdata没有任何预定义的操作，主要用于与C程序进行数据交换
-- NOTICE：LUA与C之间通过堆栈交互数据
--]]
