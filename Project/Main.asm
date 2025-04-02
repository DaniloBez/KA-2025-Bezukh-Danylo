.model small
.stack 100h
.data
buffer db 0d
numbersArray dw 10000 dup(0d)
numElements dw 0d
sumResult dw 0d
sumRemainder dw 0d
isNegative db 0d
tempNumber db 0d
currentNumber db 6 dup(0d)
isOverLimit db 0d
temporaryValue dw 0d

.code
outputCharacter PROC            ; Виводимо символ з `buffer` у консоль
    push ax
    xor ax, ax
    push bx
    xor bx, bx
    push cx
    xor cx, cx
    push dx
    xor dx, dx

    mov dl, buffer    
    mov ah, 02h
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
outputCharacter ENDP

outputNewLine PROC              ; На нову стрічку
    mov dl, 0dh   
    mov ah, 02h
    int 21h
    mov dl, 0ah   
    mov ah, 02h
    int 21h
    ret
outputNewLine ENDP

handleOverflow PROC             ; обробка переповнення
    mov [isOverLimit], 0d
    mov [sumResult], 0d
    mov [tempNumber], 2d
    mov cx, 07FFFh
    xor bx, bx
    mov bl, isNegative
    cmp bl, 0d
    je endHandleOverflow
    inc cx
endHandleOverflow:
    mov [sumResult], cx
    ret
handleOverflow ENDP

readInput PROC                  ;прочитати 1 символ (зберігаєтся у buffer -> dl)
    mov [buffer], 0dh
    xor ax, ax
    mov ah, 3Fh
    mov bx, 0h  ; stdin handle
    mov cx, 1   ; 1 byte to read
    mov dx, offset buffer   ; read to ds:dx 
    int 21h   ;  ax = number of bytes read
    
    mov dl, buffer
    ret
readInput ENDP

parseNumber PROC                ; переведення в число (number * 10 + char.toNumber()) і перевірка на переповнення
    push ax
    mov ax, '0'
    sub dx, ax
    push dx
    xor dx, dx
    mov [tempNumber], 1d

    mov ax, [sumResult]
    mov bx, 10
    mul bx
    mov cx, ax
    jno noOverflow
    mov [isOverLimit], 1d

noOverflow: 
    pop dx
    pop ax
    ret
parseNumber ENDP

multiplyByTwo PROC              ; множимо bx на 2 (для індексів, або ділення)
    push ax
    push dx
    xor dx, dx

    mov ax, 2d
    mul bx
    mov bx, ax

    pop dx
    pop ax
    ret
multiplyByTwo ENDP

positiveNumberProcessor PROC    ; зберігаємо число, збільшуємо розмір на 1
    mov bx, numElements

    call multiplyByTwo

    mov [numbersArray + bx], cx
    mov bx, numElements
    inc bx
    mov [numElements], bx
    mov [sumResult], 0d
    ret
positiveNumberProcessor ENDP

readFile PROC                   ; Посимвольно зчитує файл і заповнює масив числами
    push ax
    xor ax, ax
    push bx
    xor bx, bx
    push cx
    xor cx, cx
    push dx
    xor dx, dx

readNext:
    call readInput              ; Зчитуємо символ, перевіряємо що це за символ

    cmp dl, '-'
    je processMinus

    cmp dl, 0dh
    je spaceHandling
    cmp dl, 0ah
    je spaceHandling
    cmp dl, ' '
    je spaceHandling

    mov cl, tempNumber          ; Якщо це число і ми не зчитали більше ніж максимум або мінімум - починаємо записувати число
    cmp cl, 2d
    je continueReading

    call parseNumber            ; конвертуємо `char` -> `int` 

    push bx                     ; перевіряємо на переповнення
    mov bl, [isOverLimit]
    cmp bl, 1d 
    pop bx
    je handleOverflowCase

    add cx, dx
    jo handleOverflowCase
    mov [sumResult], cx
    jmp continueReading


handleOverflowCase:             ; Якщо переповнення - запам'ятовуємо max/min
    call handleOverflow
    jmp continueReading

spaceHandling:                  ; Якщо це пробіл або нова сторінка, або кінець файлу - записуємо зчитане число (якщо воно є)
    xor bx, bx
    mov bl, [tempNumber]
    cmp bl, 0d
    jne rememberHandling
    jmp continueReading

