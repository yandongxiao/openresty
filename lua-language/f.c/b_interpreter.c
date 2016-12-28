// gcc  b_interpreter.c -I /usr/local/include/lua5.2/  -L/usr/local/lib -llua
// LUA 标准库没有使用任何全局变量，这使得该库是可重入的。
// 可重入不代表是线程安全的，但是可重入代表LUA LIB可以与多线程结合使用
// The Lua core never writes anything directly to any output stream, 只会从堆栈返回数据
//
// stack
//   虽然该stack是由LUA LIB的函数负责向栈取数据，从栈中读数据，但是程序员需要合理的调用LUA LIB函数，确保
//   stack的一直处于干净的状态。
//   NOTICE: 这个堆栈当中的任何一个元素都可以被访问，不止是栈顶元素
//
// const 解析：
// const char *lua_tostring (lua_State *L, int index);
// The lua_tostring function returns a pointer to an internal copy of the string. You cannot change it (there is a const there to remind you).
// Lua ensures that this pointer is valid as long as the corresponding value is in the stack. When a C function returns,
// Lua clears its stack; therefore, as a rule, you should never store pointers to Lua strings outside the function that got them.
//
// NULL字符：
// tostring有可能返回NULL字符，但是属于字符串的一部分
// const char *s = lua_tostring(L, -1);   /* any Lua string */
// size_t l = lua_strlen(L, -1);          /* its length */
// assert(s[l] == '\0');
// assert(strlen(s) <= l);)]
//
#include <stdio.h>
#include <string.h>
#include <lua.h>        // basic functions
#include <lualib.h>     // defines functions to open the libraries
#include <lauxlib.h>    // 使用basic api，提供更加易用的API接口；都是以luaL_为前缀

int main (void) {
    char buff[256];
    int error;
    lua_State *L = luaL_newstate();   /* create a new Lua environment */

    luaopen_base(L);        /* opens the basic library */
    luaopen_table(L);       /* opens the table library */
    luaopen_io(L);          /* opens the I/O library */
    luaopen_string(L);      /* opens the string lib. */
    //luaL_openlibs(L);     // 加载标准库，上面的方法更具有定制化

    while (fgets(buff, sizeof(buff), stdin) != NULL) {
        // 函数成功返回0
        // luaL_loadbuffer 将lua code编译称lua chunk code，并放置在堆栈中
        // In case of errors, both functions push an error message on the stack
        error = luaL_loadbuffer(L, buff, strlen(buff), "line") || lua_pcall(L, 0, 0, 0);
        if (error) {
            // It is OK to call them even when the given element does not have the correct type.
            // In this case, lua_toboolean, lua_tonumber and lua_strlen return zero and the others return NULL.
            fprintf(stderr, "%s", lua_tostring(L, -1));     // 从堆栈中获取数据, NOTICE: 并没有POP
            lua_pop(L, 1);  /* pop error message from the stack */
        }
    }

    lua_close(L);
    return 0;
}
