--[[
-- LUA不存在默认参数
--]]

--默认参数的等价形式
function named_func(name)
    name = name or "--"
    print(name)
end
named_func()
named_func("china")
