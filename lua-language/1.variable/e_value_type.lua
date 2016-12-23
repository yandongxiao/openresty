--[[
--
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
assert(type(use_undefined)=="nil")

-- 2. boolean
f = false
t = true
assert(type(t)=="boolean")

-- 3. number
a = 1
b = -2
c = 1.1
assert(type(a)=="number")
assert(type(b)=="number")
assert(type(c)=="number")

-- 4. string
x = "x\n"   -- 转义字符有效
assert(type(x)=="string")
print(x)

y = 'y\n'   -- 转义字符有效
assert(type(y)=="string")
print(y)

-- 注释无效
-- 转义字符无效
-- 下面的换行符无效, 总可以从[[的下一行开始写字符串
z = [[
--hello
world\n
]]
-- 上面的换行符有效
assert(type(z)=="string")
print(z)

-- 5. table
t = {}
t.name  = "hello"
t.value = "world"
assert(type(t) == "table")
assert(t.name == "hello")
assert(t.value == "world")

-- 6. function
f = function (num1, num2)
    return num1+num2
end
assert(type(f) == "function")
assert(f(1,2) == 3)

-- 7. userdata
--[[
-- userdata提供了一块原始的内存区域，可以用来存储任何东西
-- 在Lua中userdata没有任何预定义的操作，主要用于与C程序进行数据交换
-- NOTICE：LUA与C之间通过堆栈交互数据
--]]
