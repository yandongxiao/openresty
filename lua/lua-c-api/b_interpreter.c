/* gcc  b_interpreter.c -I /usr/local/include/lua5.2/  -L/usr/local/lib -llua */

#include <stdio.h>
#include <string.h>
#include <lua.h>        // liblua.so中最基础的函数，以lua_开头
#include <lualib.h>     // 提供luaopen_xxx类函数，用于加载库函数
#include <lauxlib.h>    // 完全基于lua.h的接口开发的使用性强的函数；都是以luaL_为前缀

int main (void) {
    char buff[256];
    int error;
    lua_State *L = luaL_newstate();   /* create a new and empty Lua environment */

    luaopen_base(L);        /* opens the basic library */
    luaopen_table(L);       /* opens the table library */
    luaopen_io(L);          /* opens the I/O library */
    luaopen_string(L);      /* opens the string lib. */
    //luaL_openlibs(L);     // 加载标准库，上面的方法更具有定制化

    while (fgets(buff, sizeof(buff), stdin) != NULL) {
        // 函数成功返回0
        // luaL_loadbuffer 将lua code编译称lua chunk code，并放置在lua environment的堆栈中
        // lua_pcall从堆栈中取出lua chunk code, 执行，并返回结果
        // In case of errors, both functions push an error message on the stack
        error = luaL_loadbuffer(L, buff, strlen(buff), "line") || lua_pcall(L, 0, 0, 0);
        if (error) {
            fprintf(stderr, "%s", lua_tostring(L, -1));     // 从堆栈中获取数据, NOTICE: 并没有POP
            lua_pop(L, 1);  /* pop error message from the stack */
        }
    }

    lua_close(L);
    return 0;
}
