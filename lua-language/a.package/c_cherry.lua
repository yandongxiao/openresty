local function age ()
    return 10
end

local function money()
    return age() * 10
end

local function myprivate()  -- private
end

-- 通过required方式加载模块时，cheery被放置到了全局变量表当中
-- 造成的影响是：cherry = require "c_cherry";
cherry = {
    age = age,
    money = money
}

return cherry
