.model small
.stack 100h
.data
msg db ' ', ' ', '$'     ;змінна де зберігаємо значення
.code
main PROC
    mov ax, SEG @data    ;завантажуємо данні
    mov ds, ax           ;завантажуємо данні

    mov dx, offset msg   ;підготовка до виведення даних
    mov ah, 9            ;підготовка до виведення даних

    mov di, offset msg   ;підготовлюємо змінну di
    mov cx, 30h          ;встановлюємо cx = 30h ('0')
    mov [di], cx         ;переносимо данні до di+пробіл

print_loop:              ;ініціалізуємо цикл
    int 21h              ;виводимо у консоль

    inc cx               ;до змінної cx додаємо 1
    mov [di], cx         ;переносимо данні до di+пробіл
    cmp cx, 3ah          ;перевіряємо чи cx == 3ah (9)
    jne print_loop       ;якщо дорівнює - то закінчуємо цикл

    mov ax, 4c00h        ;завершуємо програму
    int 21h              ;завершуємо програму
main ENDP
END main
