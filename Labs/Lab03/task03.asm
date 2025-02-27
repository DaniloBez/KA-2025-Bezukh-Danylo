.model small
.stack 100h
.data
a dw 1
b dw 10b  
.code
main PROC
    mov ax, SEG @data   ;завантажуємо данні
    mov ds, ax          ;завантажуємо данні

    mov bx, a           ; переносимо змінну а в bx
    mov cx, b           ; переносимо змінну b в cx

    and bx, cx          ; виконуємо (a & b) і зберігаємо у bx

    cmp bx, cx          ; порівнюємо (a & b) з b
    jne else_part       ; Якщо не рівні, перейти до else

    mov a, 1            ; Якщо (a & b) == b, то a = 1
    jmp end_if          ; Перейти до кінця if-else

else_part:
    mov a, 0            ; Якщо (a & b) != b, то a = 0

end_if:
    mov ax, 4c00h       ;завершуємо програму
    int 21h             ;завершуємо програму
main ENDP
END main
