.model small
.stack 100h
.data
strings db 1000h dup(0)
pointers dw 20 dup(0)
pointersSize dw 0
buffer db 0
msg1 db "Enter something: $"
msg2 db "Your input: $"
.code

outputMessage1 PROC             ; Вивести перше повідомлення
    push ax
    xor ax, ax
    push dx
    xor dx, dx

    mov ah, 09h        
    mov dx, offset msg1       
    int 21h
    call outputNewLine
    
    pop dx
    pop ax

    ret
outputMessage1 ENDP

outputMessage2 PROC             ; Вивести перше повідомлення
    push ax
    xor ax, ax
    push dx
    xor dx, dx

    mov ah, 09h        
    mov dx, offset msg2       
    int 21h
    call outputNewLine

    pop dx
    pop ax

    ret
outputMessage2 ENDP

outputNewLine PROC              ; Нова стрічка
    push ax
    xor ax, ax
    push dx
    xor dx, dx

    mov dl, 0dh   
    mov ah, 02h
    int 21h
    mov dl, 0ah   
    int 21h

    pop dx
    pop ax

    ret
outputNewLine ENDP

outputCharacter PROC            ; Виводимо символ з `buffer` у консоль
    push ax
    xor ax, ax
    push dx
    xor dx, dx

    mov dl, buffer    
    mov ah, 02h
    int 21h

    pop dx
    pop ax
    ret
outputCharacter ENDP

outputStringsHandler PROC       ; Обробка виводу: якщо користувач нічого не ввів, і коли користувач щось ввів
    call outputMessage2
    mov cx, pointersSize
    cmp cx, 0
    je oneString
    jmp manyStrings

oneString:
    call outputNewLine
    jmp endOutput

manyStrings:
    call outputStrings

endOutput:
    ret
outputStringsHandler ENDP

outputStrings PROC              ; Виводимо усі стрічки
    shr cx, 1 
    dec cx                      ; передостанній

stringsLoop:
    mov bx, cx
    shl bx, 1
    mov si, [pointers + bx]     ; Встановлюємо на початок стрічки
loopString:
    mov al, [si]

    cmp al, '$'                 ; перевіряємо на кінець
    je endLoop

    mov buffer, al
    call outputCharacter        ; Виводимо символ
    inc si
    jmp loopString

endLoop:
    call outputNewLine          ; Нова стрічка
    loop stringsLoop

    mov bx, cx                  ; Опрацьовуємо останій елемент
    shl bx, 1
    mov si, [pointers + bx]

loopString2:
    mov al, [si]

    cmp al, '$'
    je endLoop2

    mov buffer, al
    call outputCharacter
    inc si
    jmp loopString2

endLoop2:
    call outputNewLine

    ret
outputStrings ENDP

readSymbol PROC                     ; Зчитуємо символ за допомогою 01h
    xor ax, ax
    mov ah, 01h
    int 21h
    ret
readSymbol ENDP

readStrings PROC                    ; Зчитуємо стріки
    push ax
    xor ax, ax
    push si
    xor si, si
    push di
    xor di, di
    push cx
    xor cx, cx
    push dx
    xor dx, dx

    mov cx, 20                      ; 20 разів

readLoop:
    call outputMessage1

    mov bx, offset strings          
    add bx, si
    mov [pointers + di], bx         ; Зберігаємо адресу нового рядка в pointers[di]
    add di, 2                       ; Наступний вказівник

readLine:
    call readSymbol

    cmp si, 0                      ; Обробка першого разу
    jne notException
    cmp al, 0Dh
    je finishRead

notException:
    cmp al, 0Dh                     ; Якщо не нова стрічка - продовжуємо зчитувати
    je endLine

    mov [strings + si], al
    inc si
    jmp readLine

endLine:
    mov [strings + si], '$'         ; Закінчуємо рядок символом '$'
    inc si

    add dx, 2                       ; counter
    loop readLoop

finishRead:
    mov pointersSize, dx

    pop dx 
    pop cx
    pop di
    pop si
    pop ax
    ret
readStrings ENDP

main PROC
    mov ax, @data     ; Ініціалізація сегмента даних
    mov ds, ax

    call readStrings            ; Зчитуємо стрічки
    call outputStringsHandler   ; Виводимо стрічки

    mov ax, 4c00h       ; завершуємо програму
    int 21h             ; завершуємо програму
main ENDP 
END main