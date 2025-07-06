; ------------------------------------------------------------
; Win32 NASM Example: Print "Hello, World!" to console
; Uses WinAPI: GetStdHandle, WriteFile, ExitProcess
; ------------------------------------------------------------

global _main

extern _GetStdHandle@4       ; Imports: HANDLE GetStdHandle(DWORD)
extern _WriteFile@20         ; Imports: BOOL WriteFile(...)
extern _ExitProcess@4        ; Imports: VOID ExitProcess(UINT)

section .data
    message db 'Hello, World!', 13, 10     ; Message to print (includes CR+LF for newline)
    message_len equ $ - message            ; Calculate message length

section .bss
    bytes_written resd 1    ; Reserve 4 bytes (DWORD) to store number of bytes actually written by WriteFile
    hOut resd 1   ; Reserve 4 bytes to store the handle returned by GetStdHandle (console output handle)

section .text
_main:
    ; Get handle to standard output (STD_OUTPUT_HANDLE = -11)
    push -11
    call _GetStdHandle@4
    mov [hOut], eax                    ; Save handle in hOut

    ; Call WriteFile(
    ;     hFile = hOut,
    ;     lpBuffer = message,
    ;     nNumberOfBytesToWrite = message_len,
    ;     lpNumberOfBytesWritten = &bytes_written,
    ;     lpOverlapped = 0
    ; )
    push 0                             ; lpOverlapped = NULL
    mov eax, bytes_written
    push eax                           ; lpNumberOfBytesWritten
    push message_len                   ; nNumberOfBytesToWrite
    push message                       ; lpBuffer
    mov eax, [hOut]
    push eax                           ; hFile
    call _WriteFile@20                 ; Call WriteFile

    ; Exit the process with code 0
    push 0
    call _ExitProcess@4
