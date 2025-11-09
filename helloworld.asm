
global _start

section .bss
    buffer resb 2        ; 1 char + newline
    favnumbuffer resb 3
    answer resb 2

section .text:

_start:
    mov eax, 0x4
    mov ebx, 1
    mov ecx, message
    mov edx, message_length
    int 0x80

    mov eax, 0x4
    mov ebx, 1
    mov ecx, message2
    mov edx, message2_length
    int 0x80
    
    mov eax, 4           ; sys_write
    mov ebx, 1           ; file descriptor: stdout
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Read one line (until Enter)
    mov eax, 3           ; sys_read
    mov ebx, 0           ; file descriptor: stdin
    mov ecx, buffer
    mov edx, 2           ; read up to 2 bytes (1 char + newline)
    int 0x80

    mov eax, 0x4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, prompt2_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, favnumbuffer
    mov edx, 2
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, favnumbuffer
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, favnum
    mov edx, favnum_len
    int 0x80



    mov eax, 39
    mov ebx, dirname
    mov ecx, mode
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, message3
    mov edx, message3_length
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt3
    mov edx, prompt3_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, answer
    mov edx, 2
    int 0x80

    mov al, [answer]
    cmp al, 'y'
    je yes
    cmp al, 'Y'
    je yes

    mov eax, 0x1
    mov ebx, 0
    int 0x80

yes:
    mov eax, 40
    mov ebx, dirname
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, deleteyn
    mov edx, deleteyn_length
    int 0x80

    mov eax, 0x1
    mov ebx, 0
    int 0x80

section .data:
    message: db "Hello, World!", 0xA
    message_length equ $ - message
    message2: db "I am running in assembly!", 0xA
    message2_length equ $ - message2
    prompt db "Press Enter to continue...", 0Ah
    prompt_len equ $ - prompt
    prompt2 db "What is your favorite number (0-9)? ", 0xA
    prompt2_len equ $ - prompt2
    favnum db " is your favourite number.", 0xA
    favnum_len equ $ - favnum
    message3: db "i will now create a directory /tmp/helloworldtestdir", 0xA
    message3_length equ $ - message3
    prompt3 db "Delete? (y/n): ", 0xA
    prompt3_len equ $ - prompt3
    deleteyn db "Deleting directory and exiting", 0xA
    deleteyn_length equ $ - deleteyn

    dirname db "/tmp/helloworldtestdir", 0
    mode equ 0o755
