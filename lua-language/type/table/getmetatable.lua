local t = {
__add= function (t1, t2)
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

local foo = {nihao="hello"}
-- 任何一个table都可以是另一个table的metatable
setmetatable(foo, t)

meta_foo = getmetatable(foo)
print(meta_foo)
