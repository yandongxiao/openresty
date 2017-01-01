/*
 * userdata: 这是专门给C开发者预留的一个数据类型，它在LUA的严重就是一块内存，该类型的对象没有任何预定义的操作。
 */

#include <lua.h>        // basic functions
#include <lualib.h>     // defines functions to open the libraries
#include <lauxlib.h>    // 使用basic api，提供更加易用的API接口；都是以luaL_为前缀
#include <assert.h>

typedef struct NumArray {
    int size;
    double values[1];
} NumArray;

//
// lua_newuserdata
static int newarray (lua_State *L) {
    int n = luaL_checkint(L, 1);
    size_t nbytes = sizeof(NumArray) + (n - 1)*sizeof(double);
    NumArray *a = (NumArray *)lua_newuserdata(L, nbytes);
    a->size = n;

    // 新增内容
    luaL_getmetatable(L, "LuaBook.array");  // 在registry表中获得metatable表
    lua_setmetatable(L, -2);    // 向userdta数据结构设置metatable
    return 1;  /* new userdatum is already on the stack */
}

// 检查userdata的metatable是否被正确设置，否则，raise an error
static NumArray *checkarray (lua_State *L) {
    void *ud = luaL_checkudata(L, 1, "LuaBook.array");
    luaL_argcheck(L, ud != NULL, 1, "`array' expected");
    return (NumArray *)ud;
}

// 另一个重要的辅助函数
static double *getelem (lua_State *L) {
    NumArray *a = checkarray(L);
    int index = luaL_checkint(L, 2);
    luaL_argcheck(L, 1 <= index && index <= a->size, 2,
                                     "index out of range");
      /* return element address */
      return &a->values[index - 1];
}

// NOTICE: 向userdata类型对象中写数据的操作并非是在虚拟栈中完成
static int setarray (lua_State *L) {
    double value = luaL_checknumber(L, 3);
    *getelem(L) = value;
    return 0;
}

static int getarray (lua_State *L) {
    lua_pushnumber(L, *getelem(L));
    return 1;
}

static int getsize (lua_State *L) {
    // 获取参数并检查
    NumArray *a = checkarray(L);
    lua_pushnumber(L, a->size);
    return 1;
}

static int array2string (lua_State *L) {
    NumArray *a = checkarray(L);
    lua_pushfstring(L, "array(%d)", a->size);
    return 1;
}

/* 改成了两个table */
static const luaL_Reg arraylib_f [] = {
    {"new", newarray},
    {NULL, NULL}
};

static const luaL_Reg arraylib_m [] = {
    {"set", setarray},
    {"get", getarray},
    {"size", getsize},
    {"__tostring", array2string},
    {NULL, NULL}
};

int luaopen_array (lua_State *L) {
    /*
     * 完成操作: metaarray.__index = metaarray
     */
    luaL_newmetatable(L, "LuaBook.array");

    lua_pushstring(L, "__index");
    lua_pushvalue(L, -2);  /* pushes the metatable */
    lua_settable(L, -3);  /* metatable.__index = metatable */
    //lua_pushvalue(L, -1);
    //lua_setfield(L, -2, "__index");

    luaL_setfuncs(L, arraylib_m, 0);   // 为metatable设置属性，通过lauxlib.h的宏中推断出来的

    luaL_newlib(L, arraylib_f);
    return 1;
}
