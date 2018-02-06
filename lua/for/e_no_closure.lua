#! /usr/local/bin/lua
--[[
--  通过状态变量来传递状态，避免使用闭包
--]]

function iter(a, i)     -- a是状态变量，b是控制变量
    i = i or 0          -- 为了健壮性考虑
    i = i + 1
    local v = a[i]
    if v then
        return i, v
    end
end

-- 迭代函数，状态常量，控制变量
-- 遍历过程: 控制变量，其它变量 = iter(状态常量, 控制变量)
-- 下次遍历：控制变量，其它变量 = iter(状态常量，控制变量)
-- t 就是所谓的状态变量, 0是初始状态变量
t = {1, 2, 3, 4, 5}
for i, v in iter, t, 0 do
    assert(i==1 or i==2 or i==3 or i==4 or i==5)
end

function mipairs(t)
    return iter, t, 0
end

for i, v in mipairs(t) do
    assert(i==1 or i==2 or i==3 or i==4 or i==5)
end
