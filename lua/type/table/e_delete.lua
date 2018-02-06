--[[
-- # 不要以#tab作为数组元素的个数
-- Notice however that the length operator # does not work with tables that are not arrays
-- 如果不是纯array的数组，就不要用它. 如果是数组，元素就不要是nil
--
-- 1. 删除第一个元素
-- 2. 删除最后一个元素
-- 3. 删除一个不存在的元素
-- 关注对遍历的影响
--]]

-- 1. 删除第一个元素
vals = {100, 200, 300, 400}
-- NOTE: 将不再打印任何一个元素
vals[1] = nil
for x in ipairs(vals) do
    assert(1==2)
end

-- 2. 删除中间一个元素
vals = {100, 200, 300, 400}
assert(vals[2] == 200)
assert(#vals == 4)  -- NOTE: 为什么是4?
for i, v in ipairs(vals) do
    print(v)
end

vals[3] = nil
assert(vals[3] == nil)
assert(#vals == 4)  -- NOTE: 这种删除方法不利于后续的处理, 但是为什么是4呢？
vals[4] = nil
assert(#vals == 2)

-- 3. 使用table.remove删除元素
-- NOTICE: 这是消除1和2中的副作用的方法
vals = {100, 200, 300, 400}
table.remove(vals, 2)
assert(#vals == 3)
