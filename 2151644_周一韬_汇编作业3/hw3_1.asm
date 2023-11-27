; 输入年月日，并输出结果
DATA SEGMENT
    INPUT_STRING DB 'WHAT IS THE DATE(MM/DD/YY):','$' ; 输入提示
    OUTPUT_STRING DB 'THE DATE IS: $' ; 输出提示
    STRING_M DB 30,0,0,0,0,0 ; 保存用户输入的月字符串
    STRING_D DB 30,0,0,0,0,0 ; 保存用户输入的日字符串
    STRING_Y DB 30,0,0,0,0,0 ; 保存用户输入的年字符串
DATA ENDS

STACK SEGMENT
    DW 200 DUP(0)  ; 定义栈段
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK
START:
    MOV AX, DATA
    MOV DS, AX

    ; 输出输入提示
    MOV AH, 9
    MOV DX, OFFSET INPUT_STRING
    INT 21H 

    ; 响铃操作
    MOV AH, 2 ; 响铃
    MOV DL, 7
    INT 21H ; 用02号功能，输出一个响铃字符

    MOV BX, 0; BX作为读取字符串的偏移量

    CALL GetNum ; 调用输入过程
    CALL Disp ; 调用输出过程

    MOV AX, 4C00H ; 结束程序
    INT 21H

; 输入过程
GetNum PROC 
INPUT_M: 
    MOV AH, 1 ; 一位一位读取
    INT 21H
    CMP AL, 2FH ; 判断是否是/
    JZ GETLENGTH_M ; 字符串输入结束，转入getlength处
    MOV [STRING_M + BX], AL
    INC BX
    JMP INPUT_M

GETLENGTH_M:
    MOV [STRING_M + BX], '$'
    MOV BX, 0

INPUT_D: 
    MOV AH, 1
    INT 21H
    CMP AL, 2FH ; 判断是否是/
    JZ GETLENGTH_D ; 字符串输入结束，转入getlength处
    MOV [STRING_D + BX], AL
    INC BX
    JMP INPUT_D

GETLENGTH_D:
    MOV [STRING_D + BX], '$'
    MOV BX, 0

INPUT_Y: 
    MOV AH, 1
    INT 21H
    CMP AL, 0DH ; 判断是否是回车
    JZ GETLENGTH_Y ; 字符串输入结束，转入getlength处
    MOV [STRING_Y + BX], AL
    INC BX
    JMP INPUT_Y

GETLENGTH_Y:
    MOV [STRING_Y + BX], '$'
    MOV BX, 0
    
EXIT:    
    RET 
GetNum ENDP

; 输出过程
Disp PROC
    ; 输出输出提示
    MOV AH, 9
    MOV DX, OFFSET OUTPUT_STRING
    INT 21H
    
    MOV AH, 9
    MOV DX, OFFSET STRING_Y
    INT 21H ; 
    
    MOV AH, 2
    MOV DL, '-'
    INT 21H

    MOV AH, 9
    MOV DX, OFFSET STRING_M
    INT 21H ; 

    MOV AH, 2
    MOV DL, '-'
    INT 21H

    MOV AH, 9
    MOV DX, OFFSET STRING_D
    INT 21H ; 

    RET
Disp ENDP

CODE ENDS
END START 
