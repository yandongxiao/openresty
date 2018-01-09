local P = {}
_G["share"] = P
setfenv(1, P)

-- 由于上面的设置，val是一个模块级别的变量
val = 10
