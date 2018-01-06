local ngx = require "ngx"
require "libs/global"   -- 引用第三方全局变量模块
--count = 100

local _M = {}

local function add()
    count = count + 1
end

local function sub()
    ngx.update_time()
    ngx.sleep(ngx.time()%0.003) --模拟后端阻塞时间
    count = count - 1
end

function _M.calc()
    -- NOTICE: 在执行过程中协程可能会被暂停，转而去运行新的一个协程
    -- 它们运行的都是同一份代码，公用全局变量
    add()
    sub()
    return count
end

return _M
