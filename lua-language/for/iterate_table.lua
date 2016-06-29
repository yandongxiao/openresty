
-- 与go语言的一个区别，赋值用的是等号
-- KEY不需要使用引号括起来
persons = {jerry=20, roony=30, david=40}

-- 语法上可以使用ipairs函数, 但是却没有任何输出结果
for key, val in pairs(persons) do
    print(key, val)
end
