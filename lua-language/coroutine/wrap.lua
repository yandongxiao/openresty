function sleep(n)
    os.execute("sleep " .. n)
end

function myroutine(a, b)
    local sum = a + b
    coroutine.yield(sum)
end

--[[
-- 使用wrap更加方便，但是routine的返回值需要区分routine是否已经结束
--]]
fn = coroutine.wrap(myroutine)  -- 只会函数函数这一个返回值
val = fn(1,2) -- 只会返回myroutine的yield的内容
print(val)

-- val值为nil，表示myroutine已经执行完毕并退出
val = fn(1,2)
print(val)
