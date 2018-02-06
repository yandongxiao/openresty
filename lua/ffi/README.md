# [FFI](http://luajit.org/ext_ffi.html)

1. LuaJIT is fully upwards-compatible with Lua 5.1. 所以我们要尽量使用lua 5.1版本的lua编写代码；
2. LuaJIT is also fully ABI-compatible to Lua 5.1. 开发者使用C编写的库可以被lua和luajit识别；
3. The FFI library is tightly integrated into LuaJIT。

### FFI提高了代码开发效率

当我们编写library code时，需要借助lua-c-api的函数，在虚拟堆栈上完成：

1. 对Lua table数据结构的操作；
2. 调用Lua代码时，需要压栈参数；
3. 返回结果时，需要将结果压栈；
4. 需要清楚所有lua_函数的堆栈操作细节。

所以，使用lua-c-api编写代码的效率低下。FFI通过解析C的函数声明，明确堆栈操作细节，促使可以直接调用通用的C函数。

```
local ffi = require("ffi")

ffi.cdef[[
    int printf(const char * restrict format, ...);
]]

ffi.C.printf("%s\n", "helloworld");	-- ffi.C是命名空间
ffi.C.printf("%f\n", 100)
```

>
- 大部分的函数，无需重写，无需编译，即可被Lua使用；
- ffi如何完成userdata、lua数据结构与C数据结构之间的映射；
- 尤其是当C的数据结构类型多（int，unsigned int， long， unsigned long。。）

>
- 文章一[文章](http://blog.csdn.net/alexwoo0501/article/details/50636785)
- 文章二[文章](https://moonbingbing.gitbooks.io/openresty-best-practices/lua/FFI.html)