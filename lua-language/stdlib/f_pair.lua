-- 1. 模拟pair的行为
tb = {
    1,
    2,
    fin = true,
    3
}

repeat
    k, v = next(tb, k)
    if k == nil then
        break
    end
    print(k, v)
until false

-- 2. 嵌套的table如何处理
