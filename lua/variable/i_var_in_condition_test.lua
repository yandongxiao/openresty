--[[
-- while 和 do 之间的变量x是全局变量
-- 在定义了local之后开始使用局部变量
--]]

x = 10
i = 1
while i<=x do   -- x==10
  print(x)
  local x = i*2
  print(x)      -- 2,4,6..
  i = i + 1
end
