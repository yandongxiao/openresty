/*
 *10 1 15 4 2 3 10001  20000
 */
#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <dlfcn.h>
#include <math.h>
#include <assert.h>

// 函数返回值为0
// 没有通过虚拟堆栈返回数据
static int mytest(lua_State *L) {

    int upv = (int)lua_tonumber(L, lua_upvalueindex(1));
    assert(upv==10 || upv==15);
    upv += 5;
    lua_pushinteger(L, upv);
    lua_replace(L, lua_upvalueindex(1));

    // 获取一般参数
    // NOTICE：这是从LUA那边传递过来的
    assert(lua_tonumber(L, 1) == 1 || lua_tonumber(L, 1) == 4);
    return 0;
}

int main(void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    // 设置Cclosure函数的上值
    lua_pushinteger(L, 10);
    lua_pushinteger(L, 11);     // closure variable 的初始值
    lua_pushcclosure(L, mytest, 2); // closure 函数已经在堆栈上了
    lua_setglobal(L,"upvalue_test");
    luaL_dofile(L, "./luatest.lua");

    // 获取fclosure上值的名称(临时值, 不带env)
    lua_getglobal(L, "l_counter");
    const char *name = lua_getupvalue(L, -1, 2);
    assert(strcmp(name, "local_upvalue2") == 0);    //不但返回closure的名称，还会将值入栈
    assert(lua_tonumber(L, -1) == 25);

    //设置fclosure上值，将local_upvalue的值设置为1
    lua_getglobal(L, "l_counter");
    lua_pushinteger(L, 1);
    name = lua_setupvalue(L, -2, 1);
    assert(strcmp(name, "local_upvalue") == 0);
    name = lua_getupvalue(L, -1, 1);
    assert(strcmp(name, "local_upvalue") == 0);
    assert(lua_tonumber(L, -1) == 1);

    lua_getglobal(L, "ltest");
    lua_pcall(L, 0, 0, 0);
    lua_getglobal(L, "l_counter");  // 设置为ltest可不管用
    lua_getupvalue(L, -1, 1);   // 因为是局部变量，使用lua_getglobal不管用
    int nn = lua_tonumber(L, -1);
    printf("%d\n", nn);
    assert(lua_tonumber(L, -1) == 2);

    //获取fclosure的上值（带env）
    lua_getglobal(L, "g_counter");
    printf("%s\n", lua_getupvalue(L, -1, 1));   // 返回的是_ENV，一个table

    // 通过settable重新设置env中对应的值
    // NOTICE：修改全局变量的方法
    lua_pushstring(L, "gloval_upvalue");
    lua_pushinteger(L,10000);
    lua_settable(L,-3);

    lua_pushstring(L, "gloval_upvalue1");
    lua_pushinteger(L,20000);
    lua_settable(L,-3);

    lua_getglobal(L, "gtest");
    lua_pcall(L,0,0,0);

    lua_getglobal(L, "gloval_upvalue");
    assert(lua_tonumber(L, -1) == 10001);
    lua_getglobal(L, "gloval_upvalue1");
    assert(lua_tonumber(L, -1) == 20000);

    lua_close(L);
    return 0;
}
