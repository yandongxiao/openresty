// The API has one push function for each Lua type that can be represented in C
// int lua_type (lua_State *L, int index);
//

#include <stdio.h>
#include <string.h>
#include <lua.h>        // basic functions
#include <lualib.h>     // defines functions to open the libraries
#include <lauxlib.h>    // 使用basic api，提供更加易用的API接口；都是以luaL_为前缀
#include <assert.h>

int main (void) {
    lua_State *L = luaL_newstate();   /* create a new Lua environment */
    luaL_openlibs(L);     // 加载标准库，上面的方法更具有定制化

    lua_pushstring(L, "nihao");
    int d = lua_type(L, -1);    // -1代表栈顶元素，1代表堆栈的第一个元素或是栈底元素
    assert(d == LUA_TSTRING);
    lua_pop(L, 1);  /* Pops n elements from the stack */
    lua_close(L);
    return 0;
}
