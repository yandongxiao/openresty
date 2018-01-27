local capture = ngx.location.capture
local spawn = ngx.thread.spawn
local wait = ngx.thread.wait
local say = ngx.say

local function son1(uri)
    ngx.sleep(1)
    ngx.say("son1")
end
-- 可以执行kill操作
-- co = spawn(son1)
-- ngx.thread.kill(co)
-- ngx.exit(ngx.OK)

local function son2(uri)
    res = capture("/son")
    ngx.say(res.body)
end

co = spawn(son2)
ngx.say("entry thread")

ok, err = ngx.thread.kill(co)
if not ok then
    -- 如果子协程发起了子请求，kill操作会失败
    -- error message：pending subrequests
    ngx.say(err)
end

-- 调用该函数，会导致entry thread abort
-- ngx.exit(ngx.OK)
