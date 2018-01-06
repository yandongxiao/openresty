// gcc -shared -fPIC sum.c -L/usr/local/openresty/luajit/lib -lluajit-5.1 -o sum.so
int sum(int x, int y) {
    return x+y;
}
