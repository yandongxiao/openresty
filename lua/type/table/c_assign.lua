--[[
-- table之间的赋值是引用赋值，那么如何拷贝一个数组
--]]

-- 1. 赋值是引用赋值
t1 = {10, 20, 30, 40}
t2 = t1
t2[1] = 100
assert(t1[1], 100)

-- 2. 数组的完全拷贝
t1 = {10, 20, 30, 40}
t2 = {unpack(t1)}
t2[1] = 100
assert(t1[1], 10)

-- 3. 关联数组的完全拷贝
t1 = {
    name = "jack",
    age = 10,
    company = "china"
}
t2 = {}
for key, val in pairs(t1) do
    t2[key] = val
end
t2["name"] = "bob"
assert(t1["name"] == "jack")
