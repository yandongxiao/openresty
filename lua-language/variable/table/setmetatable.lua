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

t.__sub = function(t, num)
    t[1] = t[1] - num
    return t
end

local foo = {nihao="hello"}
-- 任何一个table都可以是另一个table的metatable
setmetatable(foo, t)

local foo = foo + {1, 2, 3}
for k, v in pairs(foo) do
    print(k, v)
end

-- foo 和 1 是不同的类型，中间的操作符-，决定了是否能混用操作符
-- 像__eq, __lt, __lt就不支持混合类型运算，同时要保证它们的metatable要一致
setmetatable(foo, t)    -- foo在前面被覆盖了，所以需要设置
foo = foo - 1
print(foo[1])
