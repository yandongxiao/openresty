#include <stdio.h>

struct constr_t {
    int a;
    int b;
    struct innerstr {
        int x;
        int y;
    } c;
};

void print_constr_t(struct constr_t t)
{
    printf("a:%d\n", t.a);
    printf("b:%d\n", t.b);
    printf("c.x:%d\n", t.c.x);
    printf("c.y:%d\n", t.c.y);
}

void print_constr_p(struct constr_t *p)
{
    printf("pa:%d\n", p->a);
    printf("pb:%d\n", p->b);
    printf("pc.x:%d\n", p->c.x);
    printf("pc.y:%d\n", p->c.y);
}
