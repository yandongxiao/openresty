--[[
-- 1. 删除第一个元素
-- 2. 删除最后一个元素
-- 3. 删除一个不存在的元素
-- 关注对遍历的影响
--]]

-- 删除第一个元素
vals = {100, 200, 300, 400}
vals[1] = nil
-- 将不再打印任何一个元素 
for x in ipairs(vals) do
    print(x)
end

-- 删除最后一个元素
vals = {100, 200, 300, 400}
vals[#vals] = nil
for _, x in ipairs(vals) do
    print(x) -- 100 200 300
end

-- 删除不存在的元素
-- 不存在
vals = {100, 200, 300, 400}
vals[#vals+1] = nil
for _, x in ipairs(vals) do
    print(x) -- 100 200 300
end

