--[[
-- 通过状态变量来传递状态，避免使用闭包
-- 也称之为无状态迭代器
--]]

function iter(a, i)     -- a是状态变量，b是控制变量
    i = i or 0          -- 为了健壮性考虑
    i = i + 1
    local v = a[i]
    if v then
        return i, v
    end
end

t = {1, 2, 3, 4, 5}
for i, v in iter, t, 0 do   -- t 就是所谓的状态变量, 0 是初始状态变量
    assert(i==1 or i==2 or i==3 or i==4 or i==5)
end

function mipairs(t)     -- 同时返回了迭代函数，状态常量，控制变量
    return iter, t, 0
end

for i, v in mipairs(t) do
    assert(i==1 or i==2 or i==3 or i==4 or i==5)
end

