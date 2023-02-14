.model tiny
org 100h

.data
    ENTER_N_MSG db "Enter N: ", 0
    MINUS_ERROR_MSG db "Numer must be is positive.", 0

.code
    ; Enter n
    push ax
    push si

    lea si, ENTER_N_MSG

    NEXT_CHAR_N:
    mov al, [si]
    cmp al, 0
    jz PRINTED_N
    inc si
    mov ah, 0xeh
    int 10h
    jmp NEXT_CHAR_N

    PRINTED_N:
    pop si
    pop ax

    ; Read n
    push dx
    push ax
    push si
    push bx
    mov bx, 0xah
    mov cx, 0

    NEXT_DIGIT_N:
    ; Read char to AL
    mov ah, 0
    int 16h

    ; Write char to output
    mov ah, 0xeh
    int 10h

    ; Check is first minus
    cmp cx, 0
    jnz FIRST_MINUS_CHECK_COMPLETED_N
    cmp al, '-'
    je PRINT_MINUS_ERROR_N

    ; Check Enter
    FIRST_MINUS_CHECK_COMPLETED_N:
    cmp al, 13
    je IS_ENTER_N

    ; Check Backspace
    cmp al, 8
    je IS_BACKSPACE_N

    ; Check is digit
    cmp al, '0'
    jl EXECUTE_BACKSPACE_N
    cmp al, '9'
    jg EXECUTE_BACKSPACE_N

    ; Append digit
    push ax
    mov ax, cx
    mul bx
    mov cx, ax
    pop ax

    ; Check number is overflow
    cmp dx, 0
    jne TOO_BIG_N

    ; Convert from ASCII code
    sub al, 30h

    mov ah, 0
    mov dx, cx
    add cx, ax
    jc TOO_BIG_AFTER_APPEND_N

    jmp NEXT_DIGIT_N

    TOO_BIG_AFTER_APPEND_N:
    mov cx, dx
    mov dx, 0

    TOO_BIG_N:
    mov ax, cx
    div bx
    mov cx, ax

    EXECUTE_BACKSPACE_N:
    ; Print 8 (backspace symbol)
    push ax
    mov al, 8
    mov ah, 0xeh
    int 10h
    pop ax

    ; Print ' '
    push ax
    mov al, ' '
    mov ah, 0xeh
    int 10h
    pop ax

    ; Print 8 (backspace symbol)
    push ax
    mov al, 8
    mov ah, 0xeh
    int 10h
    pop ax
    jmp NEXT_DIGIT_N

    IS_BACKSPACE_N:
    mov dx, 0
    mov ax, cx
    div bx
    mov cx, ax

    ; Print ' '
    push ax
    mov al, ' '
    mov ah, 0xeh
    int 10h
    pop ax

    ; Print 8 (backspace symbol)
    push ax
    mov al, 8
    mov ah, 0xeh
    int 10h
    pop ax
    jmp NEXT_DIGIT_N

    IS_ENTER_N:
    pop si
    pop ax
    pop dx

    ; Do calculates
    mov ax, 0
    CALCULATE:
    add ax, cx
    loop CALCULATE

    ; Print new line
    push ax
    mov al, 13
    mov ah, 0xeh
    int 10h
    pop ax

    push ax
    mov al, 10
    mov ah, 0xeh
    int 10h
    pop ax

    ; Print n
    push ax
    push bx
    push cx
    push dx

    mov cx, 1
    mov bx, 10000
    cmp ax, 0
    jz  PRINT_ZERO_N

    PRINT_DIGIT_N:
    cmp bx,0
    jz PRINT_N_END

    cmp cx, 0
    je  CALC_N
    cmp ax, bx
    jb  SKIP_N

    CALC_N:
    mov cx, 0
    mov dx, 0
    div bx
    add al, 30h
    push ax
    mov ah, 0xeh
    int 10h
    pop ax
    mov ax, dx

    SKIP_N:
    push ax
    mov dx, 0
    mov ax, bx
    mov bx, 0xah
    div bx
    mov bx, ax
    pop ax
    jmp PRINT_DIGIT_N

    PRINT_ZERO_N:
    push ax
    mov al, '0'
    mov ah, 0xeh
    int 10h
    pop ax

    PRINT_N_END:
    jmp END_OF_PROGRAM

    ; Print minus error
    PRINT_MINUS_ERROR_N:

    ; Print new line
    push ax
    mov al, 13
    mov ah, 0xeh
    int 10h
    pop ax

    push ax
    mov al, 10
    mov ah, 0xeh
    int 10h
    pop ax

    lea si, MINUS_ERROR_MSG

    NEXT_CHAR_MINUS_ERROR_MSG:
    mov al, [si]
    cmp al, 0
    jz PRINTED_MINUS_ERROR_MSG
    inc si
    mov ah, 0xeh
    int 10h
    jmp NEXT_CHAR_MINUS_ERROR_MSG

    PRINTED_MINUS_ERROR_MSG:
    jmp END_OF_PROGRAM

    END_OF_PROGRAM:
    ret