/*
 * how to push and access table、function、userdata、closure.
 */

#include <lua.h>        // basic functions
#include <lualib.h>     // defines functions to open the libraries
#include <lauxlib.h>    // 使用basic api，提供更加易用的API接口；都是以luaL_为前缀
#include <assert.h>
#include <string.h>
#include <stdlib.h>

// 传递一个table给LUA
void table(void) {
    lua_State *L = luaL_newstate();

    // 借助虚拟栈来创建、读写table
    lua_newtable(L);
    lua_pushstring(L, "mydata");
    lua_pushnumber(L,66);
    lua_settable(L,-3);
    assert(lua_istable(L, -1));

    // 调用LUA代码
    lua_setglobal(L, "mt");
    luaL_loadfile(L, "table.lua");
    lua_pcall(L, 0, 0, 0);

    // 通过全局变量在C和LUA之间传递返回值
    lua_getglobal(L, "mt");      // 将LUA中的全局变量mt压入栈顶
    lua_pushstring(L, "mydata");
    lua_gettable(L, -2);
    assert(lua_tonumber(L, -1)==100);

    lua_close(L);
}

int add2 (lua_State *L) {
    // 比lua_tonumber 更加牛逼的地方
    double a = luaL_checknumber(L,1);
    double b = luaL_checknumber(L,2);

    lua_pushnumber(L, a+b);

    // NOTICE: 返回值用于提示该C函数的返回值数量，即压入栈中的返回值数量
    return 1;
}

// 通过register的方式传递函数
// NOTICE: not virtual stack
void function(void) {
    // 注册并执行lua文件
    lua_State* L = luaL_newstate();
    lua_register(L, "add2", add2);
    luaL_loadfile(L, "function.lua");
    lua_pcall(L, 0, 0, 0);

    // 通过全局变量在C和LUA之间传递返回值
    lua_getglobal(L, "sum");      // 将LUA中的全局变量mt压入栈顶
    assert(lua_tonumber(L, -1)==20);
}

// NOTICE: cfunc会被LUA调用，所以它的返回值就至关重要.
int cfunc (lua_State *L) {

    assert(L != NULL);
    // 修改number
    int num = lua_tonumber(L, lua_upvalueindex(1));
    num++;
    lua_pushnumber(L, num);     // 通过virtual stack输出内容
    lua_pushnumber(L, num);     // 重新设置virtual stack的值
    lua_replace(L, lua_upvalueindex(1));    // 更新upvalues

    // 修改string
    const char* str = lua_tostring(L, lua_upvalueindex(2));
    char *dest = (char*)malloc(strlen(str) + 1);
    dest[0] = 0;
    strcat(dest, str);
    lua_pushstring(L, strcat(dest, "d"));
    lua_pushvalue(L, -1);
    lua_replace(L, lua_upvalueindex(2));    // 更新upvalues

    return 2;
}

void closure(void) {
    //  初始化closure
    lua_State* L = luaL_newstate();
    lua_pushnumber(L, 10);
    lua_pushstring(L, "hello");
    lua_pushcclosure(L, cfunc, 2);

    // 执行lua脚本
    // NOTICE: 直接调用cfunc是不正确的
    // 通过lua_tocfunction(L, -1)调用也不正确
    lua_setglobal(L,"cfunc");
    luaL_dofile(L, "cfunc.lua");

    // NOTICE: 以下是通过全局变量来传递数据，也可以通过upvalue来传递数据
    lua_getglobal(L, "val1");
    assert(lua_tonumber(L, -1) == 11);
    lua_getglobal(L, "val2");
    assert(strcmp(lua_tostring(L, -1), "hellod") == 0);
}

void pushlightuserdata(void) {

    static const char Key = 'k';
    lua_State* L = luaL_newstate();

    // set
    lua_pushlightuserdata(L, (void *)&Key);
    lua_pushnumber(L, 10);
    // 这是一个特殊的table，永远就在那里
    lua_settable(L, LUA_REGISTRYINDEX);

    // get
    lua_pushlightuserdata(L, (void *)&Key);
    lua_gettable(L, LUA_REGISTRYINDEX);
    int myNumber = lua_tonumber(L, -1);
    assert(myNumber == 10);
}

int main (void) {
    table();
    function();
    closure();
    pushlightuserdata();
}
