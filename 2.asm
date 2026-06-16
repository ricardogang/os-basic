bits 16
org 0x7c00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    mov [boot_drive], dl

    mov ah, 0x02
    mov al, 0x01
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    mov dl, [boot_drive]
    mov bx, 0x7e00
    int 0x13
    jc disk_error

    jmp 0x0000:0x7e00

disk_error:
    mov si, disk_error_text
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

boot_drive: db 0
disk_error_text: db 13,10, "Disk read error.", 13,10, 0

times 510 - ($ - $$) db 0
dw 0xaa55
