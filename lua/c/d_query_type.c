/* gcc d_query_type.c -I /usr/local/include/lua5.2/  -L/usr/local/lib -llua */
/**
 * NOTICE: The lua_isnumber and lua_isstring functions do not check whether the value has that specific type,
 * but whether the value can be converted to that type
 */
#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

int main (void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_pushstring(L, "nihao");
    int d = lua_isstring(L, -1);    // -1代表栈顶元素，1代表堆栈的第一个元素或是栈底元素
    fprintf(stdout, "%d\n", d);
    lua_pop(L, 1);  /* pops n elements from the stack */
    lua_close(L);
    return 0;
}