rememberHandling:               ; запам'ятовуємо число (якщо негативне - перетворюємо)
    mov cx, [sumResult]
    xor bx, bx
    mov bl, [isNegative]
    cmp [isNegative], 0d
    je processPositiveNumber
    neg cx

processPositiveNumber:          ; ...запам'ятовуємо число
    mov [isNegative], 0d
    call positiveNumberProcessor
    mov [tempNumber], 0d
    jmp continueReading

processMinus:                   ; якщо символ `-` -> запам'ятовуємо це
    mov [isNegative], 1d
    jmp continueReading

continueReading:
    or ax, ax
    jnz readNext                ; якщо ще не кінець файлу - продовжуємо читати
 
    call outputNewLine          ; нова стрічка

    pop dx
    pop cx
    pop bx
    pop ax
    ret
readFile ENDP

outputNumber PROC               ; Виводимо число (спочатку розбираємо справа на ліво (%10 /10), а потім виводимо як треба)
    push si
    push ax
    xor ax, ax
    push bx
    xor bx, bx
    push cx
    xor cx, cx
    push dx
    xor dx, dx

    mov ax, sumResult
    mov bx, 10d
    mov si, 0d

    cmp ax, 0d         
    jge saveLoop

    neg ax
    mov [buffer], '-'           ; не забуваємо про -
    call outputCharacter

saveLoop:                       ; Розбираємо справа на ліво (%10 /10)
    xor dx, dx 
    div bx

    push ax
    mov ax, '0'
    add dx, ax
    mov [currentNumber + si], dl
    inc si
    pop ax

    cmp ax, 0d
    jne saveLoop

writeLoop:                      ; Виводимо посимвольно у правильному порядку
    dec si
    mov bl, [currentNumber + si]
    mov [buffer], bl
    call outputCharacter
    cmp si, 0d
    jne writeLoop

    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    ret
outputNumber ENDP

outputRemainder PROC            ; Виводимо залишок, перетворюючи у десяткове представлення (множачи на 10 і ділячи на дільник)
    push ax
    xor ax, ax
    push bx
    xor bx, bx
    push cx
    xor cx, cx
    push dx
    xor dx, dx

    mov ax, sumRemainder
    mov cx, 5d                  ; Обмеження знаків після коми

    cmp ax, 0d
    je exitRemainder
    mov [buffer], '.'
    call outputCharacter

    test ax, 08000h
    jz writeLoop2
    neg ax

writeLoop2:
    mov bx, 10d
    mul bx

    mov bx, numElements
    div bx

    push dx
    mov dx, '0'
    add ax, dx
    mov [buffer], al
    call outputCharacter
    pop dx

    dec cx

    cmp cx, 0d
    je exitRemainder

    mov ax, dx

    cmp ax, 0d
    jne writeLoop2

exitRemainder:

    pop dx
    pop cx
    pop bx
    pop ax
    ret
outputRemainder ENDP

divide32 PROC                   ; Ділення 32 бітового числа на 16 бітне
    push cx
    xor cx, cx
    mov [isNegative], 0d

    test dx, dx 
    jns divideLoop
    mov [isNegative], 1d
    neg dx
    dec dx
    neg ax

divideLoop:                     ; Віднімаємо поки число (dx:ax) > дільника (bx)
    cmp dx, 0
    jne notEnough
    cmp bx, ax
    ja noMoreSubtractions

notEnough:
    sub ax, bx
    sbb dx, 0
    inc cx
    jmp divideLoop

noMoreSubtractions:
    mov dx, ax
    mov ax, cx

    xor cx, cx
    mov cl, [isNegative]
    cmp cl, 1d
    jne notNegative
    neg ax
    neg dx

notNegative:
    pop cx
    ret

divide32 ENDP


outputAverage PROC              ; Знаходимо і виводимо середнє арефметичене
    push ax
    xor ax, ax
    push bx
    xor bx, bx
    push cx
    xor cx, cx
    push dx
    xor dx, dx

    mov [sumResult], ax
    mov [sumRemainder], ax

    mov cx, numElements
    mov si, 0d

