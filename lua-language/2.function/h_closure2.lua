--[[
-- LUA 支持closure语法
-- 使用closure时应注意：closure使用到的cl中的变量不会随着cl函数的执行完毕而消失，会被closure函数引用
-- 第一次closure引用cl的变量时，变量的值就是函数执行完毕以前的值。注意并非是定义closure时的值
--]]

function cl()
    t = {}
    i = 1
    sum = 0
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
