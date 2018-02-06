-- create private index
local index = {}

-- create metatable
local mt = {
    __index = function (t, k)
        print("*access to element " .. tostring(k))
        return t[index][k]   -- access the original table
    end,

    __newindex = function (t, k, v)
        print("*update of element " .. tostring(k) .. " to " .. tostring(v))
        t[index][k] = v     -- 对另一张表的赋值，不会引起for循环
    end
}

-- 对表t进行监控
function track (t)
    local proxy = {}    -- 空表代理很重要
    -- NOTICE: 这是引用的一个特点，{} != {}
    proxy[index] = t    -- index是一个表，而表是唯一的，所以可以放心的作为key。
    setmetatable(proxy, mt)
    return proxy
end

t = track{
    name = "jack",
    age = 10
}

t.job = "mn"
print(t.name)
print(t.age)
print(t.job)
