--[[
-- LUA 支持所有的算术操作的重载
-- __add  __mul __sub __div __unm __pow __concat
--   +      *     -     /     负    幂     ..
--
-- __add(a, b)  仍然是两个参数，不存在this指针
--
--]]

--[[
-- 1. __add(a, b)  对a和b参数的类型不检查，直到某些操作不满足
--    __add 函数也可以主动检查a和b的类型
-- 2. a 和 b 最好是同一种类型
-- 3. 优先选择a的metatable，如果不满足才会选择b的metatable
--]]

Array = {}
Array.mt = {}

function Array.new(t)
    return setmetatable(t, Array.mt)
end

function Array.concat(a1, a2)

    idx = 1
    sum = {}
    for i, v in ipairs(a1) do
        sum[idx] = v
        idx = idx + 1
    end

    for i, v in ipairs(a2) do
        sum[idx] = v
        idx = idx + 1
    end

    return sum
end

a1 = Array.new{1,2,3}
a2 = Array.new{1,3,5}
Array.mt.__concat = Array.concat
a3 = a1 .. a2
for i, v in ipairs(a3) do
    print(v)
end
