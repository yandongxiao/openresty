--[[
-- 被称为无状态迭代器
-- 1. mipairs函数中没有定义局部变量，或者说没有采用闭包
-- 2. 迭代函数接受两个参数，第一个状态变量，第二个是控制变量(i和v当中，i才是真正的控制变量)
--]]

function iter(a, i)
    i = i + 1
    local v = a[i]
    if v then
        return i, v
    end
end

function mipairs(t)
    -- 同时返回了迭代函数，状态常量，控制变量
    return iter, t, 0
end

t = {1, 2, 3, 4, 5}
for i, v in mipairs(t) do
    print(i, v)
end

-- 省略调用ipair的方法
t = {1, 2, 3, 4, 5}
for i, v in iter, t, 0 do
    print(i, v)
end
