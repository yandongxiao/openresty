--[[
--
-- 具名形参的实现方法
--
--]]
function call(aa)
    print(aa["name"])       -- 但是引用table的变量时，却是需要带引号的
    print(aa["age"])
end

t = {name="hello", age=10}      -- 字面值的key是不带引号的
call(t)
