/**
 * 包括调整堆栈的大小、对栈进行insert、remove、push、replace等操作.
 */
#include <lua.h>        // basic functions
#include <lualib.h>     // defines functions to open the libraries
#include <lauxlib.h>    // 使用basic api，提供更加易用的API接口；都是以luaL_为前缀
#include <assert.h>

/*
 * convert an acceptable stack index into an absolute index
 * 如果该index无效的话，程序也不会出错
 */
void absindex(void) {

    lua_State *L = luaL_newstate();
    lua_pushnil(L);
    lua_pushnumber(L, 10);

    // k为负数的计算方法是： n + k + 1
    // n: 堆栈中元素的个数
    // k是lua_absindex的第二个参数(一般为负值)
    assert(lua_absindex(L, -1) == 2);
    assert(lua_absindex(L, -2) == 1);
    assert(lua_absindex(L, -20) == -17);   // 如果给了一个不合理的值，也能算出结果

    // k为正数的计算方法： k
    assert(lua_absindex(L, 1) == 1);
    assert(lua_absindex(L, 100) == 100);   // 如果给了一个不合理的值，也能算出结果

    lua_close(L);
}

void gettop(void) {

    lua_State *L = luaL_newstate();

    assert(lua_gettop(L) == 0);   // 虚拟栈默认为空
    lua_pushnil(L);
    lua_pushnumber(L, 10);
    assert(lua_gettop(L) == 2);   // push向栈中添加数据

    lua_close(L);
}

void settop(void) {

    lua_State *L = luaL_newstate();
    lua_pushnumber(L, 1);
    lua_pushnumber(L, 2);
    lua_pushnumber(L, 3);
    lua_pushnumber(L, 4);

    // 降低栈顶
    lua_settop(L, 2);
    assert(lua_gettop(L) == 2); // 目前栈中元素个数为2
    assert(lua_tonumber(L, -1) == 2);    // 栈顶元素的值为2
    assert(lua_gettop(L) == 2); // lua_toxxx 系列的函数不会从栈中pop元素

    // 恢复栈顶
    lua_settop(L, 4);
    assert(lua_gettop(L) == 4);
    assert(lua_isnil(L, -1));   // NOTICE: 虽然将栈顶恢复为4，但是3，4位置的值已经丢失，用nil进行填充
    assert(lua_gettop(L) == 4);

    // 提高栈顶
    lua_settop(L, 8);
    assert(lua_gettop(L) == 8); // 目前栈中元素个数为8
    assert(lua_isnil(L, -1));
    assert(lua_isnil(L, -2));
    assert(lua_isnil(L, -3));
    assert(lua_isnil(L, -4));
    assert(lua_tonumber(L, 2) == 2);
    assert(lua_gettop(L) == 8);

    lua_close(L);
}

void pushvalue(void) {

    lua_State *L = luaL_newstate();
    lua_pushnumber(L, 1);
    lua_pushnumber(L, 2);
    lua_pushnumber(L, 3);
    lua_pushnumber(L, 4);

    lua_pushvalue(L, 4);
    assert(lua_gettop(L) == 5);     // 新增一个元素
    assert(lua_tonumber(L, -1) == 4);

    lua_close(L);
}

void lremove(void) {

    lua_State *L = luaL_newstate();
    lua_pushnumber(L, 1);
    lua_pushnumber(L, 2);
    lua_pushnumber(L, 3);
    lua_pushnumber(L, 4);

    lua_remove(L, 2);
    assert(lua_gettop(L) == 3);     //  删除一个元素
    assert(lua_tonumber(L, 1) == 1);
    assert(lua_tonumber(L, 2) == 3);
    assert(lua_tonumber(L, 3) == 4);

    lua_close(L);
}

void insert(void) {

    lua_State *L = luaL_newstate();
    lua_pushnumber(L, 1);
    lua_pushnumber(L, 2);
    lua_pushnumber(L, 3);
    lua_pushnumber(L, 4);

    lua_insert(L, 2);   // NOTICE: Moves the top element into the given valid index
    assert(lua_gettop(L) == 4);     // 注意是move操作
    assert(lua_tonumber(L, 1) == 1);
    assert(lua_tonumber(L, 2) == 4);
    assert(lua_tonumber(L, 3) == 2);
    assert(lua_tonumber(L, 4) == 3);

    lua_close(L);
}

void replace(void) {

    lua_State *L = luaL_newstate();
    lua_pushnumber(L, 1);
    lua_pushnumber(L, 2);
    lua_pushnumber(L, 3);
    lua_pushnumber(L, 4);

    lua_replace(L, 2);  // 与insert一样会删除栈顶元素
    assert(lua_gettop(L) == 3);
    assert(lua_tonumber(L, 1) == 1);
    assert(lua_tonumber(L, 2) == 4);    // 只是替换元素
    assert(lua_tonumber(L, 3) == 3);

    lua_close(L);
}

void copy(void) {

    lua_State *L = luaL_newstate();
    lua_pushnumber(L, 1);
    lua_pushnumber(L, 2);
    lua_pushnumber(L, 3);
    lua_pushnumber(L, 4);

    lua_copy(L, 2, -1);  // 如果设置的index值不合理，会导致程序异常退出
    assert(lua_gettop(L) == 4);
    assert(lua_tonumber(L, 1) == 1);
    assert(lua_tonumber(L, 2) == 2);
    assert(lua_tonumber(L, 3) == 3);
    assert(lua_tonumber(L, 4) == 2);

    lua_close(L);
}

// 检查虚拟栈是否有10000个slots，看来空间足够大
void checkstack(void) {

    lua_State *L = luaL_newstate();
    lua_pushnumber(L, 1);
    lua_pushnumber(L, 2);
    lua_pushnumber(L, 3);
    lua_pushnumber(L, 4);

    assert(lua_checkstack(L, 10000) == 1);

    lua_close(L);
}

void xmove(void) {

    lua_State *L1 = luaL_newstate();
    lua_State *L2 = luaL_newstate();
    lua_pushnumber(L1, 1);
    lua_pushnumber(L2, 2);
    lua_pushnumber(L1, 3);
    lua_pushnumber(L1, 4);

    lua_xmove(L1, L2, 3);
    assert(lua_gettop(L2) == 4);
    assert(lua_tonumber(L2, 1) == 2);
    assert(lua_tonumber(L2, 2) == 1);
    assert(lua_tonumber(L2, 3) == 3);
    assert(lua_tonumber(L2, 4) == 4);

    lua_close(L1);
    lua_close(L2);
}

int main (void) {
    absindex();
    gettop();
    settop();
    pushvalue();
    lremove();
    insert();
    replace();
    copy();
    checkstack();
    xmove();
}
