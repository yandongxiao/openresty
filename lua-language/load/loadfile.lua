x=10
f=loadfile("p.lua") -- 没有执行p.lua当中的一行代码

print("do loadfile function:")
print(f())  -- 执行p.lua代码, 当然有可能抛出异常

-- 调用了P模块当中的一个函数, 注意是直接调用
-- ＊＊loadfile() 相当于定义了一个匿名函数＊＊
-- 深刻理解了上面这句话的意思以后，可以得出两点结论：1. f()的返回值与require函数的相同; 2. 在函数当中可以定义函数(相当于闭包)
call_pfunc()
call_pfunc()    --闭包的效果

f()
call_pfunc()    -- 创建了一个新的闭包
call_pfunc()

