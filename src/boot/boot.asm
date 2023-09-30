;
; BIOS-PRINT
; Simple 'Operating System' that just lets you input text on a screen.
;
; https://github.com/jayc3-3/BIOS-PRINT
; Free for use and/or modification
;

;
; boot.asm
; The BIOS-PRINT bootloader
;

org 0x7C00
bits 16

boot:
cld
cli

jmp 0:reload_cs

reload_cs:
xor ax, ax
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

mov byte[boot_drive], dl

mov bp, 0x7C00
mov sp, bp
sti

call console_init

mov bx, boot_message
call console_print
call console_print.newline

mov dl, byte[boot_drive]
call disk_reset
jc disk_error

mov ax, 1
mov bx, 0x7E00
mov cl, 4
mov dl, byte[boot_drive]
call disk_read
jc disk_error

jmp 0x7E00

disk_error:
mov bx, disk_message
call console_print
call console_print.newline
jmp $

boot_drive: db 0
boot_message: db "Started BIOS-PRINT bootloader", 0
disk_message: db "Disk error", 0

%include "src/function/console.asm"
%include "src/boot/disk.asm"

times 479 - ($ - boot) db 0
version_message: db "BIOS-PRINT bootloader rev. 001", 0
dw 0xAA55