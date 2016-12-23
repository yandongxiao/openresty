--[[
-- 语法上LUA不支持默认参数，但逻辑上可支持
--]]

-- 1. 默认参数的等价形式
function named_func(name, age)
    name = name or "--"
    age = age or 10
    print(name)
    print(age)
    return
end

named_func()
assert(name==nil)   -- 注意形参相当于局部变量
assert(age==nil)
