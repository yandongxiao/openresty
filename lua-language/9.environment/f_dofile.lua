-- 1. dofile 加载LUA文件、编译、并执行。
-- 2. 与函数相比，你无法传递参数给p.lua文件，但通过dofile也可以获得模块返回值
-- 3. NOTICE: 每次执行dofile操作，都会对代码进行重编译，耗时
nt = dofile("p.lua")    -- 与require的区别之一，它不会使用搜索LUA_PATH，所以使用全称
nt.add()
nt.add()
assert(nt.val() == 3)

-- 4. 加载的文件不存在时，dofile会导致LUA出错返回
--val2=dofile("p1.lua")


-- 5. 通过dofile多次执行同一块代码，但是返回了两个独立的table
nt1 = dofile("p.lua")
nt2 = dofile("p.lua")
assert(nt1 ~= nt2)
