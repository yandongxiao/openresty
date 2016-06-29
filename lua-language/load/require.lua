--[[
-- loadfile 与 dofile的区别：
--     loadfile只是编译，文件不存在时返回nil
--     dofile是编译并执行，文件不存在时抛出异常
-- 注意：在p.lua当中将print改成了prin，并未造成loadfile返回nil；
--       感觉编译也没有做什么事情
--]]
x=10
val=require("p")
print("---")
val2=require("p")    -- 与require的区别之一，它会运行多次
print(val)  -- 这是p.lua的返回值
