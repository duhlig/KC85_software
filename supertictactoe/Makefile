SHELL := bash

txt2pas = ${prjbase}/github/KC85_software/pas_txt/txt2pas.pl
jkcemu_usb = ${prjbase}/testfeld/usb
jkcemu_pas = ${prjbase}/testfeld/pascal

all: sttt_t1.pas sttt_t2.pas superttt.pas sttt_gt2.pas

sttt_t1.pas: sttt_t1.txt
	${txt2pas} -fn $< $@
	cp $@ ${jkcemu_usb}

sttt_t2.pas: sttt_t2.txt
	${txt2pas} -fn $< $@
	cp $@ ${jkcemu_usb}

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

# Bild umwandeln
# perl pbm_kc_pivot.pl bild2_p2b.pbm b2pivot.pbm
# tail -n +3 b2pivot.pbm > b2pivot.raw
# perl rle_encode.pl b2pivot.raw b2pivot.rle
# base64 -w64 b2pivot.rle > b2pivot.b64
