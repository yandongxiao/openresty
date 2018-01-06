local ffi = require "ffi"

local sum = ffi.load("sum")

ffi.cdef[[
    int sum(int x, int y);
]]

ngx.say("package.cpath: ", package.cpath)
ngx.say("sum: ", sum.sum(1, 100))