averageLoop:                    ; Сумуємо усі числа, результат у dx:ax
    mov ax, [numbersArray + si]
    cwd                         ; Розширюємо знак

    add ax, sumResult
    adc dx, sumRemainder        ; Додаємо перенос

    mov [sumResult], ax
    mov [sumRemainder], dx

    add si, 2d
    loop averageLoop

    mov ax, sumResult
    mov dx, sumRemainder
    mov bx, numElements

    call divide32               ; Знаходимо середнє арефметичне, (ax - частка, dx - остача)

    mov [sumResult], ax
    call outputNumber

    mov [sumRemainder], dx
    call outputRemainder

    xor dx, dx
    xor ax, ax

    call outputNewLine

    pop dx
    pop cx
    pop bx
    pop ax
    ret
outputAverage ENDP

outputArray PROC                ; Допоміжний метод, виводить масив у консоль
    push ax
    xor ax, ax
    push bx
    xor bx, bx
    push cx
    xor cx, cx
    push dx
    xor dx, dx

    mov cx, numElements
    mov si, 0d
arrayLoop:
    mov ax, [numbersArray + si]
    mov [sumResult], ax
    call outputNumber

    xor dx, dx
    xor ax, ax

    mov dl, ' '
    mov ah, 02h
    int 21h

    add si, 2d
    loop arrayLoop

    xor dx, dx
    xor ax, ax

    call outputNewLine

    pop dx
    pop cx
    pop bx
    pop ax
    ret
outputArray ENDP

outputMedian PROC               ; Знаходимо і виводими медіану
    push ax
    push bx
    push cx
    push dx

    xor dx, dx
    xor ax, ax
    xor bx, bx
    xor cx, cx

    mov cx, [numElements]
    mov bx, cx
    shr bx, 1                   ; Ділимо кількість елементів на 2 (для знаходження середнього)

    test cx, 1                  ; Перевіряємо парність кількості елементів
    jz evenCase

oddCase:                        ; Непарна кількість елементів, беремо середній елемент
    shl bx, 1
    mov ax, [numbersArray + bx]
    mov [sumResult], ax
    call outputNumber
    jmp endMedian

evenCase:                       ; Парна кількість елементів, беремо середнє арифметичне двох центральних
    mov si, bx
    dec si                      ; Попередній елемент
    shl si, 1                   ; Бітовий зсув (/ 2)
    mov ax, [numbersArray + si]
    cwd

    shl bx, 1
    add ax, [numbersArray + bx]

    mov bx, 2
    idiv bx                     ; Ділимо і видовимо

    mov [sumResult], ax
    call outputNumber

    mov [sumRemainder], dx
    call outputRemainder

endMedian:
    call outputNewLine
    pop dx
    pop cx
    pop bx
    pop ax
    ret
outputMedian ENDP

swapNumbers PROC                ; Міняємо 2 елементи місцями
    mov [temporaryValue], dx
    mov dx, bx
    mov bx, temporaryValue

    ret
swapNumbers ENDP

sortArray PROC                  ; Сортуємо масив
    push ax
    xor ax, ax
    push bx
    xor bx, bx
    push cx
    xor cx, cx
    push dx
    xor dx, dx

    mov ax, 0d      ;i
    mov cx, 0d      ;j

fori:
    forj:
    mov bx, ax
    call multiplyByTwo
    mov si, bx
    mov dx, [numbersArray + si]    ;array[i]

    mov bx, cx
    call multiplyByTwo
    mov si, bx
    mov bx, [numbersArray + si]    ;array[j]

    cmp dx, bx
    jge dontSwap
    jmp swap

swap:
    mov [temporaryValue], bx
    mov bx, cx
    call multiplyByTwo
    mov si, bx
    mov [numbersArray + si], dx

    mov dx, [temporaryValue]
    mov bx, ax
    call multiplyByTwo
    mov si, bx
    mov [numbersArray + si], dx

dontSwap:
    inc cx
    mov bx, numElements
    cmp bx, cx
    jne forj

    mov cx, 0
    inc ax
    mov bx, numElements
    cmp bx, ax
    jne fori

    call outputNewLine
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
sortArray ENDP

main PROC               ; Головна програма, запускаємо усі процедури
    mov ax, @Data
    mov ds, ax

    call readFile
    call outputArray

    call sortArray
    call outputArray

    call outputMedian
    call outputAverage

    mov ax, 4c00h       ; завершуємо програму
    int 21h             ; завершуємо програму
main ENDP
END main

