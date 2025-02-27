.model small
.stack 100h
.code
main PROC
    mov ax, 200d        ; записуємо ax = 200
    mov dx, 100d        ; записуємо dx = 100

    mov bx, ax          ; bx = ax, значення 200 зберігаєтся у допоміжній змінній
    mov ax, dx          ; ax = dx, зміннюємо значення ax на dx
    mov dx, bx          ; dx = bx, дістаємо значення з bx (200) і зберігаємо у dx

    xor bx, bx          ; онуляємо змінну bx

    mov ax, 4c00h       ; завершуємо програму
    int 21h             ; завершуємо програму
main ENDP
END main
