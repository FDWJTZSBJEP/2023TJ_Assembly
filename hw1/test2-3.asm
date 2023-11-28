; 使用栈存放
DATA SEGMENT
    RESULT_STRING DB 5 DUP(?) ; 存放结果的字符串
DATA ENDS

STACK SEGMENT
    DW 200 DUP(0) ; 定义栈段，这里假设栈的大小为200字节
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK 

START:
    MOV AX, DATA ; 将数据段地址加载到AX寄存器
    MOV DS, AX ; 将数据段地址赋给DS寄存器

    ; 使用栈来存放结果
    MOV AX, 0
    MOV CX, 100

LOOP1:
    ADD AX, CX
    LOOP LOOP1

    PUSH AX ; 将累加和推入栈中

    ; 转换结果为十进制字符串
    MOV CX, 10
    MOV DI, 4
    MOV BYTE PTR [RESULT_STRING + DI], '$'

CONVERT_LOOP:
    XOR DX, DX
    DIV CX
    ADD DL, '0'
    DEC DI
    MOV BYTE PTR [RESULT_STRING + DI], DL
    TEST AX, AX
    JNZ CONVERT_LOOP

    ; 从栈中弹出累加和
    POP AX

    ; 显示结果字符串
    MOV AH, 9
    MOV DX, OFFSET RESULT_STRING
    INT 21H

    MOV AH, 4CH
    INT 21H
CODE ENDS
END START
