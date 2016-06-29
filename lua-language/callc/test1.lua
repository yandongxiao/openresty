local ffi = require("ffi")

ffi.cdef[[
  int printf(const char *format, ...);
]]

ffi.C.printf("%s\n", "helloworld");
