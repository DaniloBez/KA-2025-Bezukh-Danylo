.model small
.stack 100h
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
    push ax
    jmp return

bx_Bigger:
    sub bx, ax
    push bx
    push cx
    jmp return

return:
    ret
difference ENDP

main PROC

    mov ax, 23d
    mov bx, 32d

    push ax
    push bx
    
    call difference

    mov ax, 4c00h       ; завершуємо програму
    int 21h             ; завершуємо програму
main ENDP
END main