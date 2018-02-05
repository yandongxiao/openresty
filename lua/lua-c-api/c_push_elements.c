/* gcc c_push_elements.c -I /usr/local/include/lua5.2/  -L/usr/local/lib -llua */
#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

int main (void) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    lua_pushstring(L, "nihao");
    const char * data = lua_tostring(L, -1);    // -1代表栈顶元素，1代表堆栈的第一个元素或是栈底元素
    fprintf(stdout, "%s", data);
    lua_pop(L, 1);  /* Pops n elements from the stack */
    lua_close(L);
    return 0;
}
