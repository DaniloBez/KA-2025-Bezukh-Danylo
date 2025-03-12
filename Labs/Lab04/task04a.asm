.model small
.stack 50h
.code

difference PROC
    pop cx
    pop bx
    pop ax

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
    push cx
    ret
difference ENDP

main PROC
    mov ax, @stack
    mov ds, ax

    mov ax, 23d
    mov bx, 32d

    push ax
    push bx
    push cx

    push ax
    push bx
    
    call difference

    mov dx, ax

    pop cx
    pop bx
    pop ax

    mov ax, 4c00h       ; завершуємо програму
    int 21h             ; завершуємо програму
main ENDP
END main