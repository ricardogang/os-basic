bits 16
org 0x7e00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

menu_loop:
    mov si, menu_text
    call print_string

    call read_key

    cmp al, '1'
    je option_get_number
    cmp al, '2'
    je option_clear_screen
    cmp al, '3'
    je option_reset
    cmp al, '4'
    je option_exit

    mov si, invalid_text
    call print_string
    jmp menu_loop

option_get_number:
    mov si, prompt_number
    call print_string

    call read_key
    mov ah, 0x0e
    mov bh, 0
    int 0x10

    mov si, entered_text
    call print_string
    mov ah, 0x0e
    mov bh, 0
    int 0x10

    mov si, crlf
    call print_string
    jmp menu_loop

option_clear_screen:
    call clear_screen
    jmp menu_loop

option_reset:
    int 0x19
    jmp menu_loop

option_exit:
    mov si, exit_text
    call print_string
.halt:
    cli
    hlt
    jmp .halt

print_string:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0e
    mov bh, 0
    int 0x10
    jmp print_string
.done:
    ret

read_key:
    mov ah, 0x00
    int 0x16
    ret

clear_screen:
    mov ax, 0x0003
    int 0x10
    ret

menu_text: db 13,10, "OPCIONES", 13,10
           db "1) Digite numero", 13,10
           db "2) Limpiar pantalla", 13,10
           db "3) Reiniciar", 13,10
           db "4) Salir", 13,10
           db "Seleccione (1-4): ", 0

prompt_number: db 13,10, "Escriba un digito (0-9): ", 0
entered_text:  db 13,10, "Ingreso: ", 0
invalid_text:  db 13,10, "Opcion no valida.", 13,10, 0
exit_text:     db 13,10, "Gracias!", 13,10, 0
crlf:          db 13,10, 0

times 512 - ($ - $$) db 0
