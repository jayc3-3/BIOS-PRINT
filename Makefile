ASM = nasm

ASMFLAGS = -Ox -f bin
BINFILES = bootloader.bin runtime.bin

COMPNAME = BIOS-PRINT

all: complete

clean:
	rm *.bin

complete: bootloader runtime
	cat ${BINFILES} > ${COMPNAME}.bin

combine:
	cat ${BINFILES} > ${COMPNAME}.bin

bootloader: src/boot/boot.asm
	${ASM} $< -o $@.bin ${ASMFLAGS}

runtime: src/runtime/runtime.asm
	${ASM} $< -o $@.bin ${ASMFLAGS}