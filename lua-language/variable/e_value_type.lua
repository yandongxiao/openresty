--[[
--
-- 变量的值的类型有：
--    boolean
--    number
--    string
--    nil
--    table
--    userdata      -- 暂不介绍
--    functioned    -- 暂不介绍
--]]

-- boolean
f = false
t = true
print(f, t)

-- number
a = 1
b = -2
c = 1.1
print(a, b, c)

-- string
x = "nihao\n"
y = 'hello\n'
-- 注释无效
-- 转义字符无效
z = [[
--hello
world\n
]]
print(x)
print(y)
print(z)

-- nil
print(use_undefined)

-- table
t = {}
t.name  = "hello"
t.value = "world"
print(t.name)
print(t.value)
