#include <lua.h>        // basic functions
#include <lualib.h>     // defines functions to open the libraries
#include <lauxlib.h>    // 使用basic api，提供更加易用的API接口；都是以luaL_为前缀
#include <assert.h>
#include <string.h>
#include <stdio.h>

void isnumber (void) {
    lua_State *L = luaL_newstate();

    lua_pushnumber(L, 10);
    assert(lua_isnumber(L, -1));
    assert(lua_tonumber(L, -1) == 10);
    assert(lua_tointeger(L, -1) == 10);
    assert(lua_tounsigned(L, -1) == 10);
    assert(lua_toboolean(L, -1) == 1);

    lua_close(L);
}

void isstring(void) {
    lua_State *L = luaL_newstate();

    lua_pushstring(L, "nihao");
    assert(lua_isstring(L, -1));
    assert(strcmp(lua_tostring(L, -1), "nihao") == 0);
    assert(strcmp(lua_tolstring(L, -1, NULL), "nihao") == 0);
    assert(lua_rawlen(L, -1) == 5);

    lua_close(L);
}

int cfunc (lua_State *L) {
    assert(L != NULL);
    printf("helloworld\n");
    return 0;
}

void iscfunction(void) {

    lua_State *L = luaL_newstate();
    lua_pushcfunction(L, cfunc);
    assert(lua_iscfunction(L, -1));
    lua_CFunction cf = lua_tocfunction(L , -1);
    cf(L);
    assert(lua_topointer(L , -1) != NULL);

    lua_close(L);
}

void type(void) {
    lua_State *L = luaL_newstate();
    lua_pushcfunction(L, cfunc);
    assert(lua_iscfunction(L, -1));
    assert(lua_type(L, -1) == LUA_TFUNCTION);
    lua_close(L);
}

void ltypename(void) {
    lua_State *L = luaL_newstate();
    assert(strcmp(lua_typename(L, LUA_TFUNCTION), "function") == 0);
    lua_close(L);
}


void touserdata(void) {
    int num = 10;
    lua_State *L = luaL_newstate();
    lua_pushlightuserdata(L, &num);
    void *data= lua_touserdata(L, -1);
    assert(*(int*)data == 10);
    assert(lua_isuserdata(L, -1));
    lua_close(L);
}

void tothread(void) {
    lua_State *L = luaL_newstate();
    lua_pushthread(L);
    assert(L == lua_tothread(L, -1));
    lua_close(L);
}

int main (void) {
    isnumber();
    isstring();
    iscfunction();
    type();
    ltypename();
    tothread();
    touserdata();
}
