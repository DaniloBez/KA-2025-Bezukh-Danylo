.model small
.stack 100h
.data
a dw -2d
b db 0d
.code
main PROC
    mov ax, SEG @data   ;завантажуємо данні
    mov ds, ax          ;завантажуємо данні

    mov ax, a           ; ax = a
    mov bl, b           ; bl = b (оскільки b - тільки 1 біт, а bx - 2 біта. Тому ми записуємо у перший біт)

    test bl, 080h       ; перевіряємо, що bl - від'ємне число
    jnz reverseb        ; якщо від'ємне - додаємо біти у bh

    jmp skip

reverseb:
    mov bh, 0FFh        ; додаємо значення у bh, щоб bx було від'ємним

skip:

    add ax, bx

    test ax,  08000h
    jnz reversea

    jmp end

reversea:
    mov cx, 0FFFFh
    sub cx, ax
    mov ax, cx

end:
    inc ax

    mov ax, 4c00h       ;завершуємо програму
    int 21h             ;завершуємо програму
main ENDP
END main
