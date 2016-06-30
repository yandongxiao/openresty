foo = require "global_vars" -- require的返回值跟命名空间没有半毛钱关系

-- 如果global_vars.lua 没有显示的return， 那么返回值默认未true，表示加载模块成功
-- 如果显式地执行return nil语句，那么require的到的返回值，仍然是true
assert(foo == true)
print(AAA)
