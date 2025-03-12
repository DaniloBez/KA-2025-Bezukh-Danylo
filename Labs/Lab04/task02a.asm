.model small
.stack 100h
.code

difference PROC
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
    ret
difference ENDP

main PROC

    mov ax, 23d
    mov bx, 32d
    
    call difference

    mov ax, 4c00h       ; завершуємо програму
    int 21h             ; завершуємо програму
main ENDP
END main