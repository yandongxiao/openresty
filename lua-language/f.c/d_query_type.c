// The API has one push function for each Lua type that can be represented in C
// int lua_isnumber (lua_State *L, int index);
// int lua_isstring (lua_State *L, int index);
// int lua_istable (lua_State *L, int index);
// int lua_isboolean (lua_State *L, int index);
// ...
// NOTICE: The lua_isnumber and lua_isstring functions do not check whether the value has that specific type,
// but whether the value can be converted to that type
//

#include <stdio.h>
#include <string.h>
#include <lua.h>        // basic functions
#include <lualib.h>     // defines functions to open the libraries
#include <lauxlib.h>    // 使用basic api，提供更加易用的API接口；都是以luaL_为前缀

int main (void) {
    lua_State *L = luaL_newstate();   /* create a new Lua environment */
    luaL_openlibs(L);     // 加载标准库，上面的方法更具有定制化

    lua_pushstring(L, "nihao");
    int d = lua_isstring(L, -1);    // -1代表栈顶元素，1代表堆栈的第一个元素或是栈底元素
    fprintf(stdout, "%d\n", d);
    lua_pop(L, 1);  /* Pops n elements from the stack */
    lua_close(L);
    return 0;
}
