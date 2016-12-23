if 1 == 1 and 2 == 2 then
    assert(1==1)
else
    assert(1~=1)
end


-- true
a = 1 and 2
assert(a == 2)

-- nil front
a = nil and 2
assert(a == nil)
a = false and 2
assert(a == false)

-- nil end
a = 1 and nil
assert(a == nil)
a = 1 and false
assert(a == false)
