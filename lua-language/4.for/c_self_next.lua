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

for x in my_next_factory(t) do
    assert(x==1 or x == 2 or x == 3)
end
