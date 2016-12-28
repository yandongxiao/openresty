#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

void error (lua_State *L, const char *fmt, ...) {
}

void load (char *filename, int *width, int *height) {
    lua_State *L = luaL_newstate();
    luaopen_base(L);
    luaopen_io(L);
    luaopen_string(L);
    luaopen_math(L);

    // 如果LUA文件不存在的话，程序也能正常运行，width和height的值都是0
    if (luaL_loadfile(L, filename) || lua_pcall(L, 0, 0, 0))
        error(L, "cannot run configuration file: %s", lua_tostring(L, -1));

    lua_getglobal(L, "width");      // 将LUA中的全局变量width压入栈顶
    lua_getglobal(L, "height");
    if (!lua_isnumber(L, -2))
        error(L, "`width' should be a number\n");
    if (!lua_isnumber(L, -1))
        error(L, "`height' should be a number\n");

    *width = (int)lua_tonumber(L, -2);      // 这里的-2是与lua_getglobal的调用次序有关系
    *height = (int)lua_tonumber(L, -1);

    lua_close(L);
}

int main () {
    int width;
    int height;

    char * file = "ceph.conf";
    load(file, &width, &height);
    printf("%d\n", width);
    printf("%d\n", height);

    return 0;
}
