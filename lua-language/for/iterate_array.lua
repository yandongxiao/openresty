--[[
-- 1. 数组可以被认为是特殊的Hash Table, 所以我们应该可以使用
-- 操纵table的一切函数
--]]
names = {"terry", "roony", "gary"}

for _, name in ipairs(names) do
    print(name)
end

for k, v in pairs(names) do
    print(k, v)
end
