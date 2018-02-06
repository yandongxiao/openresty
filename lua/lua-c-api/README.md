# lua-c-api

## lua-c-api简介

### lua-c-api的主要能力

1. read and write Lua global variables（lua可以作为配置文件时）
2. call Lua functions.（lua可以成为编写C语言的"库函数"的一个选择）
3. run pieces of Lua code (C语言的开发者可以直接将逻辑外置到lua中)
4. register C functions (lua可以调用这些C函数)

### lua-c-api的接口特性

1. do not check the correctness of their arguments (由API的调用者检查)
2. the API emphasizes flexibility and simplicity, sometimes at the cost of ease of use. (即便是通过liblua与lua做简单交互，需要调用很多个API。虽然繁杂，但是给了开发者更大的控制力)
3. an omnipresent virtual stack 解决了LUA和C之间参数传递的问题, 解决了C(静态)与lua(动态)的数据类型问题，解决了lua的自动垃圾回收.

### lua-c-api的层次关系

1. The header file lua.h defines the basic functions provided by Lua.
2. Everything defined in lua.h has a lua\_ prefix.
3. lauxlib.h defines the functions which provide a higher abstraction level by using the basic api provided by lua.h
4. All its definitions start with luaL\_
5. all Lua standard libraries use the auxlib

> 所以，lua-c-api提供的API分为三个层级，lua.h, lauxlib.h 和 标准库(如lmathlib.c).

## lua-c-api的核心概念

- lua environment

	```lua_State *luaL_newstate (void)```创建lua state的同时也创建了一个lua main thread（coroutine），一个lua thread属于一个lua state。调用```lua_State *lua_newthread (lua_State *L);```会在当前的lua state内创建新的lua thread，lua thread之间虽然共享内存，但是以非抢占式方式执行。

	lua library 没有定义任何全局变量，lua_State以参数的形式在接口函数见流转，完成数据的共享. 所以lua library也是可重入，可在多线程环境下应用。

- luaopen_xxx

	lua环境的初始状态为空，既没有内置的变量也没有内置的函数。

	创建lua环境完成后，第一步操作是指定哪些函数接口可以被调用.

	```luaopen_string(L) 可以调用lstring.h头文件内定义的接口```
	
	```luaopen_io(L) 可以调用liolib.h头文件内定义的接口```
	
	```luaL_openlibs(L)加载整个标准库```

- luaL_loadbuffer

	luaL_loadbuffer: If there are no errors, the call returns zero and pushes the resulting chunk on the stack.
	
	lua_pcall: pops the chunk from the stack and runs it in protected mode.
	
	In case of error, both functions push an error message on the stack.通过lua magic stack来传递结果信息或错误信息。开发者需要了解接口函数行为，同时了解接口对stack的操作。

	luaL_loadbuffer对lua代码进行编译，如果成功则返回0, 并将编译后的chunk放到lua环境当中（压栈）

> 以上接口函数的应用，参见b_interpreter.c

## stack

liblua是lua与C之间的桥梁，桥梁的本质是虚拟堆栈。该虚拟堆栈是由Lua进行管理。当Lua调用C函数时，C函数只需要将结果压栈，并且
将结果个数以返回值的形式返回即可，Lua负责清空堆栈中的参数和结果；当C调用Lua函数时，C需要按照要求将参数入栈，Lua将参数弹栈，计算并将结果以
堆栈的形式返回，最后由C函数负责将结果弹栈。

1. 堆栈上的每个slot可以存储lua的任意数据类型；
2. slot存储的应该是指针，指针指向了一张表，表内记录记录了lua的数据，以及该数据被引用的次数。通过该表可以完成垃圾回收；
3. 由于C是静态数据类型语言，liblua提供了对slot进行各种类型数据的解析函数，如lua_tostring。
4. 虚拟堆栈是Lua和C之间交互的关键，Lua内部之间函数的调用并不会在虚拟堆栈中进行操作。所以虚拟堆栈中往往只有一个函数.

所以，虚拟堆栈支持了lua语言的两个特性，动态数据类型和自动垃圾回收。

