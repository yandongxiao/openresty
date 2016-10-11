-- table也可以用作数组，数组和HASH表最好不要混用
-- 如果你要删除一个数组中的元素，请使用 remove 函数，而不是用 nil 赋值。
--

a = {1, 2, 3}
table.remove(a, 3)
print(#a)

b = {name="terry", age=10}

--
-- table.remove(b, "name") 失败
-- remove方法是数组专用的，因为他要求第二个参数是number
-- print(#b) ==0
--
b.name = nil    --在接下来的遍历过程中，不存在<name, nil>
for x, y in pairs(b) do
    print(x, y)
end
