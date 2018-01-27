local capture = ngx.location.capture
local spawn = ngx.thread.spawn
local wait = ngx.thread.wait
local say = ngx.say

local function fetch(uri)
    res = capture(uri)
    ngx.say(res.body)
end

local threads = {
    spawn(fetch, "/foo"),
    spawn(fetch, "/bar"),
    spawn(fetch, "/baz")
}

-- for i = 1, #threads do
--     local ok, res = wait(threads[i])
--     if not ok then
--         say(i, ": failed to run: ", res)
--     else
--         say(i, ": status: ", res.status)
--         say(i, ": body: ", res.body)
--     end
-- end

-- wait any
-- 由于三个子协程都发起了子请求，所以必须执行wait操作后，方可执行ngx.exit函数
ngx.say("entry thread")
-- 没有wait，日志报错如下：
-- attempt to abort with pending subrequests
-- wait(threads[1], threads[2], threads[3])
ngx.exit(ngx.OK)
