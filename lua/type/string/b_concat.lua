-- 1. concat with string
str1 = "hello"
str3 = "world"
output = str1 .. " " .. str3
assert(output == "hello world")

-- 2. concat with number
str1 = "hello"
num3 = 3
output = str1 .. num3
assert(output=="hello3")
