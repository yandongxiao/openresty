// 编译方法
// gcc -shared -fPIC h_register_c_function2.c -L/usr/local/lib -llua -o newl.so

#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

int l_map (lua_State *L) {
    int i, n;

    /* 1st argument must be a table (t) */
    luaL_checktype(L, 1, LUA_TTABLE);
    /* 2nd argument must be a function (f) */
    luaL_checktype(L, 2, LUA_TFUNCTION);

    n = luaL_len(L, 1);  /* get size of table */
    for (i=1; i<=n; i++) {
        lua_pushvalue(L, 2);   /* push f */
        lua_rawgeti(L, 1, i);  /* push t[i] */
        lua_call(L, 1, 1);     /* call f(t[i]) */
        lua_rawseti(L, 1, i);  /* t[i] = result */
    }

    return 0;  /* no results */
}

static luaL_Reg lmap[] = {
    {"map", l_map},
    {NULL, NULL}
};

int luaopen_lmap(lua_State* L)
{
    luaL_newlib(L, lmap);
    return 1;
}
