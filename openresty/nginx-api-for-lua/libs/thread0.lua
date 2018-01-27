-- you can call coroutine.status() and coroutine.yield() on the "light thread" coroutines.
local yield = coroutine.yield

function f()
    local self = coroutine.running()
    ngx.say("f 1")
    yield(self)
    ngx.say("f 2")
    yield(self)
    ngx.say("f 3")
end

-- 返回当前正在运行的协程对象
local self = coroutine.running()
-- 虽然主动放弃了CPU，但是由于content阶段只有这么一个协程，所以它还会被ngx_lua唤醒。
ngx.say("0")
yield(self)

-- 通过ngx.thread.spawn创建了user thread, 且user thread会优先运行，直到它
-- until it returns, aborts with an error, or gets yielded due to I/O operations via the Nginx API for Lua
ngx.say("1")
ngx.thread.spawn(f)

ngx.say("2")
yield(self)

ngx.say("3")
yield(self)

ngx.say("4")

ngx.exit(ngx.OK)
