function sum(a, b)
    ngx.sleep(1)
    ngx.say("sum...")
    return a+b
end

-- 创建子协程成功后，子协程没有立即执行
thread = coroutine.create(sum)
assert(type(thread) == "thread")

-- 运行子协程，子协程虽然调用了ngx.sleep但是貌似它并不会释放计算资源
-- 子协程必须调用coroutine.yield来主动释放CPU
ngx.say("entry thread")
status, rt = coroutine.resume(thread, 1, 2)
assert(status==true)
ngx.say(rt)
