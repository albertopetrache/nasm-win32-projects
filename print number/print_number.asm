global _main

extern _GetStdHandle@4       ; Import: HANDLE GetStdHandle(DWORD nStdHandle)
extern _WriteFile@20         ; Import: BOOL WriteFile(...)
extern _ExitProcess@4        ; Import: VOID ExitProcess(UINT uExitCode)

section .data
    msg db "The number is: "         ; Message prefix to print before the number
    msg_len equ $ - msg              ; Calculate length of the message
    x dd 98766342                    ; 32-bit number (DWORD) to convert to string
    lungime_buffer dd 0              ; Variable to hold length of converted number string

section .bss
    bytes_written resd 1           ; Reserve space (10 DWORDs = 40 bytes) for bytes written variable (over-allocated)
    hOut resd 1                    ; Reserve space for output handle (over-allocated)
    buffer resd 10                 ; Reserve 40 bytes buffer (10 DWORDS) to store the number as string (digits)

section .text
_main:
    ; Get handle to standard output (console)
    push -11                       ; STD_OUTPUT_HANDLE = -11
    call _GetStdHandle@4
    mov [hOut], eax                ; Store handle in hOut

    ; Write the initial message "The number is: "
    push 0                        ; lpOverlapped = NULL
    mov eax, bytes_written
    push eax                      ; lpNumberOfBytesWritten
    push msg_len                  ; nNumberOfBytesToWrite
    push msg                      ; lpBuffer (message)
    mov eax, [hOut]
    push eax                      ; hFile (console output handle)
    call _WriteFile@20            ; Write the message to console

    ; Convert the 64-bit number x to string in buffer (in reverse order)
    mov esi, buffer               ; ESI points to start of buffer
    mov eax, [x]                  

add_in_buffer:
    xor edx, edx                 ; Clear EDX before division
    mov ebx, 10                  ; Divisor 10 (for decimal digits)
    div ebx                      ; Divide EDX:EAX by 10, quotient in EAX, remainder in EDX
    add dl, '0'                  ; Convert remainder (digit) to ASCII character
    mov [esi], dl                ; Store digit character in buffer
    inc esi                      ; Move to next position in buffer
    inc dword [lungime_buffer]   ; Increment length of buffer
    test eax, eax                ; Check if quotient (EAX) is zero
    jnz add_in_buffer            ; If not zero, continue dividing next digit

    ; Reverse the string in buffer to correct the digit order
    mov esi, 0                   ; Index start = 0
    mov edi, [lungime_buffer]    ; Index end = length of number string
    dec edi                      ; Adjust for zero-based index

reverse:
    mov al, [buffer + esi]       ; Load byte from start
    mov bl, [buffer + edi]       ; Load byte from end
    mov [buffer + esi], bl       ; Swap bytes
    mov [buffer + edi], al
    inc esi                      ; Move start forward
    dec edi                      ; Move end backward
    cmp esi, edi                 ; Compare indices
    jnge reverse                 ; Loop until indices cross

    ; Write the converted number string to console
    push 0                       ; lpOverlapped = NULL
    mov eax, bytes_written
    push eax                     ; lpNumberOfBytesWritten
    mov eax, [lungime_buffer]
    push eax                     ; nNumberOfBytesToWrite = length of number string
    push buffer                  ; lpBuffer = number string buffer
    mov eax, [hOut]
    push eax                     ; hFile = console output handle
    call _WriteFile@20           ; Write number string to console

    ; Exit process cleanly with exit code 0
    push 0
    call _ExitProcess@4
