;a1.asm
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

START_1:
    
GetNum PROC 
    MOV CX, 21 ; 循环21次
    MOV BX, 0
    MOV SI, 0
    MOV DI, 0 
LOOP_1:
    ; 写入年份
    MOV AX, DS:0[SI]
    MOV ES:[0], AX
    MOV AX, DS:0[SI+2]
    MOV ES:[2], AX

    ; 写入空格
    MOV AL, 20H
    MOV ES:[4], AL
    MOV ES:[9], AL
    MOV ES:[12], AL
    MOV ES:[15], AL

    ; 写入收入数据
    MOV AX, DS:84[SI]
    MOV ES:[5], AX
    MOV DX, DS:84[SI+2]
    MOV ES:[7], DX
    ; 由于这里是dword数据类型，需要将其转换为字符串后输出

    ; 写入人数
    MOV BX, DS:168[DI]
    ; 由于这里是word数据类型，需要将其转换为字符串后输出
    MOV ES:[10], BX

    ; 写入平均收入
    DIV BX ; 求平均值
    MOV ES:[13], AX

    ; 进入下一个循环
    MOV AX, ES
    INC AX
    MOV ES, AX
    ADD SI, 4
    ADD DI, 2
    LOOP LOOP_1

    RET 
GetNum ENDP

CODE ENDS
END START_1