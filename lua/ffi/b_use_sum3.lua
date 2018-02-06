#! /usr/local/bin/lua
local ffi = require('ffi')
local t = ffi.load("sum", false)

ffi.cdef[[
    int toint(int *x);
    void sump(int *x, int *y, int *sum);
]]

a = ffi.new("int[1]", {10})
b = ffi.new("int[1]", {10})
c = ffi.new("int[1]", {})
t.sump(a, b, c)
print(t.toint(c))
