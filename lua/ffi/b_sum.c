// gcc -shared -fPIC b_sum.c -L/usr/local/lib -llua -o libsum.dylib
int sum(int x, int y) {
    return x + y;
}

void sump(int *x, int *y, int *sum)
{
    *sum = *x+*y;
}

int toint(int *x)
{
    return *x;
}

