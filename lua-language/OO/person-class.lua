person = {name="default", age=0}

function person:pfunc()
    print("this is a person function")
end

function person:new()
    obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

p1 = person:new()
p2 = person:new()
p1.name = "p1"
p1.age  = "1"

print(p1.name)
print(p1.age)
p1.pfunc()

print(p2.name)
print(p2.age)
p2.pfunc()

