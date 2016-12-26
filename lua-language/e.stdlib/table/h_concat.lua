nums = { 1, 2, 3, 4, 5 }

assert(type(table.concat(nums)) == "string")
assert(table.concat(nums) == "12345")
assert(table.concat(nums, ":") == "1:2:3:4:5")
assert(table.concat(nums, ":", 2, 3) == "2:3")  -- 后面两个参数都是指下标，且是[2,3]形式
