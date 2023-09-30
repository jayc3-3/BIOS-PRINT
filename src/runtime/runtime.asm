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
mov al, 5
mov byte[console_cursory], al
mov bx, runtime_message
call console_print
call console_print.newline

call console_print.newline
mov bx, version_message
call console_print
call console_print.newline
mov bx, 0x7DDF
call console_print
call console_print.newline
mov bx, runtime_version
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

cmp al, 8
je .backspace

cmp al, 13
je .newline

mov bx, 0x9001
mov byte[bx], 0
dec bx
mov byte[bx], al
call console_print

.no_keypress:
jmp input_loop

.backspace:
jmp input_loop

.newline:
xor bh, bh
mov bl, byte[console_cursory]
inc bl
cmp bl, 30
je .newline_no

.newline_done:
mov byte[console_cursorx], bh
mov byte[console_cursory], bl
jmp input_loop

.newline_no:
dec bl
jmp .newline_done

runtime_message: db "Started BIOS-PRINT runtime", 0
version_message: db "Version information:", 0
runtime_version: db "BIOS-PRINT runtime    rev. 001", 0
input_message:   db "Keyboard input enabled; type away!", 0

%include "src/function/console.asm"
%include "src/runtime/keyboard.asm"

times 2048 - ($ - runtime) db 0