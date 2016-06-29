--[[
-- 完全不同形式的for
-- for var=exp1, exp2, exp3 do
--      ...
-- end
--
-- 1. exp1成为inital expression，exp2称为limit expression， exp3称为step expression
-- 2. exp1, exp2, exp3 在开始执行循环体之前被求值, 之后它们的值不会改变
-- 3. exp1, exp2, exp3的求值结果必须是数字(包括整数和浮点数)，如果是字符串那么LUA也会尝试
--    进行类型转换。如果转换失败，抛出异常
-- 4. 如果step是正数，那么i>=limit; 如果step是负数,那么i<=limit.
-- 5. 默认step是1
-- 6. i 是重新定义的一个local变量, 注意重新定义的哟
--]]

num=10
local i = 100
for i = 1, 10 do
    print(i)
    num = num + 1
end
print(num)
print(i)
