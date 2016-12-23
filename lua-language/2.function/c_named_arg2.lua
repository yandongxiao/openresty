--[[
-- 具名参数的意义在于：方便接口开发者和使用者时刻知道参数的真正含义
-- LUA 有以下方法来达到上面的目的
--]]

function exchange (t)
    t.front, t.back = t.back, t.front
    return t
end

t = exchange {
    front = 10,
    back = 100
}

assert(t.front == 100)
assert(t.back  == 10)
