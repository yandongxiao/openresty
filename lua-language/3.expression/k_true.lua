-- 非nil 和 false的值都是true

if 0 then
    assert(1==1)
else
    assert(1==2)
end

if "" then
    assert(1==1)
else
    assert(1==2)
end
