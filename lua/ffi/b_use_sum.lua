local ffi = require "ffi"

lsum = ffi.load("sum")

ffi.cdef[[
    int sum(int x, int y);
]]

ret = lsum.sum(1, 100)
print(ret)
