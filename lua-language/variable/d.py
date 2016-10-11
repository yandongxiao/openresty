#!/usr/bin/env python
# encoding: utf-8

# 等于
a, b, c = 1, 2, 3
print(a, b, c)

# 不合法
aa, bb, cc = 1, 2
print(aa, bb, cc)   # 值为nil
# 不合法
cc=10
aa, bb, cc = 1, 2
print(aa, bb, cc)   # 值为nil

# 不合法
xx, yy = 1, (2, 3)
print(xx, yy)
