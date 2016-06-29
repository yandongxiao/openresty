function sleep(n)
    os.execute("sleep " .. n)
end

function myroutine(a, b)
    local sum = a + b
    sleep(1)    --在sleep期间并没有释放执行权限
    return sum
end

-- 同一时间只能有一个routine在执行，且routine 函数的执行权不会
-- 被剥夺，只会是自己yiled
-- 那么，多个routine又有什么优势呢?
rt = coroutine.create(myroutine)
print(coroutine.resume(rt, 1, 2))
