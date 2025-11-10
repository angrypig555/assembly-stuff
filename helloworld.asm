
global _start

section .bss
    buffer resb 2        ; 1 char + newline
    favnumbuffer resb 2
    favnum2buffer resb 2
    favnumres resb 3
    answer resb 2
    pidbuf resb 12
    trash resb 1

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
    mov edx, 1
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, trash
    mov edx, 1
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

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt4
    mov edx, prompt4_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, favnum2buffer
    mov edx, 1
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, trash
    mov edx, 1
    int 0x80

    mov byte [favnumres], 0
    mov al, [favnumbuffer]
    sub al, '0'
    mov bl, [favnum2buffer]
    sub bl, '0'
    movzx eax, al
    movzx ebx, bl
    sub eax, ebx

    cmp eax, 0
    jge .positive
        neg eax
        mov byte [favnumres], '-'
        mov esi, favnumres + 1
        jmp .convert_digit
    .positive:
        mov esi, favnumres
    .convert_digit:
        add al, '0'
        mov [esi], al

    mov eax, 4
    mov ebx, 1
    mov ecx, favnumres
    cmp byte [favnumres], '-'
    jne .positive_only
    mov edx, 2
    jmp .write
    .positive_only:
    mov edx, 1
    .write:
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, substracted
    mov edx, substracted_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, message4
    mov edx, message4_length
    int 0x80

    mov eax, 0x14
    int 0x80

    ; Convert PID to string
    mov ecx, pidbuf + 11
    mov byte [ecx], 10
    dec ecx
    mov ebx, 10

.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    dec ecx
    test eax, eax
    jnz .convert
    inc ecx

    mov eax, 4
    mov ebx, 1
    mov edx, pidbuf + 12
    sub edx, ecx
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

    mov eax, 4
    mov ebx, 1
    mov ecx, exitmsg
    mov edx, exitmsg_length
    int 0x80

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

    mov eax, 4
    mov ebx, 1
    mov ecx, exitmsg
    mov edx, exitmsg_length
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
    favnum2 db " is your second favourite number.", 0xA
    favnum2_len equ $ - favnum2
    substracted db " is your 2 favourite numbers substracted", 0xA
    substracted_len equ $ - substracted
    message3: db "i will now create a directory /tmp/helloworldtestdir", 0xA
    message3_length equ $ - message3
    prompt3 db "Delete? (y/n): ", 0xA
    prompt3_len equ $ - prompt3
    deleteyn db "Deleting directory", 0xA
    deleteyn_length equ $ - deleteyn
    exitmsg db "Exiting", 0xA
    exitmsg_length equ $ - exitmsg
    message4: db "My procces id is", 0xA
    message4_length equ $ - message4
    prompt4 db "What is your second favourite number?", 0xA
    prompt4_len equ $ - prompt4


    dirname db "/tmp/helloworldtestdir", 0
    mode equ 0o755
