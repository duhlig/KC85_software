
.PHONY: clean distclean diff patch

default: diff pascal51.asm patch

all: pascal51.asm

diff:
	-[ -r p51.asm ] && diff -du p51.asm pascal51.asm > p51.patch ; true

patch:
	[ -r p51.patch ] && patch pascal51.asm p51.patch

pascal51.asm: pascal51_kcc.bin p51.block p51.sym
	@z80dasm -a -b p51.block -g 0x200 -l -S p51.sym -s p51.symout -t -u -o p51t.asm pascal51_kcc.bin
	@z80dasm -b p51.block -g 0x200 -l -S p51.sym -s p51.symout -u -o pascal51.asm pascal51_kcc.bin
	cp pascal51.asm p51.asm

pascal51_kcc.bin: pascal51.kcc
	@dd if=pascal51.kcc bs=128 skip=1 of=pascal51_kcc.bin status=none

clean:
	-rm -f *~ p51.symout p51t.asm

distclean: clean
	-rm -f pascal51_kcc.bin p51.asm p51.asm.orig p51.asm.rej
