--[[
-- 按照惯例：局部变量会全局变量覆盖掉
--]]
x = 10
local i = 1

-- while 和 do 之间的变量x是全局变量
-- 在定义了local之后开始使用局部变量
while i<=x do
  -- 我们竟然可以在同一个block之内同时使用全局和局部变量，当然，不推荐这么使用
  -- print(x)
  local x = i*2
  print(x)
  i = i + 1
end
