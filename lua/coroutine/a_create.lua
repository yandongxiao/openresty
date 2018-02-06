--[[
-- 1. 同一时间只能有一个routine在执行
-- 2. coroutine是**非抢占方式**运行，需要routine自己调用yiled方法释放资源
-- 3. coroutine与线程一样，拥有自己的堆栈、局部变量、共享全局变量
-- 4. NOTE: 任意一个函数都可以拿来当作自协程
--
-- routine的各个状态：
--]]

function sleep(n)
    os.execute("sleep " .. n)
end

function myroutine(a, b)    -- 对coroutine没有参数上的限制
    sleep(1)                -- 在sleep期间并没有释放执行权限
    print("hello")
    return 1                -- 返回给父coroutine
end

thread = coroutine.create(myroutine)    -- coroutine 并没有立刻执行
assert(type(thread) == "thread")
status, rt = coroutine.resume(thread, 1, 2) -- coroutine的运行resume和停止yield都是受到管控的
assert(status==true)
assert(rt == 1)

-- NOTICE: 参数类型不是函数
-- 类型之间不能混用，就像是字符串不能与num进行比较一样，LUA出错退出
--num = 10
--thread = coroutine.create(num)
