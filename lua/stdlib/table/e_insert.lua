names = { "apple", "pear", "orange", "grape" }
table.insert(names, "banana")   -- 默认插入到数组的末尾
table.insert(names, 1, "banana")   -- 指定插入位置
for i, v in ipairs(names) do
    if i==1 or i == 6 then
        assert(names[i] == "banana")
    end
end
