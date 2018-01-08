Person = {}
Person.mt = {}

function Person.new(t)
    return setmetatable(t, Person.mt)
end

function Person.tostring(t)
    return "helloworld"
end

Person.mt.__tostring = Person.tostring
print(Person.new{})
