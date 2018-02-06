names = { "apple", "pear", "orange", "grape" }  -- 只是针对数组
table.sort(names)   -- 在原先的table上做排序
-- 默认是做升序排序
for k, v in ipairs(names) do
    print(v)
end
