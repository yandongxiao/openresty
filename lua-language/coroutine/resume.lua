function myroutine(count)
    for i = 1, count do
        print()
        coroutine.yield(i)
    end
end

rt = coroutine.create(myroutine) 
print(coroutine.status(rt))     -- 进程状态suspended

for i=10, 1, -1 do
    -- 第一次调用resume时，传递了myroutine需要的参数
    -- 接下来调用resume函数时，这些参数可以省略，因为它们不再起到任何作用
    status, val = coroutine.resume(rt, 10)  -- 函数返回后，进程状态suspended
    if status then
        print(val, i)
    else
        local err=val
        print(err)
    end
end

status, val = coroutine.resume(rt, 10)  -- 本次coroutine的返回不是因为yield，而是执行了return语句
print(status, val)  -- status的值还是true
print(coroutine.status(rt))     -- 进程状态dead

status, val = coroutine.resume(rt, 10)
print(status, val)  -- you can not resume dead coroutine
