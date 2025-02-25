.model small
.stack 100h
.code
main PROC
    xor ax, ax     ;очищаємо дані з ax
    xor bx, bx     ;очищаємо дані з bx
    xor cx, cx     ;очищаємо дані з cx
    xor dx, dx     ;очищаємо дані з dx

    mov ax, 100    ;встановлюємо значення ax = 100
    
    mov bx, 50     ;встановлюємо значення bx = 50

    add bx, ax     ;додаємо до bx значення з ax

print_loop:        ;створюємо цикл
    inc cx         ;додаємо 1 до cx
    cmp cx, 40     ;перевіряємо чи cx == 40
    jne print_loop ;якщо так, то завершуємо цикл

    sub bx, cx     ;віднімаємо від bx, cx

    mov ax, 4c00h  ;завершуємо програму
    int 21h        ;завершуємо програму
main ENDP
END main
