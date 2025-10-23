SHELL := bash

.PHONY: clean distclean for_inc

%.bin: %.asm
	pasmo $< $@

pasex2.kcc: pasex2.asm pasex2.inc px2init_dummy.bin px2org.inc px2kern_dummy.bin
	pasmo -d pasex2.asm pasex20.bin > pasex2_pasmo.asm
	../bincut.pl -i pasex20.bin -o pasex2.kcc \
	  -b $$( od -v -t x1 \
                 -j $$(( $$(stat -c %s px2init_dummy.bin) - 5 )) \
	         px2init_dummy.bin | \
	         head -1 | cut -d \  -f 2- | tr ' ' , ) \
	  -a $$( od -v -t x1 -N 5 px2kern_dummy.bin | \
	         head -1 | cut -d \  -f 2- | tr ' ' , )

px2init_dummy.bin: px2init_dummy.asm pas_gdef.inc px2var.inc px2init.inc
px2kern_dummy.bin: px2kern_dummy.asm pas_gdef.inc px2kern.inc px2var.inc

px2org.inc: px2kern_dummy.bin
	printf "\torg 0x%4x\n" \
	  $$(( 0xc000 - $$(stat -c %s px2kern_dummy.bin) )) > px2org.inc

for_inc: pasex2.inc px2init_dummy.bin px2org.inc

clean:
	-rm -f *~ *.bin

distclean: clean
	-rm -f pasex2.kcc pasex2_pasmo.asm
