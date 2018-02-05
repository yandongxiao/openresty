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

C与Lua之间通过虚拟堆栈的方式通信，传递的是Lua的数据结构。当C作为library code，供Lua调用时，Lua是堆栈的实际管理者。每次调用完C函数后，它负责清空堆栈中的参数和结果。如果这些C函数之间，希望共享数据，该怎么办？

### The registry（模块间共享）

registry本质上是lua table，存放在虚拟堆栈的一个虚拟位置（LUA\_REGISTRYINDEX）。即：1. 这个位置只有C函数可以访问，Lua代码访问不到；2. 该表可以被大部分的lua函数使用，但是那些想移动registry位置的C函数是会失败的；3. 这个table实际上没有在虚拟堆栈上放置。

一般情况下，使用字符串作为表的key。注意，不要使用数字作为key，因为它们是预留给Lua referrence系统的。	lua referrence系统由auxiliary library的一些函数组成，旨在帮助你创建唯一的key（number类型）。函数```int r = luaL_ref(L, LUA_REGISTRYINDEX);```从堆栈中取出value，并存储到registry表当中，同时返回key。

> 注意，虚拟堆栈内存储的是Lua类型的数据结构。像lua table 或 lua function这种复杂数据类型，C语言是无法进行独立存储的，这种值称为reference value。如果希望在C函数间共享该数据，可以借助registry表，同时借助luaL\_ref生成key。

### environments（模块内共享）

模块内共享的方式与registry类似，即将共享的数据存放到index值为LUA\_ENVIRONINDEX的表内。注册放在```luaopen_foo```内。

### upvalues（函数内共享）

the upvalue mechanism implements an equivalent of C static variables that are visible only inside a particular function.

> TODO: C函数如何实现upvalues

## User-Defined Types in C

### Userdata

liblua允许通过调用函数```void *lua_newuserdata (lua_State *L, size_t size)```，向虚拟堆栈push一块内存（a userdatum on the stack）。C函数通过强制类型转换，转换为自定义的struct结构。

通过入口函数```int luaopen_xxx (lua_State *L)```, C开发者注册了一堆函数，lua通过调用这些函数，就可以完成对struct数据的操作，如```array.set(array,index,value)```。

### Metatables

因为lua调用array.set时，可以传递任意类型的userdata，如array.set(io.stdin,1,false)。set函数要想区分不同类型的userdata，就需要借助userdata。

The usual method to distinguish one type of userdata from other userdata is to create a unique metatable for that type. Every time we create a userdata, we mark it with the corresponding metatable; and every time we get a userdata, we check whether it has the right metatable. Because Lua code cannot change the metatable of a userdatum, it cannot fake our code. 

It is customary, in Lua, to register any new C type into the registry, using a type name as the index and the metatable as the value.

```
int   luaL_newmetatable (lua_State *L, const char *tname);void  luaL_getmetatable (lua_State *L, const char *tname);void *luaL_checkudata   (lua_State *L, int index, const char *tname);
```

1. 通过registry来存储metatable；
2. 当调用array.new函数来创建metadata时，从registry获取相应的metatable，并将userdata与metatable关联起来,```lua_setmetatable```；
3. set、get等函数执行前，确认metatable的值。

> userdata数据类型也是可以有自己的metatable的，且lua不能对userdata类型数据的metatable进行修改

### Object-Oriented Access

下面是我们要完成的事情。

```
a = array.new(1000)print(a:size())     --> 之前的调用方式为：array.getsize(a)```

在table中，如果某个key找不到，就会调用__index metamethod。userdata数据类型没有任何key，所以__index metamethod永远会被执行。在它内部做a:size到array.getsize之间的映射。

在lua内部做以下设置即可。

```
local metaarray = getmetatable(array.new(1))metaarray.__index = metaarraymetaarray.set = array.setmetaarray.get = array.getmetaarray.size = array.size
```

> 注意，以上操作更应该作为C函数注册的一部分，才更加合理。C也提供了这样的支持。

```
static const struct luaL_Reg arraylib_f [] = {  {"new", newarray},  {NULL, NULL}};

static const struct luaL_Reg arraylib_m [] = {  {"set", setarray},  {"get", getarray},   "size", getsize},   {NULL, NULL}};

int luaopen_array (lua_State *L) {  luaL_newmetatable(L, "LuaBook.array");   /* metatable.__index = metatable */   lua_pushvalue(L, -1);  /* duplicates the metatable */   lua_setfield(L, -2, "__index");   luaL_register(L, NULL, arraylib_m);   luaL_register(L, "array", arraylib_f);	return 1;
}
```

> 我们还可以使用a[i]的方式访问数组，原理是修改metamethod。
> TODO：Light Userdata的主要用途？

## Threads and States

lua认为多线程编程是困难的，根源在于多线程是抢占式的且共享内存。于是Lua提供了Lua threads和Lua state两种解决方案。

一下一段文字说明了state和thread的关系：

Whenever you create a Lua state by ```lua_State *luaL_newstate (void);```, Lua automatically creates a new thread within this state, which is called the main thread.The main thread is never collected.
You can create other threads in a state calling lua_newthread: ```lua_State *lua_newthread (lua_State *L)```。

you may find it useful to think of a thread as a stack — which is what a thread actually is, from an implementation point of view. 


### create lua thread

```lua_State *lua_newthread (lua_State *L);``` lua_State不是lua state的句柄，而是(state, thread)的句柄。

>
- 两个lua thread属于同一个state。
- Each thread has its own stack. 
- The new thread L1 starts with an empty stack
- the old thread L has the new thread on the top of its stack。在L的虚拟堆栈上放置新的thread对象，重要作用是防止thread对象被收集。

> coroutine.create函数的内部实现应该是调用了lua_newthread，所以lua中的thread对象，在C函数内就是指lua_State.

### resume lua thread

```
int lua_resume (lua_State *L, int narg);
```

When lua_resume returns LUA_YIELD, the visible part of the thread’s stack contains only the values passed to yield. A call to lua_gettop will return the number of yielded values. To move these values to another thread, we can use lua_xmove.


```
lua_xmove(L1, L, 1);
```
liblua允许你在两个虚拟堆栈之间操作数据，前提是两个虚拟堆栈在同一个state之间。
