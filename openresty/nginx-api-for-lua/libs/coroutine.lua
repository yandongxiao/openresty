function sum(a, b)
    ngx.say(ngx.now())
    ngx.sleep(10)
    ngx.say("sum...")
    return a+b
end

-- 创建子协程成功后，子协程没有立即执行
thread = coroutine.create(sum)
assert(type(thread) == "thread")

-- 运行子协程，子协程虽然调用了ngx.sleep但是"貌似"它并不会释放计算资源
-- 子协程必须调用coroutine.yield来主动释放CPU
-- NOTE: ngx.sleep被调用时，协程实际上释放了资源（因为并发发送curl请求时，并没有被阻塞)
ngx.say("entry thread")
status, rt = coroutine.resume(thread, 1, 2)
assert(status==true)
ngx.say(rt)
