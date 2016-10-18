--[[
-- table初始化的方式
--   1. 基本语法
--   2. 以不同类型的key构建table，以及它们对应的访问方法
--]]

-- 基本语法
-- 注意: 字面值常量中。key的类型如果是字符串，key两边没有加引号
-- 但是在引用table的元素时，key的类型如果是字符串，key两边必须加上引号
person1 = {name="nihao", age=10}
print(person1["name"])  -- nihao
print(person1["age"])   -- 10
print(person1[1])       -- nil

-- 类型不同的key
person1 = {[2]=200, [false]=false, ["nn"]="mm"}
person1[1] = 1
person1[true] = true
person1["name"] = "jh"
for k, v in pairs(person1) do
    print(k, v)
end
