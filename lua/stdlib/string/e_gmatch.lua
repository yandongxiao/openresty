-- 1. gmatch返回的是迭代器
s = "hello world from Lua"
for w in string.gmatch(s, "%a+") do
    print(w)
end

-- 2. 模式匹配的分组功能
t = {}
s = "from=world, to=Lua"
for k, v in string.gmatch(s, "(%w+)=(%w+)") do
    t[k]=v
end

for k, v in pairs(t) do
    print(k, v)
end
