#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>


double f (lua_State *L, double x, double y) {
    double z;
    /* push functions and arguments */
    lua_getglobal(L, "f");  /* function to be called */
    lua_pushnumber(L, x);   /* push 1st argument */
    lua_pushnumber(L, y);   /* push 2nd argument */
    /* do the call (2 arguments, 1 result) */
    if (lua_pcall(L, 2, 1, 0) != 0)
        luaL_error(L, "error running function ’f’: %s",
                lua_tostring(L, -1));
    /* retrieve result */
    if (!lua_isnumber(L, -1))
        luaL_error(L, "function ’f’ must return a number");
    z = lua_tonumber(L, -1);
    lua_pop(L, 1);  /* pop returned value */
    return z;
}

int main (void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    char * filename = "i.lua";

    if (luaL_loadfile(L, filename) || lua_pcall(L, 0, 0, 0))
        luaL_error(L, "cannot run configuration file: %s", lua_tostring(L, -1));

    printf("%f\n", f(L, 3, 5));
}
