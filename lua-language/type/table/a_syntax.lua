-- 1.table初始化和引用
--   除了nil类型外，所有的类型都可以作为KEY，例如function 和 table
function myfunc()
end

t = {}

person1 = {
    [false] = "boolean",
    [1] = "number",
    ["name"] = "string",
    age="string",     -- key为string类型时，提供了更加方便的初始化方式
    [myfunc] = "function",
    [t] = "table"
}

assert(person1[false] == "boolean")
assert(person1[1] == "number")
assert(person1["age"] == "string")
assert(person1["name"] == "string")
assert(person1[myfunc] == "function")
assert(person1[t] == "table")
assert(person1[true] == nil)       --  访问不存在的元素
assert(person1[2] == nil)          --  访问不存在的元素不会异常退出

for k, v in pairs(person1) do
    print(k, v)
end
