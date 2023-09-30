;
; BIOS-PRINT
; Simple 'Operating System' that just lets you input text on a screen.
;
; https://github.com/jayc3-3/BIOS-PRINT
; Free for use and/or modification
;

;
; screen.asm
; Simple screen-related functions
;

%ifndef SCREEN_ASM
%define SCREEN_ASM 1

screen_init: ; No input; No output
pusha

xor ah, ah
mov al, 0x12
int 0x10

mov ah, 5
xor al, al
int 0x10

xor cx, cx
call screen_set_cursor

popa
ret

screen_putc: ; Input: AL = ASCII character, CH = Cursor X, CL = Cursor Y; No output
push ax
push bx
push cx

call screen_set_cursor

mov ah, 9
xor bh, bh
mov bl, 0x0F
mov cx, 1
int 0x10

pop cx
pop bx
pop ax
ret

screen_set_cursor: ; Input: CH = Cursor X, CL = Cursor Y; No output
push ax
push bx
push dx

mov ah, 2
xor bh, bh
mov dx, cx
ror dx, 8
int 0x10

pop dx
pop bx
pop ax
ret

%endif