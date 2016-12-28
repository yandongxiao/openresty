// The API has one push function for each Lua type that can be represented in C
// void lua_pushnil (lua_State *L);
// void lua_pushboolean (lua_State *L, int bool);
// void lua_pushnumber (lua_State *L, double n);
// void lua_pushlstring (lua_State *L, const char *s, size_t length);
// void lua_pushstring (lua_State *L, const char *s);
// NOTICE: 设置可以push函数和userdata结构
// NOTICE: 从LUA中获取的字符串是完全独立的数据，无惧修改
// int lua_checkstack (lua_State *L, int sz); 确保堆栈有足够的空间(default 20)

#include <stdio.h>
#include <string.h>
#include <lua.h>        // basic functions
#include <lualib.h>     // defines functions to open the libraries
#include <lauxlib.h>    // 使用basic api，提供更加易用的API接口；都是以luaL_为前缀

int main (void) {
    lua_State *L = luaL_newstate();   /* create a new Lua environment */
    luaL_openlibs(L);     // 加载标准库，上面的方法更具有定制化

    lua_pushstring(L, "nihao");
    const char * data = lua_tostring(L, -1);    // -1代表栈顶元素，1代表堆栈的第一个元素或是栈底元素
    fprintf(stdout, "%s", data);
    lua_pop(L, 1);  /* Pops n elements from the stack */
    lua_close(L);
    return 0;
}
