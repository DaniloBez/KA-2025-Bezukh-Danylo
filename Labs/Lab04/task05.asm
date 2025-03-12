.model small
.stack 50h
.code

difference PROC
    push bp
    mov  bp, sp
    sub sp, 6
    push cx
    push dx

    mov ax, [bp + 4]
    mov bx, [bp + 6]   

    cmp ax, bx
    jge ax_Bigger

    jmp bx_Bigger 

ax_Bigger:
    sub ax, bx
    jmp return

bx_Bigger:
    sub bx, ax
    mov ax, bx
    jmp return

return:
    pop dx
    pop cx

    mov sp, bp
    pop bp
    ret
difference ENDP

main PROC
    mov ax, @stack
    mov ds, ax

    push 23d
    push 32d
    
    call difference

    mov ax, 4c00h       ; завершуємо програму
    int 21h             ; завершуємо програму
main ENDP
END main