

all: pascal51.asm

pascal51.asm: pascal51_kcc.bin p51.block p51.sym
	@z80dasm -a -b p51.block -g 0x200 -l -S p51.sym -t -u -o pascal51.asm pascal51_kcc.bin

pascal51_kcc.bin: pascal51.kcc
	@dd if=pascal51.kcc bs=128 skip=1 of=pascal51_kcc.bin status=none

.PHONY: clean distclean
clean:
	-rm *~

distclean: clean
	-rm pascal51_kcc.bin
