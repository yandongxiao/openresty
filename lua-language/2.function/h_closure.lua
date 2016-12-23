--[[
-- closure 就是通过匿名函数的方式实现的
--]]

sum = 0
function cl()
    local sum = 0
    function add(num)
        num = num or 0
        sum = sum + num
        return sum
    end

    return add
end

fn = cl()
fn()
fn(1)
fn(2)
assert(fn() == 3)
