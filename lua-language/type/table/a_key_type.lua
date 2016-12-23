--
-- 1. table初始化和引用
--    除了nil类型外，所有的类型都可以作为KEY，例如function 和 table
--
function myfunc()
end

t = {}

person1 = {
    [false] = "boolean",
    [2] = "number2",
    ["name"] = "string",
    age = "string",     -- key为string类型时，提供了更加方便的初始化方式
    [myfunc] = "function",
    [t] = "table",
    -- NOTICE: key为number类型时，提供了更加方便的初始化方式
    -- NOTICE: number1的key值是[1], 以后向上递增。
    -- NOTICE: key在向上递增时，忽略[num]这些值.
    "number1",
    "number12"
}

assert(person1[false] == "boolean")
assert(person1[2] == "number12")
assert(person1["age"] == "string")
assert(person1["name"] == "string")
assert(person1.name == "string")    -- key为字符串时，可采用这种索引方式
assert(person1[myfunc] == "function")
assert(person1[t] == "table")
assert(person1[true] == nil)        --  访问不存在的元素
assert(person1[1] == "number1")

for k, v in pairs(person1) do
    print(k, v)
end

assert(#person1 == 2)
