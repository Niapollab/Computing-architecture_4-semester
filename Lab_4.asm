.model tiny 
org 100h

INCLUDE emu8086.inc

DEFINE_PRINT_STRING
DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

.data
    ENTER_ARRAY_SIZE_MSG db "Enter array size: ", 0
    ENTER_ARRAY_ELEMENTS_MSG db "Enter array elements: ", 0
    ENTER_C_MSG db "Enter C: ", 0
    ENTER_D_MSG db "Enter D: ", 0
    DIVISION_BY_ZERO_MSG db "Division by zero", 0
    RESULT_MESSAGE db "X = ", 0

.code
    ; Enter array size
    lea si, ENTER_ARRAY_SIZE_MSG
    call print_string
    call scan_num
    PRINTN ''
    
    ; Enter array elements
    lea si, ENTER_ARRAY_ELEMENTS_MSG
    call print_string
    PRINTN ''
    
    ; Copy cx to dx
    mov dx, cx
    
    ; Read elements
    INPUT_ELEMENTS:
    push cx
    call scan_num
    PRINTN ''
    mov ax, cx
    pop cx
    push ax
    loop INPUT_ELEMENTS
    
    ; Enter C    
    lea si, ENTER_C_MSG
    call print_string
    call scan_num
    PRINTN ''
    mov bx, cx
    cmp bx, 0h
    jz DIVISION_BY_ZERO
    
    ; Enter D
    lea si, ENTER_D_MSG
    call print_string
    call scan_num
    PRINTN ''
    mov ax, cx
    
    ; d / c
    push dx
    cwd
    idiv bx
    pop dx
    push ax
    
    ; Restore cx from dx
    mov cx, dx
    
    ; Prepair bx to save result
    xor bx, bx
    
    ; Process elements
    PROCESS_ELEMENTS:
    pop dx
    pop ax
    cmp ax, 0h
    push dx
    jl SKIP_PROCESS_ELEMENTS
    pop dx
    cmp ax, dx
    push dx
    jl SKIP_PROCESS_ELEMENTS
    imul ax
    add bx, ax
    SKIP_PROCESS_ELEMENTS:
    loop PROCESS_ELEMENTS
    
    ; Print result 
    lea si, RESULT_MESSAGE
    call print_string
    mov ax, bx
    call print_num
    PRINTN ''
    jmp END_OF_PROGRAM
    
    ; Print error
    DIVISION_BY_ZERO:
    lea si, DIVISION_BY_ZERO_MSG
    call print_string
    
    END_OF_PROGRAM:
    ret 