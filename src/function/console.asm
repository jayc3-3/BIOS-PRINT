;
; BIOS-PRINT
; Simple 'Operating System' that just lets you input text on a screen.
;
; https://github.com/jayc3-3/BIOS-PRINT
; Free for use and/or modification
;

;
; console.asm
; Simple console interface built upon screen.asm
;

%ifndef CONSOLE_ASM
%define CONSOLE_ASM 1

console_cursorx: db 0
console_cursory: db 0

%include "src/function/screen.asm"

console_init: ; No input; No output
call screen_init
call console_clear

ret

console_clear: ; No input; No output
pusha

mov ah, 6
xor al, al
mov bh, 0xF0
xor bl, bl
xor cx, cx
mov dx, 0x1E50
int 0x10

call screen_set_cursor

mov byte[console_cursorx], ch
mov byte[console_cursory], cl

popa
ret

console_print: ; Input: BX = Pointer to string; No output
push ax
push bx
push cx
push dx

mov dh, byte[console_cursorx]
mov dl, byte[console_cursory]

.loop:
mov al, byte[bx]
cmp al, 0
je .done

cmp dh, 80
je .loop_sety

.loop_return:

cmp dl, 30
je .done

mov cx, dx
call screen_putc

inc bx
inc dh
jmp .loop

.loop_sety:
xor dh, dh
inc dl
jmp .loop_return

.done:
mov cx, dx
call screen_set_cursor

mov byte[console_cursorx], dh
mov byte[console_cursory], dl

pop dx
pop cx
pop bx
pop ax
ret

.newline:
push ax
push cx

mov ah, byte[console_cursorx]
mov al, byte[console_cursory]

xor ah, ah
inc al

cmp al, 30
je .newline_y_overflow

mov cx, ax
call screen_set_cursor

.newline_done:
mov byte[console_cursorx], ah
mov byte[console_cursory], al

pop cx
pop ax
ret

.newline_y_overflow:
xor al, al
call console_clear

jmp .newline_done

%endif