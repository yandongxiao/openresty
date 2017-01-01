// 编译方法
// gcc -shared -fPIC h_register_c_function2.c -L/usr/local/lib -llua -o newl.so

#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

//待注册的C函数，该函数的声明形式在上面的例子中已经给出。
////需要说明的是，该函数必须以C的形式被导出，因此extern "C"是必须的。
////函数代码和上例相同，这里不再赘述。
static int add(lua_State* L)
{
    double op1 = luaL_checknumber(L,1);
    double op2 = luaL_checknumber(L,2);
    lua_pushnumber(L,op1 + op2);
    return 1;
}

static int sub(lua_State* L)
{
    double op1 = luaL_checknumber(L,1);
    double op2 = luaL_checknumber(L,2);
    lua_pushnumber(L,op1 - op2);
    return 1;
}

//luaL_Reg结构体的第一个字段为字符串，在注册时用于通知Lua该函数的名字。
//第一个字段为C函数指针。
//结构体数组中的最后一个元素的两个字段均为NULL，用于提示Lua注册函数已经到达数组的末尾。
static luaL_Reg newl[] = {
    {"add", add},
    {"sub", sub},
    {NULL, NULL}
};

//该C库的唯一入口函数。其函数签名等同于上面的注册函数。见如下几点说明：
//1. 我们可以将该函数简单的理解为模块的工厂函数。
//2. 其函数名必须为luaopen_xxx，其中xxx表示library名称。Lua代码require "xxx"需要与之对应。
//3. 在luaL_register的调用中，其第一个字符串参数为模块名"xxx"，第二个参数为待注册函数的数组。
//4. 需要强调的是，所有需要用到"xxx"的代码，不论C还是Lua，都必须保持一致，这是Lua的约定，
//   否则将无法调用。
//   实际上就是调用lua_setglobal，同时借助虚拟栈，注册的函数
int luaopen_newl(lua_State* L)  // 注意函数命名规范，LUA require是就需要指定newl; 同时注意函数类型也是规定好的
{
    luaL_newlib(L, newl);   // 不支持函数luaL_register
    return 1;   //luaL_newlib在虚拟堆栈上返回LUA表，所以是1
}
