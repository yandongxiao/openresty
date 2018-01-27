local function grandson()
    ngx.say("grandson")
end

local function son()
    ngx.say("son")
    local co = ngx.thread.spawn(grandson)
    ngx.thread.wait(co)
end

ngx.say("entry thread")
local co = ngx.thread.spawn(son)
ngx.thread.wait(co)
