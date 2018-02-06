# coroutine

## 基本情况

1. 多个coroutine之间以共享内存但**非抢占式**的方式运行, 同一时间只能有一个routine在执行
2. 任意一个函数都可以拿来当作自协程
3. coroutine.resume主动触发协程执行，coroutine.yield主动放弃协程执行. 即使协程正在执行阻塞式操作, 也不会放弃执行
4. coroutine的几种状态, 见[代码](./e_status.lua)：

    - suspended. coroutine.create成功创建的协程, 或主动执行coroutine.yield的协程。只能resume suspended的协程；
    - normal. 调用coroutine.resume的“父协程”，父协程不能被resume，否则会出现```cannot resume non-suspended coroutine```；
    - running. 正在执行的协程；
    - dead. 执行完毕的协程.

## resume

1. 协程之间是全双工通信。 协程通过coroutine.resume或coroutine.yield的参数，获取另外一个协程传递的参数; 协程通过coroutine.resume或coroutine.yield的返回值获取另外一个协程传递的结果
2. 通过coroutine.wrap将协程封装成为一个函数，方便传递参数和返回值。
4. 协程之间并无父子关系，可以resume一个完全不相关的协程
4. 非主协程异常退出时，不会影响其它协程.
5. 主协程退出时，整个Lua进程退出，见[代码](./c_assign.lua)
