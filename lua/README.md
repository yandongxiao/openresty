# Lua

Lua，在葡萄牙语里代表美丽的月亮。它有如下特点：

1. Lua是嵌入式语言。它没有丰富的库和工具，一般不能独立地作为一门开发语言。
2. Lua常嵌套于C语言，通过liblua.so，将一些逻辑代码放在lua中执行.
3. Lua作为一门脚本语言，如果跑在Lua解释器中会降低Lua的执行速度
4. JIT（Just In Time）即时编译技术可以让Lua代码直接跑在CPU上，大大加快运行速度

> Lua语言不向后兼容

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

>
- both application code and library code use the same API to communicate with Lua, the so called lua c api.
- lua c api 是lua和c沟通的桥梁, 也是liblua提供的api.

## lua c api

### lua c api的主要能力

1. read and write Lua global variables（lua可以作为配置文件时）
2. call Lua functions.（lua可以成为编写C语言的"库函数"的一个选择）
3. run pieces of Lua code (C语言的开发者可以直接将逻辑外置到lua中)
4. register C functions (lua可以调用这些C函数)

### lua c api的接口特性

1. do not check the correctness of their arguments (由API的调用者检查)
2. the API emphasizes flexibility and simplicity, sometimes at the cost of ease of use. (即便是通过liblua与lua做简单交互，需要调用很多个API。虽然繁杂，但是给了开发者更大的控制力)
3. an omnipresent virtual stack 解决了LUA和C之间参数传递的问题, 解决了C(静态)与lua(动态)的数据类型问题，解决了lua的自动垃圾回收.

### lua c api的层次关系

1. The header file lua.h defines the basic functions provided by Lua.
2. Everything defined in lua.h has a lua\_ prefix.
3. lauxlib.h defines the functions which provide a higher abstraction level by using the basic api provided by lua.h
4. All its definitions start with luaL\_
5. all Lua standard libraries use the auxlib

> 所以，lua c api提供的API分为三个层级，lua.h, lauxlib.h 和 标准库(如lmathlib.c).

## lua c api的核心概念

- lua environment

```lua_State *luaL_newstate (void)```该函数创建了一个独立的lua环境，并返回lua环境的句柄。多次调用luaL_newstate函数，返回多个独立的lua环境句柄(也称为lua state)

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

In case of error, both functions push an error message on the stack.

>
- 通过lua magic stack来传递结果信息或错误信息
- 开发者需要了解接口函数行为，同时了解接口对stack的操作.

luaL_loadbuffer对lua代码进行编译，如果成功则返回0, 并将编译后的chunk
放到lua环境当中（压栈）

> 以上接口函数的应用，参见b_interpreter.c

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
Lua ensures that this pointer is valid as long as the corresponding value is in the stack.
When a C function returns, Lua clears its stack; therefore, as a rule, you should never store pointers to Lua strings outside the function that got them.

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
