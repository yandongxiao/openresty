--[[
-- 全局变量在两个协程之间共享
--]]

global_var = 100

function myroutine(a, b)
    local sum = a + b
    global_var = 200
    coroutine.yield(sum)
end

fn = coroutine.wrap(myroutine)  -- 相当于执行了coroutine.create函数
assert(type(fn) == "function")
assert(global_var == 100)
assert(fn(1, 2) == 3)    -- 执行resume函数，返回true
assert(global_var == 200)
assert(fn() == nil)     -- 执行resume函数，返回false
assert(global_var == 200)
