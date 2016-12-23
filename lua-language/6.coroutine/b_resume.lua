-- 与函数区别1: 可以与父协程边交互边执行
function myroutine1(a, b)
    coroutine.yield("hello")
    coroutine.yield("world")
    return a + b            -- 返回给父coroutine
end

th1 = coroutine.create(myroutine1)
s, v = coroutine.resume(th1, 1, 2)
assert(s==true)
assert(v=="hello")
s, v = coroutine.resume(th1)
assert(s==true)
assert(v=="world")
s, v = coroutine.resume(th1, 3, 4) -- 参见持续传递数据
assert(s==true)
assert(v==3)

-- 与函数区别2: 异常退出时，不会影响父协程
function myroutine2(a, b)
    assert (1==2)
end

th1 = coroutine.create(myroutine2)
status, msg = coroutine.resume(th1, 1, 2)
assert(status==false)
print(msg)
print("mark")

-- 与函数区别3: 持续进行数据交互
co = coroutine.create (function ()
    v1, v2, v3 = coroutine.yield()      -- 获取resume的传递的数据
    assert(v1==1 and v2==2 and v3==3)
end)
coroutine.resume(co)
coroutine.resume(co, 1, 2, 3)
