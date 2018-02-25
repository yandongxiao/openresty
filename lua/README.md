# Lua

Lua，在葡萄牙语里代表美丽的月亮。它有如下特点：

1. Lua是嵌入式语言。它没有丰富的库和工具，一般不会作为一门独立的开发语言。
2. Lua可作为多种语言的嵌入脚本，如C，java等。
3. 在C语言中通过liblua.so提供的Lua-c-api，可以完成C代码与Lua代码的互相调用。
3. Lua作为一门脚本语言，如果跑在Lua解释器中会降低Lua的执行速度
4. JIT（Just In Time）即时编译技术可以让Lua代码直接跑在CPU上，大大加快运行速度
5. Lua语言不向后兼容

>
- [基本语法](./expression)
- [全局变量](./environment)
- [协程](./coroutine)
- [FFI](./ffi)
- [Lua-c-api](./Lua-c-api)

## Lua 与 c 语言的关系

### Lua is an c application

可执行文件Lua是由c语言+liblua.so开发的一个应用。

```
源文件参见: /Users/dxyan06/opt/openresty-1.9.15.1/bundle/Lua-5.1.5/src/Lua.c
ldd /usr/bin/Lua
    libLua-5.1.so => /usr/lib64/libLua-5.1.so (0x00007f5dc1708000)
    可见，Lua应用使用了libLua库
```

### Lua is an extension language

Lua的核心是libLua.so。程序员使用C语言开发程序时，可以借助Lua库，将部分逻辑扩展到Lua
文件。C程序通过Lua_pcall调用Lua文件，获取返回结果.

可执行文件Lua就是借助libLua.so库，开发的一个Lua解释器。简单的解释器，参见：[这里](./lua-c-api/b_interpreter.c)

这时写的C语言代码，称为applcation code(e.g: Lua.c).

### Lua is an extensible language

Lua可以调用C代码，这样C语言的强大的库也可以暴露给Lua使用.

这时写的C语言代码，称为library code(e.g: lmathlib.c).

>
- both application code and library code use the same API to communicate with Lua, the so called Lua-c-api.
- Lua-c-api 是Lua和c沟通的桥梁, 桥梁的本质是虚拟堆栈技术.
- Luajit提供了开发library code效率更高的[FFI模块](./ffi/README.md)
