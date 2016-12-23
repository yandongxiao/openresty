function rc()
    print("rc1")
    coroutine.yield()
    print("rc2")
end

function rb()
    thc = coroutine.create(rc)
    coroutine.yield(thc)
    -- 创建子协程后就退出
    coroutine.resume(thc)
end

-- 证明:
--  1. thread 的传递肯定时引用传递
--  2. 父子协程的声明周期没有固定的约束，也可以认为没有所谓的父子协程
--  3. 多个协程可以控制同一个协程
--  4. 存在main协程
thb = coroutine.create(rb)
_, thc = coroutine.resume(thb)
coroutine.resume(thc) -- output rc1
coroutine.resume(thb) -- output rc2
