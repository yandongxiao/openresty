-- 注意
-- foo.name = 10 只有不存在key的时候，才会去调用__newindex方法。
--

foo = {1, 2, 3}
foo.meta = {}

-- 注意使用的是rawset来设置值
function newindex_function(t, key, value)
    if (key == "name") then
        rawset(t, key, "terry") --否则程序陷入死循环
        return
    end
    rawset(t, key, value)
end
foo.meta.__newindex = newindex_function
setmetatable(foo, foo.meta)
foo.name = "lilei"
print(foo["name"])
foo.age = 10
print(foo["age"])

-- 也可以设置__newindex的值是一个table, 那么foo.name="lilei"最终会在newindex_table当中
-- 设置一个newindex_table.name="lilei"，此时你去访问foo.name，还是会得到nil
-- 所以应该将__index设置为同一个table，就可以访问到了
newindex_table = {}
foo.meta.__newindex = newindex_table
setmetatable(foo, foo.meta)
foo.name = "lilei"
print(newindex_table["name"])
foo.age = 10
print(newindex_table["age"])
