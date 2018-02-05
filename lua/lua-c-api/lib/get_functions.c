#include <lua.h>        // basic functions
#include <lualib.h>     // defines functions to open the libraries
#include <lauxlib.h>    // 使用basic api，提供更加易用的API接口；都是以luaL_为前缀
#include <assert.h>
#include <string.h>
#include <stdlib.h>

void getglobal(){
    // 将LUA解释器中的一个全局变量入栈
    // lua_setglobal(L, "mt");
}

void gettable(){
    // 获取LUA解释器中某个VALUE的值，stack 如下:
    // table
    // key
}

// 与gettable没什么区别
void getfield(){

    lua_State *L = luaL_newstate();
    luaL_loadfile(L, "getfield.lua");
    lua_pcall(L, 0, 0, 0);

    lua_getglobal(L, "mt");      // 将LUA中的全局变量mt压入栈顶
    lua_getfield(L, -1, "age");
    assert(lua_tonumber(L, -1) == 10);
}

// 与lua_gettable 相似，但是不会被劫持
void rawget(){

    lua_State *L = luaL_newstate();
    luaL_loadfile(L, "rawget.lua");
    lua_pcall(L, 0, 0, 0);

    lua_getglobal(L, "mt");      // 将LUA中的全局变量mt压入栈顶
    lua_pushstring(L, "age");
    lua_rawget(L, -2);
    assert(lua_tonumber(L, -1) == 10);
}

// 与rawget相似，只不过操作的是数组
void rawgeti(){
    lua_State *L = luaL_newstate();
    luaL_loadfile(L, "rawgeti.lua");
    lua_pcall(L, 0, 0, 0);

    lua_getglobal(L, "mt");      // 将LUA中的全局变量mt压入栈顶
    lua_rawgeti(L, -1, 1);
    assert(lua_tonumber(L, -1) == 10);
}

void rawgetp(){
    lua_State *L = luaL_newstate();
    int val = 0;

    lua_newtable(L);
    lua_pushnumber(L, 100);
    lua_rawsetp(L, -2, (const void *)&val); // 只是使用val作为索引，val的值没有被改变
    assert(val ==0);

    lua_setglobal(L, "mt");
    luaL_loadfile(L, "rawsetp.lua");    // LUA 的输出是看不见的
    lua_pcall(L, 0, 0, 0);

    lua_getglobal(L, "mt");
    lua_rawgetp(L, -1, &val);
    assert(lua_tonumber(L, -1) == 100);
}

int main () {
    getfield();
    rawget();
    rawgeti();
    rawgetp();
}
