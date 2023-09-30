;
; BIOS-PRINT
; Simple 'Operating System' that just lets you input text on a screen.
;
; https://github.com/jayc3-3/BIOS-PRINT
; Free for use and/or modification
;

;
; disk.asm
; Simple INT 13h disk functions
;

%ifndef DISK_ASM
%define DISK_ASM 1

disk_reset: ; Input: DL = Drive; Output: Carry Flag = Set on error
push ax
clc

xor ah, ah
int 0x13
jc .error
cmp ah, 0
jne .error

.done:
pop ax
ret

.error:
stc
jmp .done

disk_read: ; Input: AX = LBA, CL = Sectors to read, DL = Drive; Output: [ES:BX] = Data read from disk, Carry Flag = Set on error
push ax
push bx
push cx
push dx
push bx
clc

mov bl, cl

mov byte[.drive], dl
xor dx, dx

push ax
mov al, 63
mov cl, 16
mul cl
mov cx, ax
pop ax

push ax
xor dx, dx
div cx
and ax, 1023
mov word[.cylinder], ax
pop ax

push ax
mov cl, 63
div cl
xor ah, ah

mov cl, 16
div cl

mov al, ah
mov byte[.head], al
pop ax

push ax
mov cl, 63
div cl
shr ax, 8
inc ax

and ax, 63
mov byte[.sector], al
pop ax

mov dl, bl
pop bx
push dx
mov ah, 2
mov al, dl
mov cx, word[.cylinder]
shl cx, 8
mov cl, byte[.sector]
mov dh, byte[.head]
mov dl, byte[.drive]
int 0x13
jc .error
cmp ah, 0
jne .error
pop dx
cmp al, dl
jne .error

.done:
pop dx
pop cx
pop bx
pop ax
ret

.error:
stc
jmp .done

.cylinder: dw 0
.head:     db 0
.sector:   db 0
.drive:    db 0

%endif