--[[
-- LUA 支持closure语法
-- 使用closure时应注意：closure使用到的cl中的变量不会随着cl函数的执行完毕而消失，会被closure函数锁引用
-- 第一次closure引用cl的变量时，变量的值就是函数执行完毕以前的值。注意并非是定义closure时的值
--]]

function cl()
    t = {}
    i = 1
    repeat
        function add(num)
            return num + i
        end
        t[i] = add
        i = i + 1
    until i == 5
    print(i)
    return t
end

t = cl()
print(t[1](1))
print(t[2](1))
print(t[3](1))
print(t[4](1))
