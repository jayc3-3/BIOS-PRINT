;
; BIOS-PRINT
; Simple 'Operating System' that just lets you input text on a screen.
;
; https://github.com/jayc3-3/BIOS-PRINT
; Free for use and/or modification
;

;
; runtime.asm
; The BIOS-PRINT runtime
;

org 0x7E00
bits 16

runtime:
mov al, 1
mov byte[console_cursory], al
mov bx, runtime_message
call console_print
call console_print.newline

call console_print.newline
mov bx, version_message
call console_print
call console_print.newline
mov bx, 0x7DDF ; Address of bootloader 'version_message' string
call console_print
call console_print.newline
mov bx, runtime_version
call console_print
call console_print.newline
mov bx, 0x7DC0 ; Address of bootloader 'version_message' string
call console_print
call console_print.newline
mov bx, date_message
call console_print
call console_print.newline

call console_print.newline
mov bx, owner_message
call console_print
call console_print.newline
mov bx, github_message
call console_print
call console_print.newline

call keyboard_init

call console_print.newline

mov bx, reboot_notice
call console_print
call console_print.newline
mov bx, input_notice
call console_print
call console_print.newline
mov bx, input_message
call console_print
call console_print.newline

input_loop:
call keyboard_read
cmp al, 0
je .no_keypress

cmp al, 18
je reboot

call print_input

.no_keypress:

jmp input_loop

reboot:
jmp 0xFFFF:0

times 4096 - ($ - runtime) db 0

data:

runtime_message: db "Started runtime", 0
version_message: db "Version information:", 0
runtime_version: db "BIOS-PRINT runtime    rev. 001", 0
input_notice:    db "Press CTRL+Backspace to delete current line", 0
reboot_notice:   db "Press CTRL+R to reboot", 0
input_message:   db "Keyboard input enabled; type away!", 0
owner_message:   db "BIOS-PRINT made by JayC3-3", 0
github_message:  db "https://github.com/jayc3-3/BIOS-PRINT", 0
date_message:    db "Runtime dated    Sep. 30, 2023", 0

line_string: db "                                                                                ", 0

times 4096 - ($ - data) db 0

functions:

print_input:
push ax
push bx

cmp al, 8
je .backspace

cmp al, 9
je .tab

cmp al, 13
je .newline

cmp al, 127
je .empty_line

cmp al, 32
jl .done

mov bx, 0x2000
mov byte[bx], al
mov byte[bx+1], 0
call console_print

jmp .done

.backspace:
mov ah, byte[console_cursorx]
mov al, byte[console_cursory]

dec ah

cmp ah, -1
je .backspace_dec_y
mov byte[console_cursorx], ah

mov bx, 0x2000
mov byte[bx], 0x20
mov byte[bx+1], 0
call console_print

mov byte[console_cursorx], ah

jmp .done

.backspace_dec_y:
mov byte[console_cursorx], ah

mov bx, 0x2000
mov byte[bx], 0x20
mov byte[bx+1], 0
call console_print

mov byte[console_cursorx], ah

mov ah, 79
dec al

cmp al, -1
je .backspace_inc_y

mov byte[console_cursorx], ah
mov byte[console_cursory], al

mov bx, 0x2000
mov byte[bx], 0x20
mov byte[bx+1], 0
call console_print

mov byte[console_cursorx], ah
mov byte[console_cursory], al

jmp .done

.backspace_inc_y:
xor ah, ah
inc al
mov byte[console_cursorx], ah
mov byte[console_cursory], al

mov bx, 0x2000
mov byte[bx], 0x20
mov byte[bx+1], 0
call console_print

mov byte[console_cursorx], ah
mov byte[console_cursory], al

jmp .done

.tab:
mov bx, 0x2000
mov byte[bx], 0x20
mov byte[bx+1], 0
call console_print
call console_print
call console_print
call console_print

jmp .done

.newline:
xor bh, bh
mov bl, byte[console_cursory]
inc bl
cmp bl, 30
je .newline_no

.newline_done:
mov byte[console_cursorx], bh
mov byte[console_cursory], bl

jmp .done

.newline_no:
dec bl
jmp .newline_done

.empty_line:
xor bh, bh
mov byte[console_cursorx], bh

mov bx, line_string
call console_print

mov bh, byte[console_cursory]
dec bh
cmp bh, -2
je .empty_line_inc_y

mov byte[console_cursory], bh

jmp .done

.empty_line_inc_y:
inc bh
mov byte[console_cursory], bh

jmp .done

.done:
pop bx
pop ax
ret

%include "src/function/console.asm"
%include "src/runtime/keyboard.asm"

times 8192 - ($ - functions) db 0
