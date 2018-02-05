# lua应用

1. read and write Lua global variables（lua可以作为配置文件时）
2. call Lua functions.（lua可以成为编写C语言的"库函数"的一个选择）
3. run pieces of Lua code (C语言的开发者可以直接将逻辑外置到lua中)
4. register C functions (lua可以调用这些C函数)

## [使用lua作为配置文件](./g_lua_as_conf.c)

1. 无论多么简单的配置文件，都需要解析器的帮助；
2. 本质是执行Lua文件，使用lua解析配置文件, 并通过虚拟堆栈的方式获取结果;
3. lua的全局变量不会自动放置到虚拟堆栈中，借助lua_getglobal(L, "width")的方式
获取全局变量，并放置到虚拟堆栈的栈顶.

## 获取Lua的table结构

1. lua\_getglobal(L, "background"); 虚拟堆栈的一个slot可以存放lua的任意数据类型，包括table；
2. lua_pushstring(L, key); 将希望获取的key压栈；
3. lua_gettable(L, -2);  gettable首先弹栈key，获取value，再把value压栈；
4. lua_pop(L, 1) 恢复堆栈状态

> Lua将2，3，4步合并，对外提供了lua_getfield(L, -1, key)函数。

## 向虚拟堆栈push一个table

1. lua\_newtable(L);
2. lua\_pushstring(L, key)
3. lua\_pushnumber(L, (double)value/MAX_COLOR);
4. lua\_settable(L, -3); 将key和value从堆栈中取出来，并设置到table内
5. 循环执行2，3，4步，最后执行lua_setglobal(L, ct->name)，将它设置为lua的全局变量

## [Calling Lua Functions](./i_call_lua_function.c)

1. you push the function to be called
2. you push the arguments to the call
3. you use lua_pcall to do the actual call
4. you pop the results from the stack

> 虚拟堆栈与C的堆栈的工作方式看起来是一样的
> lua_pcall的最后一个参数是错误处理函数，它一般用于异常时打印堆栈信息。


## Calling C from Lua

如果C函数想要被lua调用，需要解决函数地址问题，传参问题以及返回值的问题。

1. 注册C函数；

	- 被注册函数形式

	```
	typedef int (*lua_CFunction) (lua_State *L);
	returns an integer with the number of values it is returning in the stack.
	```

	- 注册过程

	```
	lua_pushcfunction(L, l_sin);   lua_setglobal(L, "mysin");
	```
	接下来，lua代码中就可以使用mysin函数了

2. 从虚拟堆栈中获取参数（无需POP）；
3. 将计算结果push到虚拟堆栈，return在虚拟堆栈上结果的个数；
4. lua根据C函数的返回值可以确定虚拟堆栈中返回值的个数，一并将函数、形参和结果进行清除。

> lua标准库中的函数是对ANSI C中的函数的抽象。这是考虑到了lua的平台通用性。如果希望lua读写文件，底层C函数实现时，可能会依赖不同的系统（Windows或POSIX），所以标准lua不会提供这些函数。

### C Modules

一般情况下，我们不会只提供一个C函数来供Lua调用，我们会提供一些列的C函数，这些C函数被称为一个C module。

Lua module的定义方式：1. 定义多个lua函数；2. 在lua main chunk内，通过lua table，将这些lua函数组织起来；3. 返回该table；4. 调用者调用require "xx", 返回该table。

c module的定义方式与Lua类似：

- 定义所有的C函数；
- 在一个特殊的函数内将注册所有的C函数，在lua module内对应的是lua main chunk；

```
int luaopen_newl(lua_State* L) {

	//1. 并且完成模块初始化(因为这个特殊函数，往往只会执行一次);
	//2. newl是类似于lua的一个表，完成函数名与函数地址的映射；
	luaL_newlib(L, newl)
}

gcc -shared -fPIC h_register_c_function2.c -L/usr/local/lib -llua -o newl.so
```

- 将生成动态链接库放置在LUA_PATH下，lua函数可以通过newl = require "newl"的方式使用该动态库

详情参见[h_register\_c\_function2.c](./h_register_c_function2.c)

> When you are writing the main code in an application, you should not use lua\_call, because you want to catch any errors. When you are writing functions, however, it is usually a good idea to use lua\_call; if there is an error, just leave it to someone that cares about it.


## 编写C函数的技巧

1. liblua为array的查询和修改，提供了专门的函数（虽然也可以使用table类的函数）；
2. liblua为字符串的substring和连接字符串提供了帮助，也解决了链接大量字符串时存在的效率问题；
