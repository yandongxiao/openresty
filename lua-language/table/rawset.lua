foo = {1, 2, 3}
foo.meta = {}

-- 注意使用的是rawset来设置值
foo.meta.__newindex = function(t, key, value)
    if (key == "name") then
        rawset(t, key, "terry") --否则程序陷入死循环
        return
    end
    rawset(t, key, value)
end

setmetatable(foo, foo.meta)

foo.name = "lilei"
rawset(foo, "name", "lilei")    --存在这一行，那么lilei设置成功
print(foo["name"])


foo.age = 10
print(foo["age"])
