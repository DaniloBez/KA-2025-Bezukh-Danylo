.model small
.stack 100h
.data
buffer db 0d

.code
write_symbol PROC
    push ax
    push bx
    push cx
    push dx

    mov dl, [buffer]    
    mov ah, 02h
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
write_symbol ENDP

read_file PROC
    push ax
    push bx
    push cx
    push dx

read_next:
    mov [buffer], 0dh
    mov ah, 3Fh
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset buffer   ; read to ds:dx 
    int 21h   ;  ax = number of bytes read
    
    call write_symbol

    or ax,ax
    jnz read_next

    mov dl, 0ah   
    mov ah, 02h
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
read_file ENDP

main PROC
    mov ax, @Data
    mov ds, ax

    call read_file 

    mov ax, 4c00h       ; завершуємо програму
    int 21h             ; завершуємо програму
main ENDP
END main

