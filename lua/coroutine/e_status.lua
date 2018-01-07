--[[
-- 当在协程A中resume()另外一个协程B时，A的状态不是suspended，因为我们不能再通过resume()调用执行，
-- 而且协程A也不是running状态，协程B才是，因此协程A处于normal状态。
--
-- status: suspended, normal, running, dead
-- NOTICE: 只能启动一个suspended和normal状态的协程
--]]

function myroutine(parrent)
    assert(coroutine.status(parrent) == "normal")
    -- NOTICE: 你不可以resume父协程：
    -- cannot resume non-suspended coroutine
    print(coroutine.resume(parrent))
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
