--[
-- string 会自动转换为number类型
--]]

num1 = "1"
num2 = 2
sum = num1 + num2
assert(sum==3)
assert(type(sum)=="number")
