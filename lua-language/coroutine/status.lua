-- status: suspended, normal, running, dead

function sleep()
    os.execute("sleep 3")
end

function my2routine()
    -- if the coroutine is active but not running, 就是反观父coroutine的状态时，得到normal值
    print(coroutine.status(rt))
    coroutine.yield(10)

end

function myroutine()
    local rt = coroutine.create(my2routine)
    status, val = coroutine.resume(rt)
    coroutine.yield(val)
end

rt = coroutine.create(myroutine)
status, val = coroutine.resume(rt)  --yiled
print(val)
coroutine.resume(rt)    --return

status, val = coroutine.resume(rt)
if status then
    print("status should be false")
end

