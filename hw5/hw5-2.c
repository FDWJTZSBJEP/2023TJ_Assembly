#include <stdio.h>

int main() {
    int a = 10, result;

    // 嵌入式使用asm汇编
    asm (
        "movl %[input_a], %[output_result]"  // 汇编代码
        : [output_result] "=r" (result)       // 输出操作数
        : [input_a] "r" (a)                   // 输入操作数
        : // 使用到的寄存器
    );

    printf("Result: %d\n", result);

    return 0;
}
