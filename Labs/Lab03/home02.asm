.model small
.stack 100h
.data
a dw 11d
b dw 20d
.code
main PROC
    mov ax, SEG @data   ;завантажуємо данні
    mov ds, ax          ;завантажуємо данні

    ; if(a >= 100 || b >= 100){
    ;   a += 10
    ;   if(a+b <= 150){
    ;       b = 150 - a+b
    ;   }
    ; else
    ;   a = 0
    ;   b = 1

    mov ax, a
    mov bx, b

    cmp ax, 100     ; if(a >= 100)
    jge first_true
    jmp skip1

first_true:
    mov dl, 1d      ; a >= 100 - true
    jmp all_true    ; lazy checking

skip1:
    cmp bx, 100d    ; if(b >= 100)
    jge second_true
    jmp skip2

second_true:
    mov cl, 1d      ; b >= 100 true

skip2:
    or cl, dl
    mov dx, 0d

    cmp cl, 1d      ; if(a >= 100 || b >= 100)
    je all_true
    jmp all_false

all_true:           ; (a >= 100 || b >= 100) - true
    add ax, 10d     ; a += 10

    mov cx, ax
    add cx, bx
    cmp cx, 150d    ; if ((a + b) <= 150)
    jle in_true
    jmp end_program

in_true:
    mov bx, 150d    ; ((a + b) <= 150) - true
    sub bx, cx      ; b = 150 - (a + b)
    mov cx, 0d
    jmp end_program

all_false:          ; (a >= 100 || b >= 100) - false
    mov ax, 0d      ; a = 0
    mov bx, 1d      ; b = 1

end_program:
    mov ax, 4c00h   ;завершуємо програму
    int 21h         ;завершуємо програму
main ENDP
END main