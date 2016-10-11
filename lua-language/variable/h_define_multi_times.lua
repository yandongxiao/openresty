--[[
-- 变量可以在同一个作用域下面定义多次，第二次相当于赋值操作
--]]

function call_variable()
    local num = 100
    local num = 10
    print(num)
end

call_variable()
