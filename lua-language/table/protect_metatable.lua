local t = {}
t.__add= function (t1, t2)
    newt = {}
    for k, v in pairs(t1) do
        newt[k] = v
    end
    for k, v in pairs(t2) do
        newt[k] = v
    end
    return newt
end

-- 注意是对t设置__metatable属性，使得
-- 1. foo一旦setmetatable以后，就别想再换
-- 2. getmetatable(foo) 返回的是any字符串
t.__metatable="any"

local t2 = {}
t2.__add= function (t1, t2) end

local foo = {nihao="hello"}
setmetatable(foo, t)
print(getmetatable(foo))

-- setmetatable(foo, t2)   -- 这样的调用会抛出异常

local foo = foo + {1, 2, 3}
for k, v in pairs(foo) do
    print(k, v)
end
