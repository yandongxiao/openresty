--[[
-- 访问数组中的元素：
--   访问第一个元素
--   访问最后一个元素 or 如何获取数组的长度
--]]

vals = {1,2,3}
print(vals[1])       -- 1
print(vals[#vals])   -- 3
print(vals[#vals-1]) -- 2
