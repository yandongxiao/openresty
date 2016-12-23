--
-- 借助范性for语句来进行迭代
--

function my_next_factory(t) -- 这次返回的是下标
    i = 0
    n = #t
    return function()
        if i < n then
            i = i + 1
            return i
        else
            return nil
        end
    end
end

t = { "jack", 10, "JACK" }

local f, s, var = my_next_factory(t)  -- s和var的初始状态nil
while true do
    local var1, var2, var3 = f(s, var)  -- 其实迭代器只返回了一个值
    var = var1
    if var == nil then break end
    do
        assert(var==1 or var == 2 or var == 3)
    end
end

-- 上面的代码等价于

for var in my_next_factory(t) do
    assert(var==1 or var == 2 or var == 3)
end

