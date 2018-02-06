# coroutine

1. 多个coroutine之间以共享内存但**非抢占式**的方式运行
2. coroutine.resume主动触发协程执行，coroutine.yield主动放弃协程执行
3. coroutine的几种状态, 见[代码](./e_status.lua)：

    - suspended. coroutine.create成功创建的协程, 或主动执行coroutine.yield的协程；
    - normal. 调用coroutine.resume的“父协程”；
    - running. 正在执行的协程；
    - dead. 执行完毕的协程.

> cannot resume non-suspended coroutine
