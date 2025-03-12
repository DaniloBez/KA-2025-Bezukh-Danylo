.model small
.stack 100h
.data
array dw 16 dup(01111h)
.code
main PROC
    mov ax, SEG @Data
    mov ds, ax

    mov bx, 4d          ; iterator (4 бо зсув на 2 2бітних числа)
    mov ax, 0d

    mov [array], 0d
    mov [array + 2], 1d

loop_:
    mov ax, [array + bx - 4]
    add ax, [array + bx - 2]

    mov [array + bx], ax
    inc bx              ; bx += 2 (викоритовуємо 2 байтові змінні)
    inc bx

    cmp bx, 32d         ; if bx == 32d (16 елемент масиву)
    jne loop_

    mov ax, 4c00h       ; завершуємо програму
    int 21h             ; завершуємо програму
main ENDP
END main
