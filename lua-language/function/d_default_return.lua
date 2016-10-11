--[[
-- 函数的默认返回值是nil
-- Python:
--  函数的默认返回值是None
-- BASH：
--  函数的默认返回值是空字符串
--]]

function return_nothing()
end

ret=return_nothing()

if (ret) then
    print("ret:", ret)
else
    print("ret is nil") -- 默认返回值是nil
end
