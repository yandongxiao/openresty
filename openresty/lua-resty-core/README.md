# lua-resty-core

1. 这是纯LuaJIT FFI实现的库
2. 由于它是重新实现了ngx_lua模块的部分函数，所以lua-resty-core库的函数在ngx.*和ndk.*的命名空间内
3. **为什么需要重新实现一遍**
