.model small
.stack 100h
.data
array dw 20 dup(0AAh)
.code
main PROC
    mov ax, SEG @Data
    mov ds, ax

    mov bx, 0d          ; iterator
    mov cx, 0ffffh      ; -0

loop_:
    mov [array + bx], cx
    dec cx              ; cx--
    inc bx              ; bx += 2 (викоритовуємо 2 байтові змінні)
    inc bx

    cmp bx, 38d         ; if bx == 38d (20 елемент масиву)
    jne loop_

    mov ax, 4c00h       ; завершуємо програму
    int 21h             ; завершуємо програму
main ENDP
END main
