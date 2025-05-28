SHELL := bash

asm = pasmo

.PHONY: clean distclean


pas51x.kcc: pas51x.asm pas_gdef.inc pasex2/px2org.inc
	$(MAKE) -C pasex2 for_inc
	pasmo -d -I pasex2 pas51x.asm pas51x0.bin > pas51x_pasmo.asm
	./bincut.pl -i pas51x0.bin -o pas51x.kcc \
	  -b $$( od -v -t x1 \
                 -j $$(( $$(stat -c %s pasex2/px2init_dummy.bin) - 5 )) \
	         pasex2/px2init_dummy.bin | \
	         head -1 | cut -d \  -f 2- | tr ' ' , ) \
	  -a $$( od -v -t x1 -N 5 pasex2/px2kern_dummy.bin | \
	         head -1 | cut -d \  -f 2- | tr ' ' , )

clean:
	-rm -f *~

distclean: clean
	-rm -f pas51x.kcc
