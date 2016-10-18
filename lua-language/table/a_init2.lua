--[[
-- unpack table来初始化table
--   unpack的工作原理如下：以下标1开始寻找对应的值，知道某个下标的值为nil，按照多重赋值的方式返回给调用者
--   例如vals = {1,2,3, name="dsa"}
--   那么， {unpack(vals)}  --> {1,2,3}
--]]

-- unpack
person1 = { [1]=1, [10]=10, name="nihao", age=10}
-- person1 = { [1]=1, [10]=10, name="nihao", age=10, 8, 9}  --  数字8的默认下标是1，所以person1的第一个字面值就被覆盖了
-- 根据unpack的工作方式，它发现 person1[2]=nil, 停止
person2 = {unpack(person1)}
for k, v in pairs(person2) do
    print(k, v)  -- 1, 注意并没有1
end

print(person1[1])   -- 1
print(person1[10])  -- 10
for k, v in pairs(person1) do
    print(k, v)  -- 2, 3, 注意并没有1
end


