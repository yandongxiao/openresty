--[[
-- NOTICE:
-- string库是不会对源字符串做任何修改的，都是返回新的字符串
-- 字符串是不可修改的，这个在python和GO语言当中也是如此处理的
-- 字符串变量实际上对应一小块内存结构，该结构一般由两部分组成，一是指向字符串的内存首地址，二是字符串的长度.
-- 所以两个字符串变量之间的比较是这两小块的内存的比较，速度是O(1)
--]]

str = "helloworld"
assert(string.rep(str, 2) == "helloworldhelloworld")
assert(string.upper(str) == "HELLOWORLD")
assert(string.lower("HELLOworld") == str)
assert(string.len(str) == 10)
assert(string.sub(str, 2, -2) == "elloworl")
assert(string.sub(str, 2) == "elloworld")
assert(string.sub(str, 22) == "")
assert(string.reverse(str) == "dlrowolleh")
assert(string.format("%s-%s", str, str) == "helloworld-helloworld")
assert(string.char(97, 98, 99) == "abc")
a, b, c = string.byte("abc", 1, 3)  -- 第三个参数的默认值与第二个参数的值相同
assert(a == 97)
assert(b == 98)
assert(c == 99)

b, e = string.find(str, "o")
assert(b==5)
assert(e==5)
