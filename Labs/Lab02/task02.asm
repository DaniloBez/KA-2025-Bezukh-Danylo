.model small
.stack 100h
.data
msg db ' ', ' ', '$'    ;змінна де зберігаємо значення
num db '9'              ;змінна-число до котрого виводимо
.code
main PROC
    mov ax, SEG @data   ;завантажуємо данні
    mov ds, ax          ;завантажуємо данні

    mov dx, offset msg  ;підготовка до виведення даних
    mov ah, 9           ;підготовка до виведення даних

    mov di, offset msg  ;підготовлюємо змінну di
    mov cx, 30h         ;встановлюємо cx = 30h ('0')
    mov [di], cx        ;переносимо данні до di+пробіл

    mov bl, [num]       ;переносимо значення з num до bx
    inc bx              ;додаємо 1, оскільки виводимо включно

print_loop:             ;ініціалізуємо цикл
    int 21h             ;виводимо у консоль

    inc cx              ;до змінної cx додаємо 1
    mov [di], cx        ;переносимо данні до di+пробіл
    cmp cx, bx          ;перевіряємо чи cx == bx
    jne print_loop      ;якщо дорівнює - то закінчуємо цикл

    mov ax, 4c00h       ;завершуємо програму
    int 21h             ;завершуємо програму
main ENDP
END main
