--
-- 实现类似next函数的功能
-- 借助范性for语句来进行迭代
-- 泛型for的工作原理：不断调用next功能的函数，并将结果返回给，直到结果为nil
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

t = { "jack", 10, "JACK" }
for v in my_next_factory(t) do
    assert(x=="jack" or x == 10 or x == "JACK")
end
