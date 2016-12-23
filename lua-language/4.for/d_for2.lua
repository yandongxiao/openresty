function my_next_factory(t) -- 这次返回的是下标
    i = 0
    n = #t
    return function(s, c)   -- 更加类似next的一个函数
        c = c or 0
        if c < n then
            return c+1, t[c+1]
        else
            return
        end
    end
end

local f, s, var = my_next_factory{"jack", "other", "JACK"}  -- s和var的初始状态nil
while true do
    local var1, var2, var3 = f(s, var)  -- 迭代器返回了下标和值
    var = var1
    if var == nil then break end
    do
        assert(var1==1 or var1 == 2 or var1 == 3)
        assert(var2=="jack" or var2 == "other" or var2 == "JACK")
    end
end

-- 上面的代码等价于

for var1, var2 in my_next_factory{"jack", "other", "JACK"} do
    assert(var1==1 or var1 == 2 or var1 == 3)
    assert(var2=="jack" or var2 == "other" or var2 == "JACK")
end

