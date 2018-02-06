-- a ? b : c 的等价形式

b = "b"
c = "c"

a = nil
assert((a and b) or c == "c")

a=1
assert((a and b) or c == "b")
