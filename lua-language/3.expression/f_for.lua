-- 1. numberic for loop
-- [0, 10]
-- 1. exp1成为inital expression，exp2称为limit expression， exp3称为step expression
-- 2. exp1, exp2, exp3 在开始执行循环体之前被求值, 之后它们的值不会改变
-- 3. exp1, exp2, exp3的求值结果必须是数字(包括整数和浮点数)，如果是字符串那么LUA也会尝试
--    进行类型转换。如果转换失败，抛出异常
-- 4. 如果step是正数，那么i>=limit; 如果step是负数,那么i<=limit.
-- 5. 默认step是1
-- 6. i 是重新定义的一个local变量, 注意重新定义的哟
-- 
sum = 0
for i=0, 10, 1 do
    sum = sum + 1
end
-- NOTICE: 是11
assert(sum==11)

-- 2. ipair for loop
t = {1, 2, 3, name="jack", 4}
sum = 0
for i,v in ipairs(t) do
   sum = sum + 1
end
assert(sum == 4)

-- 3. pair for loop

t = {1, 2, 3, name="jack", 4}
sum = 0
for k, v in pairs(t) do
   sum = sum + 1
end
assert(sum == 5)
