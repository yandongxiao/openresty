-- 1. 访问下标不存在的元素时，返回nil
arr = {
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [100] = 100
}
assert(arr[4]==nil)
assert(arr[#arr]   == 3)    -- #arr 返回的是数组的长度，not 关联数组长度
assert(arr[#arr-1] == 2)

-- a[100] 并不会被输出，当迭代到a[4]时，发现它的值是nil
-- 程序就直接退出了
for _, val in ipairs(arr) do
    assert(val==1  or val==2 or val==3)
end

-- append
arr[#arr+1] = 4
assert(#arr == 4)

-- insert
arr[1000] = 1000    -- 这样的赋值对性能完全没有影响
