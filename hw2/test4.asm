DATA SEGMENT
    table  db 7,2,3,4,5,6,7,8,9             ;9*9表数据
	       db 2,4,7,8,10,12,14,16,18
	       db 3,6,9,12,15,18,21,24,27
	       db 4,8,12,16,7,24,28,32,36
	       db 5,10,15,20,25,30,35,40,45
	       db 6,12,18,24,30,7,42,48,54
	       db 7,14,21,28,35,42,49,56,63
	       db 8,16,24,32,40,48,56,7,72
	       db 9,18,27,36,45,54,63,72,81
          
DATA ENDS

STACK SEGMENT
    DW 200 DUP(0) ; 定义栈段
STACK ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, SS:STACK, DS:DATA
MAIN PROC FAR

    MOV AX, DATA ; 设置data段
    MOV DS, AX
    
    MOV AX, STACK ; 将栈段地址加载到AX寄存器
    MOV SS, AX ; 将栈段地址传给SS寄存器
    MOV SP, 100 ; 初始化栈顶指针为100

    ; 打印x和y
    MOV DL, "x"
    MOV AH, 2
    INT 21H

    MOV DL, " "
    MOV AH, 2
    INT 21H

    MOV DL, "y"
    MOV AH, 2
    INT 21H

    ; 打印换行
    MOV DL, 10         
    INT 21H
    MOV DL, 13         
    INT 21H

    MOV CX, 9 ; 外层循环 
    MOV BX, 9 ; 内层循环  
outer_loop:
    PUSH CX         
    MOV CX, BX        
    MOV DX, 0     

inner_loop:
    MOV AX, BX   
    MUL CX
    PUSH AX

    POP AX
    MOV DX, AX        
    
    ; 下面进行纠错判断，先将我们用到的寄存器用栈保存

    PUSH AX
    PUSH CX
    PUSH BX
    PUSH DX
    
    ; 计算AX=（BX-1）*9+CX-1 
    MOV AX, BX
    DEC AX
    MOV BX, 9
    MUL BX
    ADD AX, CX
    DEC AX

    ; 使用si作为读取寄存器值作为偏移量
    MOV SI, AX
    MOV BX, OFFSET TABLE
    ADD BX, SI
    MOV AL, [BX] ; 去出纠错表内对应位置的元素
    POP DX
    POP BX
    POP CX
    CMP DL,AL
    JNE error
continue:

    POP AX

    LOOP inner_loop   

    POP CX          
    DEC BX           
    LOOP outer_loop    

    ; 程序结束
    MOV AH, 4Ch
    INT 21H

error:
    MOV DL, BL
    ADD DL, '0'         ; 将数字转换为字符
    MOV AH, 2
    INT 21H

    MOV DL, " "
    MOV AH, 2
    INT 21H

    MOV DL, CL
    ADD DL, '0'         ; 将数字转换为字符
    MOV AH, 2
    INT 21H

     ; 打印换行
    MOV DL, 10         
    INT 21H
    MOV DL, 13         
    INT 21H
    JMP continue
    

MAIN ENDP
    CODESEG ENDS
END MAIN