// 多文件汇编
#include <stdio.h>

// extern声明汇编函数
extern int my_asm_function(int a);

int main() {
    int a = 10;
    int result = my_asm_function(a);

    printf("Result: %d\n", result);

    return 0;
}