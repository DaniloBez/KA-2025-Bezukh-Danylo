.model small
.stack 100h
.code
main PROC
    mov ax, -10d    ; ax = -10d
    mov dx, 4d      ; dx = 4d

    xor ax, dx      ; ax = x xor y
    xor dx, ax      ; dx = y xor (x xor y) => x
    xor ax, dx      ; ax = (x xor y) xor x => y

    mov ax, 4c00h   ;завершуємо програму
    int 21h         ;завершуємо програму
main ENDP
END main
