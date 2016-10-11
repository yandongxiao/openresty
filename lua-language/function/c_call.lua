--[[
-- 实参传递给形参的过程其实是多重赋值的过程，按照多重赋值的语义
-- 实参的个数比一定要等于形参的个数
--]]

--默认参数的等价形式
function named_func(name)
    name = name or "--" -- 相当于默认形参
    print(name)
end

named_func()
named_func("china")
named_func("china", 2)
