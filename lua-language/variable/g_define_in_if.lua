--[[
-- 变量是可以被嵌套定义
-- 这是高级编译类语言都拥有的特性，例如java，c等
-- NOTICE: Python和BASH都不支持嵌套定义变量
--]]

num = 1
function fn()
    local num = 2
    if true then
        local num = 3
        print(num)  -- 3
    end
    print(num)  -- 2
end

fn()
print(num)  -- 1
