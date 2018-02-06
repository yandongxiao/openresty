#! /usr/local/bin/lua
local ffi = require("ffi")

ffi.cdef[[
    int printf(const char * restrict format, ...);
]]

ffi.C.printf("%s\n", "helloworld");
ffi.C.printf("%f\n", 100)  -- 为什么会执行失败
