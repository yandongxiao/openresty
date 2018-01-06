-- t 称为状态常量
function my_next_factory(t) -- 这次返回的是下标
    i = 0
    n = #t
    -- function是就是next函数
    -- s称为状态常量，一般与t的值相等；
    -- c称为控制变量，一般为key
    return function(s, c)
        c = c or 0
        if c < n then
            -- NOTE: 第一个返回的参数是控制变量
            return c+1, t[c+1]
        end
    end
end

-- for的原理
-- s和var的初始状态nil
local f, s, var = my_next_factory{"jack", "other", "JACK"}
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
