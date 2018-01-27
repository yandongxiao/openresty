function f()
    ngx.sleep(0.2)
    ngx.say("f: hello")
    return "f done"
end

function g()
    ngx.sleep(0.1)
    ngx.say("g: hello")
    return "g done"
end

local tf, err = ngx.thread.spawn(f)
if not tf then
    ngx.say("failed to spawn thread f: ", err)
    return
end

-- running
ngx.say("f thread created: ", coroutine.status(tf))

local tg, err = ngx.thread.spawn(g)
if not tg then
    ngx.say("failed to spawn thread g: ", err)
    return
end

-- running
ngx.say("g thread created: ", coroutine.status(tg))

-- wait any
-- 由于两个子协程并没有发起subrequest, 所以可以直接调用ngx.exit来退出该handler
--ok, res = ngx.thread.wait(tf, tg)
--if not ok then
--   ngx.say("failed to wait: ", res)
--   return
--end
--ngx.say("res: ", res)

-- 第一次wait返回了tg的结果，所以可以再次等待tf的结果
-- ok, res = ngx.thread.wait(tf)
-- ngx.say("res: ", res)

-- stop the "world", aborting other running threads
-- NOTE:NOTE: 该函数必须放在ngx.thread.wait之后
-- You must call ngx.thread.wait to wait for those "light thread" to terminate before quitting the "world".
ngx.exit(ngx.OK)
