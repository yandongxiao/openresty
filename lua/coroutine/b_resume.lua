--[[
-- 任意函数都可以被协程化，使用协程通信时，是全双工通信。
-- python的生成器和协程也拥有类似的功能
--]]

-- 与函数区别1: 可以与父协程边交互边执行
function myroutine1(a, b)
    coroutine.yield("hello")
    coroutine.yield("world")
    return a + b            -- 返回给父coroutine
end

th1 = coroutine.create(myroutine1)  --协程th1进入Suspend状态
s, v = coroutine.resume(th1, 1, 2)  --协程th1进入Running状态，开始运行
assert(s==true)                     --每次都会返回th1的状态信息
assert(v=="hello")
s, v = coroutine.resume(th1)        --二次启动
assert(s==true)
assert(v=="world")
s, v = coroutine.resume(th1, 3, 4) -- NOTE: 传递的参数根本没用, 参见区别3
assert(s==true)
assert(v==3)

-- 与函数区别2: 异常退出时，不会影响父协程
function myroutine2(a, b)
    assert (1==2)
end

th1 = coroutine.create(myroutine2)
status, msg = coroutine.resume(th1, 1, 2)
assert(status==false)       --NOTE: 异常退出时，状态码为false
print(msg)

-- 与函数区别3: 持续进行数据交互
co = coroutine.create (function ()
    v1, v2, v3 = coroutine.yield()      -- 获取resume的传递的数据
    print(v1, v2, v3)
    v1, v2, v3 = coroutine.yield()
    print(v1, v2, v3)
end)
coroutine.resume(co)
coroutine.resume(co, 1, 2, 3)
coroutine.resume(co, 4, 5, 6)
