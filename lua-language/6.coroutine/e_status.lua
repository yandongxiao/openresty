--[[
--
-- status: suspended, normal, running, dead
-- NOTICE: 只能启动一个suspended和normal状态的协程
--
--]]

function myroutine(parrent)
    assert(coroutine.status(parrent) == "normal")
    -- NOTICE: 你可以resume父协程，父协程的resume函数返回true
    coroutine.resume(parrent)
    assert(coroutine.status(coroutine.running()) == "running")
    coroutine.yield()
    assert(coroutine.status(coroutine.running()) == "running")
end

-- suspended after created
rt = coroutine.create(myroutine)
assert(coroutine.status(rt) == "suspended")

-- suspended after yied
coroutine.resume(rt, coroutine.running())
assert(coroutine.status(rt) == "suspended")

-- dead after retuned
coroutine.resume(rt)
assert(coroutine.status(rt) == "dead")
