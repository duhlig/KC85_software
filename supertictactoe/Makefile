SHELL := bash

txt2pas = ${prjbase}/github/KC85_software/pas_txt/txt2pas.pl
jkcemu_usb = ${prjbase}/eigene/usb
jkcemu_pas = ${prjbase}/eigene/pascal

all: superttt.pas sttt_gt2.pas

clean:
	rm -f superttt.txt superttt.pas sttt_gt2.txt sttt_gt2.pas
	rm -f sttt_t1t.txt sttt_t1t.pas sttt_t2t.txt sttt_t2t.pas

superttt.txt: stttgdef.txt sttt_t1.txt
	cat $^ | perl cut_testcode.pl > $@

superttt.pas: superttt.txt
	${txt2pas} -fn $< $@
	cp $@ ${jkcemu_usb}

sttt_gt2.txt: stttgdef.txt sttt_t2.txt
	cat $^ | perl cut_testcode.pl > $@

sttt_gt2.pas: sttt_gt2.txt
	${txt2pas} -fn $< $@
	cp $@ ${jkcemu_usb}

# ----- fuer Einzeltests -----

sttt_t1t.txt: stttgdef.txt sttt_t1.txt
	cat $^ > $@

sttt_t1t.pas: sttt_t1t.txt
	${txt2pas} -fn $< $@
	cp $@ ${jkcemu_usb}

sttt_t2t.txt: stttgdef.txt sttt_t2.txt
	cat $^ > $@

sttt_t2t.pas: sttt_t2t.txt
	${txt2pas} -fn $< $@
	cp $@ ${jkcemu_usb}

# ----- Bild umwandeln -----
# perl pbm_kc_pivot.pl bild2_p2b.pbm b2pivot.pbm
# tail -n +3 b2pivot.pbm > b2pivot.raw
# perl rle_encode.pl b2pivot.raw b2pivot.rle
# base64 -w64 b2pivot.rle > b2pivot.b64
