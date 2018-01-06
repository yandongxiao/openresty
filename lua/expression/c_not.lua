if not (1 == 2) then    -- 必须加括号
    assert(1==1)
else
    assert(1==2)
end

a = not (1 == 2) 
assert (a == true)
