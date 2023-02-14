.model tiny
org 100h

INCLUDE emu8086.inc

DEFINE_PRINT_STRING
DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

.data
    ENTER_A_MSG db "Enter A: ", 0
    ENTER_C_MSG db "Enter C: ", 0
    ENTER_D_MSG db "Enter D: ", 0
    RESULT_MESSAGE db "(c * 2 - d / 2 + 1) / (a * a + 7) = ", 0

.code
    ; Enter A
    lea si, ENTER_A_MSG
    call print_string
    call scan_num
    PRINTN ''
    mov ax, cx

    ; (a * a + 7)
    imul ax
    add ax, 7h
    push ax

    ; Enter C
    lea si, ENTER_C_MSG
    call print_string
    call scan_num
    PRINTN ''
    mov ax, cx

    ; c * 2
    mov bx, 2h
    imul bx
    push ax

    ; Enter D
    lea si, ENTER_D_MSG
    call print_string
    call scan_num
    PRINTN ''
    mov ax, cx

    ; d / 2 + 1
    mov bx, 2h
    xor dx, dx
    cwd
    idiv bx
    add ax, 1h
    push ax

    ; (c * 2) - (d / 2 + 1)
    pop bx
    pop ax
    sub ax, bx

    ; ((c * 2) - (d / 2 + 1)) / (a * a + 7)
    pop bx
    xor dx, dx
    cwd
    idiv bx

    ; Print result
    lea si, RESULT_MESSAGE
    call print_string
    call print_num
    ret