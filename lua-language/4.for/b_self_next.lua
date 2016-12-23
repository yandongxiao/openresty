--
-- 实现类似next函数的功能
--

function my_next_factory(t) -- 只是针对数组
    i = 0
    n = #t
    return function()
        if i < n then
            i = i + 1
            return t[i]
        else
            return nil
        end
    end
end

t = { "jack", 10, "JACK" }

next = my_next_factory(t)
assert(next() == "jack")
assert(next() == 10)
assert(next() == "JACK")
assert(next() == nil)
