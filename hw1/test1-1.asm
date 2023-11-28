; loop指令实现打印26个小写字母，并换行输出
CODESEG SEGMENT
    ASSUME CS:CODESEG
MAIN PROC FAR

    MOV CX, 13
    MOV AH, 2
    MOV DL, 'a'  ; 初始化

L: 
    INT 21H
    INC DL
    LOOP L

    MOV AH, 2
    MOV DL, 10  ; 打印换行符
    INT 21H

    MOV CX, 13  ; 重置计数器
    MOV DL, 'n'  

L2:
    INT 21H
    INC DL
    LOOP L2

    MOV AH, 4Ch
    INT 21H

MAIN ENDP
CODESEG ENDS

END MAIN
