;
; BIOS-PRINT
; Simple OS that just lets you type on a screen.
;
; https://github.com/jayc3-3/BIOS-PRINT
; Free for use and/or modification
;

;
; runtime.asm
; The BIOS-PRINT runtime
;

org 0x8000
bits 16

runtime:
mov al, 3
mov byte[console_cursory], al
mov bx, runtime_message
call console_print

mov bx, date_message
call console_print

call console_print.newline
mov bx, owner_message
call console_print
mov bx, github_message
call console_print

call keyboard_init

call console_print.newline
mov bx, reboot_notice
call console_print
mov bx, input_notice
call console_print
mov bx, input_message
call console_print

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

runtime_message: db "Started BIOS-PRINT rev. 003", 0
input_notice:    db "Press 'CTRL+Backspace' to delete current line", 0
reboot_notice:   db "Press 'CTRL+R' to reboot", 0
input_message:   db "Keyboard input enabled; type away!", 0
owner_message:   db "BIOS-PRINT made by JayC3-3", 0
github_message:  db "https://github.com/jayc3-3/BIOS-PRINT", 0
date_message:    db "Software dated Oct. 1, 2023", 0

line_string: db "                                                                                ", 0

%include "src/console.asm"
%include "src/keyboard.asm"

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
mov ax, 0x8A1F
call console_print

jmp .done

.backspace:
mov ah, byte[console_cursorx]
mov al, byte[console_cursory]

dec ah

cmp ah, -1
je .backspace_dec_y
mov byte[console_cursorx], ah

push ax
mov bx, 0x2000
mov byte[bx], 0x20
mov byte[bx+1], 0
mov ax, 0x8A1F
call console_print
pop ax

mov byte[console_cursorx], ah

jmp .done

.backspace_dec_y:
mov byte[console_cursorx], ah

push ax
mov bx, 0x2000
mov byte[bx], 0x20
mov byte[bx+1], 0
mov ax, 0x8A1F
call console_print
pop ax

mov byte[console_cursorx], ah

mov ah, 79
dec al

cmp al, -1
je .backspace_inc_y

mov byte[console_cursorx], ah
mov byte[console_cursory], al

push ax
mov bx, 0x2000
mov byte[bx], 0x20
mov byte[bx+1], 0
mov ax, 0x8A1F
call console_print
pop ax

mov byte[console_cursorx], ah
mov byte[console_cursory], al

jmp .done

.backspace_inc_y:
xor ah, ah
inc al
mov byte[console_cursorx], ah
mov byte[console_cursory], al

push ax
mov bx, 0x2000
mov byte[bx], 0x20
mov byte[bx+1], 0
mov ax, 0x8A1F
call console_print
pop ax

mov byte[console_cursorx], ah
mov byte[console_cursory], al

jmp .done

.tab:
push ax
mov bx, 0x2000
mov byte[bx], 0x20
mov byte[bx+1], 0
mov ax, 0x8A1F
call console_print
call console_print
call console_print
call console_print
pop ax

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
push ax
mov ax, 0x8A1F
call console_print
pop ax

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

times 16384 - ($ - runtime) db 0