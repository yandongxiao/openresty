-- 最普通的形式
num = 10
print(num)

-- 为多个变量赋值
a, b = 10, 20
print(a, b)

-- 左右两边元素个数不同
x, y, z = 1, 2
print(x, y, z)
-- 相当于
xx, yy, zz = 1, 2, nil  --又一个坑
print(xx, yy, zz)

-- 左右两边元素个数不同
mm, nn = 1, 2, 3
print(mm, nn)

-- 交换两个变量的值
a = 1
b = 2
a, b = b, a
print(a,b)

-- out put
--[[
10
10  20
1   2   nil
1   2   nil
1   2
2   1
--]]
