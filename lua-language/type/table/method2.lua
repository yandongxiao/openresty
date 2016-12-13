person = {inst={}}

function person:getname()
    return self.inst.name
end

function person:getage()
    return self.inst.age
end

function person:setname(name)
    self.inst.name = name
end

function person:setage(age)
    person.inst.age = age
end

function person:new(name, age)
    person.inst = {}
    person:setname(name)
    person:setage(age)
    return person
end

terry = person:new("terry", 10)
lilei = person:new("lilei", 20)
print(terry:getname())
print(terry:getage())
print(person:getname()) -- 有问题
print(person:getage())
