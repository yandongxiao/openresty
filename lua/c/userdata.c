/*
 * userdata: 这是专门给C开发者预留的一个数据类型，它在LUA的严重就是一块内存，该类型的对象没有任何预定义的操作。
 */

#include <lua.h>        // basic functions
#include <lualib.h>     // defines functions to open the libraries
#include <lauxlib.h>    // 使用basic api，提供更加易用的API接口；都是以luaL_为前缀
#include <assert.h>

typedef struct NumArray {
    int size;
    double values[1];
} NumArray;

//
// lua_newuserdata
static int newarray (lua_State *L) {
    int n = luaL_checkint(L, 1);
    size_t nbytes = sizeof(NumArray) + (n - 1)*sizeof(double);
    /* 1. 将申请的内存块的地址压入虚拟栈，这个lua_newtable是一样的;
     * 2. 同时返回内存块的地址
     */
    NumArray *a = (NumArray *)lua_newuserdata(L, nbytes);
    a->size = n;
    return 1;  /* new userdatum is already on the stack */
}

// NOTICE: 向userdata类型对象中写数据的操作并非是在虚拟栈中完成
static int setarray (lua_State *L) {
    /* setarray注册成为LUA的函数，当它被LUA调用时，是在一个私有的虚拟栈中被调用的
     * LUA调用时传递的第一个参数就是在虚拟栈中的1位置
     */
    NumArray *a = (NumArray *)lua_touserdata(L, 1);
    int index = luaL_checkint(L, 2);
    double value = luaL_checknumber(L, 3);

    luaL_argcheck(L, a != NULL, 1, "`array' expected");
    luaL_argcheck(L, 1 <= index && index <= a->size, 2, "index out of range");
    a->values[index-1] = value;
    return 0;
}

static int getarray (lua_State *L) {
    // LUA 传递的参数
    NumArray *a = (NumArray *)lua_touserdata(L, 1);
    int index = luaL_checkint(L, 2);

    // 检查参数正确性
    luaL_argcheck(L, a != NULL, 1, "`array' expected");
    luaL_argcheck(L, 1 <= index && index <= a->size, 2,"index out of range");

    // 通过私有虚拟栈返回结果
    lua_pushnumber(L, a->values[index-1]);
    return 1;
}

static int getsize (lua_State *L) {
    // 获取参数并检查
    NumArray *a = (NumArray *)lua_touserdata(L, 1);
    luaL_argcheck(L, a != NULL, 1, "`array' expected");

    lua_pushnumber(L, a->size);
    return 1;
}

static const luaL_Reg arraylib [] = {
    {"new", newarray},
    {"set", setarray},
    {"get", getarray},
    {"size", getsize},
    {NULL, NULL}
};

int luaopen_array (lua_State *L) {
    luaL_newlib(L, arraylib);
    return 1;
}
