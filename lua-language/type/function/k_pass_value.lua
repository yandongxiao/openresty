--[[
--
-- 值传递的类型有:
--      boolean
--      number
--      string
--]]

function myfunc(val)
    val = true
end
b = false
myfunc(b)
assert(b==false)

function myfunc(val)
    val = 10
end
n = 1
myfunc(n)
assert(n==1)

function myfunc(val)
    val = "bb"
end
ss = "ss"
myfunc(ss)
assert(ss=="ss")
