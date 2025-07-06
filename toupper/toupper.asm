global _main

extern _GetStdHandle@4       ; Import: HANDLE GetStdHandle(DWORD nStdHandle)
extern _WriteFile@20         ; Import: BOOL WriteFile(...)
extern _ExitProcess@4        ; Import: VOID ExitProcess(UINT uExitCode)

section .data
    msg db "Hello, World!", 13, 10    ; Message to convert and print (includes CR + LF for newline)
    msg_len equ $ - msg               ; Calculate length of message

section .bss
    bytes_written resd 1             ; Reserve space to store number of bytes written
    hOut resd 1                      ; Reserve space for console output handle

section .text
_main:
    ; Get handle to standard output (console)
    push -11                         ; STD_OUTPUT_HANDLE = -11
    call _GetStdHandle@4
    mov [hOut], eax                  ; Store the handle in hOut

    ; Convert message to uppercase (in-place)
    mov esi, msg                     ; ESI points to start of message
    mov ecx, msg_len                 ; ECX holds the number of characters to process

convert:
    mov al, [esi]                    ; Load current character from [ESI] into AL
    cmp al, 'a'                      ; Check if char is below lowercase 'a'
    jb no_change                     ; If less, skip (not lowercase)
    cmp al, 'z'                      ; Check if char is above lowercase 'z'
    ja no_change                     ; If more, skip (not lowercase)
    sub al, 32                       ; Convert lowercase to uppercase by subtracting 32 (ASCII diff)

no_change:
    mov [esi], al                    ; Write back the (possibly converted) character
    inc esi                          ; Move to next character
    dec ecx                          ; Decrement counter
    cmp ecx, 0                       ; Are we done?
    jnz convert                      ; If not zero, repeat loop

    ; Call WriteFile to print the (modified) message
    push 0                           ; lpOverlapped = NULL
    mov eax, bytes_written
    push eax                         ; lpNumberOfBytesWritten
    push msg_len                     ; nNumberOfBytesToWrite
    push msg                         ; lpBuffer (now uppercase)
    mov eax, [hOut]
    push eax                         ; hFile (console output)
    call _WriteFile@20               ; Call WriteFile

    ; Exit program
    push 0
    call _ExitProcess@4
