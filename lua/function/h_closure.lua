--[[
-- LUA 支持函数嵌套，支持closure语法
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
assert(sum == 0)

-- 定义了多个closure函数，这些闭包函数共享cl的局部变量
-- 第一次closure引用cl的变量时，变量的值就是cl函数执行完毕后的值。
function cl()
    local t = {}
    local i = 1
    local sum = 0
    repeat
        function add(num)
            num = num or 0
            i = i + 1
            sum = sum + num + i
            return sum
        end
        t[i] = add
        i = i + 1
    until i == 5    -- 退出时i==5
    return t
end

t = cl()
assert(t[1]() == 6)      -- 当add被执行时，i==5
assert(t[2]() == 13)     -- 共享t、i、sum
assert(t[3]() == 21)
