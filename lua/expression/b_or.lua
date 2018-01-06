if 1 == 2 or 2 == 2 then
    assert(2 == 2)
else
    assert(2 ~= 2)  -- not equal
end

-- true
a = 1 or 2
assert(a==1)
a = nil or 2
assert(a==2)

-- false
a = nil or false
assert(a==false)
a = false or nil
assert(a==nil)
