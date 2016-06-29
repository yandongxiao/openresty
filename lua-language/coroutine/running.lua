function myroutine(a, b)
    local sum = a + b
    -- 相当于获得当前线程的线程ID
    print(coroutine.status(coroutine.running()))
    return sum
end

rt = coroutine.create(myroutine)
print(coroutine.resume(rt, 1, 2))
