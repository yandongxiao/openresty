# Lua

Lua，在葡萄牙语里代表美丽的月亮。它有如下特点：

1. Lua是嵌入式语言。它没有丰富的库和工具，一般不能独立地作为一门开发语言。
2. Lua常嵌套于C语言，通过liblua.so，将一些逻辑代码放在lua中执行.
3. Lua作为一门脚本语言，如果跑在Lua解释器中会降低Lua的执行速度
4. JIT（Just In Time）即时编译技术可以让Lua代码直接跑在CPU上，大大加快运行速度
5. Lua语言不向后兼容

>
- [全局变量](./environment)
- [协程](./coroutine)
- [FFI](./ffi)
- [lua-c-api](./lua-c-api)

## lua 与 c 语言的关系

### lua is an c application

可执行文件lua是由c语言开发的一个应用.

```
源文件参见: /Users/dxyan06/opt/openresty-1.9.15.1/bundle/lua-5.1.5/src/lua.c
ldd /usr/bin/lua
    liblua-5.1.so => /usr/lib64/liblua-5.1.so (0x00007f5dc1708000)
    可见，lua应用使用了liblua库
```

### lua is an extension language

lua的核心是liblua.so。程序员使用C语言开发程序时，可以借助lua库，将部分逻辑扩展到lua
文件。C程序通过lua_pcall调用lua文件，并获取返回结果.

可执行文件lua就是借助liblua.so库，开发的一个lua解释器。简单的解释器，参见：./b_interpreter.c

这时写的C语言代码，称为applcation code(e.g: lua.c).

### lua is an extensible language

lua可以调用C代码，这样C语言的强大的库也可以暴露给Lua使用.

这时写的C语言代码，称为library code(e.g: lmathlib.c).

- both application code and library code use the same API to communicate with Lua, the so called lua-c-api.
- lua-c-api 是lua和c沟通的桥梁, 也是liblua提供的api.
- luajit提供了开发library code效率更高的[FFI模块](./ffi/README.md)

