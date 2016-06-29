--[[
-- loadfile 与 dofile的区别：
--     loadfile只是编译，文件不存在时返回nil
--     dofile是编译并执行，文件不存在时抛出异常
-- 注意：在p.lua当中将print改成了prin，并未造成loadfile返回nil；
--       感觉编译也没有做什么事情(将LUA代码转换成了中间代码，执行效率更高了)
--]]
x=10
val=dofile("p.lua")     -- 与require的区别之一，它不会使用搜索LUA_PATH，所以使用全称
val2=dofile("p.lua")    -- 与require的区别之一，它会运行多次
print(val)  -- 这是p.lua的返回值
