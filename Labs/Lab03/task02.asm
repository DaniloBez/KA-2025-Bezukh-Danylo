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

    jmp skip            ; число додантнє - пропустити перетворення

reverseb:
    mov bh, 0FFh        ; додаємо значення у bh, щоб bx було від'ємним

skip:
    add ax, bx          ; додаємо 2 числа

    test ax,  08000h    ; перевіряємо на від'ємність
    jnz reversea        ; число від'ємне - перетворити на додатнє

    jmp end             ; в іншому випадку - пропускаємо перетворення

reversea:
    mov cx, 0FFFFh      ; задаємо максимальне значення регістру cx
    sub cx, ax          ; віднімаємо від cx, ax
    mov ax, cx          ; перезаписуємо значення у ax

    inc ax              ; додаємо 1, щоб отримати правильний результат

end:
    mov ax, 4c00h       ;завершуємо програму
    int 21h             ;завершуємо програму
main ENDP
END main
