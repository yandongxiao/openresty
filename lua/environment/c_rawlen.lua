-- 劫持len操作
Person = {}
Person.mt = {}

function Person.new(t)
    return setmetatable(t, Person.mt)
end

function Person.len(t)
    len = t.size or 0
    return len
end

Person.mt.__len = Person.len
jack = Person.new{
    name = "jack",
    size = 170
}

assert(#jack == 170)

-- 2. 通过rawlen来绕过劫持
assert(rawlen(jack) == 0)   -- 注意返回的不是2
