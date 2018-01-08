-- 只针对字符串和数字
age = "10"
assert(tonumber(age) == 10)

-- NOTICE: 只是返回nil，没有出错返回
age = {}
assert(tonumber(age) == nil)
