local mysql = require "resty.mysql"
local memcached = require "resty.memcached"
local cjson = require "cjson"

local function query_mysql()
    local db = mysql:new()
    db:connect{
                host = "127.0.0.1",
                port = 3306,
                database = "hello",
                user = "root",
                password = "root",
                charset = "utf8"
              }
    local res, err, errno, sqlstate =
            db:query("select * from department")
    db:set_keepalive(0, 100)
    ngx.say("mysql done: ", cjson.encode(res))
end

local function query_http()
    local res = ngx.location.capture("/sub")
    ngx.say("http done: ", res.body)
end

c1 = ngx.thread.spawn(query_mysql)      -- create thread 1
c2 = ngx.thread.spawn(query_http)       -- create thread 2

-- 由于ngx.thread.spawn创建的协程是异步执行的
-- 且query_mysql和query_http会发起阻塞式的IO，所以下面的语句会优先执行
ngx.say("entry thread")

-- NOTE: So it is also prohibited to abort a running "light thread" that is pending on one ore more Nginx subrequests.
-- NOTE: Waits on one or more child "light threads" and returns the results of the first "light thread" that terminates (either successfully or with an error).)
-- 所以要分成两个wait来确保两个子协程都terminate
-- NOTE: Only the direct "parent coroutine" can wait on its child "light thread", otherwise a Lua exception will be raised.
-- ngx.thread.wait(c1)
-- ngx.thread.wait(c2)
-- ngx.say("end")

--父协程运行时，其它协程都处于pending状态（虽然coroutine.status返回了running状态）
--*** 且子协程发起了子请求 ***
--此时不能直接调用ngx.exit(ngx.OK). 必须执行ngx.thread.wait
ngx.thread.wait(c1, c2)
-- ngx.say(coroutine.status(c1), coroutine.status(c2))
ngx.exit(ngx.OK)
