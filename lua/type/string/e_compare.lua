-- 比较时必须是类型必须一样，不存在类型自动转换
v3 = "3"
v2 = 2
if v3 > v2 then
    assert(1==1)
else
    assert(1==2)
end
