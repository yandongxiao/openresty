-- 返回的类型是thread类型
-- 一个coroutine对应一个thread实例
th = coroutine.running()
assert(type(th) == "thread")

-- 启动一个正在运行的coroutine
-- 报错如下：cannot resume non-suspended coroutine
print(coroutine.resume(th))