>
- lua使用虚拟堆栈的方式与c语言使用栈的方式一样
- c可以对虚拟堆栈的任何位置进行增删改查
- The lua_tostring function returns a pointer to an internal copy of the string.
Lua ensures that this pointer is valid as long as the corresponding value is in the stack. When a C function returns, Lua clears its stack; therefore, as a rule, you should never store pointers to Lua strings outside the function that got them.

### Pushing elements

**The API has one push function for each C type that can be represented in Lua**

- lua_pushnil （nil --> NULL）
- lua_pushboolean (boolean --> int)
- lua_pushnumber (number --> double)
- lua_pushinteger (供string使用，该类型的最大值就是lua中string的最大值)
- lua_pushlstring（len + string）
- lua_pushstring（zero-terminated string）

> lua考虑到通用性，采用len+字符串的方式来表示string。lua_pushstring是为了兼容C的字符串。

### Querying elements

**To refer to elements in the stack, the API uses indices**

1. 栈底元素，1；
2. 栈顶元素，-1；

检查元素类型：

- lua\_isxxx: xxx是lua的类型，lua\_isnumber，lua\_isstring，lua\_istable。
- 原型：int lua\_isxxx (lua_State *L, int index);
- lua\_isxxx does not check whether the value has that specific type, but whether the value can be converted to that type
- For instance, any number satisfies lua_isstring. 解决这个问题的函数：lua_type

获取元素的值：

- lua\_toboolean，lua\_tonumber，lua\_tointeger，lua\_tolstring，lua\_objlen
- It is OK to call them even when the given element does not have the correct type.In this case, lua\_toboolean, lua\_tonumber, lua\_tointeger, and lua\_objlen return zero; the other functions return NULL. 错误情况下返回0，使得函数的正确返回和错误返回无法区分。
- When a C function called by Lua returns, Lua clears its stack; therefore, as a rule, you should never store pointers to Lua strings outside the function that got them. Lua首先将函数参数push到虚拟堆栈，然后调用C的函数，C函数从虚拟堆栈中获取数据。当C函数返回时，Lua负责清楚虚拟堆栈。

### stack operations

c语言对虚拟堆栈拥有Root权限，包括：

- int  lua\_gettop(lua_State *L);

	returns the number of elements in the stack，也是栈顶元素的下标。

- void lua\_settop(lua_State *L, int index);

	sets the top to a specific value. 如果index值小于lua\_gettop的返回值，相当于将栈顶的元素POP出去；否则，栈指针上提，并使用nil值填充。

- void lua\_pushvalue(lua_State *L, int index)

	The lua_pushvalue function pushes on the stack a copy of the element at the given index。将index位置的元素拷贝一份放置到栈顶

- void lua\_remove(lua_State *L, int index)

	removes the element at the given index, shifting down all elements on top of this position to fill in the gap

- void lua\_insert(lua_State *L, int index)

	**moves the top element into the given position**, shifting up all elements on top of this position to open space; 

- void lua\_replace(lua_State *L, int index)

	pops a value from the top and sets it as the value of the given index, without moving anything.

> 操作虚拟堆栈的函数的参数都完全一致，pushvalue，insert，replace等含有插入动作的函数，它们的插入源也是来自于虚拟堆栈。

## Error Handling with the C API

