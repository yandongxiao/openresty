--[[
-- 定义普通的成员函数
-- ]]

local foo={}
function foo.bar(a, b, c)
  print(a+b+c)
end
foo.bar(1,2,3)

print("------")
local person = {}

--不能使用person:setname的形式，否则在new中的设置
-- t.setname = person.setname
-- 将会失效
--
function person.setname(self, name)
    self.name = name
end

function person.setage(self, age)
    self.age = age
end

function person:new(name, age)
    local t = {}
    t.setname = person.setname
    t.setage  = person.setage
    t:setname(name)
    t:setage(age)
    return t
end

p1 = person:new("terry", 10)
print(p1.name)
print(p1.age)

