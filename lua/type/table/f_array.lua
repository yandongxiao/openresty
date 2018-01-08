-- 其后的元素会被前移, 所以结果是1, 3, 4
-- NOTE: 使用ipairs遍历时删除是不安全的
-- 1. 使用#tab的方式，从后往前进行遍历
-- 2. 控制index
tab = {1, 2, 3, 4}
table.remove(tab, 2)

-- 1. 使用#tab的方式，从后往前进行遍历
tab = {1, 2, 3, 4}
for i=#tab, 1, -1 do
    if i == 2 then
        table.remove(tab, i)
    else
        print(tab[i])
    end
end

-- 2. 控制index
i = 1
tab = {1, 2, 3, 4}
while i <= #tab do
    -- NOTE: 不能用下标的方式进行判断
    if tab[i] == 2 then
        table.remove(tab, i)
    else
        i = i + 1
    end
end


-- NOTE: 使用这种方式也很危险，毕竟它将数组从中间截断了
-- tab[2] = nil    -- 将所有元素删除完毕

for _, v in ipairs(tab) do
    print(v)
end

