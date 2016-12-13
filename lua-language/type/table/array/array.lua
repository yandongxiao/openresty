a = {}
a[1] = 1
a[100]=100

-- a[100] 并不会输出，当迭代到a[2]时，发现它的值是nil
-- 程序就直接退出了
for _, val in ipairs(a) do
    print(val)
end
