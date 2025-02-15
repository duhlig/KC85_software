SHELL := bash

.PHONY: clean distclean diff patch

default: diff pascal51.asm

all: default test

diff:
	-[ -r p51.asm ] && diff -du p51.asm pascal51.asm > p51.patch ; true

patch:
	[ -r p51.patch ] && patch pascal51.asm p51.patch

pascal51.asm: pascal51_kcc.bin p51.block p51.sym
	cp pascal51.asm pascal51.bak
	z80dasm -a -b p51.block -g 0x200 -l -S p51.sym -s p51.symout -t -u -o p51t.asm pascal51_kcc.bin
	@z80dasm -b p51.block -g 0x200 -l -S p51.sym -s p51.symout -u -o pascal51.asm pascal51_kcc.bin
	cp pascal51.asm p51.asm
	[ -r p51.patch ] && patch pascal51.asm p51.patch

pascal51_kcc.bin: pascal51.kcc
	@dd if=pascal51.kcc bs=128 skip=1 of=pascal51_kcc.bin status=none

test: p51.bin
	diff <(xxd -p -c 1 pascal51_kcc.bin) <(xxd -p -c 1 p51.bin)

p51.bin: pascal51.asm
	pasmo pascal51.asm p510.bin
	./bincut.pl -i p510.bin -o p51.bin -b c,c,c,7c,0 -a 0,0,41,53,43,49,49

p5a.kcc: p5a.asm
	pasmo p5a.asm p5a.kcc

p5a.asm: pascal51.asm
	cp pascal51.asm p5a.asm
	patch p5a.asm p5a.patch

clean:
	-rm -f *~ p51.symout p51t.asm p510.bin p51.bin pascal51.bak

distclean: clean
	-rm -f pascal51_kcc.bin p51.asm pascal51.asm.orig pascal51.asm.rej
