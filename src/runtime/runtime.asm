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

call console_print.newline
mov bx, owner_message
call console_print
call console_print.newline
mov bx, github_message
call console_print
call console_print.newline

call keyboard_init

call console_print.newline
mov bx, input_message
call console_print
call console_print.newline

input_loop:
call keyboard_read
cmp al, 0
je .no_keypress

call print_input

.no_keypress:

jmp input_loop

times 512 - ($ - runtime) db 0

data:

runtime_message: db "Started runtime", 0
version_message: db "Version information:", 0
runtime_version: db "BIOS-PRINT runtime    rev. 001", 0
input_message:   db "Keyboard input enabled; type away!", 0
owner_message:   db "BIOS-PRINT made by JayC3-3", 0
github_message:  db "https://github.com/jayc3-3/BIOS-PRINT", 0

%include "src/function/console.asm"
%include "src/runtime/keyboard.asm"

times 512 - ($ - data) db 0

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

mov bx, 0x9000
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

mov bx, 0x9000
mov byte[bx], 0x20
mov byte[bx+1], 0
call console_print

mov byte[console_cursorx], ah

jmp .done

.backspace_dec_y:
mov byte[console_cursorx], ah

mov bx, 0x9000
mov byte[bx], 0x20
mov byte[bx+1], 0
call console_print

mov byte[console_cursorx], ah

mov ah, 79
dec al

mov byte[console_cursorx], ah
mov byte[console_cursory], al

mov bx, 0x9000
mov byte[bx], 0x20
mov byte[bx+1], 0
call console_print

mov byte[console_cursorx], ah
mov byte[console_cursory], al

jmp .done

.tab:
mov bx, 0x9000
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

.done:
pop bx
pop ax
ret

times 512 - ($ - functions) db 0