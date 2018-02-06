--[[
-- 与 coroutine.create + coroutine.resume 的区别
-- 1. coroutine.resume表达力不强
-- 2. 需要额外的参数来接收coroutine的状态
--]]

-- val值为nil，表示myroutine已经执行完毕并退出
function myroutine(a, b)
    local sum = a + b
    coroutine.yield(sum)
    -- 最后return nil
end

fn = coroutine.wrap(myroutine)  -- 相当于执行了coroutine.create函数
assert(type(fn) == "function")

assert(fn(1,2) == 3)    -- 执行resume函数，返回true
assert(fn() == nil)     -- 执行resume函数，返回false
