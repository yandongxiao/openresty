--[[
-- 1. 向array中append元素
-- 2. 向任意大的位置添加一个元素
-- 3. 这种情况下遍历如何进行
--]]

a={}
a[1] = 1
a[100] = 100
a[50] = 50

print(a[2]) -- nil
-- 以ipairs的方式进行遍历时，当它发现下标为2的元素的值为nil，那么认为数组遍历成功
for _, x in ipairs(a) do
    print(x)
end

-- 只有通过遍历表的方式来遍历数组
-- 这种情况下, 不是按照下标的大小为顺序进行遍历的
for _, val in pairs(a) do
    print(val)
end
