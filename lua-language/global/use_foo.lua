A = 360     --定义全局变量
foo = require("foo")

b = foo.add(A, A)
print("b = ", b)

foo.update_A()
print("A = ", A)
