;a2.asm
DATA SEGMENT
    ; 以下是表示21年的21个字符串
    DB '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    DB '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    DB '1993','1994','1995'
        
    ; 以下是表示21年公司总收的21个dword型数据
    DD 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    DD 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
        
    ; 以下是表示21年公司雇员人数的21个word型数据
    DW 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    DW 11542,14430,15257,17800

DATA ENDS

TABLE SEGMENT
    DB 21 DUP('YEAR SUMM NE ?? ')
TABLE ENDS

STACK SEGMENT
    DW 100 DUP(0) ; 定义栈段
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK

START_2:
Disp PROC
    

    MOV BX, OFFSET TABLE 
    SUB BX, 112 ; BX是table段的起始位置

    ; 循环打印结果
    MOV SI, 0 ; 记录偏移量
    MOV CX, 0
    MOV AX, 0
    MOV AH,2
INPUT:
    CMP CX, 21
    JZ EXIT

    MOV SI, 0
    MOV AH, 2
INPUT_1:; 输出年份
    MOV DL,[BX+SI]
    INT 21H
    INC SI
    CMP SI,4
    JNE INPUT_1

    ; 打印空格
    MOV DL, ' '
    INT 21H
    PUSH CX ; 暂存计数器

INPUT_2:; 输出收入
    MOV AX,[BX+5]; 总收入的低16位
    MOV DX,[BX+7]; 总收入的高16位
    MOV DI,0
    CALL CONVERT

    ; 打印空格
    MOV AH, 2
    MOV DL, ' '
    INT 21H

INPUT_3: ; 输出人数
    MOV AX,[BX+10]
    MOV DX,0
    MOV DI,0
    CALL CONVERT

    ; 打印空格
    MOV AH, 2
    MOV DL, ' '
    INT 21H

INPUT_4: ; 输出平均值
    MOV AX,[BX+13]
    MOV DX,0
    MOV DI,0
    CALL CONVERT

INPUT_5:
    ; 换行
    MOV AH, 2
    MOV DL, 10         
    INT 21H
    MOV DL, 13         
    INT 21H
    POP CX ; 取出计数器
    INC CX
    ADD BX, 16; 指向下一组数据

    JMP INPUT

EXIT:
    RET
Disp ENDP

CONVERT PROC
; 转化为十进制后输出
CONVERT_LOOP:
    MOV CX, 10 ; 每次除十取余

    PUSH BX
	
    MOV BX,AX
    MOV AX,DX
    MOV DX,0
    DIV CX

    PUSH AX
    MOV AX,BX
    DIV CX

    MOV CX,DX
    POP DX
    POP BX
    PUSH CX ; 余数入栈

    CMP AX, 0 ; AX和DX都为零时结束
    JNE CONVERT_LOOP
    CMP DX, 0
    JNE CONVERT_LOOP

    ; 打印栈内数据
OUTPUT:
    POP DX
    MOV AH, 2
    ADD DL, '0'
    INT 21H
    CMP SP, 94 ; 这里因为前面有三个数据在栈中，sp=94时表示余数全部输出
    JNE OUTPUT

RET
CONVERT ENDP

CODE ENDS
END START_2