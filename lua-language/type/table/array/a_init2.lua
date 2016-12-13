--[[
--   字面值不再是常量，而变成了表达式：
--     函数名称
--     函数调用, 不在字面值列表的尾部
--     函数调用，  在字面值列表的尾部
--]]

function myfunc()
    return 1,2,3
end

-- 方式一
t1 = {myfunc}   -- myfunc本身就是一个普普通通的变量而已
print(t1[1])    -- 打印函数地址

-- 方式二
t1 = {myfunc()}
print(t1[1])    -- 1

-- 方式三
t1 = {myfunc(), 1}
print(t1[2])    -- 1
