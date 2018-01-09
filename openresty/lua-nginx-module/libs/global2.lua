local ngx = require "ngx"
require "libs/global"   -- 引用第三方全局变量模块
--count = 100

local function add()
    count = count + 1
    return count
end

local function sub()
    count = count - 1
    return count
end

local _M = {
    add = add,
    sub = sub
}

return _M
