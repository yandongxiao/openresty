function child(num1, num2)
    local self = coroutine.running()

    ngx.ctx.sum = num1 + num2
    coroutine.yield(self)

    ngx.ctx.sub = num1 - num2
    -- 以下错误发生在user thread, 只会导致该light thread异常退出
    ngx.sleep('e')
end

local self = coroutine.running()
local co = ngx.thread.spawn(child, 1, 2)

-- NOTE: ngx.say指令不允许出现在两个handler内
-- 3, nil
--ngx.say(ngx.ctx.sum)
--ngx.say(ngx.ctx.sub)

-- 3, -1
coroutine.yield(self)
--ngx.say(ngx.ctx.sum)
--ngx.say(ngx.ctx.sub)

-- 以下错误发生在entry thread, 导致nginx直接返回500.
-- ngx.sleep('e')