关于setjump和longjump的详细信息请参见[这里](http://www.cnblogs.com/hazir/p/c_setjmp_longjmp.html)。goto语句完成了函数内的跳转，这两个函数完成了函数间的跳转。步骤如下：

1. 调用setjump(env)函数保存堆栈的上下文；
2. 调用longjump(env)恢复堆栈环境，程序不是从longjump函数处返回，而是从setjump处返回继续执行。

liblua使用setjump和longjump完成抛出异常和捕获异常。

### Error handling in application code

当我们写application code（c调用lua），且lua出现异常（比如除零异常或者lua又调用C的时候出现异常）时，有以下集中解决方案：

1. 出错点返回错误码，然后逐级返回该错误码，直到返回给c。C语言的error机制传递message是不可取的，这样会导致Lua线程不安全。

2. application code可以借助lua enviroment传递setjump的返回值。当lua发现异常时，调用longjump直接跳转到c处。

3. 如果lua environment没有设置setjump的值，那么它只好调用exit函数退出。C语言提供了atexit函数（对应lua_atpanic函数），可以让c有机会书写自己的临终遗言。

默认情况下，application code运行在unproctected模式，即第三种模式。

> 可惜lua environment并没有提供传递setjump返回值的功能，所以第二种假设不成立。解决办法：首先，调用setjump并将返回值保存在虚拟堆栈中；其次，注册lua_atpanic函数，当异常发生后，回调函数从虚拟堆栈中取出setjump返回值；最后执行longjump.

4. run your lua code in protected mode.

	lua\_call: 无保护模式；lua\_pcall: 保护模式；lua\_cpcall: 保护模式，只是lua\_cpcall调用的是c函数。 其实保护模式的实现，也许就参见了2的想法。

### Error handling in library code

在写library code时，涉及到如何调用其它函数以及如何抛出错误。使用lua\_call的方式调用其它函数，这表明library code不关心异常，由上层来考虑如何处理；使用lua\_error抛出错误，这样错误就能够被lua\_pcall捕获。

## lua应用

1. read and write Lua global variables（lua可以作为配置文件时）
2. call Lua functions.（lua可以成为编写C语言的"库函数"的一个选择）
3. run pieces of Lua code (C语言的开发者可以直接将逻辑外置到lua中)
4. register C functions (lua可以调用这些C函数)

### [使用lua作为配置文件](./g_lua_as_conf.c)

1. 无论多么简单的配置文件，都需要解析器的帮助；
2. 本质是执行Lua文件，使用lua解析配置文件, 并通过虚拟堆栈的方式获取结果;
3. lua的全局变量不会自动放置到虚拟堆栈中，借助lua_getglobal(L, "width")的方式
获取全局变量，并放置到虚拟堆栈的栈顶.

### 获取Lua的table结构

1. lua\_getglobal(L, "background"); 虚拟堆栈的一个slot可以存放lua的任意数据类型，包括table；
2. lua_pushstring(L, key); 将希望获取的key压栈；
3. lua_gettable(L, -2);  gettable首先弹栈key，获取value，再把value压栈；
4. lua_pop(L, 1) 恢复堆栈状态

> Lua将2，3，4步合并，对外提供了lua_getfield(L, -1, key)函数。

### 向虚拟堆栈push一个table

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
int luaopen_newl(lua_State\* L) {

	//1. 并且完成模块初始化(因为这个特殊函数，往往只会执行一次);
	//2. newl是类似于lua的一个表，完成函数名与函数地址的映射；
	luaL_newlib(L, newl)
}

gcc -shared -fPIC h_register_c_function2.c -L/usr/local/lib -llua -o newl.so
```

- 将生成动态链接库放置在LUA_PATH下，lua函数可以通过newl = require "newl"的方式使用该动态库

详情参见[h_register\_c\_function2.c](./h_register_c_function2.c)

> When you are writing the main code in an application, you should not use lua\_call, because you want to catch any errors. When you are writing functions, however, it is usually a good idea to use lua\_call; if there is an error, just leave it to someone that cares about it.


## C函数之间共享变量的方法

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

```lua_State *lua_newthread (lua_State *L)``` lua_State不是lua state的句柄，而是(state, thread)的句柄。

>
- 两个lua thread属于同一个state。
- Each thread has its own stack.
- The new thread L1 starts with an empty stack
- the old thread L has the new thread on the top of its stack。在L的虚拟堆栈上放置新的thread对象，重要作用是防止thread对象被收集。

> coroutine.create函数的内部实现应该是调用了lua_newthread，所以lua中的thread对象，在C函数内就是指lua_State.

### resume lua thread

```
int lua_resume (lua_State *L, int narg)
```

When lua_resume returns LUA_YIELD, the visible part of the thread’s stack contains only the values passed to yield. A call to lua_gettop will return the number of yielded values. To move these values to another thread, we can use lua_xmove.


```
lua_xmove(L1, L, 1);
```
liblua允许你在两个虚拟堆栈之间操作数据，前提是两个虚拟堆栈在同一个state之间。