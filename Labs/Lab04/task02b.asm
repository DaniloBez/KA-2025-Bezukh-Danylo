.model small
.stack 100h
.data
array dw 12*10 dup(01111h)
.code

findNumber PROC
    mov ax, bx          ; ax = x
    mov bx, 4d          ; bx = 4
    mul bx              ; ax = 4x
    sub ax, dx          ; ax = 4x - y

    ret
findNumber ENDP

main PROC
    mov ax, SEG @Data
    mov ds, ax

    mov ch, 0           ; Set loop counter for rows (X)
    mov cl, 0           ; Set loop counter for columns (Y)

myloop:
    xor ax, ax          ; онуляємо значення ax

    mov bl, ch          ; bx = x
    mov dl, cl          ; dx = y

    call findNumber     ; викликаємо функцію знаходження числа

    mov bx, ax          ; bx = ax


    ; find the address of the element in the word array
    ; first, find the address of the row
    mov ax, 10
    mul ch
    ; now add the column stored in CL
    mov dl, cl
    xor dh, dh
    add ax, dx
    
    ; now multiply by 2 to get the offset in the array
    shl ax, 1
    ; exhcange AX and BX so that BX contains the address of the element and AX contains the value
    xchg ax, bx

    ; now store the result from BX into the array
    mov [array + bx], ax
    inc cl
    cmp cl, 10
    jne myloop
    mov cl, 0
    inc ch
    cmp ch, 12
    jne myloop

    mov ax, 4c00h       ; завершуємо програму
    int 21h             ; завершуємо програму
main ENDP
END main
