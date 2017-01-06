// gcc -shared -fPIC sum.c -L/usr/local/lib -llua -o sum.so
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <assert.h>

static int add (lua_State *L) {
    int a = luaL_checkint(L, 1);
    int b = luaL_checkint(L, 2);
    lua_pushnumber(L, a+b);
    return 1;
}

static const luaL_Reg sum [] = {
    {"add", add},
    {NULL, NULL}
};

int luaopen_sum (lua_State *L) {
    //NOTICE: 因为openresty中的LUA解析器对luaL_newlib不支持，而liblua.dyml又是5.2，造成了这个例子没法进行下去
    //但是已经证明lua_package_cpath就是用来指定sum.so所在的目录的
    luaL_newlib(L, sum);
    return 1;
}
