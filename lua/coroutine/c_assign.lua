#! /usr/local/bin/lua
--[[
-- 证明:
--  1. thread 的传递肯定是引用传递
--  2. 父子协程的生命周期没有固定的约束，也可以认为没有所谓的父子协程
--  3. 可以resume一个不相关的协程
--  4. 存在主协程
--]]

function rc()
    print("rc1")
    coroutine.yield()
    print("rc2")
    coroutine.yield()
    print("rc3")    -- 没有被执行
end

function rb()
    print("rb begin")
    thc = coroutine.create(rc)
    coroutine.yield(thc)
    coroutine.resume(thc)
    print("rb end")
end

function rbb(thc)
    print("rbb begin")
    coroutine.resume(thc)
    print("rbb end")
end

-- main协程
print("main begin")
thb = coroutine.create(rb)
_, thc = coroutine.resume(thb)
thbb = coroutine.create(rbb)
coroutine.resume(thc)   -- output rc1
coroutine.resume(thb)   -- output rc2
print("main end")
