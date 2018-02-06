function sleep(n)
    os.execute("sleep " .. n)
end

function myroutine(a, b)    -- 对coroutine没有参数上的限制
    sleep(1)                -- NOTE: 在sleep期间并没有释放执行权限
    print("hello")
    return a+b                -- 返回给父coroutine
end

thread = coroutine.create(myroutine)    -- coroutine 并没有立刻执行
assert(type(thread) == "thread")
status, rt = coroutine.resume(thread, 1, 2)
assert(status==true)
assert(rt == 3)

-- NOTICE: 参数类型不是函数
-- 类型之间不能混用，就像是字符串不能与num进行比较一样，LUA出错退出
--num = 10
--thread = coroutine.create(num)
