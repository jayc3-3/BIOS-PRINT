;
; BIOS-PRINT
; Simple 'Operating System' that just lets you input text on a screen.
;
; https://github.com/jayc3-3/BIOS-PRINT
; Free for use and/or modification
;

;
; keyboard.asm
; Simple INT 16h keyboard functions
;

keyboard_init: ; No input; No output
push ax
push bx

mov ah, 3
mov al, 5
mov bh, 2
mov bl, 0xA
int 0x16

pop bx
pop ax
ret

keyboard_read: ; No input; Output: AH = Key scancode, AL = ASCII value of pressed key (zero if none)
mov ah, 1
int 0x16
jnz .input

xor ax, ax

.done:
ret

.input:
xor ah, ah
int 0x16

jmp .done