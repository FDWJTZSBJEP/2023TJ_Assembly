; 使用条件跳转实现打印26个小写字母，并换行输出
CODESEG SEGMENT
    ASSUME CS:CODESEG
MAIN PROC FAR

    MOV CX, 13    
    MOV AH, 2
    MOV DL, 'a'   

L1:
    INT 21H
    INC DL
    DEC CX        
    JNZ L1 ;如果CX不等于0，跳转到L1

    ; 打印换行
    MOV AH, 2
    MOV DL, 10    
    INT 21H

    MOV CX, 13 ;重置计数器
    MOV DL, 'n'   

L2:
    INT 21H
    INC DL
    DEC CX        
    JNZ L2 ;如果CX不等于0，跳转到L2

    MOV AH, 4Ch
    INT 21H       

MAIN ENDP
CODESEG ENDS

END MAIN
