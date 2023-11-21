; 使用数据段存放
DATA SEGMENT
    SUM DW ? ; 存放最终的累加和
    RESULT_STRING DB 5 DUP(?) ; 存放结果的字符串
DATA ENDS

STACK SEGMENT
    DB 200 DUP(0) ; 定义栈段
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK 

START:
    MOV AX, DATA ; 将数据段地址加载到AX寄存器
    MOV DS, AX ; 将数据段地址赋给DS寄存器
    MOV AX, 0 
    MOV CX, 100 ; 循环100次

LOOP1:
    ADD AX, CX ; 累加
    LOOP LOOP1 

    MOV SUM, AX ; 存储最终累加和到SUM

    ; 转换结果为十进制字符串
    MOV AX, SUM ; 将累加和加载到AX
    MOV CX, 10 ; 除数为10
    MOV DI, 4 ; DI用于指向字符串的位置
    MOV BYTE PTR [RESULT_STRING + DI], '$' ; 设置字符串终止字符$

CONVERT_LOOP:
    XOR DX, DX ; 清空DX
    DIV CX ; AX = AX / 10 (商), DX = AX % 10 (余数)
    ADD DL, '0' ; 将余数转换为字符
    DEC DI ; 移动到下一个字符串位置
    MOV BYTE PTR [RESULT_STRING + DI], DL ; 存储字符
    TEST AX, AX ; 检查商是否为0
    JNZ CONVERT_LOOP ; 如果不为0，继续循环

    ; 显示结果字符串
    MOV AH, 9 
    MOV DX, OFFSET RESULT_STRING ; DX指向要显示的字符串
    INT 21H

    MOV AH, 4CH 
    INT 21H 
CODE ENDS
END START
