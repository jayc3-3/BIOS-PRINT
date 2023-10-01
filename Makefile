ASM = nasm

ASMFLAGS = -Ox -f bin
BINFILES = BIOS-BOOTLOADER.bin runtime.bin

COMPNAME = BIOS-PRINT

all: complete

clean:
	rm ${COMPNAME}.bin

complete: runtime
	cat ${BINFILES} > ${COMPNAME}.bin

runtime: src/runtime.asm
	${ASM} $< -o $@.bin ${ASMFLAGS}