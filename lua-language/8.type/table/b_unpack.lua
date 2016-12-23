--[[
-- table 在作为函数参数方面的应用
--]]

-- 1. unpack
-- unpack的工作原理如下：以下标1开始寻找值，直到某个下标的值为nil，按照多重赋值的方式返回给调用者
vals = {1, 2, 3, name="dsa"}
function myfunc(v1, v2, v3)
    assert(v1 == 1)
    assert(v2 == 2)
    assert(v3 == 3)
end
myfunc(unpack(vals))    --NOTICE: unpack 是函数和table之间的适配层

-- 2. 印证unpack的工作原理
person1 = {
    [1]=1,
    [10]=10,
    name="nihao",
    age=10,
    8,
    9
}

cnt = 0
newp = {unpack(person1)}
for k, v in pairs(newp) do  -- NOTICE: not ipairs
    assert(newp[1]==8)
    assert(newp[2]==9)
    cnt = cnt + 1
end
assert(cnt==2)
