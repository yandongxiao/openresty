-- mymodule.lua
local _M = {}

-- module只会被执行一次
--
-- 如果ctx是局部变量：
--      第一次请求完毕以后，ngx.ctx会被重置为nil
--      ctx将永远指向第一次请求申请的table
--
--  如果ctx是全局变量:
--      第一次请求完毕以后，ngx.ctx会被重置为nil
--      由于ngx_lua对全局变量的隔离操作，ctx会被重置为nil
--
--  如果ctx是_M的成员:
--      第一次请求完毕以后，ngx.ctx会被重置为nil
--      ctx将永远指向第一次请求申请的table
--      _M.ctx可以被访问
--
local ctx1 = ngx.ctx
ctx2 = ngx.ctx
_M.ctx3 = ngx.ctx

local function random(n, m)
    math.randomseed(os.clock()*math.random(1000000,90000000)+math.random(1000000,90000000))
    return math.random(n, m)
end

function _M.main()
    -- 他们共享同一个表
    val = random(1, 9)
    ctx1.foo = val
    ctx2.foo = val
    _M.ctx3.foo = val
end

function _M.main2(ctx)
    val = random(1, 9)
    ctx.foo = val
end

return _M
