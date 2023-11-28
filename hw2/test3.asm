; 打印九九乘法表
STACK SEGMENT
    DW 200 DUP(0) ; 定义栈段
STACK ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, SS:STACK
MAIN PROC FAR

    MOV AX, STACK ; 将栈段地址加载到AX寄存器
    MOV SS, AX ; 将栈段地址传给SS寄存器
    MOV SP, 100 ; 初始化栈顶指针为100

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
    ; 打印第一个因子
    MOV DL, BL
    ADD DL, '0'         ; 将数字转换为字符
    MOV AH, 2
    INT 21H

    ; 打印'*'
    MOV DL, '*'
    INT 21H
    
    ; 打印第二个因子
    MOV DL, CL
    ADD DL, '0'         ; 将数字转换为字符
    MOV AH, 2
    INT 21H

    ; 打印'='
    MOV DL, '='
    INT 21H

    POP AX
    MOV DX, AX        

    ; 输出AX中的结果
    PUSH CX
    
    MOV CX, 10
CONVERT_LOOP2:
    MOV DX, 0 
    DIV CX  ; 用AX除以CX，商在AX，余数在DX
    PUSH DX  ; 将余数推入栈中
    CMP AX, 0  ; 检查商是否为0 ，不为0则继续转换
    JNE CONVERT_LOOP2

    MOV AH, 2 
 ; 打印累加和得到的数据
CONVERT_LOOP3:
    POP DX  ; 弹出栈中的余数
    ADD DL, '0' ; 将余数转化为字符
    INT 21H     
    CMP SP, 96 ; 检查栈是否为空(因为在进行进制转换前两个CX在栈中，所以SP指针为96时余数为空)
    JNE CONVERT_LOOP3  ; 如果不为空，继续打印
    
    POP CX ; 出栈，恢复计数器       

    ; 打印空格
    MOV DL, ' '
    INT 21H

    LOOP inner_loop   

    ; 打印换行
    MOV DL, 10         
    INT 21H
    MOV DL, 13         
    INT 21H

    POP CX          
    DEC BX           
    LOOP outer_loop    

    ; 程序结束
    MOV AH, 4Ch
    INT 21H

MAIN ENDP
    CODESEG ENDS
END MAIN