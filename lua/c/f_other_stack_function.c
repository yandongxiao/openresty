//int lua_gettop (lua_State *L);    // 返回堆栈中元素的个数
//void lua_settop (lua_State *L, int index);    // 重新设置栈顶，lua_pop(L, 1)==(lua_settop(L, -1-1); lua_settop(L,0)清空堆栈
//void lua_pushvalue (lua_State *L, int index); // 拷贝index处的元素到栈顶
//void lua_remove (lua_State *L, int index);    // 删除从index开始的元素，只删除一个
//void lua_insert (lua_State *L, int index);    // 插入的源是从栈顶获取，栈顶元素pop出来
//void lua_replace (lua_State *L, int index);   // 替换的源是从栈顶获取，栈顶元素pop出来

#include <stdio.h>
#include <string.h>
#include <lua.h>        // basic functions
#include <lualib.h>     // defines functions to open the libraries
#include <lauxlib.h>    // 使用basic api，提供更加易用的API接口；都是以luaL_为前缀

static void stackDump (lua_State *L) {
    int i;
    int top = lua_gettop(L);

    for (i = 1; i <= top; i++) {  /* repeat for each level */
        int t = lua_type(L, i);
        switch (t) {
        case LUA_TSTRING:  /* strings */
            printf("`%s'", lua_tostring(L, i));
            break;
        case LUA_TBOOLEAN:  /* booleans */
            printf(lua_toboolean(L, i) ? "true" : "false");
            break;
        case LUA_TNUMBER:  /* numbers */
            printf("%g", lua_tonumber(L, i));
            break;
        default:  /* other values */
            printf("%s", lua_typename(L, t));
            break;
        }
        printf("  ");  /* put a separator */
    }
    printf("\n");  /* end the listing */
}

int main (void) {
      lua_State *L = luaL_newstate();
      lua_pushboolean(L, 1);
      lua_pushnumber(L, 10);
      lua_pushnil(L);
      lua_pushstring(L, "hello");
      stackDump(L); /* true  10  nil  `hello'  */

      lua_pushvalue(L, -4);
      stackDump(L); /* true  10  nil  `hello'  true  */

      lua_replace(L, 3);
      stackDump(L); /* true  10  true  `hello'  */

      lua_settop(L, 6);
      stackDump(L); /* true  10  true  `hello'  nil  nil  */

      lua_remove(L, -3);
      stackDump(L); /* true  10  true  nil  nil  */

      lua_settop(L, -5);
      stackDump(L); /* true  */

      lua_close(L);
      return 0;
}
