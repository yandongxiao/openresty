#! /usr/local/bin/lua
if not (1 == 2) then    -- 必须加括号
    assert(1==1)
else
    assert(1==2)
end

a = not (1 == 2)
assert (a == true)

-- table, function, userdata是引用比较
a = {1, 2, 3}
b = {1, 2, 3}
assert(a ~= b)
b = a
assert(a == b)
