--[[
-- LUA不存在默认参数，但是可以仿造出来
-- BASH也不存在默认形参
-- python 存在
--]]

--默认参数的等价形式
function named_func(name)
    name = name or "--"
    print(name)
end

named_func()
named_func("china")
named_func("china", 2)
