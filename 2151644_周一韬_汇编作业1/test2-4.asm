DATA SEGMENT
    INPUT_STRING DB 10,0,0,0,0,0 ; 保存用户输入的字符串
    INPUT DB 'INPUT NUMBER(1-100):','$' ; 提示信息
DATA ENDS

STACK SEGMENT
    DW 200 DUP(0) ; 定义栈段
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK

START:
    MOV AX, DATA      
    MOV DS, AX  
    MOV AX, STACK ; 将栈段地址加载到AX寄存器
    MOV SS, AX ; 将栈段地址传给SS寄存器
    MOV SP, 10 ; 初始化栈顶指针为10

    ; 打印提示信息
    MOV AH, 9
    MOV DX, OFFSET INPUT 
    INT 21H 

    ; 中断输入字符
    MOV AH, 10
    MOV DX, OFFSET INPUT_STRING 
    INT 21H

    MOV AX, 0 ; 清零AX寄存器
    MOV SI, 0 ; 清零SI寄存器

; 将用户输入的字符串转化为整数存放
CONVERT_LOOP1:
    MOV BX, 0
    MOV BL, [SI+2] ; 从INPUT_STRING中读取字符
    SUB BL, '0' ; 将字符转化为数字
    MOV [SI+2], BL ; 将转化后的数字存回INPUT_STRING
    MOV BX, 10 
    MUL BL ; 将AL和BL相乘，结果存入AX
    ADD AL, [SI+2] ; 将AL和INPUT_STRING中的字符相加
    INC SI 
    MOV BL, [SI+2] ; 读取下一个字符
    CMP BL, 0DH ; 检查是否为回车符
    JNE CONVERT_LOOP1 ; 如果不是回车符，继续转换

    MOV CX, AX ; 将转化后的结果放入CX
    MOV AX, 0  ; 清零AX

; 循环累加
LOOP1:
    ADD AX, CX 
    LOOP LOOP1 

    MOV CX, 10 

; 转化为十进制输出
CONVERT_LOOP2:
    MOV DX, 0 
    DIV CX  ; 用AX除以CX，商在AX，余数在DX
    PUSH DX  ; 将余数推入栈中
    CMP AX, 0  ; 检查商是否为0 ，不为0则继续转换
    JNE CONVERT_LOOP2

    MOV AH, 2 ; 设置AH为2，表示打印字符
    MOV DL, 0AH 
    INT 21H    

    MOV AH, 2 

 ; 打印累加和得到的数据
CONVERT_LOOP3:
    POP DX  ; 弹出栈中的余数
    ADD DL, '0' ; 将余数转化为字符
    INT 21H     
    CMP SP, 10 ; 检查栈是否为空
    JNE CONVERT_LOOP3  ; 如果不为空，继续打印

    MOV AH, 4CH      
    INT 21H 

CODE ENDS
END START
