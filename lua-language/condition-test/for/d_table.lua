--[[
-- 遍历table的方式
--   数组：下标从1开始
--   table：key都是字符串
--   pairs更加强大，能够遍历数组和table
--   ipairs只能遍历数组
--]]

-- 数组
numbers = {10,20,30,40}
for i, x in pairs(numbers) do   -- pairs用户获取下标
    print(i, x)     -- 下标从1开始
end
for i, x in ipairs(numbers) do
    print(i, x)
end

-- table
persons = {jerry=20, roony=30, david=40}    -- 注意字面值的指定方式
for key, val in pairs(persons) do
    print(key, val)
end
for key, val in ipairs(persons) do    -- 获取key
    print(key, val)
end
