--[[
-- 1. 删除第一个元素
-- 2. 删除最后一个元素
-- 3. 删除一个不存在的元素
-- 关注对遍历的影响
--]]

-- 1. 删除第一个元素
vals = {100, 200, 300, 400}
vals[1] = nil
-- 将不再打印任何一个元素
for x in ipairs(vals) do
    assert(1==2)
end

-- 2. 删除中间一个元素
vals = {100, 200, 300, 400, [300]="niha"}
vals[3] = nil
assert(#vals == 4)  -- 这种删除方法不利于后续的处理, 但是为什么是4呢？
vals[4] = nil
assert(#vals == 2)

-- 3. 使用table.remove删除元素
-- NOTICE: 这是消除1和2中的副作用的方法
vals = {100, 200, 300, 400}
table.remove(vals, 2)
assert(#vals == 3)
