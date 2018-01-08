tbl = {
    [1] = "a",
    [2] = "b",
    [3] = "c",
    [26] = "z"
}
assert(#tb1 == 3)
assert(table.maxn(tb1) == 26)   -- 下标为正数的最大值
tbl[91.32] = true
assert(table.maxn(tb1)==91.32)  -- 也可以是浮点数
