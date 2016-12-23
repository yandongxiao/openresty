t = {
    __add = function (t1, t2)
        newt = {}
        for k, v in pairs(t1) do
            newt[k] = v
        end
        for k, v in pairs(t2) do
            newt[k] = v
        end
        return newt
    end
}

-- NOTICE: 是对t设置__metatable属性，使得
-- 1. foo一旦setmetatable以后，就别想再换
-- 2. getmetatable(foo) 返回的是any字符串
t.__metatable="any"

foo = {}
setmetatable(foo, t)
assert(getmetatable(foo) == "any")

-- LUA error: cannot change a protected metatable
--setmetatable(foo, {})
