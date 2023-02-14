.model tiny 
org 100h

INCLUDE emu8086.inc

DEFINE_PRINT_STRING
DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

.data
    ENTER_A_MSG db "Enter A: ", 0
    ENTER_B_MSG db "Enter B: ", 0
    DIVISION_BY_ZERO_MSG db "Division by zero", 0
    RESULT_MESSAGE db "X = ", 0

.code
    ; Enter A     
    lea si, ENTER_A_MSG
    call print_string
    call scan_num
    PRINTN ''
    mov ax, cx
    
    ; Enter B     
    lea si, ENTER_B_MSG
    call print_string
    call scan_num
    PRINTN ''
    mov bx, cx
    
    ; Compare A and B
    cmp ax, bx
    je EQUAL_A_B
    jg A_GREATER_B
    
    ; A < B (X = (2 * a - 5) / b)
    cmp bx, 0h
    je DIVISION_BY_ZERO 
    mov dx, 2h
    imul dx
    sub ax, 5h
    cwd
    idiv bx
    jmp END_A_B_COMPARE
    
    ; A = B (X = 3425) 
    EQUAL_A_B:
    mov ax, 0xD61h
    jmp END_A_B_COMPARE 
    
    ; A > B (X = b / a + 10)
    A_GREATER_B:
    cmp ax, 0h
    je DIVISION_BY_ZERO
    xchg ax, bx
    cwd
    idiv bx
    add ax, 0xAh
    jmp END_A_B_COMPARE
    
    ; Print result 
    END_A_B_COMPARE:
    lea si, RESULT_MESSAGE
    call print_string
    call print_num
    jmp END_OF_PROGRAM
    
    ; Print error
    DIVISION_BY_ZERO:
    lea si, DIVISION_BY_ZERO_MSG
    call print_string
    END_OF_PROGRAM:
    ret 