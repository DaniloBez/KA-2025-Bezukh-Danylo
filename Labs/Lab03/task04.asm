.model small
.stack 100h
.code
main PROC
    xor dx, dx     ;За допомогою команди xor ми онуляємо значення у регістрі, тобто встановлюємо dx = 0

    mov ax, 4c00h  ;завершуємо програму
    int 21h        ;завершуємо програму
main ENDP
END main
