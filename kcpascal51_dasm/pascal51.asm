; z80dasm 1.1.6
; command line: z80dasm -a -b p51.block -g 0x200 -l -S p51.sym -t -u -o pascal51.asm pascal51_kcc.bin

	org	00200h
l01eeh:	equ 0x01ee
CCTL0:	equ 0xb7a6
SUTAB:	equ 0xb7b0
SUBALT:	equ 0xb7fe
PXSASCI:	equ 0xbc00
PXSASCI+1:	equ 0xbc01
PXASCI:	equ 0xbc08
PXTAPE:	equ 0xbc0f
PXTAPE+1:	equ 0xbc10
PXDISK:	equ 0xbc20
PXDISK+1:	equ 0xbc21
ISRO:	equ 0xbc2f
PXNxtBlock:	equ 0xbc47
PXSendCtl:	equ 0xbc5c
MBO:	equ 0xbc80
CSRO:	equ 0xbc96
ISRI:	equ 0xbc9e
PXRecvBlock_s:	equ 0xbcb2
MBI:	equ 0xbcd0
CSRI:	equ 0xbce9
SUBNEU:	equ 0xbcee
SUBNEU+2:	equ 0xbcf0
SUBNEU+10:	equ 0xbcf8
SUBNEU+16:	equ 0xbcfe
PV1:	equ 0xf003

l0200h:
	nop			;0200	00 	. 
	nop			;0201	00 	. 
PasPrgMenuName:
	nop			;0202	00 	. 
	nop			;0203	00 	. 
	nop			;0204	00 	. 
	nop			;0205	00 	. 
	nop			;0206	00 	. 
	nop			;0207	00 	. 
l0208h:
	nop			;0208	00 	. 
	nop			;0209	00 	. 
	nop			;020a	00 	. 
	jp PasPrgStart		;020b	c3 c8 06 	. . . 
MenuPRec:

; BLOCK 'MenuPRec' (start 0x020e end 0x0216)
MenuPRec_start:
	defb 07fh		;020e	7f 	 
	defb 07fh		;020f	7f 	 
	defb 050h		;0210	50 	P 
	defb 041h		;0211	41 	A 
	defb 053h		;0212	53 	S 
	defb 052h		;0213	52 	R 
	defb 045h		;0214	45 	E 
	defb 043h		;0215	43 	C 
	nop			;0216	00 	. 
	jp Recall		;0217	c3 a8 06 	. . . 
MenuPEnt:

; BLOCK 'MenuPEnt' (start 0x021a end 0x0224)
MenuPEnt_start:
	defb 07fh		;021a	7f 	 
	defb 07fh		;021b	7f 	 
	defb 050h		;021c	50 	P 
	defb 041h		;021d	41 	A 
	defb 053h		;021e	53 	S 
	defb 045h		;021f	45 	E 
	defb 04eh		;0220	4e 	N 
	defb 054h		;0221	54 	T 
	defb 052h		;0222	52 	R 
	defb 059h		;0223	59 	Y 
	nop			;0224	00 	. 
	jp Entry		;0225	c3 a0 06 	. . . 
DoNopRET:
	nop			;0228	00 	. 
	nop			;0229	00 	. 
	ret			;022a	c9 	. 
DoRET:
	ret			;022b	c9 	. 
CCaos:
	push iy		;022c	fd e5 	. . 
	push ix		;022e	dd e5 	. . 
	push bc			;0230	c5 	. 
	push de			;0231	d5 	. 
	push hl			;0232	e5 	. 
	ld ix,(caos_ix)		;0233	dd 2a b0 06 	. * . . 
	ld (pascal_sp),sp		;0237	ed 73 b2 06 	. s . . 
l023bh:
	ld (tmp_reg_a),a		;023b	32 bd 06 	2 . . 
	in a,(088h)		;023e	db 88 	. . 
	set 5,a		;0240	cb ef 	. . 
	set 2,a		;0242	cb d7 	. . 
	out (088h),a		;0244	d3 88 	. . 
	ld a,e			;0246	7b 	{ 
	ld (OSPrc),a		;0247	32 55 02 	2 U . 
	ld a,(tmp_reg_a)		;024a	3a bd 06 	: . . 
	ld sp,(caos_sp)		;024d	ed 7b 06 07 	. { . . 
	ei			;0251	fb 	. 
	call PV1		;0252	cd 03 f0 	. . . 
OSPrc:
	defb 000h		;0255	00 	. 
	di			;0256	f3 	. 
	ld (caos_sp),sp		;0257	ed 73 06 07 	. s . . 
	ld (tmp_reg_a),a		;025b	32 bd 06 	2 . . 
	in a,(088h)		;025e	db 88 	. . 
	res 5,a		;0260	cb af 	. . 
	res 2,a		;0262	cb 97 	. . 
	out (088h),a		;0264	d3 88 	. . 
	ld a,(tmp_reg_a)		;0266	3a bd 06 	: . . 
	ld sp,(pascal_sp)		;0269	ed 7b b2 06 	. { . . 
	pop hl			;026d	e1 	. 
	pop de			;026e	d1 	. 
	pop bc			;026f	c1 	. 
	pop ix		;0270	dd e1 	. . 
	pop iy		;0272	fd e1 	. . 
	ret			;0274	c9 	. 
CAOS_KBDS:
	push de			;0275	d5 	. 
	ld e,00ch		;0276	1e 0c 	. . 
	call CCaos		;0278	cd 2c 02 	. , . 
	pop de			;027b	d1 	. 
	ld a,0ffh		;027c	3e ff 	> . 
	ret c			;027e	d8 	. 
	xor a			;027f	af 	. 
	ret			;0280	c9 	. 
GetKey:
	push de			;0281	d5 	. 
	push ix		;0282	dd e5 	. . 
	ld ix,(caos_ix)		;0284	dd 2a b0 06 	. * . . 
	in a,(088h)		;0288	db 88 	. . 
	set 5,a		;028a	cb ef 	. . 
	set 2,a		;028c	cb d7 	. . 
	out (088h),a		;028e	d3 88 	. . 
	res 0,(ix+008h)		;0290	dd cb 08 86 	. . . . 
	in a,(088h)		;0294	db 88 	. . 
	res 5,a		;0296	cb af 	. . 
	res 2,a		;0298	cb 97 	. . 
	out (088h),a		;029a	d3 88 	. . 
	ei			;029c	fb 	. 
	ld a,002h		;029d	3e 02 	> . 
	ld e,014h		;029f	1e 14 	. . 
l02a1h:
	call CCaos		;02a1	cd 2c 02 	. , . 
GetKeyTest:
	ld e,00ch		;02a4	1e 0c 	. . 
	call CCaos		;02a6	cd 2c 02 	. , . 
	cp 080h		;02a9	fe 80 	. . 
	jr c,CAOS_KBD		;02ab	38 1a 	8 . 
	in a,(088h)		;02ad	db 88 	. . 
	set 5,a		;02af	cb ef 	. . 
	set 2,a		;02b1	cb d7 	. . 
	out (088h),a		;02b3	d3 88 	. . 
	xor a			;02b5	af 	. 
	ld (ix+00dh),a		;02b6	dd 77 0d 	. w . 
	res 0,(ix+008h)		;02b9	dd cb 08 86 	. . . . 
	in a,(088h)		;02bd	db 88 	. . 
	res 5,a		;02bf	cb af 	. . 
	res 2,a		;02c1	cb 97 	. . 
	out (088h),a		;02c3	d3 88 	. . 
	jr GetKeyTest		;02c5	18 dd 	. . 
CAOS_KBD:
	ld e,004h		;02c7	1e 04 	. . 
	call CCaos		;02c9	cd 2c 02 	. , . 
	cp 080h		;02cc	fe 80 	. . 
	jr nc,CAOS_KBD		;02ce	30 f7 	0 . 
	ld e,a			;02d0	5f 	_ 
	in a,(088h)		;02d1	db 88 	. . 
	set 5,a		;02d3	cb ef 	. . 
	set 2,a		;02d5	cb d7 	. . 
	out (088h),a		;02d7	d3 88 	. . 
	res 0,(ix+008h)		;02d9	dd cb 08 86 	. . . . 
	in a,(088h)		;02dd	db 88 	. . 
	res 5,a		;02df	cb af 	. . 
	res 2,a		;02e1	cb 97 	. . 
	out (088h),a		;02e3	d3 88 	. . 
l02e5h:
	ld a,e			;02e5	7b 	{ 
	pop ix		;02e6	dd e1 	. . 
	pop de			;02e8	d1 	. 
	ret			;02e9	c9 	. 
CAOS_CRT:
	push af			;02ea	f5 	. 
	ld a,c			;02eb	79 	y 
	push de			;02ec	d5 	. 
	ld e,000h		;02ed	1e 00 	. . 
	call CCaos		;02ef	cd 2c 02 	. , . 
	pop de			;02f2	d1 	. 
	pop af			;02f3	f1 	. 
	ret			;02f4	c9 	. 
Save:
	ld ix,(caos_ix)		;02f5	dd 2a b0 06 	. * . . 
	ld (SaveBlockAdr),hl		;02f9	22 b8 06 	" . . 
	ld (00091h),hl		;02fc	22 91 00 	" . . 
	ld hl,0008bh		;02ff	21 8b 00 	! . . 
	ld b,005h		;0302	06 05 	. . 
KillMem:
	ld (hl),000h		;0304	36 00 	6 . 
	inc hl			;0306	23 	# 
	djnz KillMem		;0307	10 fb 	. . 
SavePrg:
	inc de			;0309	13 	. 
	ld (bin_end),de		;030a	ed 53 ba 06 	. S . . 
	ld (00093h),de		;030e	ed 53 93 00 	. S . . 
	ld a,002h		;0312	3e 02 	> . 
l0314h:
	ld (00090h),a		;0314	32 90 00 	2 . . 
	ld a,(fileExt)		;0317	3a 00 07 	: . . 
	cp 043h		;031a	fe 43 	. C 
	jr nz,l034ch		;031c	20 2e 	  . 
	ld a,d			;031e	7a 	z 
	ld (00093h),a		;031f	32 93 00 	2 . . 
	ld hl,l04d5h		;0322	21 d5 04 	! . . 
	ld (00094h),hl		;0325	22 94 00 	" . . 
	ld hl,07f7fh		;0328	21 7f 7f 	!   
	ld (l0200h),hl		;032b	22 00 02 	" . . 
	ld hl,00000h		;032e	21 00 00 	! . . 
	ld (MenuPEnt),hl		;0331	22 1a 02 	" . . 
	ld (MenuPRec),hl		;0334	22 0e 02 	" . . 
	ld hl,fileName		;0337	21 f8 06 	! . . 
	ld de,PasPrgMenuName		;033a	11 02 02 	. . . 
	ld b,008h		;033d	06 08 	. . 
FName2Menu:
	ld a,(hl)			;033f	7e 	~ 
	cp 020h		;0340	fe 20 	.   
	jr z,l034ch		;0342	28 08 	( . 
	or a			;0344	b7 	. 
	jr z,l034ch		;0345	28 05 	( . 
	ld (de),a			;0347	12 	. 
	inc hl			;0348	23 	# 
	inc de			;0349	13 	. 
	djnz FName2Menu		;034a	10 f3 	. . 
l034ch:
	ld hl,fileName		;034c	21 f8 06 	! . . 
	ld bc,0000bh		;034f	01 0b 00 	. . . 
l0352h:
	ld de,00080h		;0352	11 80 00 	. . . 
	ldir		;0355	ed b0 	. . 
	ld hl,00080h		;0357	21 80 00 	! . . 
	in a,(088h)		;035a	db 88 	. . 
	set 5,a		;035c	cb ef 	. . 
	set 2,a		;035e	cb d7 	. . 
	out (088h),a		;0360	d3 88 	. . 
	ld (ix+005h),l		;0362	dd 75 05 	. u . 
	ld (ix+006h),h		;0365	dd 74 06 	. t . 
	in a,(088h)		;0368	db 88 	. . 
	res 5,a		;036a	cb af 	. . 
	res 2,a		;036c	cb 97 	. . 
	out (088h),a		;036e	d3 88 	. . 
	ld bc,l1f40h		;0370	01 40 1f 	. @ . 
	ld e,008h		;0373	1e 08 	. . 
	call CCaos		;0375	cd 2c 02 	. , . 
SaveBlock:
	ld hl,(SaveBlockAdr)		;0378	2a b8 06 	* . . 
	ld de,00080h		;037b	11 80 00 	. . . 
	ld bc,00080h		;037e	01 80 00 	. . . 
	ldir		;0381	ed b0 	. . 
	ld (SaveBlockAdr),hl		;0383	22 b8 06 	" . . 
	ld bc,000a0h		;0386	01 a0 00 	. . . 
	ld e,001h		;0389	1e 01 	. . 
	call CCaos		;038b	cd 2c 02 	. , . 
	in a,(088h)		;038e	db 88 	. . 
l0390h:
	set 5,a		;0390	cb ef 	. . 
	set 2,a		;0392	cb d7 	. . 
	out (088h),a		;0394	d3 88 	. . 
	ld e,(ix+002h)		;0396	dd 5e 02 	. ^ . 
	in a,(088h)		;0399	db 88 	. . 
	res 5,a		;039b	cb af 	. . 
	res 2,a		;039d	cb 97 	. . 
	out (088h),a		;039f	d3 88 	. . 
	ld a,e			;03a1	7b 	{ 
	call PrByteHex		;03a2	cd c0 08 	. . . 
	call PrSpace		;03a5	cd 89 08 	. . . 
	ld hl,(SaveBlockAdr)		;03a8	2a b8 06 	* . . 
	ld de,(bin_end)		;03ab	ed 5b ba 06 	. [ . . 
	or a			;03af	b7 	. 
	sbc hl,de		;03b0	ed 52 	. R 
	jr c,SaveBlock		;03b2	38 c4 	8 . 
	ld e,009h		;03b4	1e 09 	. . 
	call CCaos		;03b6	cd 2c 02 	. , . 
	ld a,012h		;03b9	3e 12 	> . 
	call OutChr		;03bb	cd 29 07 	. ) . 
	jp PrNL		;03be	c3 85 08 	. . . 
TestBreak:
	ld e,02ah		;03c1	1e 2a 	. * 
	call CCaos		;03c3	cd 2c 02 	. , . 
	ret nc			;03c6	d0 	. 
	ld a,012h		;03c7	3e 12 	> . 
	call OutChr		;03c9	cd 29 07 	. ) . 
	jp Reset		;03cc	c3 dd 06 	. . . 
Load:
	ld (srcAddr_LoadSave),hl		;03cf	22 b4 06 	" . . 
RetryISRI:
	ld ix,(caos_ix)		;03d2	dd 2a b0 06 	. * . . 
C_ISRI:
	call TestBreak		;03d6	cd c1 03 	. . . 
	ld hl,00080h		;03d9	21 80 00 	! . . 
	in a,(088h)		;03dc	db 88 	. . 
	set 5,a		;03de	cb ef 	. . 
	set 2,a		;03e0	cb d7 	. . 
	out (088h),a		;03e2	d3 88 	. . 
	set 0,(ix+007h)		;03e4	dd cb 07 c6 	. . . . 
	ld (ix+005h),l		;03e8	dd 75 05 	. u . 
	ld (ix+006h),h		;03eb	dd 74 06 	. t . 
	in a,(088h)		;03ee	db 88 	. . 
	res 5,a		;03f0	cb af 	. . 
	res 2,a		;03f2	cb 97 	. . 
	out (088h),a		;03f4	d3 88 	. . 
	ld e,00ah		;03f6	1e 0a 	. . 
	call CCaos		;03f8	cd 2c 02 	. , . 
	jr c,RetryISRI		;03fb	38 d5 	8 . 
	in a,(088h)		;03fd	db 88 	. . 
	set 5,a		;03ff	cb ef 	. . 
	set 2,a		;0401	cb d7 	. . 
	out (088h),a		;0403	d3 88 	. . 
	ld e,(ix+002h)		;0405	dd 5e 02 	. ^ . 
	in a,(088h)		;0408	db 88 	. . 
	res 5,a		;040a	cb af 	. . 
	res 2,a		;040c	cb 97 	. . 
	out (088h),a		;040e	d3 88 	. . 
	ld a,e			;0410	7b 	{ 
ChkForBlock1:
	cp 001h		;0411	fe 01 	. . 
	jp nz,RetryISRI		;0413	c2 d2 03 	. . . 
	inc a			;0416	3c 	< 
	ld (nextBlkNum),a		;0417	32 bc 06 	2 . . 
	ld de,00080h		;041a	11 80 00 	. . . 
	ld bc,l0b00h		;041d	01 00 0b 	. . . 
	ld hl,fileName		;0420	21 f8 06 	! . . 
CmpFNamChr:
	ld a,(de)			;0423	1a 	. 
	or a			;0424	b7 	. 
	jr z,CmpFNamNxtChr		;0425	28 12 	( . 
	cp 020h		;0427	fe 20 	.   
	jr z,CmpFNamNxtChr		;0429	28 0e 	( . 
	cp (hl)			;042b	be 	. 
	jr z,CmpFNamEchoChr		;042c	28 07 	( . 
	ld a,03fh		;042e	3e 3f 	> ? 
	cp (hl)			;0430	be 	. 
	jr z,CmpFNamEchoChr		;0431	28 02 	( . 
	ld c,001h		;0433	0e 01 	. . 
CmpFNamEchoChr:
	ld a,(de)			;0435	1a 	. 
	call OutChr		;0436	cd 29 07 	. ) . 
CmpFNamNxtChr:
	inc de			;0439	13 	. 
	inc hl			;043a	23 	# 
	djnz CmpFNamChr		;043b	10 e6 	. . 
	call PrNL		;043d	cd 85 08 	. . . 
	ld a,c			;0440	79 	y 
	or a			;0441	b7 	. 
	jp nz,RetryISRI		;0442	c2 d2 03 	. . . 
	ld de,(00091h)		;0445	ed 5b 91 00 	. [ . . 
	ld hl,(00093h)		;0449	2a 93 00 	* . . 
	or a			;044c	b7 	. 
	sbc hl,de		;044d	ed 52 	. R 
	ld (SaveBlockAdr),hl		;044f	22 b8 06 	" . . 
	ld de,(srcAddr_LoadSave)		;0452	ed 5b b4 06 	. [ . . 
	add hl,de			;0456	19 	. 
	ld (l06b6h),hl		;0457	22 b6 06 	" . . 
C_MBI:
	call TestBreak		;045a	cd c1 03 	. . . 
	ld e,005h		;045d	1e 05 	. . 
	call CCaos		;045f	cd 2c 02 	. , . 
	jr c,C_MBI		;0462	38 f6 	8 . 
	in a,(088h)		;0464	db 88 	. . 
	set 5,a		;0466	cb ef 	. . 
	set 2,a		;0468	cb d7 	. . 
	out (088h),a		;046a	d3 88 	. . 
	ld e,(ix+002h)		;046c	dd 5e 02 	. ^ . 
	in a,(088h)		;046f	db 88 	. . 
	res 5,a		;0471	cb af 	. . 
	res 2,a		;0473	cb 97 	. . 
	out (088h),a		;0475	d3 88 	. . 
	ld a,e			;0477	7b 	{ 
	ld hl,nextBlkNum		;0478	21 bc 06 	! . . 
	cp 0ffh		;047b	fe ff 	. . 
	jr z,C_CSRI		;047d	28 3c 	( < 
	cp (hl)			;047f	be 	. 
	jr z,BlockRead		;0480	28 0d 	( . 
	call PrByteHex		;0482	cd c0 08 	. . . 
	ld a,02ah		;0485	3e 2a 	> * 
	call OutChr		;0487	cd 29 07 	. ) . 
	call PrSpace		;048a	cd 89 08 	. . . 
	jr C_MBI		;048d	18 cb 	. . 
BlockRead:
	inc (hl)			;048f	34 	4 
	call PrByteHex		;0490	cd c0 08 	. . . 
	ld a,03eh		;0493	3e 3e 	> > 
	call OutChr		;0495	cd 29 07 	. ) . 
	call PrSpace		;0498	cd 89 08 	. . . 
	ld hl,(SaveBlockAdr)		;049b	2a b8 06 	* . . 
	ld de,00080h		;049e	11 80 00 	. . . 
	or a			;04a1	b7 	. 
	sbc hl,de		;04a2	ed 52 	. R 
	jr c,C_CSRI		;04a4	38 15 	8 . 
	ld (SaveBlockAdr),hl		;04a6	22 b8 06 	" . . 
	ld bc,00080h		;04a9	01 80 00 	. . . 
	ld hl,00080h		;04ac	21 80 00 	! . . 
	ld de,(srcAddr_LoadSave)		;04af	ed 5b b4 06 	. [ . . 
	ldir		;04b3	ed b0 	. . 
	ld (srcAddr_LoadSave),de		;04b5	ed 53 b4 06 	. S . . 
	jr C_MBI		;04b9	18 9f 	. . 
C_CSRI:
	ld bc,(SaveBlockAdr)		;04bb	ed 4b b8 06 	. K . . 
	ld hl,00080h		;04bf	21 80 00 	! . . 
	ld de,(srcAddr_LoadSave)		;04c2	ed 5b b4 06 	. [ . . 
	ldir		;04c6	ed b0 	. . 
	ld e,00bh		;04c8	1e 0b 	. . 
	call CCaos		;04ca	cd 2c 02 	. , . 
	ld a,012h		;04cd	3e 12 	> . 
	call OutChr		;04cf	cd 29 07 	. ) . 
	ld hl,(l06b6h)		;04d2	2a b6 06 	* . . 
l04d5h:
	ret			;04d5	c9 	. 
RET_to_CAOS:
	ld e,012h		;04d6	1e 12 	. . 
	jp CCaos		;04d8	c3 2c 02 	. , . 
CAOS_UOT1:
	push af			;04db	f5 	. 
l04dch:
	ld a,c			;04dc	79 	y 
	push de			;04dd	d5 	. 
	ld e,002h		;04de	1e 02 	. . 
	call CCaos		;04e0	cd 2c 02 	. , . 
	pop de			;04e3	d1 	. 
	pop af			;04e4	f1 	. 
	ret			;04e5	c9 	. 
sub_04e6h:
	ld a,(l178fh)		;04e6	3a 8f 17 	: . . 
	ld h,a			;04e9	67 	g 
	ld a,(l178dh)		;04ea	3a 8d 17 	: . . 
	ld l,a			;04ed	6f 	o 
	in a,(088h)		;04ee	db 88 	. . 
	set 5,a		;04f0	cb ef 	. . 
	set 2,a		;04f2	cb d7 	. . 
	out (088h),a		;04f4	d3 88 	. . 
	ld (0b7a0h),hl		;04f6	22 a0 b7 	" . . 
	in a,(088h)		;04f9	db 88 	. . 
	res 5,a		;04fb	cb af 	. . 
	res 2,a		;04fd	cb 97 	. . 
	out (088h),a		;04ff	d3 88 	. . 
	ret			;0501	c9 	. 
sub_0502h:
	ld a,(l178fh)		;0502	3a 8f 17 	: . . 
	and 007h		;0505	e6 07 	. . 
	ld l,a			;0507	6f 	o 
	ld a,(l178dh)		;0508	3a 8d 17 	: . . 
	and 01fh		;050b	e6 1f 	. . 
	rlca			;050d	07 	. 
	rlca			;050e	07 	. 
	rlca			;050f	07 	. 
	or l			;0510	b5 	. 
l0511h:
	ld l,a			;0511	6f 	o 
	in a,(088h)		;0512	db 88 	. . 
	set 5,a		;0514	cb ef 	. . 
	set 2,a		;0516	cb d7 	. . 
l0518h:
	out (088h),a		;0518	d3 88 	. . 
	ld a,l			;051a	7d 	} 
	ld (0b7a3h),a		;051b	32 a3 b7 	2 . . 
	in a,(088h)		;051e	db 88 	. . 
	res 5,a		;0520	cb af 	. . 
	res 2,a		;0522	cb 97 	. . 
	out (088h),a		;0524	d3 88 	. . 
	ret			;0526	c9 	. 
sub_0527h:
	in a,(088h)		;0527	db 88 	. . 
	set 5,a		;0529	cb ef 	. . 
	set 2,a		;052b	cb d7 	. . 
	out (088h),a		;052d	d3 88 	. . 
	ld hl,(l178dh)		;052f	2a 8d 17 	* . . 
	ld (0b7d3h),hl		;0532	22 d3 b7 	" . . 
	ld a,(l178fh)		;0535	3a 8f 17 	: . . 
	ld (0b7d5h),a		;0538	32 d5 b7 	2 . . 
	ld a,(0b7a3h)		;053b	3a a3 b7 	: . . 
	and 0f8h		;053e	e6 f8 	. . 
	ld (0b7d6h),a		;0540	32 d6 b7 	2 . . 
	in a,(088h)		;0543	db 88 	. . 
l0545h:
	res 5,a		;0545	cb af 	. . 
	res 2,a		;0547	cb 97 	. . 
	out (088h),a		;0549	d3 88 	. . 
sub_054bh:
	push de			;054b	d5 	. 
	ld e,030h		;054c	1e 30 	. 0 
	call CCaos		;054e	cd 2c 02 	. , . 
	pop de			;0551	d1 	. 
	ret			;0552	c9 	. 
sub_0553h:
	call sub_05c7h		;0553	cd c7 05 	. . . 
	ld l,a			;0556	6f 	o 
	ld h,000h		;0557	26 00 	& . 
	jr z,l0588h		;0559	28 2d 	( - 
	ld (l1791h),hl		;055b	22 91 17 	" . . 
	in a,(088h)		;055e	db 88 	. . 
	set 5,a		;0560	cb ef 	. . 
	set 2,a		;0562	cb d7 	. . 
	out (088h),a		;0564	d3 88 	. . 
	ld hl,(l178dh)		;0566	2a 8d 17 	* . . 
	ld (0b7d3h),hl		;0569	22 d3 b7 	" . . 
	ld a,(l178fh)		;056c	3a 8f 17 	: . . 
	ld (0b7d5h),a		;056f	32 d5 b7 	2 . . 
	ld a,(l1791h)		;0572	3a 91 17 	: . . 
	and 0f8h		;0575	e6 f8 	. . 
	ld (0b7d6h),a		;0577	32 d6 b7 	2 . . 
	in a,(088h)		;057a	db 88 	. . 
	res 5,a		;057c	cb af 	. . 
	res 2,a		;057e	cb 97 	. . 
	out (088h),a		;0580	d3 88 	. . 
	call sub_054bh		;0582	cd 4b 05 	. K . 
	ld hl,(l1791h)		;0585	2a 91 17 	* . . 
l0588h:
	ld a,l			;0588	7d 	} 
	and 0f8h		;0589	e6 f8 	. . 
	rrca			;058b	0f 	. 
	rrca			;058c	0f 	. 
	rrca			;058d	0f 	. 
	ld l,a			;058e	6f 	o 
	ret			;058f	c9 	. 
sub_0590h:
	call sub_05c7h		;0590	cd c7 05 	. . . 
	ld l,a			;0593	6f 	o 
	ld h,000h		;0594	26 00 	& . 
	jr z,l05c5h		;0596	28 2d 	( - 
	ld (l1791h),hl		;0598	22 91 17 	" . . 
	in a,(088h)		;059b	db 88 	. . 
	set 5,a		;059d	cb ef 	. . 
	set 2,a		;059f	cb d7 	. . 
	out (088h),a		;05a1	d3 88 	. . 
	ld hl,(l178dh)		;05a3	2a 8d 17 	* . . 
	ld (0b7d3h),hl		;05a6	22 d3 b7 	" . . 
	ld a,(l178fh)		;05a9	3a 8f 17 	: . . 
	ld (0b7d5h),a		;05ac	32 d5 b7 	2 . . 
	ld a,(l1791h)		;05af	3a 91 17 	: . . 
	and 0f8h		;05b2	e6 f8 	. . 
	ld (0b7d6h),a		;05b4	32 d6 b7 	2 . . 
	in a,(088h)		;05b7	db 88 	. . 
	res 5,a		;05b9	cb af 	. . 
	res 2,a		;05bb	cb 97 	. . 
	out (088h),a		;05bd	d3 88 	. . 
	call sub_054bh		;05bf	cd 4b 05 	. K . 
	ld a,001h		;05c2	3e 01 	> . 
	ret			;05c4	c9 	. 
l05c5h:
	xor a			;05c5	af 	. 
	ret			;05c6	c9 	. 
sub_05c7h:
	in a,(088h)		;05c7	db 88 	. . 
	set 5,a		;05c9	cb ef 	. . 
	set 2,a		;05cb	cb d7 	. . 
	out (088h),a		;05cd	d3 88 	. . 
	ld hl,(l178dh)		;05cf	2a 8d 17 	* . . 
	ld (0b7d3h),hl		;05d2	22 d3 b7 	" . . 
	ld a,(l178fh)		;05d5	3a 8f 17 	: . . 
	ld (0b7d5h),a		;05d8	32 d5 b7 	2 . . 
	in a,(088h)		;05db	db 88 	. . 
	res 5,a		;05dd	cb af 	. . 
	res 2,a		;05df	cb 97 	. . 
	out (088h),a		;05e1	d3 88 	. . 
	push de			;05e3	d5 	. 
	ld e,02fh		;05e4	1e 2f 	. / 
	call CCaos		;05e6	cd 2c 02 	. , . 
	pop de			;05e9	d1 	. 
	ret			;05ea	c9 	. 
sub_05ebh:
	in a,(088h)		;05eb	db 88 	. . 
	set 5,a		;05ed	cb ef 	. . 
	set 2,a		;05ef	cb d7 	. . 
	out (088h),a		;05f1	d3 88 	. . 
	ld hl,(l178dh)		;05f3	2a 8d 17 	* . . 
	ld (0b782h),hl		;05f6	22 82 b7 	" . . 
	ld hl,(l178fh)		;05f9	2a 8f 17 	* . . 
	ld (0b784h),hl		;05fc	22 84 b7 	" . . 
	ld hl,(l1791h)		;05ff	2a 91 17 	* . . 
	ld (0b786h),hl		;0602	22 86 b7 	" . . 
	ld hl,(l1793h)		;0605	2a 93 17 	* . . 
	ld (0b788h),hl		;0608	22 88 b7 	" . . 
	ld a,(0b7a3h)		;060b	3a a3 b7 	: . . 
	and 0f8h		;060e	e6 f8 	. . 
	ld (0b7d6h),a		;0610	32 d6 b7 	2 . . 
	in a,(088h)		;0613	db 88 	. . 
	res 5,a		;0615	cb af 	. . 
	res 2,a		;0617	cb 97 	. . 
	out (088h),a		;0619	d3 88 	. . 
	push de			;061b	d5 	. 
	ld e,03eh		;061c	1e 3e 	. > 
	call CCaos		;061e	cd 2c 02 	. , . 
	pop de			;0621	d1 	. 
	ret			;0622	c9 	. 
sub_0623h:
	in a,(088h)		;0623	db 88 	. . 
	set 5,a		;0625	cb ef 	. . 
	set 2,a		;0627	cb d7 	. . 
	out (088h),a		;0629	d3 88 	. . 
	ld hl,(l178dh)		;062b	2a 8d 17 	* . . 
	ld (0b782h),hl		;062e	22 82 b7 	" . . 
	ld hl,(l178fh)		;0631	2a 8f 17 	* . . 
	ld (0b784h),hl		;0634	22 84 b7 	" . . 
	ld hl,(l1791h)		;0637	2a 91 17 	* . . 
	ld (0b786h),hl		;063a	22 86 b7 	" . . 
	ld a,(0b7a3h)		;063d	3a a3 b7 	: . . 
	and 0f8h		;0640	e6 f8 	. . 
	ld (0b7d6h),a		;0642	32 d6 b7 	2 . . 
	in a,(088h)		;0645	db 88 	. . 
	res 5,a		;0647	cb af 	. . 
	res 2,a		;0649	cb 97 	. . 
	out (088h),a		;064b	d3 88 	. . 
	push de			;064d	d5 	. 
	ld e,03fh		;064e	1e 3f 	. ? 
	call CCaos		;0650	cd 2c 02 	. , . 
	pop de			;0653	d1 	. 
	ret			;0654	c9 	. 
sub_0655h:
	in a,(088h)		;0655	db 88 	. . 
	set 5,a		;0657	cb ef 	. . 
	set 2,a		;0659	cb d7 	. . 
	out (088h),a		;065b	d3 88 	. . 
	ld a,(l178dh)		;065d	3a 8d 17 	: . . 
	ld (hl),a			;0660	77 	w 
	in a,(088h)		;0661	db 88 	. . 
	res 5,a		;0663	cb af 	. . 
	res 2,a		;0665	cb 97 	. . 
	out (088h),a		;0667	d3 88 	. . 
	ret			;0669	c9 	. 
sub_066ah:
	in a,(088h)		;066a	db 88 	. . 
	set 5,a		;066c	cb ef 	. . 
	set 2,a		;066e	cb d7 	. . 
	out (088h),a		;0670	d3 88 	. . 
	ld l,(hl)			;0672	6e 	n 
	ld h,000h		;0673	26 00 	& . 
	in a,(088h)		;0675	db 88 	. . 
	res 5,a		;0677	cb af 	. . 
	res 2,a		;0679	cb 97 	. . 
	out (088h),a		;067b	d3 88 	. . 
	ret			;067d	c9 	. 
GetRAMEnd:
	in a,(088h)		;067e	db 88 	. . 
	res 5,a		;0680	cb af 	. . 
	res 2,a		;0682	cb 97 	. . 
	out (088h),a		;0684	d3 88 	. . 
	ld hl,06000h		;0686	21 00 60 	! . ` 
l0689h:
	ld e,(hl)			;0689	5e 	^ 
	ld a,055h		;068a	3e 55 	> U 
	ld (hl),a			;068c	77 	w 
	cp (hl)			;068d	be 	. 
	jr nz,l069ch		;068e	20 0c 	  . 
	ld a,0aah		;0690	3e aa 	> . 
	ld (hl),a			;0692	77 	w 
	cp (hl)			;0693	be 	. 
	jr nz,l069ch		;0694	20 06 	  . 
	ld (hl),e			;0696	73 	s 
	inc hl			;0697	23 	# 
	ld a,h			;0698	7c 	| 
	or l			;0699	b5 	. 
	jr nz,l0689h		;069a	20 ed 	  . 
l069ch:
	dec hl			;069c	2b 	+ 
	push hl			;069d	e5 	. 
	pop de			;069e	d1 	. 
	ret			;069f	c9 	. 
Entry:
	ld (caos_ix),ix		;06a0	dd 22 b0 06 	. " . . 
	di			;06a4	f3 	. 
	jp Init1		;06a5	c3 be 06 	. . . 
Recall:
	ld (caos_ix),ix		;06a8	dd 22 b0 06 	. " . . 
	di			;06ac	f3 	. 
	jp l06c3h		;06ad	c3 c3 06 	. . . 
caos_ix:
	defw 00000h		;06b0	00 00 	. . 
pascal_sp:
	defw 00000h		;06b2	00 00 	. . 
srcAddr_LoadSave:
	defw 00000h		;06b4	00 00 	. . 
l06b6h:
	defw 00000h		;06b6	00 00 	. . 
SaveBlockAdr:
	defw 00000h		;06b8	00 00 	. . 
bin_end:
	defw 00000h		;06ba	00 00 	. . 
nextBlkNum:
	defb 000h		;06bc	00 	. 
tmp_reg_a:
	nop			;06bd	00 	. 
Init1:
	call SaveCAOS_SP		;06be	cd 13 07 	. . . 
	jr Init2		;06c1	18 17 	. . 
l06c3h:
	call SaveCAOS_SP		;06c3	cd 13 07 	. . . 
	jr Reset		;06c6	18 15 	. . 
PasPrgStart:
	jp 07cd5h		;06c8	c3 d5 7c 	. . | 
JEndPascal:
	jp END_PASCAL		;06cb	c3 1b 07 	. . . 
JReadEditIBuf__:
	jp ReadEditIBuf__		;06ce	c3 6f 0a 	. o . 
JCodeNextByte:
	jp CodeNextByte		;06d1	c3 ee 33 	. . 3 
JPrError:
	jp CoErNumTooBig		;06d4	c3 e4 2c 	. . , 
JResetPrintFlag:
	jp ResetPrintFlag		;06d7	c3 22 07 	. " . 
Init2:
	jp START_PASCAL		;06da	c3 55 23 	. U # 
Reset:
	jp ResetPasStack		;06dd	c3 8b 23 	. . # 
StartEditLine:
	jp PrevLineFound		;06e0	c3 51 25 	. Q % 
JSrcToLineBuf:
	jp SrcToLineBuf		;06e3	c3 a9 28 	. . ( 
JLdHLSrcEnd:
	jp LdHLSrcEnd		;06e6	c3 dd 23 	. . # 
sub_06e9h:
	jp l23e1h		;06e9	c3 e1 23 	. . # 
	jp ExpandLine		;06ec	c3 bc 2b 	. . + 
	jp ExpandLineSrc		;06ef	c3 c8 2b 	. . + 
JCompile:
	jp Compile		;06f2	c3 f7 2b 	. . + 
JCompileToRuntimeEnd:
	jp SetBinStartToRuntimeEnd		;06f5	c3 f4 2b 	. . + 
fileName:
	defb 000h		;06f8	00 	. 
	defb 000h		;06f9	00 	. 
	defb 000h		;06fa	00 	. 
	defb 000h		;06fb	00 	. 
	defb 000h		;06fc	00 	. 
	defb 000h		;06fd	00 	. 
	defb 000h		;06fe	00 	. 
	defb 000h		;06ff	00 	. 
fileExt:
	defb 000h		;0700	00 	. 
	defb 000h		;0701	00 	. 
	defb 000h		;0702	00 	. 
	defb 000h		;0703	00 	. 
l0704h:
	defw 00000h		;0704	00 00 	. . 
caos_sp:
	defw 00000h		;0706	00 00 	. . 
	defw 00000h		;0708	00 00 	. . 
	defw PrcFncTab_start		;070a	58 18 	X . 
curSrcLineNum:
	defw 00028h		;070c	28 00 	( . 
l070eh:
	defw 00000h		;070e	00 00 	. . 
l0710h:
	defw 00000h		;0710	00 00 	. . 
printFlag:
	defb 000h		;0712	00 	. 
SaveCAOS_SP:
	ld (caos_sp),sp		;0713	ed 73 06 07 	. s . . 
	jp DoRET		;0717	c3 2b 02 	. + . 
	ret			;071a	c9 	. 
END_PASCAL:
	ld sp,(caos_sp)		;071b	ed 7b 06 07 	. { . . 
	jp RET_to_CAOS		;071f	c3 d6 04 	. . . 
ResetPrintFlag:
	xor a			;0722	af 	. 
	ld (printFlag),a		;0723	32 12 07 	2 . . 
	jp DoNopRET		;0726	c3 28 02 	. ( . 
OutChr:
	push bc			;0729	c5 	. 
	push af			;072a	f5 	. 
	ld c,a			;072b	4f 	O 
	cp 010h		;072c	fe 10 	. . 
	jr nz,OCChkNL		;072e	20 0a 	  . 
	ld a,(printFlag)		;0730	3a 12 07 	: . . 
	xor 001h		;0733	ee 01 	. . 
	ld (printFlag),a		;0735	32 12 07 	2 . . 
	jr OCEnd		;0738	18 0c 	. . 
OCChkNL:
	cp 00dh		;073a	fe 0d 	. . 
	jr nz,OCOther		;073c	20 05 	  . 
	call OutCh1		;073e	cd 49 07 	. I . 
	ld c,00ah		;0741	0e 0a 	. . 
OCOther:
	call OutCh1		;0743	cd 49 07 	. I . 
OCEnd:
	pop af			;0746	f1 	. 
	pop bc			;0747	c1 	. 
	ret			;0748	c9 	. 
OutCh1:
	push bc			;0749	c5 	. 
	call CAOS_CRT		;074a	cd ea 02 	. . . 
	ld a,(printFlag)		;074d	3a 12 07 	: . . 
	bit 0,a		;0750	cb 47 	. G 
	pop bc			;0752	c1 	. 
	ret z			;0753	c8 	. 
	jp CAOS_UOT1		;0754	c3 db 04 	. . . 
KbdStat:
	jp CAOS_KBDS		;0757	c3 75 02 	. u . 
Upper:
	cp 07eh		;075a	fe 7e 	. ~ 
	ret nc			;075c	d0 	. 
	cp 061h		;075d	fe 61 	. a 
	ret c			;075f	d8 	. 
	res 5,a		;0760	cb af 	. . 
	ret			;0762	c9 	. 
SetFileName:
	push hl			;0763	e5 	. 
	push bc			;0764	c5 	. 
	ld b,008h		;0765	06 08 	. . 
	ld hl,fileName		;0767	21 f8 06 	! . . 
	push hl			;076a	e5 	. 
SetFNClear:
	ld (hl),000h		;076b	36 00 	6 . 
	inc hl			;076d	23 	# 
	djnz SetFNClear		;076e	10 fb 	. . 
	pop hl			;0770	e1 	. 
	ld b,008h		;0771	06 08 	. . 
SetFNChr:
	ld a,(de)			;0773	1a 	. 
	cp 00dh		;0774	fe 0d 	. . 
	jr z,SetFNEnd		;0776	28 08 	( . 
	call Upper		;0778	cd 5a 07 	. Z . 
	ld (hl),a			;077b	77 	w 
	inc de			;077c	13 	. 
	inc hl			;077d	23 	# 
	djnz SetFNChr		;077e	10 f3 	. . 
SetFNEnd:
	pop bc			;0780	c1 	. 
	pop hl			;0781	e1 	. 
	push hl			;0782	e5 	. 
	add hl,bc			;0783	09 	. 
	ex de,hl			;0784	eb 	. 
	pop hl			;0785	e1 	. 
	ret			;0786	c9 	. 
SetExtPAS:
	push hl			;0787	e5 	. 
	ld hl,fileExtPAS		;0788	21 a2 07 	! . . 
SetFileExt:
	push bc			;078b	c5 	. 
	push de			;078c	d5 	. 
	ld bc,00003h		;078d	01 03 00 	. . . 
	ld de,fileExt		;0790	11 00 07 	. . . 
	ldir		;0793	ed b0 	. . 
	pop de			;0795	d1 	. 
	pop bc			;0796	c1 	. 
	pop hl			;0797	e1 	. 
	ret			;0798	c9 	. 
SetExtCOM:
	push hl			;0799	e5 	. 
	ld hl,fileExtCOM		;079a	21 9f 07 	! . . 
	jr SetFileExt		;079d	18 ec 	. . 
fileExtCOM:
	defb 043h		;079f	43 	C 
	defb 04fh		;07a0	4f 	O 
	defb 04dh		;07a1	4d 	M 
fileExtPAS:
	defb 050h		;07a2	50 	P 
	defb 041h		;07a3	41 	A 
	defb 053h		;07a4	53 	S 
SaveSrcFile:
	push ix		;07a5	dd e5 	. . 
	push iy		;07a7	fd e5 	. . 
	push hl			;07a9	e5 	. 
	push bc			;07aa	c5 	. 
	push de			;07ab	d5 	. 
	call SetExtPAS		;07ac	cd 87 07 	. . . 
	call SetFileName		;07af	cd 63 07 	. c . 
	call Save		;07b2	cd f5 02 	. . . 
	pop de			;07b5	d1 	. 
	jr SaveLoadEnd		;07b6	18 13 	. . 
LoadSrcFile:
	push ix		;07b8	dd e5 	. . 
	push iy		;07ba	fd e5 	. . 
	push hl			;07bc	e5 	. 
	push bc			;07bd	c5 	. 
	push hl			;07be	e5 	. 
	call SetExtPAS		;07bf	cd 87 07 	. . . 
	call SetFileName		;07c2	cd 63 07 	. c . 
	pop hl			;07c5	e1 	. 
	call Load		;07c6	cd cf 03 	. . . 
	ex de,hl			;07c9	eb 	. 
	dec de			;07ca	1b 	. 
SaveLoadEnd:
	pop bc			;07cb	c1 	. 
	pop hl			;07cc	e1 	. 
	pop iy		;07cd	fd e1 	. . 
	pop ix		;07cf	dd e1 	. . 
	ret			;07d1	c9 	. 
SaveCom:
	ld hl,l0200h		;07d2	21 00 02 	! . . 
	call SetExtCOM		;07d5	cd 99 07 	. . . 
	call SetFileName		;07d8	cd 63 07 	. c . 
	call Save		;07db	cd f5 02 	. . . 
	jp JEndPascal		;07de	c3 cb 06 	. . . 
InitRuntimeErr__:
	ld a,0c3h		;07e1	3e c3 	> . 
	ld (JReadEditIBuf__),a		;07e3	32 ce 06 	2 . . 
	ld hl,ReadEditIBuf__		;07e6	21 6f 0a 	! o . 
	ld (JReadEditIBuf__+1),hl		;07e9	22 cf 06 	" . . 
	ld hl,PrRuntimeErr		;07ec	21 f8 08 	! . . 
	ld (JPrError+1),hl		;07ef	22 d5 06 	" . . 
	ld hl,inputBuf		;07f2	21 ab 17 	! . . 
	ld (iBufCurChrAddr),hl		;07f5	22 a9 17 	" . . 
	ld hl,0000dh		;07f8	21 0d 00 	! . . 
	ld (inputBuf),hl		;07fb	22 ab 17 	" . . 
	ret			;07fe	c9 	. 
PrGetKey:
	call GetKey		;07ff	cd 81 02 	. . . 
	jp OutChr		;0802	c3 29 07 	. ) . 
PrCuL:
	ld a,008h		;0805	3e 08 	> . 
	jp OutChr		;0807	c3 29 07 	. ) . 
PrDez:
	push hl			;080a	e5 	. 
	ld b,005h		;080b	06 05 	. . 
	bit 7,h		;080d	cb 7c 	. | 
	jr z,PrDezPos1		;080f	28 08 	( . 
	ex de,hl			;0811	eb 	. 
	ld hl,00000h		;0812	21 00 00 	! . . 
	or a			;0815	b7 	. 
	sbc hl,de		;0816	ed 52 	. R 
	inc b			;0818	04 	. 
PrDezPos1:
	ld iy,hexDezTab		;0819	fd 21 70 08 	. ! p . 
PrDezNumLen:
	ld e,(iy+000h)		;081d	fd 5e 00 	. ^ . 
	ld d,(iy+001h)		;0820	fd 56 01 	. V . 
	or a			;0823	b7 	. 
	sbc hl,de		;0824	ed 52 	. R 
	jr nc,PrDezFillSpc		;0826	30 08 	0 . 
	add hl,de			;0828	19 	. 
	inc iy		;0829	fd 23 	. # 
	inc iy		;082b	fd 23 	. # 
	djnz PrDezNumLen		;082d	10 ee 	. . 
	inc b			;082f	04 	. 
PrDezFillSpc:
	ld l,a			;0830	6f 	o 
	ld a,b			;0831	78 	x 
	call PrFillSpc		;0832	cd 7a 08 	. z . 
	pop hl			;0835	e1 	. 
	bit 7,h		;0836	cb 7c 	. | 
	jr z,PrDezPos2		;0838	28 0c 	( . 
	ld a,02dh		;083a	3e 2d 	> - 
	call OutChr		;083c	cd 29 07 	. ) . 
	or a			;083f	b7 	. 
	ex de,hl			;0840	eb 	. 
	ld hl,00000h		;0841	21 00 00 	! . . 
	sbc hl,de		;0844	ed 52 	. R 
PrDezPos2:
	ld iy,hexDezTab		;0846	fd 21 70 08 	. ! p . 
	ld bc,00530h		;084a	01 30 05 	. 0 . 
PrDezConv:
	ld a,030h		;084d	3e 30 	> 0 
	ld e,(iy+000h)		;084f	fd 5e 00 	. ^ . 
	ld d,(iy+001h)		;0852	fd 56 01 	. V . 
PrDezCount:
	or a			;0855	b7 	. 
	sbc hl,de		;0856	ed 52 	. R 
	jr c,PrDezOutChr		;0858	38 03 	8 . 
	inc a			;085a	3c 	< 
	jr PrDezCount		;085b	18 f8 	. . 
PrDezOutChr:
	add hl,de			;085d	19 	. 
	cp c			;085e	b9 	. 
	jr z,PrDezSkip0		;085f	28 04 	( . 
	call OutChr		;0861	cd 29 07 	. ) . 
	dec c			;0864	0d 	. 
PrDezSkip0:
	inc iy		;0865	fd 23 	. # 
	inc iy		;0867	fd 23 	. # 
	djnz PrDezConv		;0869	10 e2 	. . 
	cp c			;086b	b9 	. 
	ret nz			;086c	c0 	. 
	jp OutChr		;086d	c3 29 07 	. ) . 
hexDezTab:

; BLOCK 'HexDezTab' (start 0x0870 end 0x0879)
HexDezTab_start:
	defb 010h		;0870	10 	. 
	defb 027h		;0871	27 	' 
	defb 0e8h		;0872	e8 	. 
	defb 003h		;0873	03 	. 
	defb 064h		;0874	64 	d 
	defb 000h		;0875	00 	. 
	defb 00ah		;0876	0a 	. 
	defb 000h		;0877	00 	. 
	defb 001h		;0878	01 	. 
	nop			;0879	00 	. 
PrFillSpc:
	sub l			;087a	95 	. 
	ret nc			;087b	d0 	. 
	neg		;087c	ed 44 	. D 
PrNSpaceA:
	ld b,a			;087e	47 	G 
PrNSpaceB:
	call PrSpace		;087f	cd 89 08 	. . . 
	djnz PrNSpaceB		;0882	10 fb 	. . 
	ret			;0884	c9 	. 
PrNL:
	ld a,00dh		;0885	3e 0d 	> . 
	jr JOutChr		;0887	18 02 	. . 
PrSpace:
	ld a,020h		;0889	3e 20 	>   
JOutChr:
	jp OutChr		;088b	c3 29 07 	. ) . 
OutNStr:
	ld a,(hl)			;088e	7e 	~ 
	inc hl			;088f	23 	# 
	call OutChr		;0890	cd 29 07 	. ) . 
	djnz OutNStr		;0893	10 f9 	. . 
	ret			;0895	c9 	. 
PrBool:
	or a			;0896	b7 	. 
	jr nz,PrTrue		;0897	20 05 	  . 
PrFalse:
	ld hl,tFalse		;0899	21 d4 08 	! . . 
	jr OutZStr		;089c	18 03 	. . 
PrTrue:
	ld hl,tTrue		;089e	21 da 08 	! . . 
OutZStr:
	ld a,(hl)			;08a1	7e 	~ 
	inc hl			;08a2	23 	# 
	or a			;08a3	b7 	. 
	ret z			;08a4	c8 	. 
	call OutChr		;08a5	cd 29 07 	. ) . 
	jr OutZStr		;08a8	18 f7 	. . 
PrHex:
	dec l			;08aa	2d 	- 
	ld a,e			;08ab	7b 	{ 
	jr z,Pr1Hex		;08ac	28 1b 	( . 
	dec l			;08ae	2d 	- 
	jr z,PrByteHex		;08af	28 0f 	( . 
	dec l			;08b1	2d 	- 
	jr z,PrWordHex		;08b2	28 07 	( . 
	dec l			;08b4	2d 	- 
	jr z,PrWordHex		;08b5	28 04 	( . 
	ld b,l			;08b7	45 	E 
	call PrNSpaceB		;08b8	cd 7f 08 	.  . 
PrWordHex:
	ld a,d			;08bb	7a 	z 
	call PrByteHex		;08bc	cd c0 08 	. . . 
	ld a,e			;08bf	7b 	{ 
PrByteHex:
	push af			;08c0	f5 	. 
	rrca			;08c1	0f 	. 
	rrca			;08c2	0f 	. 
	rrca			;08c3	0f 	. 
	rrca			;08c4	0f 	. 
	call Pr1Hex		;08c5	cd c9 08 	. . . 
	pop af			;08c8	f1 	. 
Pr1Hex:
	and 00fh		;08c9	e6 0f 	. . 
	add a,090h		;08cb	c6 90 	. . 
	daa			;08cd	27 	' 
	adc a,040h		;08ce	ce 40 	. @ 
	daa			;08d0	27 	' 
	jp OutChr		;08d1	c3 29 07 	. ) . 
tFalse:

; BLOCK 'TFalse' (start 0x08d4 end 0x08d9)
TFalse_start:
	defb 046h		;08d4	46 	F 
	defb 041h		;08d5	41 	A 
	defb 04ch		;08d6	4c 	L 
	defb 053h		;08d7	53 	S 
	defb 045h		;08d8	45 	E 
	nop			;08d9	00 	. 
tTrue:

; BLOCK 'TTrue' (start 0x08da end 0x08de)
TTrue_start:
	defb 054h		;08da	54 	T 
	defb 052h		;08db	52 	R 
	defb 055h		;08dc	55 	U 
	defb 045h		;08dd	45 	E 
	nop			;08de	00 	. 
PrRAM:
	ld de,T_RAM		;08df	11 4c 09 	. L . 
	jr PrErr2		;08e2	18 11 	. . 
l08e4h:
	pop bc			;08e4	c1 	. 
ErrNumExpected:
	pop bc			;08e5	c1 	. 
	ld de,TNumExpected		;08e6	11 a3 09 	. . . 
	jr PrErr2		;08e9	18 0a 	. . 
l08ebh:
	pop bc			;08eb	c1 	. 
	pop bc			;08ec	c1 	. 
l08edh:
	ld de,TNumTooBig		;08ed	11 95 09 	. . . 
	jr PrErr2		;08f0	18 03 	. . 
ErrOverflow:
	ld de,TUeber		;08f2	11 42 09 	. B . 
PrErr2:
	jp JPrError		;08f5	c3 d4 06 	. . . 
PrRuntimeErr:
	ex de,hl			;08f8	eb 	. 
	call OutZStr		;08f9	cd a1 08 	. . . 
	ld hl,T_beiPC		;08fc	21 39 09 	! 9 . 
	jr OutZStrOutAddr		;08ff	18 29 	. ) 
ErrDivBy0:
	ld de,TDiv0		;0901	11 53 09 	. S . 
	jr PrErr2		;0904	18 ef 	. . 
ErrIdxLow:
	ld de,TIdxLow		;0906	11 60 09 	. ` . 
	jr PrErr2		;0909	18 ea 	. . 
ErrIdxHigh:
	ld de,TIdxHigh		;090b	11 71 09 	. q . 
	jr PrErr2		;090e	18 e5 	. . 
ErrMath:
	ld de,TMathErr		;0910	11 7f 09 	.  . 
	jr PrErr2		;0913	18 e0 	. . 
Break:
	call CAOS_KBDS		;0915	cd 75 02 	. u . 
	inc a			;0918	3c 	< 
	ret nz			;0919	c0 	. 
	call GetKey		;091a	cd 81 02 	. . . 
	cp 003h		;091d	fe 03 	. . 
	jr z,PrHalt		;091f	28 06 	( . 
	call GetKey		;0921	cd 81 02 	. . . 
	cp 003h		;0924	fe 03 	. . 
	ret nz			;0926	c0 	. 
PrHalt:
	ld hl,THalt		;0927	21 34 09 	! 4 . 
OutZStrOutAddr:
	call OutZStr		;092a	cd a1 08 	. . . 
	pop de			;092d	d1 	. 
	call PrWordHex		;092e	cd bb 08 	. . . 
	jp Reset		;0931	c3 dd 06 	. . . 
THalt:

; BLOCK 'TErrMsg' (start 0x0934 end 0x09b1)
TErrMsg_start:
	defb 00dh		;0934	0d 	. 
	defb 048h		;0935	48 	H 
	defb 061h		;0936	61 	a 
	defb 06ch		;0937	6c 	l 
	defb 074h		;0938	74 	t 
T_beiPC:
	defb 020h		;0939	20 	  
	defb 062h		;093a	62 	b 
	defb 065h		;093b	65 	e 
	defb 069h		;093c	69 	i 
	defb 020h		;093d	20 	  
	defb 050h		;093e	50 	P 
	defb 043h		;093f	43 	C 
	defb 03dh		;0940	3d 	= 
	defb 000h		;0941	00 	. 
TUeber:
	defb 055h		;0942	55 	U 
	defb 065h		;0943	65 	e 
	defb 062h		;0944	62 	b 
	defb 065h		;0945	65 	e 
	defb 072h		;0946	72 	r 
	defb 06ch		;0947	6c 	l 
	defb 061h		;0948	61 	a 
	defb 075h		;0949	75 	u 
	defb 066h		;094a	66 	f 
	defb 000h		;094b	00 	. 
T_RAM:
	defb 03eh		;094c	3e 	> 
	defb 03eh		;094d	3e 	> 
	defb 020h		;094e	20 	  
	defb 052h		;094f	52 	R 
	defb 041h		;0950	41 	A 
	defb 04dh		;0951	4d 	M 
	defb 000h		;0952	00 	. 
TDiv0:
	defb 02fh		;0953	2f 	/ 
	defb 020h		;0954	20 	  
	defb 064h		;0955	64 	d 
	defb 075h		;0956	75 	u 
	defb 072h		;0957	72 	r 
	defb 063h		;0958	63 	c 
	defb 068h		;0959	68 	h 
	defb 020h		;095a	20 	  
	defb 04eh		;095b	4e 	N 
	defb 075h		;095c	75 	u 
	defb 06ch		;095d	6c 	l 
	defb 06ch		;095e	6c 	l 
	defb 000h		;095f	00 	. 
TIdxLow:
	defb 049h		;0960	49 	I 
	defb 06eh		;0961	6e 	n 
	defb 064h		;0962	64 	d 
	defb 065h		;0963	65 	e 
	defb 078h		;0964	78 	x 
	defb 020h		;0965	20 	  
	defb 07ah		;0966	7a 	z 
	defb 075h		;0967	75 	u 
	defb 020h		;0968	20 	  
	defb 06eh		;0969	6e 	n 
	defb 069h		;096a	69 	i 
	defb 065h		;096b	65 	e 
	defb 064h		;096c	64 	d 
	defb 072h		;096d	72 	r 
	defb 069h		;096e	69 	i 
	defb 067h		;096f	67 	g 
	defb 000h		;0970	00 	. 
TIdxHigh:
	defb 049h		;0971	49 	I 
	defb 06eh		;0972	6e 	n 
	defb 064h		;0973	64 	d 
	defb 065h		;0974	65 	e 
	defb 078h		;0975	78 	x 
	defb 020h		;0976	20 	  
	defb 07ah		;0977	7a 	z 
	defb 075h		;0978	75 	u 
	defb 020h		;0979	20 	  
	defb 068h		;097a	68 	h 
	defb 06fh		;097b	6f 	o 
	defb 063h		;097c	63 	c 
	defb 068h		;097d	68 	h 
	defb 000h		;097e	00 	. 
TMathErr:
	defb 06dh		;097f	6d 	m 
	defb 061h		;0980	61 	a 
	defb 074h		;0981	74 	t 
	defb 068h		;0982	68 	h 
	defb 065h		;0983	65 	e 
	defb 06dh		;0984	6d 	m 
	defb 061h		;0985	61 	a 
	defb 074h		;0986	74 	t 
	defb 069h		;0987	69 	i 
	defb 073h		;0988	73 	s 
	defb 063h		;0989	63 	c 
	defb 068h		;098a	68 	h 
	defb 065h		;098b	65 	e 
	defb 072h		;098c	72 	r 
	defb 020h		;098d	20 	  
	defb 046h		;098e	46 	F 
l098fh:
	defb 065h		;098f	65 	e 
	defb 068h		;0990	68 	h 
	defb 06ch		;0991	6c 	l 
	defb 065h		;0992	65 	e 
	defb 072h		;0993	72 	r 
	defb 000h		;0994	00 	. 
TNumTooBig:
	defb 05ah		;0995	5a 	Z 
	defb 061h		;0996	61 	a 
	defb 068h		;0997	68 	h 
	defb 06ch		;0998	6c 	l 
	defb 020h		;0999	20 	  
	defb 07ah		;099a	7a 	z 
	defb 075h		;099b	75 	u 
	defb 020h		;099c	20 	  
	defb 067h		;099d	67 	g 
	defb 072h		;099e	72 	r 
	defb 06fh		;099f	6f 	o 
	defb 07eh		;09a0	7e 	~ 
	defb 000h		;09a1	00 	. 
TEmpty:
	defb 000h		;09a2	00 	. 
TNumExpected:
	defb 05ah		;09a3	5a 	Z 
	defb 061h		;09a4	61 	a 
	defb 068h		;09a5	68 	h 
	defb 06ch		;09a6	6c 	l 
	defb 020h		;09a7	20 	  
	defb 065h		;09a8	65 	e 
	defb 072h		;09a9	72 	r 
l09aah:
	defb 077h		;09aa	77 	w 
	defb 061h		;09ab	61 	a 
	defb 072h		;09ac	72 	r 
	defb 074h		;09ad	74 	t 
	defb 065h		;09ae	65 	e 
	defb 074h		;09af	74 	t 
	defb 000h		;09b0	00 	. 
sub_09b1h:
	ld d,ixh		;09b1	dd 54 	. T 
	ld e,ixl		;09b3	dd 5d 	. ] 
l09b5h:
	ex de,hl			;09b5	eb 	. 
	ld e,(hl)			;09b6	5e 	^ 
	inc hl			;09b7	23 	# 
	ld d,(hl)			;09b8	56 	V 
	djnz l09b5h		;09b9	10 fa 	. . 
	ret			;09bb	c9 	. 
Mul8x8:
	xor a			;09bc	af 	. 
	sbc hl,de		;09bd	ed 52 	. R 
	add hl,de			;09bf	19 	. 
	jr nc,l09c3h		;09c0	30 01 	0 . 
	ex de,hl			;09c2	eb 	. 
l09c3h:
	or d			;09c3	b2 	. 
	scf			;09c4	37 	7 
	ret nz			;09c5	c0 	. 
	or e			;09c6	b3 	. 
	ld e,d			;09c7	5a 	Z 
	jr nz,l09d1h		;09c8	20 07 	  . 
	ex de,hl			;09ca	eb 	. 
	ret			;09cb	c9 	. 
l09cch:
	ex de,hl			;09cc	eb 	. 
	add hl,de			;09cd	19 	. 
	ex de,hl			;09ce	eb 	. 
l09cfh:
	add hl,hl			;09cf	29 	) 
	ret c			;09d0	d8 	. 
l09d1h:
	rra			;09d1	1f 	. 
	jr nc,l09cfh		;09d2	30 fb 	0 . 
	or a			;09d4	b7 	. 
l09d5h:
	jr nz,l09cch		;09d5	20 f5 	  . 
	add hl,de			;09d7	19 	. 
l09d8h:
	ret			;09d8	c9 	. 
JErrOverflow:
	jp ErrOverflow		;09d9	c3 f2 08 	. . . 
Mul16x8sgn:
	ld a,d			;09dc	7a 	z 
	xor h			;09dd	ac 	. 
	ld b,a			;09de	47 	G 
	call AbsHL		;09df	cd 0e 0a 	. . . 
	ex de,hl			;09e2	eb 	. 
l09e3h:
	call AbsHL		;09e3	cd 0e 0a 	. . . 
	xor a			;09e6	af 	. 
	sbc hl,de		;09e7	ed 52 	. R 
	add hl,de			;09e9	19 	. 
	jr nc,l09edh		;09ea	30 01 	0 . 
	ex de,hl			;09ec	eb 	. 
l09edh:
	or d			;09ed	b2 	. 
	jr nz,JErrOverflow		;09ee	20 e9 	  . 
	or e			;09f0	b3 	. 
	ld e,d			;09f1	5a 	Z 
l09f2h:
	jp nz,l09fdh		;09f2	c2 fd 09 	. . . 
	ex de,hl			;09f5	eb 	. 
	ret			;09f6	c9 	. 
l09f7h:
	ex de,hl			;09f7	eb 	. 
	add hl,de			;09f8	19 	. 
	ex de,hl			;09f9	eb 	. 
l09fah:
	add hl,hl			;09fa	29 	) 
	jr c,JErrOverflow		;09fb	38 dc 	8 . 
l09fdh:
	rra			;09fd	1f 	. 
	jr nc,l09fah		;09fe	30 fa 	0 . 
	or a			;0a00	b7 	. 
	jr nz,l09f7h		;0a01	20 f4 	  . 
	adc hl,de		;0a03	ed 5a 	. Z 
l0a05h:
	jr c,JErrOverflow		;0a05	38 d2 	8 . 
	jp m,JErrOverflow		;0a07	fa d9 09 	. . . 
	or b			;0a0a	b0 	. 
	ret p			;0a0b	f0 	. 
	jr NegHL		;0a0c	18 03 	. . 
AbsHL:
	ld a,h			;0a0e	7c 	| 
	or a			;0a0f	b7 	. 
	ret p			;0a10	f0 	. 
NegHL:
	xor a			;0a11	af 	. 
	sub l			;0a12	95 	. 
	ld l,a			;0a13	6f 	o 
	ld a,000h		;0a14	3e 00 	> . 
	sbc a,h			;0a16	9c 	. 
	ld h,a			;0a17	67 	g 
	ret			;0a18	c9 	. 
Div:
	ld a,h			;0a19	7c 	| 
	or l			;0a1a	b5 	. 
	jp z,ErrDivBy0		;0a1b	ca 01 09 	. . . 
	ld a,h			;0a1e	7c 	| 
	push de			;0a1f	d5 	. 
	xor d			;0a20	aa 	. 
	push af			;0a21	f5 	. 
	xor a			;0a22	af 	. 
	or h			;0a23	b4 	. 
	call p,NegHL		;0a24	f4 11 0a 	. . . 
	ld b,h			;0a27	44 	D 
	ld c,l			;0a28	4d 	M 
	ld hl,00000h		;0a29	21 00 00 	! . . 
	ex de,hl			;0a2c	eb 	. 
	call AbsHL		;0a2d	cd 0e 0a 	. . . 
	or l			;0a30	b5 	. 
	jp z,l0a49h		;0a31	ca 49 0a 	. I . 
	ld a,011h		;0a34	3e 11 	> . 
l0a36h:
	add hl,hl			;0a36	29 	) 
	dec a			;0a37	3d 	= 
	jr nc,l0a36h		;0a38	30 fc 	0 . 
	ex de,hl			;0a3a	eb 	. 
l0a3bh:
	adc hl,hl		;0a3b	ed 6a 	. j 
	add hl,bc			;0a3d	09 	. 
	jr c,l0a42h		;0a3e	38 02 	8 . 
	sbc hl,bc		;0a40	ed 42 	. B 
l0a42h:
	rl e		;0a42	cb 13 	. . 
	rl d		;0a44	cb 12 	. . 
	dec a			;0a46	3d 	= 
	jr nz,l0a3bh		;0a47	20 f2 	  . 
l0a49h:
	pop af			;0a49	f1 	. 
	ex de,hl			;0a4a	eb 	. 
	call m,NegHL		;0a4b	fc 11 0a 	. . . 
	ex de,hl			;0a4e	eb 	. 
	pop af			;0a4f	f1 	. 
	or a			;0a50	b7 	. 
	ret p			;0a51	f0 	. 
	jr NegHL		;0a52	18 bd 	. . 
CurrCharIsNum:
	call GetCurIBufChr		;0a54	cd 68 0a 	. h . 
IsNum:
	cp 030h		;0a57	fe 30 	. 0 
	ccf			;0a59	3f 	? 
	ret nc			;0a5a	d0 	. 
	cp 03ah		;0a5b	fe 3a 	. : 
	ret			;0a5d	c9 	. 
IsEOL:
	call GetCurIBufChr		;0a5e	cd 68 0a 	. h . 
	cp 00dh		;0a61	fe 0d 	. . 
	ld a,000h		;0a63	3e 00 	> . 
	ret nz			;0a65	c0 	. 
	inc a			;0a66	3c 	< 
	ret			;0a67	c9 	. 
GetCurIBufChr:
	push hl			;0a68	e5 	. 
	ld hl,(iBufCurChrAddr)		;0a69	2a a9 17 	* . . 
	ld a,(hl)			;0a6c	7e 	~ 
	pop hl			;0a6d	e1 	. 
	ret			;0a6e	c9 	. 
ReadEditIBuf__:
	call GetCurIBufChr		;0a6f	cd 68 0a 	. h . 
EditIBuf__:
	push hl			;0a72	e5 	. 
	push de			;0a73	d5 	. 
	push bc			;0a74	c5 	. 
	push af			;0a75	f5 	. 
	call ReadIBufOrEdit		;0a76	cd 7e 0a 	. ~ . 
	pop af			;0a79	f1 	. 
	pop bc			;0a7a	c1 	. 
	pop de			;0a7b	d1 	. 
	pop hl			;0a7c	e1 	. 
	ret			;0a7d	c9 	. 
ReadIBufOrEdit:
	ld hl,(iBufCurChrAddr)		;0a7e	2a a9 17 	* . . 
	inc hl			;0a81	23 	# 
	ld a,(hl)			;0a82	7e 	~ 
	ld (iBufCurChrAddr),hl		;0a83	22 a9 17 	" . . 
	or a			;0a86	b7 	. 
	ret nz			;0a87	c0 	. 
	ld d,000h		;0a88	16 00 	. . 
	exx			;0a8a	d9 	. 
	ld hl,inputBuf		;0a8b	21 ab 17 	! . . 
	ld d,000h		;0a8e	16 00 	. . 
	push hl			;0a90	e5 	. 
	call EditLine		;0a91	cd af 0a 	. . . 
	pop hl			;0a94	e1 	. 
	jp nc,Reset		;0a95	d2 dd 06 	. . . 
	ld (iBufCurChrAddr),hl		;0a98	22 a9 17 	" . . 
	ld c,000h		;0a9b	0e 00 	. . 
	cpir		;0a9d	ed b1 	. . 
	ld (hl),000h		;0a9f	36 00 	6 . 
	ret			;0aa1	c9 	. 
l0aa2h:
	call JReadEditIBuf__		;0aa2	cd ce 06 	. . . 
	cp 00dh		;0aa5	fe 0d 	. . 
	jr nz,l0aa2h		;0aa7	20 f9 	  . 
	ret			;0aa9	c9 	. 
EditSrcLine__:
	ld d,006h		;0aaa	16 06 	. . 
l0aach:
	ld hl,lineBuf		;0aac	21 01 18 	! . . 
EditLine:
	ld c,051h		;0aaf	0e 51 	. Q 
	ld e,000h		;0ab1	1e 00 	. . 
l0ab3h:
	ld a,028h		;0ab3	3e 28 	> ( 
	sub d			;0ab5	92 	. 
	ld b,a			;0ab6	47 	G 
LineEdLoop__:
	exx			;0ab7	d9 	. 
	bit 1,d		;0ab8	cb 4a 	. J 
	exx			;0aba	d9 	. 
	ret nz			;0abb	c0 	. 
LineEdNextLine__:
	ld a,b			;0abc	78 	x 
	and 003h		;0abd	e6 03 	. . 
	jr nz,l0ac5h		;0abf	20 04 	  . 
	exx			;0ac1	d9 	. 
	res 4,d		;0ac2	cb a2 	. . 
	exx			;0ac4	d9 	. 
l0ac5h:
	ld a,020h		;0ac5	3e 20 	>   
	exx			;0ac7	d9 	. 
	bit 4,d		;0ac8	cb 62 	. b 
	jr nz,ChkCuUp		;0aca	20 08 	  . 
	bit 0,d		;0acc	cb 42 	. B 
	exx			;0ace	d9 	. 
	ld a,(hl)			;0acf	7e 	~ 
	exx			;0ad0	d9 	. 
	call z,GetKey		;0ad1	cc 81 02 	. . . 
ChkCuUp:
	exx			;0ad4	d9 	. 
	cp 00bh		;0ad5	fe 0b 	. . 
	jr nz,l0adfh		;0ad7	20 06 	  . 
	exx			;0ad9	d9 	. 
	set 4,d		;0ada	cb e2 	. . 
	exx			;0adc	d9 	. 
	jr l0ac5h		;0add	18 e6 	. . 
l0adfh:
	cp 002h		;0adf	fe 02 	. . 
	jr nz,TestBreakLEdi		;0ae1	20 0b 	  . 
	inc e			;0ae3	1c 	. 
	dec e			;0ae4	1d 	. 
	jr z,LineEdLoop__		;0ae5	28 d0 	( . 
LinEdDelLine__:
	call LineEdCuL__		;0ae7	cd 41 0b 	. A . 
	jr nz,LinEdDelLine__		;0aea	20 fb 	  . 
l0aech:
	jr l0ab3h		;0aec	18 c5 	. . 
TestBreakLEdi:
	cp 003h		;0aee	fe 03 	. . 
	jp z,Reset		;0af0	ca dd 06 	. . . 
	cp 008h		;0af3	fe 08 	. . 
	jr nz,TestCuD		;0af5	20 07 	  . 
ItsCuL:
	inc e			;0af7	1c 	. 
	dec e			;0af8	1d 	. 
	call nz,LineEdCuL__		;0af9	c4 41 0b 	. A . 
	jr LineEdLoop__		;0afc	18 b9 	. . 
TestCuD:
	cp 010h		;0afe	fe 10 	. . 
l0b00h:
	jr nz,TestEnter		;0b00	20 05 	  . 
	call OutChr		;0b02	cd 29 07 	. ) . 
	jr LineEdNextLine__		;0b05	18 b5 	. . 
TestEnter:
	cp 00dh		;0b07	fe 0d 	. . 
	jr z,l0b1ah		;0b09	28 0f 	( . 
	cp 00ch		;0b0b	fe 0c 	. . 
	jr nz,TestPrintableChr		;0b0d	20 06 	  . 
	call OutChr		;0b0f	cd 29 07 	. ) . 
	jp l0aach		;0b12	c3 ac 0a 	. . . 
TestPrintableChr:
	cp 020h		;0b15	fe 20 	.   
	jr c,LineEdLoop__		;0b17	38 9e 	8 . 
	ccf			;0b19	3f 	? 
l0b1ah:
	ld (hl),a			;0b1a	77 	w 
	inc hl			;0b1b	23 	# 
	push af			;0b1c	f5 	. 
	call OutChr		;0b1d	cd 29 07 	. ) . 
	pop af			;0b20	f1 	. 
	ccf			;0b21	3f 	? 
	ret c			;0b22	d8 	. 
	inc e			;0b23	1c 	. 
	dec b			;0b24	05 	. 
	dec c			;0b25	0d 	. 
	jr z,ItsCuL		;0b26	28 cf 	( . 
	inc b			;0b28	04 	. 
	dec b			;0b29	05 	. 
	jr nz,LineEdLoop__		;0b2a	20 8b 	  . 
	exx			;0b2c	d9 	. 
	dec e			;0b2d	1d 	. 
	exx			;0b2e	d9 	. 
	ld b,d			;0b2f	42 	B 
	inc b			;0b30	04 	. 
	dec b			;0b31	05 	. 
	jp z,l0ab3h		;0b32	ca b3 0a 	. . . 
	push hl			;0b35	e5 	. 
	ld hl,printFlag		;0b36	21 12 07 	! . . 
	bit 0,(hl)		;0b39	cb 46 	. F 
	pop hl			;0b3b	e1 	. 
	call z,PrNSpaceB		;0b3c	cc 7f 08 	.  . 
	jr l0aech		;0b3f	18 ab 	. . 
LineEdCuL__:
	ld a,028h		;0b41	3e 28 	> ( 
	sub d			;0b43	92 	. 
	cp b			;0b44	b8 	. 
	jr nz,l0b51h		;0b45	20 0a 	  . 
	ld b,d			;0b47	42 	B 
	inc b			;0b48	04 	. 
	dec b			;0b49	05 	. 
	jr z,l0b51h		;0b4a	28 05 	( . 
DelLineNum__:
	call PrCuL		;0b4c	cd 05 08 	. . . 
	djnz DelLineNum__		;0b4f	10 fb 	. . 
l0b51h:
	inc b			;0b51	04 	. 
	call PrCuL		;0b52	cd 05 08 	. . . 
	exx			;0b55	d9 	. 
	res 4,d		;0b56	cb a2 	. . 
	exx			;0b58	d9 	. 
	dec hl			;0b59	2b 	+ 
	inc c			;0b5a	0c 	. 
	dec e			;0b5b	1d 	. 
	ret			;0b5c	c9 	. 
MulBy10_HL_DE:
	add hl,hl			;0b5d	29 	) 
	rl e		;0b5e	cb 13 	. . 
	rl d		;0b60	cb 12 	. . 
	push de			;0b62	d5 	. 
	push hl			;0b63	e5 	. 
	add hl,hl			;0b64	29 	) 
	rl e		;0b65	cb 13 	. . 
	rl d		;0b67	cb 12 	. . 
	add hl,hl			;0b69	29 	) 
	rl e		;0b6a	cb 13 	. . 
	rl d		;0b6c	cb 12 	. . 
	pop bc			;0b6e	c1 	. 
	add hl,bc			;0b6f	09 	. 
	ex de,hl			;0b70	eb 	. 
	pop bc			;0b71	c1 	. 
	adc hl,bc		;0b72	ed 4a 	. J 
	ex de,hl			;0b74	eb 	. 
	ret			;0b75	c9 	. 
sub_0b76h:
	call IsNum		;0b76	cd 57 0a 	. W . 
	jp nc,l08e4h		;0b79	d2 e4 08 	. . . 
	ld hl,00000h		;0b7c	21 00 00 	! . . 
	ld d,h			;0b7f	54 	T 
	ld e,l			;0b80	5d 	] 
	ld b,007h		;0b81	06 07 	. . 
	push bc			;0b83	c5 	. 
	jr l0b8ah		;0b84	18 04 	. . 
l0b86h:
	push bc			;0b86	c5 	. 
	call MulBy10_HL_DE		;0b87	cd 5d 0b 	. ] . 
l0b8ah:
	sub 030h		;0b8a	d6 30 	. 0 
	ld c,a			;0b8c	4f 	O 
	ld b,d			;0b8d	42 	B 
	add hl,bc			;0b8e	09 	. 
	jr nc,l0b92h		;0b8f	30 01 	0 . 
	inc de			;0b91	13 	. 
l0b92h:
	call CurrCharIsNum		;0b92	cd 54 0a 	. T . 
	pop bc			;0b95	c1 	. 
	dec b			;0b96	05 	. 
	ret nc			;0b97	d0 	. 
	call EditIBuf__		;0b98	cd 72 0a 	. r . 
	jr nz,l0b86h		;0b9b	20 e9 	  . 
l0b9dh:
	inc d			;0b9d	14 	. 
	call CurrCharIsNum		;0b9e	cd 54 0a 	. T . 
	ret nc			;0ba1	d0 	. 
	call EditIBuf__		;0ba2	cd 72 0a 	. r . 
	jr l0b9dh		;0ba5	18 f6 	. . 
l0ba7h:
	call JReadEditIBuf__		;0ba7	cd ce 06 	. . . 
	cp 020h		;0baa	fe 20 	.   
	jr z,l0ba7h		;0bac	28 f9 	( . 
	cp 00dh		;0bae	fe 0d 	. . 
	ret nz			;0bb0	c0 	. 
	jr l0ba7h		;0bb1	18 f4 	. . 
sub_0bb3h:
	call l0ba7h		;0bb3	cd a7 0b 	. . . 
	cp 02dh		;0bb6	fe 2d 	. - 
	jr z,l0bcch		;0bb8	28 12 	( . 
	cp 02bh		;0bba	fe 2b 	. + 
sub_0bbch:
	call z,JReadEditIBuf__		;0bbc	cc ce 06 	. . . 
	call sub_0b76h		;0bbf	cd 76 0b 	. v . 
	ld a,d			;0bc2	7a 	z 
	or e			;0bc3	b3 	. 
	jr nz,l0bc9h		;0bc4	20 03 	  . 
	bit 7,h		;0bc6	cb 7c 	. | 
	ret z			;0bc8	c8 	. 
l0bc9h:
	jp l08edh		;0bc9	c3 ed 08 	. . . 
l0bcch:
	call sub_0bbch		;0bcc	cd bc 0b 	. . . 
	ex de,hl			;0bcf	eb 	. 
	or a			;0bd0	b7 	. 
	sbc hl,de		;0bd1	ed 52 	. R 
	ret			;0bd3	c9 	. 
l0bd4h:
	call GetCurIBufChr		;0bd4	cd 68 0a 	. h . 
	cp 00dh		;0bd7	fe 0d 	. . 
	jr z,l0be3h		;0bd9	28 08 	( . 
	ld (hl),a			;0bdb	77 	w 
	inc hl			;0bdc	23 	# 
	call EditIBuf__		;0bdd	cd 72 0a 	. r . 
	djnz l0bd4h		;0be0	10 f2 	. . 
	ret			;0be2	c9 	. 
l0be3h:
	xor a			;0be3	af 	. 
l0be4h:
	ld (hl),a			;0be4	77 	w 
	inc hl			;0be5	23 	# 
	djnz l0be4h		;0be6	10 fc 	. . 
	ret			;0be8	c9 	. 
sub_0be9h:
	ld hl,00002h		;0be9	21 02 00 	! . . 
	add hl,sp			;0bec	39 	9 
	ld c,a			;0bed	4f 	O 
	xor a			;0bee	af 	. 
	srl c		;0bef	cb 39 	. 9 
	rra			;0bf1	1f 	. 
	srl c		;0bf2	cb 39 	. 9 
	rra			;0bf4	1f 	. 
	srl c		;0bf5	cb 39 	. 9 
	rla			;0bf7	17 	. 
	rla			;0bf8	17 	. 
	rla			;0bf9	17 	. 
	ld b,a			;0bfa	47 	G 
	inc b			;0bfb	04 	. 
	xor a			;0bfc	af 	. 
	scf			;0bfd	37 	7 
l0bfeh:
	adc a,a			;0bfe	8f 	. 
	djnz l0bfeh		;0bff	10 fd 	. . 
	add hl,bc			;0c01	09 	. 
	ret			;0c02	c9 	. 
sub_0c03h:
	inc a			;0c03	3c 	< 
	ld b,a			;0c04	47 	G 
l0c05h:
	ld a,(hl)			;0c05	7e 	~ 
	or d			;0c06	b2 	. 
	ld (hl),a			;0c07	77 	w 
	rlc d		;0c08	cb 02 	. . 
	jr nc,l0c0dh		;0c0a	30 01 	0 . 
	inc hl			;0c0c	23 	# 
l0c0dh:
	djnz l0c05h		;0c0d	10 f6 	. . 
	ret			;0c0f	c9 	. 
InitLocVar_CaPrc__:
	pop hl			;0c10	e1 	. 
	ld (retAddr__),hl		;0c11	22 89 17 	" . . 
	xor a			;0c14	af 	. 
	ld b,a			;0c15	47 	G 
	ld l,a			;0c16	6f 	o 
	ld h,a			;0c17	67 	g 
	sbc hl,bc		;0c18	ed 42 	. B 
	add hl,sp			;0c1a	39 	9 
	ld d,h			;0c1b	54 	T 
	ld e,l			;0c1c	5d 	] 
	dec hl			;0c1d	2b 	+ 
	ld sp,hl			;0c1e	f9 	. 
	ld (hl),a			;0c1f	77 	w 
	ldir		;0c20	ed b0 	. . 
	ld hl,(retAddr__)		;0c22	2a 89 17 	* . . 
sub_0c25h:
	jp (hl)			;0c25	e9 	. 
MaskBytes__:
	pop hl			;0c26	e1 	. 
	ld (retAddr__),hl		;0c27	22 89 17 	" . . 
	ld hl,00000h		;0c2a	21 00 00 	! . . 
	add hl,sp			;0c2d	39 	9 
	ld d,h			;0c2e	54 	T 
	ld e,l			;0c2f	5d 	] 
	add hl,bc			;0c30	09 	. 
	ld b,c			;0c31	41 	A 
l0c32h:
	ld a,(de)			;0c32	1a 	. 
opCodes:
	defb 002h		;0c33	02 	. 
	defb 000h		;0c34	00 	. 
	ld (hl),a			;0c35	77 	w 
	inc hl			;0c36	23 	# 
	inc de			;0c37	13 	. 
	djnz l0c32h		;0c38	10 f8 	. . 
	ex de,hl			;0c3a	eb 	. 
	ld sp,hl			;0c3b	f9 	. 
	ld hl,(retAddr__)		;0c3c	2a 89 17 	* . . 
	jp (hl)			;0c3f	e9 	. 
sub_0c40h:
	pop hl			;0c40	e1 	. 
	ld (retAddr__),hl		;0c41	22 89 17 	" . . 
	ld hl,00000h		;0c44	21 00 00 	! . . 
	add hl,sp			;0c47	39 	9 
	ld d,h			;0c48	54 	T 
	ld e,l			;0c49	5d 	] 
	add hl,bc			;0c4a	09 	. 
	ld b,c			;0c4b	41 	A 
l0c4ch:
	call 00000h		;0c4c	cd 00 00 	. . . 
	inc hl			;0c4f	23 	# 
	inc de			;0c50	13 	. 
	djnz l0c4ch		;0c51	10 f9 	. . 
	ld a,001h		;0c53	3e 01 	> . 
l0c55h:
	ld sp,hl			;0c55	f9 	. 
	ld hl,(retAddr__)		;0c56	2a 89 17 	* . . 
	jp (hl)			;0c59	e9 	. 
l0c5ah:
	ld a,(de)			;0c5a	1a 	. 
	cp (hl)			;0c5b	be 	. 
l0c5ch:
	ret z			;0c5c	c8 	. 
l0c5dh:
	inc hl			;0c5d	23 	# 
	djnz l0c5dh		;0c5e	10 fd 	. . 
	xor a			;0c60	af 	. 
	jr l0c55h		;0c61	18 f2 	. . 
l0c63h:
	ld a,(de)			;0c63	1a 	. 
	cpl			;0c64	2f 	/ 
	and (hl)			;0c65	a6 	. 
	jr l0c5ch		;0c66	18 f4 	. . 
l0c68h:
	ex de,hl			;0c68	eb 	. 
	ld a,(de)			;0c69	1a 	. 
	cpl			;0c6a	2f 	/ 
	and (hl)			;0c6b	a6 	. 
	ex de,hl			;0c6c	eb 	. 
	jr l0c5ch		;0c6d	18 ed 	. . 
sub_0c6fh:
	or a			;0c6f	b7 	. 
	sbc hl,de		;0c70	ed 52 	. R 
	ld a,080h		;0c72	3e 80 	> . 
	jp pe,l0c82h		;0c74	ea 82 0c 	. . . 
l0c77h:
	and h			;0c77	a4 	. 
	rlca			;0c78	07 	. 
	ret			;0c79	c9 	. 
sub_0c7ah:
	or a			;0c7a	b7 	. 
	sbc hl,de		;0c7b	ed 52 	. R 
	ld a,080h		;0c7d	3e 80 	> . 
	jp pe,l0c77h		;0c7f	ea 77 0c 	. w . 
l0c82h:
	and h			;0c82	a4 	. 
	rlca			;0c83	07 	. 
	xor 001h		;0c84	ee 01 	. . 
	ret			;0c86	c9 	. 
sub_0c87h:
	push hl			;0c87	e5 	. 
	ld hl,0ffcfh		;0c88	21 cf ff 	! . . 
	ld de,(l178bh)		;0c8b	ed 5b 8b 17 	. [ . . 
	sbc hl,de		;0c8f	ed 52 	. R 
	ex de,hl			;0c91	eb 	. 
	add hl,bc			;0c92	09 	. 
	ld (l178bh),hl		;0c93	22 8b 17 	" . . 
	pop hl			;0c96	e1 	. 
	ld (hl),e			;0c97	73 	s 
	inc hl			;0c98	23 	# 
	ld (hl),d			;0c99	72 	r 
	ret			;0c9a	c9 	. 
l0c9bh:
	pop af			;0c9b	f1 	. 
l0c9ch:
	pop bc			;0c9c	c1 	. 
	pop de			;0c9d	d1 	. 
	pop hl			;0c9e	e1 	. 
	push bc			;0c9f	c5 	. 
	ret			;0ca0	c9 	. 
sub_0ca1h:
	bit 6,h		;0ca1	cb 74 	. t 
	jr z,l0c9ch		;0ca3	28 f7 	( . 
	ld iy,00000h		;0ca5	fd 21 00 00 	. ! . . 
	add iy,sp		;0ca9	fd 39 	. 9 
	ld a,h			;0cab	7c 	| 
	ld b,(iy+005h)		;0cac	fd 46 05 	. F . 
	bit 6,b		;0caf	cb 70 	. p 
	jr z,l0cf7h		;0cb1	28 44 	( D 
	xor b			;0cb3	a8 	. 
	push af			;0cb4	f5 	. 
	push de			;0cb5	d5 	. 
	ld a,d			;0cb6	7a 	z 
	ld d,b			;0cb7	50 	P 
	ld b,e			;0cb8	43 	C 
	ld e,(iy+004h)		;0cb9	fd 5e 04 	. ^ . 
	sub (iy+003h)		;0cbc	fd 96 03 	. . . 
	jp pe,l0cfch		;0cbf	ea fc 0c 	. . . 
	jp m,l0d1ah		;0cc2	fa 1a 0d 	. . . 
	ld c,(iy+002h)		;0cc5	fd 4e 02 	. N . 
	jr z,l0d29h		;0cc8	28 5f 	( _ 
l0ccah:
	push hl			;0cca	e5 	. 
	res 7,d		;0ccb	cb ba 	. . 
l0ccdh:
	res 7,h		;0ccd	cb bc 	. . 
l0ccfh:
	srl d		;0ccf	cb 3a 	. : 
	rr e		;0cd1	cb 1b 	. . 
	rr c		;0cd3	cb 19 	. . 
	dec a			;0cd5	3d 	= 
	jr nz,l0ccfh		;0cd6	20 f7 	  . 
	ld a,b			;0cd8	78 	x 
	bit 7,(iy-001h)		;0cd9	fd cb ff 7e 	. . . ~ 
	jr nz,l0d01h		;0cdd	20 22 	  " 
l0cdfh:
	add a,c			;0cdf	81 	. 
	adc hl,de		;0ce0	ed 5a 	. Z 
	pop bc			;0ce2	c1 	. 
	pop de			;0ce3	d1 	. 
	jp po,l0cf0h		;0ce4	e2 f0 0c 	. . . 
	srl h		;0ce7	cb 3c 	. < 
	rr l		;0ce9	cb 1d 	. . 
	rra			;0ceb	1f 	. 
	inc d			;0cec	14 	. 
	jp pe,l0d11h		;0ced	ea 11 0d 	. . . 
l0cf0h:
	ld e,a			;0cf0	5f 	_ 
	ld a,b			;0cf1	78 	x 
	and 080h		;0cf2	e6 80 	. . 
	or h			;0cf4	b4 	. 
	ld h,a			;0cf5	67 	g 
l0cf6h:
	pop af			;0cf6	f1 	. 
l0cf7h:
	pop bc			;0cf7	c1 	. 
	pop af			;0cf8	f1 	. 
	pop af			;0cf9	f1 	. 
	push bc			;0cfa	c5 	. 
	ret			;0cfb	c9 	. 
l0cfch:
	pop de			;0cfc	d1 	. 
	jr nc,l0c9bh		;0cfd	30 9c 	0 . 
	jr l0cf6h		;0cff	18 f5 	. . 
l0d01h:
	sub c			;0d01	91 	. 
	sbc hl,de		;0d02	ed 52 	. R 
l0d04h:
	pop bc			;0d04	c1 	. 
l0d05h:
	pop de			;0d05	d1 	. 
l0d06h:
	bit 6,h		;0d06	cb 74 	. t 
	jr nz,l0cf0h		;0d08	20 e6 	  . 
	add a,a			;0d0a	87 	. 
	adc hl,hl		;0d0b	ed 6a 	. j 
	dec d			;0d0d	15 	. 
	jp po,l0d06h		;0d0e	e2 06 0d 	. . . 
l0d11h:
	ld sp,iy		;0d11	fd f9 	. . 
	pop bc			;0d13	c1 	. 
	pop hl			;0d14	e1 	. 
	pop hl			;0d15	e1 	. 
	push bc			;0d16	c5 	. 
	jp ErrOverflow		;0d17	c3 f2 08 	. . . 
l0d1ah:
	ld c,b			;0d1a	48 	H 
	ld b,(iy+003h)		;0d1b	fd 46 03 	. F . 
	ld (iy-003h),b		;0d1e	fd 70 fd 	. p . 
	ld b,(iy+002h)		;0d21	fd 46 02 	. F . 
	ex de,hl			;0d24	eb 	. 
	neg		;0d25	ed 44 	. D 
	jr l0ccah		;0d27	18 a1 	. . 
l0d29h:
	ld a,b			;0d29	78 	x 
	push hl			;0d2a	e5 	. 
	res 7,h		;0d2b	cb bc 	. . 
	res 7,d		;0d2d	cb ba 	. . 
	bit 7,(iy-001h)		;0d2f	fd cb ff 7e 	. . . ~ 
	jr z,l0cdfh		;0d33	28 aa 	( . 
	sub c			;0d35	91 	. 
	sbc hl,de		;0d36	ed 52 	. R 
	jr nz,l0d3dh		;0d38	20 03 	  . 
	or a			;0d3a	b7 	. 
	jr z,l0d4dh		;0d3b	28 10 	( . 
l0d3dh:
	jr nc,l0d04h		;0d3d	30 c5 	0 . 
	ld de,00000h		;0d3f	11 00 00 	. . . 
	ex de,hl			;0d42	eb 	. 
	ld c,a			;0d43	4f 	O 
	pop af			;0d44	f1 	. 
	cpl			;0d45	2f 	/ 
	ld b,a			;0d46	47 	G 
	xor a			;0d47	af 	. 
	sub c			;0d48	91 	. 
	sbc hl,de		;0d49	ed 52 	. R 
	jr l0d05h		;0d4b	18 b8 	. . 
l0d4dh:
	ld d,h			;0d4d	54 	T 
	ld e,h			;0d4e	5c 	\ 
	pop af			;0d4f	f1 	. 
	pop af			;0d50	f1 	. 
	jr l0cf6h		;0d51	18 a3 	. . 
RealSqrt__:
	pop bc			;0d53	c1 	. 
	push hl			;0d54	e5 	. 
	push de			;0d55	d5 	. 
	push bc			;0d56	c5 	. 
RealMul__:
	ld iy,00000h		;0d57	fd 21 00 00 	. ! . . 
	add iy,sp		;0d5b	fd 39 	. 9 
	ld a,040h		;0d5d	3e 40 	> @ 
	and h			;0d5f	a4 	. 
	ld b,(iy+005h)		;0d60	fd 46 05 	. F . 
	and b			;0d63	a0 	. 
	jr z,RealRes0__		;0d64	28 5e 	( ^ 
	ld a,h			;0d66	7c 	| 
	xor b			;0d67	a8 	. 
	and 080h		;0d68	e6 80 	. . 
	ld b,a			;0d6a	47 	G 
	ld a,(iy+003h)		;0d6b	fd 7e 03 	. ~ . 
	add a,d			;0d6e	82 	. 
	ld c,a			;0d6f	4f 	O 
	jp pe,l0d11h		;0d70	ea 11 0d 	. . . 
	push bc			;0d73	c5 	. 
	res 7,h		;0d74	cb bc 	. . 
	ld c,e			;0d76	4b 	K 
	xor a			;0d77	af 	. 
	ex de,hl			;0d78	eb 	. 
	ld l,(iy+002h)		;0d79	fd 6e 02 	. n . 
	ld b,008h		;0d7c	06 08 	. . 
l0d7eh:
	rr l		;0d7e	cb 1d 	. . 
	jr nc,l0d83h		;0d80	30 01 	0 . 
	add a,d			;0d82	82 	. 
l0d83h:
	rra			;0d83	1f 	. 
	djnz l0d7eh		;0d84	10 f8 	. . 
	rr l		;0d86	cb 1d 	. . 
	ld h,a			;0d88	67 	g 
	ld a,(iy+004h)		;0d89	fd 7e 04 	. ~ . 
	ld b,008h		;0d8c	06 08 	. . 
l0d8eh:
	rra			;0d8e	1f 	. 
	jr nc,l0d92h		;0d8f	30 01 	0 . 
	add hl,de			;0d91	19 	. 
l0d92h:
	rr h		;0d92	cb 1c 	. . 
	rr l		;0d94	cb 1d 	. . 
	djnz l0d8eh		;0d96	10 f6 	. . 
	rra			;0d98	1f 	. 
	ld b,007h		;0d99	06 07 	. . 
l0d9bh:
	rr (iy+005h)		;0d9b	fd cb 05 1e 	. . . . 
	jr nc,l0da4h		;0d9f	30 03 	0 . 
	add a,c			;0da1	81 	. 
	adc hl,de		;0da2	ed 5a 	. Z 
l0da4h:
	rr h		;0da4	cb 1c 	. . 
	rr l		;0da6	cb 1d 	. . 
	rra			;0da8	1f 	. 
	djnz l0d9bh		;0da9	10 f0 	. . 
	pop bc			;0dab	c1 	. 
	ld e,a			;0dac	5f 	_ 
	ld d,c			;0dad	51 	Q 
	bit 6,h		;0dae	cb 74 	. t 
	jr nz,l0db8h		;0db0	20 06 	  . 
	rl e		;0db2	cb 13 	. . 
	adc hl,hl		;0db4	ed 6a 	. j 
	jr l0dbch		;0db6	18 04 	. . 
l0db8h:
	inc d			;0db8	14 	. 
	jp pe,l0d11h		;0db9	ea 11 0d 	. . . 
l0dbch:
	ld a,b			;0dbc	78 	x 
	or h			;0dbd	b4 	. 
	ld h,a			;0dbe	67 	g 
	pop bc			;0dbf	c1 	. 
	pop af			;0dc0	f1 	. 
	pop af			;0dc1	f1 	. 
	push bc			;0dc2	c5 	. 
	ret			;0dc3	c9 	. 
RealRes0__:
	pop hl			;0dc4	e1 	. 
	pop de			;0dc5	d1 	. 
	ex (sp),hl			;0dc6	e3 	. 
	ld hl,00000h		;0dc7	21 00 00 	! . . 
	ld e,h			;0dca	5c 	\ 
	ld d,l			;0dcb	55 	U 
	ret			;0dcc	c9 	. 
RealDiv__:
	bit 6,h		;0dcd	cb 74 	. t 
	jp z,ErrDivBy0		;0dcf	ca 01 09 	. . . 
	ld iy,00000h		;0dd2	fd 21 00 00 	. ! . . 
	add iy,sp		;0dd6	fd 39 	. 9 
	ld b,(iy+005h)		;0dd8	fd 46 05 	. F . 
	bit 6,b		;0ddb	cb 70 	. p 
	jp z,RealRes0__		;0ddd	ca c4 0d 	. . . 
	ld a,(iy+003h)		;0de0	fd 7e 03 	. ~ . 
	sub d			;0de3	92 	. 
	jp pe,l0d11h		;0de4	ea 11 0d 	. . . 
	push af			;0de7	f5 	. 
	ld d,b			;0de8	50 	P 
	ld c,e			;0de9	4b 	K 
	ld e,(iy+004h)		;0dea	fd 5e 04 	. ^ . 
	ld a,d			;0ded	7a 	z 
	xor h			;0dee	ac 	. 
	and 080h		;0def	e6 80 	. . 
	res 7,d		;0df1	cb ba 	. . 
	res 7,h		;0df3	cb bc 	. . 
	push af			;0df5	f5 	. 
	ex de,hl			;0df6	eb 	. 
	ld a,(iy+002h)		;0df7	fd 7e 02 	. ~ . 
	ld b,008h		;0dfa	06 08 	. . 
l0dfch:
	sub c			;0dfc	91 	. 
	sbc hl,de		;0dfd	ed 52 	. R 
	jr nc,l0e04h		;0dff	30 03 	0 . 
	add a,c			;0e01	81 	. 
	adc hl,de		;0e02	ed 5a 	. Z 
l0e04h:
	rl (iy-004h)		;0e04	fd cb fc 16 	. . . . 
	add a,a			;0e08	87 	. 
	adc hl,hl		;0e09	ed 6a 	. j 
	djnz l0dfch		;0e0b	10 ef 	. . 
	ld b,008h		;0e0d	06 08 	. . 
l0e0fh:
	sbc hl,de		;0e0f	ed 52 	. R 
	jr nc,l0e14h		;0e11	30 01 	0 . 
	add hl,de			;0e13	19 	. 
l0e14h:
	rla			;0e14	17 	. 
	add hl,hl			;0e15	29 	) 
	djnz l0e0fh		;0e16	10 f7 	. . 
	cpl			;0e18	2f 	/ 
	ld l,a			;0e19	6f 	o 
	ld a,h			;0e1a	7c 	| 
	ld b,008h		;0e1b	06 08 	. . 
l0e1dh:
	sub d			;0e1d	92 	. 
	jr nc,l0e21h		;0e1e	30 01 	0 . 
	add a,d			;0e20	82 	. 
l0e21h:
	rl e		;0e21	cb 13 	. . 
	add a,a			;0e23	87 	. 
	djnz l0e1dh		;0e24	10 f7 	. . 
	pop bc			;0e26	c1 	. 
	ld a,c			;0e27	79 	y 
	cpl			;0e28	2f 	/ 
	ld h,a			;0e29	67 	g 
	ld a,e			;0e2a	7b 	{ 
	pop de			;0e2b	d1 	. 
	cpl			;0e2c	2f 	/ 
	bit 7,h		;0e2d	cb 7c 	. | 
	jr nz,l0e3eh		;0e2f	20 0d 	  . 
	dec d			;0e31	15 	. 
	jp pe,l0d11h		;0e32	ea 11 0d 	. . . 
l0e35h:
	ld e,a			;0e35	5f 	_ 
	ld a,h			;0e36	7c 	| 
	or b			;0e37	b0 	. 
	ld h,a			;0e38	67 	g 
	pop bc			;0e39	c1 	. 
	pop af			;0e3a	f1 	. 
	pop af			;0e3b	f1 	. 
	push bc			;0e3c	c5 	. 
	ret			;0e3d	c9 	. 
l0e3eh:
	srl h		;0e3e	cb 3c 	. < 
	rr l		;0e40	cb 1d 	. . 
	rra			;0e42	1f 	. 
	jr l0e35h		;0e43	18 f0 	. . 
sub_0e45h:
	ld a,080h		;0e45	3e 80 	> . 
	and h			;0e47	a4 	. 
	jp z,l0e52h		;0e48	ca 52 0e 	. R . 
	ex de,hl			;0e4b	eb 	. 
	ld hl,00000h		;0e4c	21 00 00 	! . . 
	sbc hl,de		;0e4f	ed 52 	. R 
	or a			;0e51	b7 	. 
l0e52h:
	ld de,00000h		;0e52	11 00 00 	. . . 
	adc hl,de		;0e55	ed 5a 	. Z 
	ret z			;0e57	c8 	. 
	ld d,00eh		;0e58	16 0e 	. . 
l0e5ah:
	bit 6,h		;0e5a	cb 74 	. t 
	jp nz,l0e64h		;0e5c	c2 64 0e 	. d . 
	add hl,hl			;0e5f	29 	) 
	dec d			;0e60	15 	. 
	jp l0e5ah		;0e61	c3 5a 0e 	. Z . 
l0e64h:
	ld e,000h		;0e64	1e 00 	. . 
	or h			;0e66	b4 	. 
	ld h,a			;0e67	67 	g 
	ret			;0e68	c9 	. 
sub_0e69h:
	bit 6,h		;0e69	cb 74 	. t 
	ret z			;0e6b	c8 	. 
	ld a,080h		;0e6c	3e 80 	> . 
	and h			;0e6e	a4 	. 
	ld c,a			;0e6f	4f 	O 
	res 7,h		;0e70	cb bc 	. . 
	ld a,00eh		;0e72	3e 0e 	> . 
	sub d			;0e74	92 	. 
	jr z,l0e81h		;0e75	28 0a 	( . 
	jp m,l0e8bh		;0e77	fa 8b 0e 	. . . 
	ld b,a			;0e7a	47 	G 
l0e7bh:
	srl h		;0e7b	cb 3c 	. < 
	rr l		;0e7d	cb 1d 	. . 
	djnz l0e7bh		;0e7f	10 fa 	. . 
l0e81h:
	inc c			;0e81	0c 	. 
	ret p			;0e82	f0 	. 
	ex de,hl			;0e83	eb 	. 
	ld hl,00000h		;0e84	21 00 00 	! . . 
	or a			;0e87	b7 	. 
	sbc hl,de		;0e88	ed 52 	. R 
	ret			;0e8a	c9 	. 
l0e8bh:
	ld hl,00000h		;0e8b	21 00 00 	! . . 
	ret			;0e8e	c9 	. 
sub_0e8fh:
	ld hl,(l1795h)		;0e8f	2a 95 17 	* . . 
	ld a,048h		;0e92	3e 48 	> H 
	and h			;0e94	a4 	. 
	jp po,l0e99h		;0e95	e2 99 0e 	. . . 
	scf			;0e98	37 	7 
l0e99h:
	rl h		;0e99	cb 14 	. . 
	res 7,h		;0e9b	cb bc 	. . 
	ld a,l			;0e9d	7d 	} 
	rr l		;0e9e	cb 1d 	. . 
	and 011h		;0ea0	e6 11 	. . 
	jp po,l0ea7h		;0ea2	e2 a7 0e 	. . . 
	set 7,h		;0ea5	cb fc 	. . 
l0ea7h:
	ld a,h			;0ea7	7c 	| 
	xor l			;0ea8	ad 	. 
	ld (l1795h),hl		;0ea9	22 95 17 	" . . 
	ld l,a			;0eac	6f 	o 
	ld h,000h		;0ead	26 00 	& . 
	ret			;0eaf	c9 	. 
	push hl			;0eb0	e5 	. 
	push de			;0eb1	d5 	. 
	ld de,0ff00h		;0eb2	11 00 ff 	. . . 
	ld hl,04000h		;0eb5	21 00 40 	! . @ 
	call sub_0ca1h		;0eb8	cd a1 0c 	. . . 
sub_0ebbh:
	bit 6,h		;0ebb	cb 74 	. t 
	ret z			;0ebd	c8 	. 
	ld a,080h		;0ebe	3e 80 	> . 
	and h			;0ec0	a4 	. 
	ld c,a			;0ec1	4f 	O 
	res 7,h		;0ec2	cb bc 	. . 
	ld a,d			;0ec4	7a 	z 
	or a			;0ec5	b7 	. 
	jp m,l0ef1h		;0ec6	fa f1 0e 	. . . 
	ld a,00eh		;0ec9	3e 0e 	> . 
	sub d			;0ecb	92 	. 
	jp c,ErrOverflow		;0ecc	da f2 08 	. . . 
	ld b,a			;0ecf	47 	G 
	xor a			;0ed0	af 	. 
	cp e			;0ed1	bb 	. 
	jp z,l0ed6h		;0ed2	ca d6 0e 	. . . 
	inc a			;0ed5	3c 	< 
l0ed6h:
	dec b			;0ed6	05 	. 
	inc b			;0ed7	04 	. 
	jp z,l0ee3h		;0ed8	ca e3 0e 	. . . 
l0edbh:
	srl h		;0edb	cb 3c 	. < 
	rr l		;0edd	cb 1d 	. . 
	adc a,000h		;0edf	ce 00 	. . 
	djnz l0edbh		;0ee1	10 f8 	. . 
l0ee3h:
	inc c			;0ee3	0c 	. 
	ret p			;0ee4	f0 	. 
	or a			;0ee5	b7 	. 
	jp z,l0eeah		;0ee6	ca ea 0e 	. . . 
	inc hl			;0ee9	23 	# 
l0eeah:
	ex de,hl			;0eea	eb 	. 
	ld hl,00000h		;0eeb	21 00 00 	! . . 
	sbc hl,de		;0eee	ed 52 	. R 
	ret			;0ef0	c9 	. 
l0ef1h:
	inc c			;0ef1	0c 	. 
	ld hl,00000h		;0ef2	21 00 00 	! . . 
	ret p			;0ef5	f0 	. 
	dec hl			;0ef6	2b 	+ 
	ret			;0ef7	c9 	. 
sub_0ef8h:
	ld hl,04000h		;0ef8	21 00 40 	! . @ 
	ld d,l			;0efb	55 	U 
	ld e,l			;0efc	5d 	] 
	ld iy,realTab1__		;0efd	fd 21 24 0f 	. ! $ . 
l0f01h:
	srl a		;0f01	cb 3f 	. ? 
	jr nc,l0f1ch		;0f03	30 17 	0 . 
	push af			;0f05	f5 	. 
	push iy		;0f06	fd e5 	. . 
	push hl			;0f08	e5 	. 
	push de			;0f09	d5 	. 
	ld h,(iy+000h)		;0f0a	fd 66 00 	. f . 
	ld l,(iy+001h)		;0f0d	fd 6e 01 	. n . 
	ld e,(iy+002h)		;0f10	fd 5e 02 	. ^ . 
	ld d,(iy+003h)		;0f13	fd 56 03 	. V . 
	call RealMul__		;0f16	cd 57 0d 	. W . 
	pop iy		;0f19	fd e1 	. . 
	pop af			;0f1b	f1 	. 
l0f1ch:
	ret z			;0f1c	c8 	. 
	ld bc,00004h		;0f1d	01 04 00 	. . . 
	add iy,bc		;0f20	fd 09 	. . 
	jr l0f01h		;0f22	18 dd 	. . 
realTab1__:

; BLOCK 'realTab1__' (start 0x0f24 end 0x0f2f)
realTab1___start:
	defb 050h		;0f24	50 	P 
	defb 000h		;0f25	00 	. 
	defb 000h		;0f26	00 	. 
	defb 003h		;0f27	03 	. 
	defb 064h		;0f28	64 	d 
	defb 000h		;0f29	00 	. 
	defb 000h		;0f2a	00 	. 
	defb 006h		;0f2b	06 	. 
	defb 04eh		;0f2c	4e 	N 
	defb 020h		;0f2d	20 	  
	defb 000h		;0f2e	00 	. 
realTab1___end:
l0f2fh:
	dec c			;0f2f	0d 	. 
	ld e,a			;0f30	5f 	_ 
	ld e,(hl)			;0f31	5e 	^ 
	djnz l0f4eh		;0f32	10 1a 	. . 
	ld b,a			;0f34	47 	G 
	dec c			;0f35	0d 	. 
	call po,04e35h		;0f36	e4 35 4e 	. 5 N 
	jp po,06ad4h		;0f39	e2 d4 6a 	. . j 
sub_0f3ch:
	ld a,d			;0f3c	7a 	z 
	cp 003h		;0f3d	fe 03 	. . 
	ret c			;0f3f	d8 	. 
	push hl			;0f40	e5 	. 
	push de			;0f41	d5 	. 
	ld bc,l5000h		;0f42	01 00 50 	. . P 
	jr nz,l0f4ch		;0f45	20 05 	  . 
	or a			;0f47	b7 	. 
	sbc hl,bc		;0f48	ed 42 	. B 
	jr c,l0f5ch		;0f4a	38 10 	8 . 
l0f4ch:
	ld h,b			;0f4c	60 	` 
	ld l,c			;0f4d	69 	i 
l0f4eh:
	ld de,00300h		;0f4e	11 00 03 	. . . 
	call RealDiv__		;0f51	cd cd 0d 	. . . 
	ld a,(l1797h)		;0f54	3a 97 17 	: . . 
	inc a			;0f57	3c 	< 
	ld (l1797h),a		;0f58	32 97 17 	2 . . 
	ret			;0f5b	c9 	. 
l0f5ch:
	pop de			;0f5c	d1 	. 
	pop hl			;0f5d	e1 	. 
	ret			;0f5e	c9 	. 
l0f5fh:
	pop af			;0f5f	f1 	. 
l0f60h:
	pop af			;0f60	f1 	. 
	ld a,(l17a5h)		;0f61	3a a5 17 	: . . 
	ld hl,(l1799h)		;0f64	2a 99 17 	* . . 
	ld de,(l179bh)		;0f67	ed 5b 9b 17 	. [ . . 
	jp l106fh		;0f6b	c3 6f 10 	. o . 
sub_0f6eh:
	ld a,e			;0f6e	7b 	{ 
	ld (l17a5h),a		;0f6f	32 a5 17 	2 . . 
	ld a,l			;0f72	7d 	} 
	ld (l1798h),a		;0f73	32 98 17 	2 . . 
	or a			;0f76	b7 	. 
	ld a,0ffh		;0f77	3e ff 	> . 
	jr z,l0f80h		;0f79	28 05 	( . 
	jp m,l0f80h		;0f7b	fa 80 0f 	. . . 
	sub l			;0f7e	95 	. 
	dec a			;0f7f	3d 	= 
l0f80h:
	add a,e			;0f80	83 	. 
	pop hl			;0f81	e1 	. 
	pop de			;0f82	d1 	. 
	ex (sp),hl			;0f83	e3 	. 
	ld (l1799h),hl		;0f84	22 99 17 	" . . 
	ld (l179bh),de		;0f87	ed 53 9b 17 	. S . . 
	rlc h		;0f8b	cb 04 	. . 
	push af			;0f8d	f5 	. 
	rrc h		;0f8e	cb 0c 	. . 
	jp p,l0f96h		;0f90	f2 96 0f 	. . . 
	res 7,h		;0f93	cb bc 	. . 
	dec a			;0f95	3d 	= 
l0f96h:
	or a			;0f96	b7 	. 
	jp m,l0f60h		;0f97	fa 60 0f 	. ` . 
	ld (l1797h),a		;0f9a	32 97 17 	2 . . 
	push hl			;0f9d	e5 	. 
	push de			;0f9e	d5 	. 
	ld hl,04000h		;0f9f	21 00 40 	! . @ 
	push hl			;0fa2	e5 	. 
	ld h,0ffh		;0fa3	26 ff 	& . 
	push hl			;0fa5	e5 	. 
	ld a,(l1798h)		;0fa6	3a 98 17 	: . . 
	call sub_0ef8h		;0fa9	cd f8 0e 	. . . 
	call RealDiv__		;0fac	cd cd 0d 	. . . 
	call sub_0ca1h		;0faf	cd a1 0c 	. . . 
	ld (l070eh),hl		;0fb2	22 0e 07 	" . . 
	ld (l179fh),de		;0fb5	ed 53 9f 17 	. S . . 
	pop af			;0fb9	f1 	. 
	ld a,0ffh		;0fba	3e ff 	> . 
	push af			;0fbc	f5 	. 
	ld a,(l1797h)		;0fbd	3a 97 17 	: . . 
	ld c,a			;0fc0	4f 	O 
	ld a,(l1798h)		;0fc1	3a 98 17 	: . . 
	add a,c			;0fc4	81 	. 
	dec a			;0fc5	3d 	= 
	ld (l1798h),a		;0fc6	32 98 17 	2 . . 
	ld a,c			;0fc9	79 	y 
l0fcah:
	push hl			;0fca	e5 	. 
	push de			;0fcb	d5 	. 
	call sub_0ef8h		;0fcc	cd f8 0e 	. . . 
	call RealDiv__		;0fcf	cd cd 0d 	. . . 
	call sub_1045h		;0fd2	cd 45 10 	. E . 
	ld a,d			;0fd5	7a 	z 
	push af			;0fd6	f5 	. 
	cp 00ah		;0fd7	fe 0a 	. . 
	jr nc,l0f5fh		;0fd9	30 84 	0 . 
	pop af			;0fdb	f1 	. 
	jp m,l1038h		;0fdc	fa 38 10 	. 8 . 
	or a			;0fdf	b7 	. 
	jr nz,l0ff7h		;0fe0	20 15 	  . 
	ld a,(l1797h)		;0fe2	3a 97 17 	: . . 
	sub b			;0fe5	90 	. 
	jr z,l0ff7h		;0fe6	28 0f 	( . 
	ld d,a			;0fe8	57 	W 
	call PrSpace		;0fe9	cd 89 08 	. . . 
	ld a,d			;0fec	7a 	z 
	dec a			;0fed	3d 	= 
	ld hl,(l070eh)		;0fee	2a 0e 07 	* . . 
	ld de,(l179fh)		;0ff1	ed 5b 9f 17 	. [ . . 
	jr l0fcah		;0ff5	18 d3 	. . 
l0ff7h:
	call sub_103dh		;0ff7	cd 3d 10 	. = . 
l0ffah:
	ld a,030h		;0ffa	3e 30 	> 0 
	add a,d			;0ffc	82 	. 
	call OutChr		;0ffd	cd 29 07 	. ) . 
l1000h:
	ld a,(l1797h)		;1000	3a 97 17 	: . . 
	cp b			;1003	b8 	. 
	jr nz,l100bh		;1004	20 05 	  . 
	ld a,02eh		;1006	3e 2e 	> . 
	call OutChr		;1008	cd 29 07 	. ) . 
l100bh:
	ld a,d			;100b	7a 	z 
	ld hl,(l17a1h)		;100c	2a a1 17 	* . . 
	ld de,(l17a3h)		;100f	ed 5b a3 17 	. [ . . 
	neg		;1013	ed 44 	. D 
	jr z,l1022h		;1015	28 0b 	( . 
	push hl			;1017	e5 	. 
	push de			;1018	d5 	. 
	ld l,a			;1019	6f 	o 
	ld h,0ffh		;101a	26 ff 	& . 
	call sub_0e45h		;101c	cd 45 0e 	. E . 
	call sub_0ca1h		;101f	cd a1 0c 	. . . 
l1022h:
	ld bc,l5000h		;1022	01 00 50 	. . P 
	push bc			;1025	c5 	. 
	ld b,003h		;1026	06 03 	. . 
	push bc			;1028	c5 	. 
	call RealMul__		;1029	cd 57 0d 	. W . 
	call sub_1045h		;102c	cd 45 10 	. E . 
	jr nc,l0ffah		;102f	30 c9 	0 . 
l1031h:
	ld a,030h		;1031	3e 30 	> 0 
	add a,d			;1033	82 	. 
	pop bc			;1034	c1 	. 
	jp OutChr		;1035	c3 29 07 	. ) . 
l1038h:
	call sub_103dh		;1038	cd 3d 10 	. = . 
	jr l1031h		;103b	18 f4 	. . 
sub_103dh:
	bit 0,c		;103d	cb 41 	. A 
	ret z			;103f	c8 	. 
	ld a,02dh		;1040	3e 2d 	> - 
	jp OutChr		;1042	c3 29 07 	. ) . 
sub_1045h:
	ld (l17a1h),hl		;1045	22 a1 17 	" . . 
	ld (l17a3h),de		;1048	ed 53 a3 17 	. S . . 
	call sub_0e69h		;104c	cd 69 0e 	. i . 
	ld d,l			;104f	55 	U 
	pop hl			;1050	e1 	. 
	pop bc			;1051	c1 	. 
	inc b			;1052	04 	. 
	push bc			;1053	c5 	. 
	ld a,(l1798h)		;1054	3a 98 17 	: . . 
	cp b			;1057	b8 	. 
	push hl			;1058	e5 	. 
	ret			;1059	c9 	. 
l105ah:
	ld hl,0117fh		;105a	21 7f 11 	!  . 
	call OutZStr		;105d	cd a1 08 	. . . 
	ld a,(l1798h)		;1060	3a 98 17 	: . . 
	inc a			;1063	3c 	< 
	ld b,a			;1064	47 	G 
	ld a,030h		;1065	3e 30 	> 0 
l1067h:
	call OutChr		;1067	cd 29 07 	. ) . 
	djnz l1067h		;106a	10 fb 	. . 
	jp OutZStr		;106c	c3 a1 08 	. . . 
l106fh:
	sub 008h		;106f	d6 08 	. . 
	jp p,l1076h		;1071	f2 76 10 	. v . 
l1074h:
	ld a,004h		;1074	3e 04 	> . 
l1076h:
	ld (l1798h),a		;1076	32 98 17 	2 . . 
	sub 005h		;1079	d6 05 	. . 
	jr c,l1083h		;107b	38 06 	8 . 
	inc a			;107d	3c 	< 
	call PrNSpaceA		;107e	cd 7e 08 	. ~ . 
	jr l1074h		;1081	18 f1 	. . 
l1083h:
	bit 6,h		;1083	cb 74 	. t 
	jr z,l105ah		;1085	28 d3 	( . 
	bit 7,h		;1087	cb 7c 	. | 
	jr z,l1091h		;1089	28 06 	( . 
	res 7,h		;108b	cb bc 	. . 
	ld a,02dh		;108d	3e 2d 	> - 
	jr l1093h		;108f	18 02 	. . 
l1091h:
	ld a,020h		;1091	3e 20 	>   
l1093h:
	call OutChr		;1093	cd 29 07 	. ) . 
	ld a,d			;1096	7a 	z 
	or a			;1097	b7 	. 
	push hl			;1098	e5 	. 
	push de			;1099	d5 	. 
	ld de,0004dh		;109a	11 4d 00 	. M . 
	ld h,d			;109d	62 	b 
	ld l,d			;109e	6a 	j 
	jp m,l1138h		;109f	fa 38 11 	. 8 . 
l10a2h:
	srl a		;10a2	cb 3f 	. ? 
	jr nc,l10ach		;10a4	30 06 	0 . 
	add hl,de			;10a6	19 	. 
l10a7h:
	ex de,hl			;10a7	eb 	. 
	add hl,hl			;10a8	29 	) 
	ex de,hl			;10a9	eb 	. 
	jr l10a2h		;10aa	18 f6 	. . 
l10ach:
	jr nz,l10a7h		;10ac	20 f9 	  . 
	ld a,h			;10ae	7c 	| 
	ld (l1797h),a		;10af	32 97 17 	2 . . 
	call sub_0ef8h		;10b2	cd f8 0e 	. . . 
	call RealDiv__		;10b5	cd cd 0d 	. . . 
	call sub_0f3ch		;10b8	cd 3c 0f 	. < . 
	push hl			;10bb	e5 	. 
	push de			;10bc	d5 	. 
l10bdh:
	ld a,(l1798h)		;10bd	3a 98 17 	: . . 
	add a,a			;10c0	87 	. 
	add a,a			;10c1	87 	. 
	ld e,a			;10c2	5f 	_ 
	ld d,000h		;10c3	16 00 	. . 
	ld hl,l116bh		;10c5	21 6b 11 	! k . 
	add hl,de			;10c8	19 	. 
	ld e,(hl)			;10c9	5e 	^ 
	inc hl			;10ca	23 	# 
	ld d,(hl)			;10cb	56 	V 
	inc hl			;10cc	23 	# 
	ld c,(hl)			;10cd	4e 	N 
	inc hl			;10ce	23 	# 
	ld h,(hl)			;10cf	66 	f 
	ld l,c			;10d0	69 	i 
	call sub_0ca1h		;10d1	cd a1 0c 	. . . 
	call sub_0f3ch		;10d4	cd 3c 0f 	. < . 
	ld b,d			;10d7	42 	B 
	inc b			;10d8	04 	. 
	inc b			;10d9	04 	. 
	ld d,e			;10da	53 	S 
	ld e,h			;10db	5c 	\ 
	ld h,l			;10dc	65 	e 
	ld l,d			;10dd	6a 	j 
	ld d,000h		;10de	16 00 	. . 
l10e0h:
	add hl,hl			;10e0	29 	) 
	rl e		;10e1	cb 13 	. . 
	rl d		;10e3	cb 12 	. . 
	djnz l10e0h		;10e5	10 f9 	. . 
	ld a,030h		;10e7	3e 30 	> 0 
	add a,d			;10e9	82 	. 
	call OutChr		;10ea	cd 29 07 	. ) . 
	ld d,000h		;10ed	16 00 	. . 
	ld a,02eh		;10ef	3e 2e 	> . 
	call OutChr		;10f1	cd 29 07 	. ) . 
	ld a,(l1798h)		;10f4	3a 98 17 	: . . 
	inc a			;10f7	3c 	< 
	ld b,a			;10f8	47 	G 
l10f9h:
	push bc			;10f9	c5 	. 
	call MulBy10_HL_DE		;10fa	cd 5d 0b 	. ] . 
	ld a,030h		;10fd	3e 30 	> 0 
	add a,d			;10ff	82 	. 
l1100h:
	call OutChr		;1100	cd 29 07 	. ) . 
	ld d,000h		;1103	16 00 	. . 
	pop bc			;1105	c1 	. 
	djnz l10f9h		;1106	10 f1 	. . 
	ld a,045h		;1108	3e 45 	> E 
	call OutChr		;110a	cd 29 07 	. ) . 
	ld a,(l1797h)		;110d	3a 97 17 	: . . 
l1110h:
	or a			;1110	b7 	. 
	jp p,l111bh		;1111	f2 1b 11 	. . . 
	neg		;1114	ed 44 	. D 
	ld c,a			;1116	4f 	O 
	ld a,02dh		;1117	3e 2d 	> - 
	jr l111eh		;1119	18 03 	. . 
l111bh:
	ld c,a			;111b	4f 	O 
	ld a,02bh		;111c	3e 2b 	> + 
l111eh:
	call OutChr		;111e	cd 29 07 	. ) . 
	ld a,c			;1121	79 	y 
	ld b,00ah		;1122	06 0a 	. . 
	ld c,030h		;1124	0e 30 	. 0 
l1126h:
	sub b			;1126	90 	. 
	jr c,l112ch		;1127	38 03 	8 . 
	inc c			;1129	0c 	. 
	jr l1126h		;112a	18 fa 	. . 
l112ch:
	add a,b			;112c	80 	. 
	add a,030h		;112d	c6 30 	. 0 
	ld b,a			;112f	47 	G 
	ld a,c			;1130	79 	y 
	call OutChr		;1131	cd 29 07 	. ) . 
	ld a,b			;1134	78 	x 
	jp OutChr		;1135	c3 29 07 	. ) . 
l1138h:
	cpl			;1138	2f 	/ 
l1139h:
	srl a		;1139	cb 3f 	. ? 
	jr nc,l1143h		;113b	30 06 	0 . 
	add hl,de			;113d	19 	. 
l113eh:
	ex de,hl			;113e	eb 	. 
	add hl,hl			;113f	29 	) 
	ex de,hl			;1140	eb 	. 
	jr l1139h		;1141	18 f6 	. . 
l1143h:
	jr nz,l113eh		;1143	20 f9 	  . 
	ld a,h			;1145	7c 	| 
	cpl			;1146	2f 	/ 
	ld (l1797h),a		;1147	32 97 17 	2 . . 
	neg		;114a	ed 44 	. D 
	call sub_0ef8h		;114c	cd f8 0e 	. . . 
	call RealMul__		;114f	cd 57 0d 	. W . 
	push hl			;1152	e5 	. 
	push de			;1153	d5 	. 
	ld a,d			;1154	7a 	z 
	or a			;1155	b7 	. 
	jp p,l10bdh		;1156	f2 bd 10 	. . . 
	ld hl,l5000h		;1159	21 00 50 	! . P 
	ld de,00300h		;115c	11 00 03 	. . . 
	call RealMul__		;115f	cd 57 0d 	. W . 
	push hl			;1162	e5 	. 
	push de			;1163	d5 	. 
	ld hl,l1797h		;1164	21 97 17 	! . . 
	dec (hl)			;1167	35 	5 
	jp l10bdh		;1168	c3 bd 10 	. . . 
l116bh:
	ld h,(hl)			;116b	66 	f 
	ei			;116c	fb 	. 
	ld h,(hl)			;116d	66 	f 
	ld h,(hl)			;116e	66 	f 
	add a,l			;116f	85 	. 
	ret m			;1170	f8 	. 
	ex de,hl			;1171	eb 	. 
	ld d,c			;1172	51 	Q 
	ld (hl),0f5h		;1173	36 f5 	6 . 
	add a,l			;1175	85 	. 
	ld b,c			;1176	41 	A 
	adc a,e			;1177	8b 	. 
	pop af			;1178	f1 	. 
	in a,(068h)		;1179	db 68 	. h 
	sub 0eeh		;117b	d6 ee 	. . 
	jp po,l2053h		;117d	e2 53 20 	. S   
	jr nc,l11b0h		;1180	30 2e 	0 . 
	nop			;1182	00 	. 
	ld b,l			;1183	45 	E 
	dec hl			;1184	2b 	+ 
	jr nc,$+50		;1185	30 30 	0 0 
	nop			;1187	00 	. 
	ld a,h			;1188	7c 	| 
	or a			;1189	b7 	. 
	jp m,ErrMath		;118a	fa 10 09 	. . . 
	ret z			;118d	c8 	. 
	ld (l179bh),de		;118e	ed 53 9b 17 	. S . . 
	ld (l1799h),hl		;1192	22 99 17 	" . . 
	sra d		;1195	cb 2a 	. * 
	ld b,004h		;1197	06 04 	. . 
l1199h:
	push bc			;1199	c5 	. 
	push hl			;119a	e5 	. 
	push de			;119b	d5 	. 
	ld bc,(l1799h)		;119c	ed 4b 99 17 	. K . . 
	push bc			;11a0	c5 	. 
	ld bc,(l179bh)		;11a1	ed 4b 9b 17 	. K . . 
	push bc			;11a5	c5 	. 
	call RealDiv__		;11a6	cd cd 0d 	. . . 
	call sub_0ca1h		;11a9	cd a1 0c 	. . . 
	dec d			;11ac	15 	. 
	pop bc			;11ad	c1 	. 
	djnz l1199h		;11ae	10 e9 	. . 
l11b0h:
	ret			;11b0	c9 	. 
sub_11b1h:
	call l0ba7h		;11b1	cd a7 0b 	. . . 
	cp 02dh		;11b4	fe 2d 	. - 
	jr z,l11c1h		;11b6	28 09 	( . 
	cp 02bh		;11b8	fe 2b 	. + 
	call z,JReadEditIBuf__		;11ba	cc ce 06 	. . . 
	call sub_11cch		;11bd	cd cc 11 	. . . 
	ret			;11c0	c9 	. 
l11c1h:
	call JReadEditIBuf__		;11c1	cd ce 06 	. . . 
	call sub_11cch		;11c4	cd cc 11 	. . . 
	ld a,080h		;11c7	3e 80 	> . 
	xor h			;11c9	ac 	. 
	ld h,a			;11ca	67 	g 
	ret			;11cb	c9 	. 
sub_11cch:
	call sub_0b76h		;11cc	cd 76 0b 	. v . 
	cp 02eh		;11cf	fe 2e 	. . 
	jp nz,l1221h		;11d1	c2 21 12 	. ! . 
	call EditIBuf__		;11d4	cd 72 0a 	. r . 
	call JReadEditIBuf__		;11d7	cd ce 06 	. . . 
	call IsNum		;11da	cd 57 0a 	. W . 
	jp nc,ErrNumExpected		;11dd	d2 e5 08 	. . . 
	dec b			;11e0	05 	. 
	inc b			;11e1	04 	. 
	ld c,d			;11e2	4a 	J 
	jr z,l11fdh		;11e3	28 18 	( . 
l11e5h:
	push bc			;11e5	c5 	. 
	call MulBy10_HL_DE		;11e6	cd 5d 0b 	. ] . 
	sub 030h		;11e9	d6 30 	. 0 
	ld c,a			;11eb	4f 	O 
	ld b,d			;11ec	42 	B 
	add hl,bc			;11ed	09 	. 
	jr nc,l11f1h		;11ee	30 01 	0 . 
	inc e			;11f0	1c 	. 
l11f1h:
	pop bc			;11f1	c1 	. 
	dec c			;11f2	0d 	. 
	call CurrCharIsNum		;11f3	cd 54 0a 	. T . 
	jr nc,l1207h		;11f6	30 0f 	0 . 
	call EditIBuf__		;11f8	cd 72 0a 	. r . 
	djnz l11e5h		;11fb	10 e8 	. . 
l11fdh:
	call CurrCharIsNum		;11fd	cd 54 0a 	. T . 
	jr nc,l1207h		;1200	30 05 	0 . 
	call EditIBuf__		;1202	cd 72 0a 	. r . 
	jr l11fdh		;1205	18 f6 	. . 
l1207h:
	ld d,c			;1207	51 	Q 
	cp 045h		;1208	fe 45 	. E 
	jr nz,l1225h		;120a	20 19 	  . 
l120ch:
	push de			;120c	d5 	. 
	call EditIBuf__		;120d	cd 72 0a 	. r . 
	call JReadEditIBuf__		;1210	cd ce 06 	. . . 
	cp 02dh		;1213	fe 2d 	. - 
	jr nz,l1228h		;1215	20 11 	  . 
	call JReadEditIBuf__		;1217	cd ce 06 	. . . 
	call sub_1290h		;121a	cd 90 12 	. . . 
	pop af			;121d	f1 	. 
	sub b			;121e	90 	. 
	jr NumToFloat__		;121f	18 11 	. . 
l1221h:
	cp 045h		;1221	fe 45 	. E 
	jr z,l120ch		;1223	28 e7 	( . 
l1225h:
	ld a,d			;1225	7a 	z 
	jr NumToFloat__		;1226	18 0a 	. . 
l1228h:
	cp 02bh		;1228	fe 2b 	. + 
	call z,JReadEditIBuf__		;122a	cc ce 06 	. . . 
	call sub_1290h		;122d	cd 90 12 	. . . 
	pop af			;1230	f1 	. 
	add a,b			;1231	80 	. 
NumToFloat__:
	ld d,016h		;1232	16 16 	. . 
	ld c,a			;1234	4f 	O 
	bit 7,e		;1235	cb 7b 	. { 
	jp nz,l1283h		;1237	c2 83 12 	. . . 
	xor a			;123a	af 	. 
	cp e			;123b	bb 	. 
	jr nz,NToF_CorrExp		;123c	20 09 	  . 
	cp l			;123e	bd 	. 
	jr nz,NToF_CorrNum		;123f	20 0a 	  . 
	cp h			;1241	bc 	. 
	jr nz,NToF_CorrNum		;1242	20 07 	  . 
	ld d,000h		;1244	16 00 	. . 
	ret			;1246	c9 	. 
NToF_CorrExp:
	bit 6,e		;1247	cb 73 	. s 
	jr nz,NToF_Convert__		;1249	20 06 	  . 
NToF_CorrNum:
	add hl,hl			;124b	29 	) 
	rl e		;124c	cb 13 	. . 
	dec d			;124e	15 	. 
	jr NToF_CorrExp		;124f	18 f6 	. . 
NToF_Convert__:
	ld b,e			;1251	43 	C 
	ld e,l			;1252	5d 	] 
	ld l,h			;1253	6c 	l 
	ld h,b			;1254	60 	` 
	ld a,c			;1255	79 	y 
	or a			;1256	b7 	. 
	ret z			;1257	c8 	. 
	push hl			;1258	e5 	. 
	push de			;1259	d5 	. 
	jp m,l1264h		;125a	fa 64 12 	. d . 
	call sub_0ef8h		;125d	cd f8 0e 	. . . 
	call RealMul__		;1260	cd 57 0d 	. W . 
	ret			;1263	c9 	. 
l1264h:
	neg		;1264	ed 44 	. D 
	cp 020h		;1266	fe 20 	.   
	jr nc,l1271h		;1268	30 07 	0 . 
	call sub_0ef8h		;126a	cd f8 0e 	. . . 
l126dh:
	call RealDiv__		;126d	cd cd 0d 	. . . 
	ret			;1270	c9 	. 
l1271h:
	sub 020h		;1271	d6 20 	.   
	call sub_0ef8h		;1273	cd f8 0e 	. . . 
	call RealDiv__		;1276	cd cd 0d 	. . . 
	push hl			;1279	e5 	. 
	push de			;127a	d5 	. 
	ld hl,l4ee2h		;127b	21 e2 4e 	! . N 
	ld de,06ad4h		;127e	11 d4 6a 	. . j 
	jr l126dh		;1281	18 ea 	. . 
l1283h:
	inc hl			;1283	23 	# 
	jr nz,l1287h		;1284	20 01 	  . 
	inc e			;1286	1c 	. 
l1287h:
	srl e		;1287	cb 3b 	. ; 
	rr h		;1289	cb 1c 	. . 
	rr l		;128b	cb 1d 	. . 
	inc d			;128d	14 	. 
	jr NToF_Convert__		;128e	18 c1 	. . 
sub_1290h:
	call IsNum		;1290	cd 57 0a 	. W . 
	jr nc,l12b1h		;1293	30 1c 	0 . 
	sub 030h		;1295	d6 30 	. 0 
	ld b,a			;1297	47 	G 
	call CurrCharIsNum		;1298	cd 54 0a 	. T . 
	ret nc			;129b	d0 	. 
	call EditIBuf__		;129c	cd 72 0a 	. r . 
	sub 030h		;129f	d6 30 	. 0 
	ld c,a			;12a1	4f 	O 
	ld a,b			;12a2	78 	x 
	add a,a			;12a3	87 	. 
	ld b,a			;12a4	47 	G 
	add a,a			;12a5	87 	. 
	add a,a			;12a6	87 	. 
	add a,b			;12a7	80 	. 
	add a,c			;12a8	81 	. 
	ld b,a			;12a9	47 	G 
	call CurrCharIsNum		;12aa	cd 54 0a 	. T . 
	jp c,l08ebh		;12ad	da eb 08 	. . . 
	ret			;12b0	c9 	. 
l12b1h:
	pop bc			;12b1	c1 	. 
	pop bc			;12b2	c1 	. 
	pop bc			;12b3	c1 	. 
	ld de,l12bah		;12b4	11 ba 12 	. . . 
	jp PrErr2		;12b7	c3 f5 08 	. . . 
l12bah:
	ld b,l			;12ba	45 	E 
	ld a,b			;12bb	78 	x 
	ld (hl),b			;12bc	70 	p 
	ld l,a			;12bd	6f 	o 
	ld l,(hl)			;12be	6e 	n 
	ld h,l			;12bf	65 	e 
	ld l,(hl)			;12c0	6e 	n 
	ld (hl),h			;12c1	74 	t 
	jr nz,$+103		;12c2	20 65 	  e 
	ld (hl),d			;12c4	72 	r 
	ld (hl),a			;12c5	77 	w 
	ld h,c			;12c6	61 	a 
	ld (hl),d			;12c7	72 	r 
	ld (hl),h			;12c8	74 	t 
	ld h,l			;12c9	65 	e 
	ld (hl),h			;12ca	74 	t 
	nop			;12cb	00 	. 
sub_12cch:
	ld a,h			;12cc	7c 	| 
	or a			;12cd	b7 	. 
	ret z			;12ce	c8 	. 
	jp m,l12f2h		;12cf	fa f2 12 	. . . 
sub_12d2h:
	bit 7,d		;12d2	cb 7a 	. z 
	ret nz			;12d4	c0 	. 
	ld b,d			;12d5	42 	B 
	inc b			;12d6	04 	. 
	ld a,e			;12d7	7b 	{ 
l12d8h:
	add a,a			;12d8	87 	. 
	adc hl,hl		;12d9	ed 6a 	. j 
	djnz l12d8h		;12db	10 fb 	. . 
	ld d,0ffh		;12dd	16 ff 	. . 
	res 7,h		;12df	cb bc 	. . 
	ld e,a			;12e1	5f 	_ 
l12e2h:
	bit 6,h		;12e2	cb 74 	. t 
	ret nz			;12e4	c0 	. 
	dec d			;12e5	15 	. 
	sla e		;12e6	cb 23 	. # 
	adc hl,hl		;12e8	ed 6a 	. j 
	jr nz,l12e2h		;12ea	20 f6 	  . 
	inc e			;12ec	1c 	. 
	dec e			;12ed	1d 	. 
	jr nz,l12e2h		;12ee	20 f2 	  . 
	ld d,e			;12f0	53 	S 
	ret			;12f1	c9 	. 
l12f2h:
	res 7,h		;12f2	cb bc 	. . 
	call sub_12d2h		;12f4	cd d2 12 	. . . 
	bit 6,h		;12f7	cb 74 	. t 
	ret z			;12f9	c8 	. 
	set 7,h		;12fa	cb fc 	. . 
	push hl			;12fc	e5 	. 
	push de			;12fd	d5 	. 
	ld hl,04000h		;12fe	21 00 40 	! . @ 
	ld d,l			;1301	55 	U 
	ld e,l			;1302	5d 	] 
	call sub_0ca1h		;1303	cd a1 0c 	. . . 
	ret			;1306	c9 	. 
	push hl			;1307	e5 	. 
	push de			;1308	d5 	. 
	ld hl,05c55h		;1309	21 55 5c 	! U \ 
	ld de,0001eh		;130c	11 1e 00 	. . . 
	call RealMul__		;130f	cd 57 0d 	. W . 
	push hl			;1312	e5 	. 
	push de			;1313	d5 	. 
	call sub_0ebbh		;1314	cd bb 0e 	. . . 
	ld (l1797h),hl		;1317	22 97 17 	" . . 
	pop de			;131a	d1 	. 
	pop hl			;131b	e1 	. 
	call sub_12cch		;131c	cd cc 12 	. . . 
	bit 6,h		;131f	cb 74 	. t 
	jr z,l1394h		;1321	28 71 	( q 
	call sub_1720h		;1323	cd 20 17 	.   . 
	exx			;1326	d9 	. 
	or a			;1327	b7 	. 
	jp m,l138fh		;1328	fa 8f 13 	. . . 
	jp z,l1398h		;132b	ca 98 13 	. . . 
	ld hl,l139fh		;132e	21 9f 13 	! . . 
l1331h:
	ld b,(hl)			;1331	46 	F 
	inc hl			;1332	23 	# 
	ld c,000h		;1333	0e 00 	. . 
	push bc			;1335	c5 	. 
	ld b,0feh		;1336	06 fe 	. . 
	push bc			;1338	c5 	. 
	exx			;1339	d9 	. 
	call sub_0ca1h		;133a	cd a1 0c 	. . . 
	exx			;133d	d9 	. 
	ld c,(hl)			;133e	4e 	N 
	inc hl			;133f	23 	# 
	ld b,(hl)			;1340	46 	F 
	inc hl			;1341	23 	# 
	push bc			;1342	c5 	. 
	ld c,(hl)			;1343	4e 	N 
	inc hl			;1344	23 	# 
	ld b,000h		;1345	06 00 	. . 
	push bc			;1347	c5 	. 
	ld c,(hl)			;1348	4e 	N 
	inc hl			;1349	23 	# 
	ld b,(hl)			;134a	46 	F 
	inc hl			;134b	23 	# 
	push bc			;134c	c5 	. 
	ld c,(hl)			;134d	4e 	N 
	ld b,004h		;134e	06 04 	. . 
	push bc			;1350	c5 	. 
	exx			;1351	d9 	. 
	push hl			;1352	e5 	. 
	push de			;1353	d5 	. 
	ld bc,0c53fh		;1354	01 3f c5 	. ? . 
	push bc			;1357	c5 	. 
	ld bc,C_ISRI		;1358	01 d6 03 	. . . 
	push bc			;135b	c5 	. 
	ld bc,063e7h		;135c	01 e7 63 	. . c 
	push bc			;135f	c5 	. 
	ld bc,l04dch		;1360	01 dc 04 	. . . 
	push bc			;1363	c5 	. 
	call RealDiv__		;1364	cd cd 0d 	. . . 
	call sub_0ca1h		;1367	cd a1 0c 	. . . 
	call sub_0ca1h		;136a	cd a1 0c 	. . . 
	call RealDiv__		;136d	cd cd 0d 	. . . 
	call sub_0ca1h		;1370	cd a1 0c 	. . . 
l1373h:
	ld a,(l1798h)		;1373	3a 98 17 	: . . 
	or a			;1376	b7 	. 
	jr z,l1386h		;1377	28 0d 	( . 
	inc a			;1379	3c 	< 
	jp nz,ErrOverflow		;137a	c2 f2 08 	. . . 
	ld a,(l1797h)		;137d	3a 97 17 	: . . 
	or a			;1380	b7 	. 
	jp p,ErrOverflow		;1381	f2 f2 08 	. . . 
	ld d,a			;1384	57 	W 
	ret			;1385	c9 	. 
l1386h:
	ld a,(l1797h)		;1386	3a 97 17 	: . . 
	or a			;1389	b7 	. 
	jp m,ErrOverflow		;138a	fa f2 08 	. . . 
	ld d,a			;138d	57 	W 
	ret			;138e	c9 	. 
l138fh:
	ld hl,l13a6h		;138f	21 a6 13 	! . . 
	jr l1331h		;1392	18 9d 	. . 
l1394h:
	ld h,040h		;1394	26 40 	& @ 
	jr l1373h		;1396	18 db 	. . 
l1398h:
	ld hl,05a82h		;1398	21 82 5a 	! . Z 
	ld e,04fh		;139b	1e 4f 	. O 
	jr l1373h		;139d	18 d4 	. . 
l139fh:
	ret nz			;139f	c0 	. 
	and d			;13a0	a2 	. 
	ld l,e			;13a1	6b 	k 
	ld a,a			;13a2	7f 	 
	halt			;13a3	76 	v 
	ld (hl),h			;13a4	74 	t 
	adc a,h			;13a5	8c 	. 
l13a6h:
	ld b,b			;13a6	40 	@ 
	dec de			;13a7	1b 	. 
	ld c,h			;13a8	4c 	L 
	rst 30h			;13a9	f7 	. 
	ld e,d			;13aa	5a 	Z 
	ld d,d			;13ab	52 	R 
	ld (de),a			;13ac	12 	. 
	ld a,h			;13ad	7c 	| 
	dec a			;13ae	3d 	= 
	jp m,ErrMath		;13af	fa 10 09 	. . . 
	ld a,d			;13b2	7a 	z 
	ld (l1797h),a		;13b3	32 97 17 	2 . . 
	ld d,000h		;13b6	16 00 	. . 
	ld bc,sub_4072h+1		;13b8	01 73 40 	. s @ 
	push bc			;13bb	c5 	. 
	ld bc,l02a1h		;13bc	01 a1 02 	. . . 
	push bc			;13bf	c5 	. 
	ld bc,0c4d2h		;13c0	01 d2 c4 	. . . 
	push bc			;13c3	c5 	. 
	ld bc,l0545h		;13c4	01 45 05 	. E . 
	push bc			;13c7	c5 	. 
	push hl			;13c8	e5 	. 
	push de			;13c9	d5 	. 
	ld bc,l5309h		;13ca	01 09 53 	. . S 
	push bc			;13cd	c5 	. 
	ld bc,l0390h		;13ce	01 90 03 	. . . 
	push bc			;13d1	c5 	. 
	ld bc,0c103h		;13d2	01 03 c1 	. . . 
	push bc			;13d5	c5 	. 
	ld bc,l0314h		;13d6	01 14 03 	. . . 
	push bc			;13d9	c5 	. 
	push hl			;13da	e5 	. 
	push de			;13db	d5 	. 
	ld bc,l41a3h		;13dc	01 a3 41 	. . A 
	push bc			;13df	c5 	. 
	ld bc,00189h		;13e0	01 89 01 	. . . 
	push bc			;13e3	c5 	. 
	ld bc,0c43ah		;13e4	01 3a c4 	. : . 
	push bc			;13e7	c5 	. 
	ld bc,0fea0h		;13e8	01 a0 fe 	. . . 
	push bc			;13eb	c5 	. 
	ld bc,06ccch		;13ec	01 cc 6c 	. . l 
	push bc			;13ef	c5 	. 
	ld bc,0fe7ch		;13f0	01 7c fe 	. | . 
	push bc			;13f3	c5 	. 
	call sub_0ca1h		;13f4	cd a1 0c 	. . . 
	call RealDiv__		;13f7	cd cd 0d 	. . . 
	call sub_0ca1h		;13fa	cd a1 0c 	. . . 
	call sub_0ca1h		;13fd	cd a1 0c 	. . . 
l1400h:
	call RealDiv__		;1400	cd cd 0d 	. . . 
sub_1403h:
	call sub_0ca1h		;1403	cd a1 0c 	. . . 
	call sub_0ca1h		;1406	cd a1 0c 	. . . 
	call RealDiv__		;1409	cd cd 0d 	. . . 
	call sub_0ca1h		;140c	cd a1 0c 	. . . 
	push hl			;140f	e5 	. 
	push de			;1410	d5 	. 
	ld a,(l1797h)		;1411	3a 97 17 	: . . 
	ld l,a			;1414	6f 	o 
	ld h,000h		;1415	26 00 	& . 
	or a			;1417	b7 	. 
	jp p,l141ch		;1418	f2 1c 14 	. . . 
	dec h			;141b	25 	% 
l141ch:
	call sub_0e45h		;141c	cd 45 0e 	. E . 
	ld bc,058b9h		;141f	01 b9 58 	. . X 
	push bc			;1422	c5 	. 
	ld bc,0ff0ch		;1423	01 0c ff 	. . . 
	push bc			;1426	c5 	. 
	call RealMul__		;1427	cd 57 0d 	. W . 
	call sub_0ca1h		;142a	cd a1 0c 	. . . 
	ret			;142d	c9 	. 
l142eh:
	ld hl,04000h		;142e	21 00 40 	! . @ 
	ld d,l			;1431	55 	U 
	ld e,l			;1432	5d 	] 
	ret			;1433	c9 	. 
	bit 6,h		;1434	cb 74 	. t 
	jr z,l142eh		;1436	28 f6 	( . 
	ld a,d			;1438	7a 	z 
	cp 0f3h		;1439	fe f3 	. . 
	jp m,l142eh		;143b	fa 2e 14 	. . . 
	call sub_1581h		;143e	cd 81 15 	. . . 
	ld b,000h		;1441	06 00 	. . 
	jr nz,l144ah		;1443	20 05 	  . 
	ld b,080h		;1445	06 80 	. . 
	call sub_156ah		;1447	cd 6a 15 	. j . 
l144ah:
	ld a,d			;144a	7a 	z 
	add a,002h		;144b	c6 02 	. . 
	ex af,af'			;144d	08 	. 
	ld a,002h		;144e	3e 02 	> . 
	jr l1466h		;1450	18 14 	. . 
	bit 6,h		;1452	cb 74 	. t 
	ret z			;1454	c8 	. 
	ld a,d			;1455	7a 	z 
	cp 0f3h		;1456	fe f3 	. . 
	ret m			;1458	f8 	. 
	push hl			;1459	e5 	. 
	call sub_1581h		;145a	cd 81 15 	. . . 
	jr nz,l1463h		;145d	20 04 	  . 
	call sub_156ah		;145f	cd 6a 15 	. j . 
	xor a			;1462	af 	. 
l1463h:
	ex af,af'			;1463	08 	. 
	xor a			;1464	af 	. 
	pop bc			;1465	c1 	. 
l1466h:
	ex af,af'			;1466	08 	. 
	xor b			;1467	a8 	. 
	cpl			;1468	2f 	/ 
	and 080h		;1469	e6 80 	. . 
	ld (l1797h),a		;146b	32 97 17 	2 . . 
	ld a,d			;146e	7a 	z 
	cp 0feh		;146f	fe fe 	. . 
	call z,sub_156ah		;1471	cc 6a 15 	. j . 
	ex af,af'			;1474	08 	. 
	add a,a			;1475	87 	. 
	ex af,af'			;1476	08 	. 
	cp 0fdh		;1477	fe fd 	. . 
	jr nz,l147eh		;1479	20 03 	  . 
	call sub_156ah		;147b	cd 6a 15 	. j . 
l147eh:
	cp 0fch		;147e	fe fc 	. . 
	ex af,af'			;1480	08 	. 
	add a,a			;1481	87 	. 
	ex af,af'			;1482	08 	. 
	jr nz,l1494h		;1483	20 0f 	  . 
	ex af,af'			;1485	08 	. 
	inc a			;1486	3c 	< 
	ex af,af'			;1487	08 	. 
	ld bc,04000h		;1488	01 00 40 	. . @ 
	push bc			;148b	c5 	. 
	ld b,0fdh		;148c	06 fd 	. . 
	push bc			;148e	c5 	. 
	set 7,h		;148f	cb fc 	. . 
	call sub_0ca1h		;1491	cd a1 0c 	. . . 
l1494h:
	ex af,af'			;1494	08 	. 
	exx			;1495	d9 	. 
	ld l,a			;1496	6f 	o 
	ld h,000h		;1497	26 00 	& . 
	ld de,xxTab__		;1499	11 97 15 	. . . 
	add hl,de			;149c	19 	. 
	ld a,(hl)			;149d	7e 	~ 
	ld (l1798h),a		;149e	32 98 17 	2 . . 
	exx			;14a1	d9 	. 
	ld (l1799h),de		;14a2	ed 53 99 17 	. S . . 
	ld (l179bh),hl		;14a6	22 9b 17 	" . . 
	call RealSqrt__		;14a9	cd 53 0d 	. S . 
	push hl			;14ac	e5 	. 
	push de			;14ad	d5 	. 
	ld bc,07a3bh		;14ae	01 3b 7a 	. ; z 
	push bc			;14b1	c5 	. 
	ld bc,00021h		;14b2	01 21 00 	. ! . 
	push bc			;14b5	c5 	. 
	ld bc,04d67h		;14b6	01 67 4d 	. g M 
	push bc			;14b9	c5 	. 
	ld bc,00157h		;14ba	01 57 01 	. W . 
	push bc			;14bd	c5 	. 
	ld bc,0e144h		;14be	01 44 e1 	. D . 
	push bc			;14c1	c5 	. 
	ld bc,000b2h		;14c2	01 b2 00 	. . . 
	push bc			;14c5	c5 	. 
	call sub_0ca1h		;14c6	cd a1 0c 	. . . 
	call RealDiv__		;14c9	cd cd 0d 	. . . 
	call sub_0ca1h		;14cc	cd a1 0c 	. . . 
	ld (l17a1h),de		;14cf	ed 53 a1 17 	. S . . 
	ld (l17a3h),hl		;14d3	22 a3 17 	" . . 
	call RealDiv__		;14d6	cd cd 0d 	. . . 
	ld c,h			;14d9	4c 	L 
	ld a,h			;14da	7c 	| 
	xor 080h		;14db	ee 80 	. . 
	ld h,a			;14dd	67 	g 
	ld (l070eh),de		;14de	ed 53 0e 07 	. S . . 
	ld (l179fh),hl		;14e2	22 9f 17 	" . . 
	ld h,c			;14e5	61 	a 
	push hl			;14e6	e5 	. 
	push de			;14e7	d5 	. 
	ld de,(l17a1h)		;14e8	ed 5b a1 17 	. [ . . 
	ld hl,(l17a3h)		;14ec	2a a3 17 	* . . 
	call sub_0ca1h		;14ef	cd a1 0c 	. . . 
	ld (l17a5h),de		;14f2	ed 53 a5 17 	. S . . 
	ld (l17a7h),hl		;14f6	22 a7 17 	" . . 
	ld a,(l1798h)		;14f9	3a 98 17 	: . . 
	srl a		;14fc	cb 3f 	. ? 
	jr c,l1529h		;14fe	38 29 	8 ) 
	or a			;1500	b7 	. 
	jr nz,l1514h		;1501	20 11 	  . 
	ld de,(l1799h)		;1503	ed 5b 99 17 	. [ . . 
	ld hl,(l179bh)		;1507	2a 9b 17 	* . . 
	inc d			;150a	14 	. 
l150bh:
	call sub_155dh		;150b	cd 5d 15 	. ] . 
l150eh:
	ld a,(l1797h)		;150e	3a 97 17 	: . . 
	or h			;1511	b4 	. 
	ld h,a			;1512	67 	g 
	ret			;1513	c9 	. 
l1514h:
	ld de,(l17a1h)		;1514	ed 5b a1 17 	. [ . . 
	ld hl,(l17a3h)		;1518	2a a3 17 	* . . 
	push hl			;151b	e5 	. 
	push de			;151c	d5 	. 
	ld de,(l070eh)		;151d	ed 5b 0e 07 	. [ . . 
	ld hl,(l179fh)		;1521	2a 9f 17 	* . . 
	call sub_0ca1h		;1524	cd a1 0c 	. . . 
	jr l150bh		;1527	18 e2 	. . 
l1529h:
	ld hl,05a82h		;1529	21 82 5a 	! . Z 
	ld de,0ff79h		;152c	11 79 ff 	. y . 
	push hl			;152f	e5 	. 
	push de			;1530	d5 	. 
	inc d			;1531	14 	. 
	or a			;1532	b7 	. 
	jr nz,l1537h		;1533	20 02 	  . 
	set 7,h		;1535	cb fc 	. . 
l1537h:
	push hl			;1537	e5 	. 
	push de			;1538	d5 	. 
	ld de,(l070eh)		;1539	ed 5b 0e 07 	. [ . . 
	ld hl,(l179fh)		;153d	2a 9f 17 	* . . 
	jr nz,l1546h		;1540	20 04 	  . 
	ld a,h			;1542	7c 	| 
	xor 080h		;1543	ee 80 	. . 
	ld h,a			;1545	67 	g 
l1546h:
	push hl			;1546	e5 	. 
	push de			;1547	d5 	. 
	ld hl,(l179bh)		;1548	2a 9b 17 	* . . 
	ld de,(l1799h)		;154b	ed 5b 99 17 	. [ . . 
	call sub_0ca1h		;154f	cd a1 0c 	. . . 
	call RealMul__		;1552	cd 57 0d 	. W . 
	call sub_155dh		;1555	cd 5d 15 	. ] . 
l1558h:
	call sub_0ca1h		;1558	cd a1 0c 	. . . 
	jr l150eh		;155b	18 b1 	. . 
sub_155dh:
	push hl			;155d	e5 	. 
	push de			;155e	d5 	. 
	ld hl,(l17a7h)		;155f	2a a7 17 	* . . 
	ld de,(l17a5h)		;1562	ed 5b a5 17 	. [ . . 
	call RealDiv__		;1566	cd cd 0d 	. . . 
	ret			;1569	c9 	. 
sub_156ah:
	ld a,e			;156a	7b 	{ 
l156bh:
	dec d			;156b	15 	. 
	add a,a			;156c	87 	. 
	adc hl,hl		;156d	ed 6a 	. j 
	jr z,l157bh		;156f	28 0a 	( . 
	bit 6,h		;1571	cb 74 	. t 
	jr z,l156bh		;1573	28 f6 	( . 
l1575h:
	ld e,a			;1575	5f 	_ 
	ex af,af'			;1576	08 	. 
	inc a			;1577	3c 	< 
	ex af,af'			;1578	08 	. 
	ld a,d			;1579	7a 	z 
	ret			;157a	c9 	. 
l157bh:
	or a			;157b	b7 	. 
	jr nz,l156bh		;157c	20 ed 	  . 
	ld d,a			;157e	57 	W 
	jr l1575h		;157f	18 f4 	. . 
sub_1581h:
	push af			;1581	f5 	. 
	res 7,h		;1582	cb bc 	. . 
	ld bc,0517ch		;1584	01 7c 51 	. | Q 
	push bc			;1587	c5 	. 
	ld bc,0fdc0h		;1588	01 c0 fd 	. . . 
	push bc			;158b	c5 	. 
	call RealMul__		;158c	cd 57 0d 	. W . 
	call sub_12cch		;158f	cd cc 12 	. . . 
	pop af			;1592	f1 	. 
	ex af,af'			;1593	08 	. 
	ld a,d			;1594	7a 	z 
	inc a			;1595	3c 	< 
	ret			;1596	c9 	. 
xxTab__:

; BLOCK 'xxTab__' (start 0x1597 end 0x15a7)
xxTab___start:
	defb 000h		;1597	00 	. 
	defb 001h		;1598	01 	. 
	defb 003h		;1599	03 	. 
	defb 002h		;159a	02 	. 
	defb 002h		;159b	02 	. 
	defb 003h		;159c	03 	. 
	defb 001h		;159d	01 	. 
	defb 000h		;159e	00 	. 
	defb 002h		;159f	02 	. 
	defb 003h		;15a0	03 	. 
	defb 001h		;15a1	01 	. 
	defb 000h		;15a2	00 	. 
	defb 000h		;15a3	00 	. 
	defb 001h		;15a4	01 	. 
	defb 003h		;15a5	03 	. 
	defb 002h		;15a6	02 	. 
xxTab___end:
	bit 6,h		;15a7	cb 74 	. t 
	ret z			;15a9	c8 	. 
	ld a,h			;15aa	7c 	| 
	and 080h		;15ab	e6 80 	. . 
	ld (l1797h),a		;15ad	32 97 17 	2 . . 
	res 7,h		;15b0	cb bc 	. . 
	ld a,d			;15b2	7a 	z 
	or a			;15b3	b7 	. 
	jp m,l15cdh		;15b4	fa cd 15 	. . . 
	ld a,002h		;15b7	3e 02 	> . 
	ld (l1799h),a		;15b9	32 99 17 	2 . . 
	exx			;15bc	d9 	. 
	ld hl,l49e6h		;15bd	21 e6 49 	! . I 
	ld de,0ff9dh		;15c0	11 9d ff 	. . . 
	push hl			;15c3	e5 	. 
	push de			;15c4	d5 	. 
	ld bc,0d555h		;15c5	01 55 d5 	. U . 
	push bc			;15c8	c5 	. 
	ld b,000h		;15c9	06 00 	. . 
	jr l15f0h		;15cb	18 23 	. # 
l15cdh:
	cp 0feh		;15cd	fe fe 	. . 
	jr nc,l15dch		;15cf	30 0b 	0 . 
	cp 0f3h		;15d1	fe f3 	. . 
	jp c,l150eh		;15d3	da 0e 15 	. . . 
	xor a			;15d6	af 	. 
	ld (l1799h),a		;15d7	32 99 17 	2 . . 
	jr l15fdh		;15da	18 21 	. ! 
l15dch:
	ld a,001h		;15dc	3e 01 	> . 
	ld (l1799h),a		;15de	32 99 17 	2 . . 
	exx			;15e1	d9 	. 
	ld hl,06ed9h		;15e2	21 d9 6e 	! . n 
	ld de,000ebh		;15e5	11 eb 00 	. . . 
	push hl			;15e8	e5 	. 
	push de			;15e9	d5 	. 
	ld bc,0c000h		;15ea	01 00 c0 	. . . 
	push bc			;15ed	c5 	. 
	ld b,002h		;15ee	06 02 	. . 
l15f0h:
	push bc			;15f0	c5 	. 
	push hl			;15f1	e5 	. 
	push de			;15f2	d5 	. 
	exx			;15f3	d9 	. 
	call sub_0ca1h		;15f4	cd a1 0c 	. . . 
	call RealDiv__		;15f7	cd cd 0d 	. . . 
	call sub_0ca1h		;15fa	cd a1 0c 	. . . 
l15fdh:
	push hl			;15fd	e5 	. 
	push de			;15fe	d5 	. 
	ld bc,04000h		;15ff	01 00 40 	. . @ 
	push bc			;1602	c5 	. 
	ld b,c			;1603	41 	A 
	push bc			;1604	c5 	. 
	call RealSqrt__		;1605	cd 53 0d 	. S . 
	push hl			;1608	e5 	. 
	push de			;1609	d5 	. 
	ld bc,06000h		;160a	01 00 60 	. . ` 
	push bc			;160d	c5 	. 
	ld b,001h		;160e	06 01 	. . 
	push bc			;1610	c5 	. 
	inc d			;1611	14 	. 
	inc d			;1612	14 	. 
	push hl			;1613	e5 	. 
	push de			;1614	d5 	. 
	dec d			;1615	15 	. 
	dec d			;1616	15 	. 
	ld b,050h		;1617	06 50 	. P 
	push bc			;1619	c5 	. 
	ld b,002h		;161a	06 02 	. . 
	push bc			;161c	c5 	. 
	push hl			;161d	e5 	. 
	push de			;161e	d5 	. 
	ld bc,0638eh		;161f	01 8e 63 	. . c 
	push bc			;1622	c5 	. 
	ld bc,0ff39h		;1623	01 39 ff 	. 9 . 
	push bc			;1626	c5 	. 
	ld bc,06b15h		;1627	01 15 6b 	. . k 
	push bc			;162a	c5 	. 
	ld bc,0fc00h		;162b	01 00 fc 	. . . 
	push bc			;162e	c5 	. 
	call RealMul__		;162f	cd 57 0d 	. W . 
	call sub_0ca1h		;1632	cd a1 0c 	. . . 
	call RealDiv__		;1635	cd cd 0d 	. . . 
	call sub_0ca1h		;1638	cd a1 0c 	. . . 
	call RealDiv__		;163b	cd cd 0d 	. . . 
	call sub_0ca1h		;163e	cd a1 0c 	. . . 
	call RealDiv__		;1641	cd cd 0d 	. . . 
	call sub_0ca1h		;1644	cd a1 0c 	. . . 
	call RealDiv__		;1647	cd cd 0d 	. . . 
	ld a,(l1799h)		;164a	3a 99 17 	: . . 
	or a			;164d	b7 	. 
	jr z,l1666h		;164e	28 16 	( . 
	push hl			;1650	e5 	. 
	push de			;1651	d5 	. 
	add a,a			;1652	87 	. 
	add a,a			;1653	87 	. 
	ld hl,01665h		;1654	21 65 16 	! e . 
	ld e,a			;1657	5f 	_ 
	ld d,000h		;1658	16 00 	. . 
	add hl,de			;165a	19 	. 
	ld e,(hl)			;165b	5e 	^ 
	inc hl			;165c	23 	# 
	ld d,(hl)			;165d	56 	V 
	inc hl			;165e	23 	# 
	ld c,(hl)			;165f	4e 	N 
	inc hl			;1660	23 	# 
	ld h,(hl)			;1661	66 	f 
	ld l,c			;1662	69 	i 
	call sub_0ca1h		;1663	cd a1 0c 	. . . 
l1666h:
	jp l150eh		;1666	c3 0e 15 	. . . 
	ld c,b			;1669	48 	H 
	rst 38h			;166a	ff 	. 
	dec b			;166b	05 	. 
	ld b,e			;166c	43 	C 
	ld c,b			;166d	48 	H 
	nop			;166e	00 	. 
	dec b			;166f	05 	. 
	ld b,e			;1670	43 	C 
	call pe,08700h		;1671	ec 00 87 	. . . 
	ld h,h			;1674	64 	d 
l1675h:
	xor a			;1675	af 	. 
	jr l16b7h		;1676	18 3f 	. ? 
	bit 6,h		;1678	cb 74 	. t 
	ret z			;167a	c8 	. 
	ld a,d			;167b	7a 	z 
	cp 0f8h		;167c	fe f8 	. . 
	ret m			;167e	f8 	. 
	ld a,h			;167f	7c 	| 
	ld (l1797h),a		;1680	32 97 17 	2 . . 
	res 7,h		;1683	cb bc 	. . 
	ld bc,0517ch		;1685	01 7c 51 	. | Q 
	push bc			;1688	c5 	. 
	ld bc,0fec1h		;1689	01 c1 fe 	. . . 
	push bc			;168c	c5 	. 
	call RealMul__		;168d	cd 57 0d 	. W . 
	call sub_12cch		;1690	cd cc 12 	. . . 
	call sub_1720h		;1693	cd 20 17 	.   . 
	ld a,(l1797h)		;1696	3a 97 17 	: . . 
	xor h			;1699	ac 	. 
	xor 080h		;169a	ee 80 	. . 
	and 080h		;169c	e6 80 	. . 
	ld (l1797h),a		;169e	32 97 17 	2 . . 
	res 7,h		;16a1	cb bc 	. . 
	ld a,d			;16a3	7a 	z 
	add a,003h		;16a4	c6 03 	. . 
	jr nc,l1675h		;16a6	30 cd 	0 . 
	jr z,l16b6h		;16a8	28 0c 	( . 
	ld a,h			;16aa	7c 	| 
	cp 070h		;16ab	fe 70 	. p 
	jp nc,l172bh		;16ad	d2 2b 17 	. + . 
	cp 060h		;16b0	fe 60 	. ` 
	ld a,002h		;16b2	3e 02 	> . 
	jr c,l16b7h		;16b4	38 01 	8 . 
l16b6h:
	inc a			;16b6	3c 	< 
l16b7h:
	add a,a			;16b7	87 	. 
	exx			;16b8	d9 	. 
	ld d,000h		;16b9	16 00 	. . 
	ld e,a			;16bb	5f 	_ 
	ld hl,l1761h		;16bc	21 61 17 	! a . 
	add hl,de			;16bf	19 	. 
	ld c,000h		;16c0	0e 00 	. . 
	ld b,(hl)			;16c2	46 	F 
	inc hl			;16c3	23 	# 
	push bc			;16c4	c5 	. 
	ld b,(hl)			;16c5	46 	F 
	push bc			;16c6	c5 	. 
	exx			;16c7	d9 	. 
	call sub_0ca1h		;16c8	cd a1 0c 	. . . 
	push hl			;16cb	e5 	. 
	push de			;16cc	d5 	. 
	ld bc,l4305h		;16cd	01 05 43 	. . C 
	push bc			;16d0	c5 	. 
	ld bc,0ff49h		;16d1	01 49 ff 	. I . 
	push bc			;16d4	c5 	. 
	ld bc,0d4e1h		;16d5	01 e1 d4 	. . . 
	push bc			;16d8	c5 	. 
	ld bc,0fff4h		;16d9	01 f4 ff 	. . . 
	push bc			;16dc	c5 	. 
	ld bc,0c0d8h		;16dd	01 d8 c0 	. . . 
	push bc			;16e0	c5 	. 
	ld bc,0fe77h		;16e1	01 77 fe 	. w . 
	push bc			;16e4	c5 	. 
	call RealSqrt__		;16e5	cd 53 0d 	. S . 
	call sub_0ca1h		;16e8	cd a1 0c 	. . . 
	call RealDiv__		;16eb	cd cd 0d 	. . . 
	call sub_0ca1h		;16ee	cd a1 0c 	. . . 
	call RealMul__		;16f1	cd 57 0d 	. W . 
	exx			;16f4	d9 	. 
	sla e		;16f5	cb 23 	. # 
	sla e		;16f7	cb 23 	. # 
	ld hl,l1769h		;16f9	21 69 17 	! i . 
	add hl,de			;16fc	19 	. 
	ld c,(hl)			;16fd	4e 	N 
	inc hl			;16fe	23 	# 
	ld b,(hl)			;16ff	46 	F 
	push bc			;1700	c5 	. 
	inc hl			;1701	23 	# 
	ld c,(hl)			;1702	4e 	N 
	inc hl			;1703	23 	# 
	ld b,(hl)			;1704	46 	F 
	push bc			;1705	c5 	. 
	inc hl			;1706	23 	# 
	ld c,(hl)			;1707	4e 	N 
	inc hl			;1708	23 	# 
	ld b,(hl)			;1709	46 	F 
	inc hl			;170a	23 	# 
	ld e,(hl)			;170b	5e 	^ 
	inc hl			;170c	23 	# 
	ld d,(hl)			;170d	56 	V 
	push bc			;170e	c5 	. 
	push de			;170f	d5 	. 
	exx			;1710	d9 	. 
	call sub_0ca1h		;1711	cd a1 0c 	. . . 
	call RealDiv__		;1714	cd cd 0d 	. . . 
	exx			;1717	d9 	. 
	set 7,b		;1718	cb f8 	. . 
	push bc			;171a	c5 	. 
	push de			;171b	d5 	. 
	exx			;171c	d9 	. 
	jp l1558h		;171d	c3 58 15 	. X . 
sub_1720h:
	ld bc,0c000h		;1720	01 00 c0 	. . . 
	push bc			;1723	c5 	. 
	ld b,0ffh		;1724	06 ff 	. . 
	push bc			;1726	c5 	. 
	call sub_0ca1h		;1727	cd a1 0c 	. . . 
	ret			;172a	c9 	. 
l172bh:
	call sub_1720h		;172b	cd 20 17 	.   . 
	res 7,h		;172e	cb bc 	. . 
	push hl			;1730	e5 	. 
	push de			;1731	d5 	. 
	call RealSqrt__		;1732	cd 53 0d 	. S . 
	ld bc,06487h		;1735	01 87 64 	. . d 
	push bc			;1738	c5 	. 
	ld bc,l01eeh		;1739	01 ee 01 	. . . 
	push bc			;173c	c5 	. 
	push hl			;173d	e5 	. 
	push de			;173e	d5 	. 
	ld bc,l52aeh		;173f	01 ae 52 	. . R 
	push bc			;1742	c5 	. 
	ld bc,003f5h		;1743	01 f5 03 	. . . 
	push bc			;1746	c5 	. 
	ld bc,0519ah		;1747	01 9a 51 	. . Q 
	push bc			;174a	c5 	. 
	ld bc,005f2h		;174b	01 f2 05 	. . . 
	push bc			;174e	c5 	. 
	call RealMul__		;174f	cd 57 0d 	. W . 
	call sub_0ca1h		;1752	cd a1 0c 	. . . 
	call RealMul__		;1755	cd 57 0d 	. W . 
	call sub_0ca1h		;1758	cd a1 0c 	. . . 
	call RealMul__		;175b	cd 57 0d 	. W . 
	jp l150eh		;175e	c3 0e 15 	. . . 
l1761h:
	nop			;1761	00 	. 
	nop			;1762	00 	. 
	nop			;1763	00 	. 
	nop			;1764	00 	. 
	nop			;1765	00 	. 
	nop			;1766	00 	. 
	nop			;1767	00 	. 
	nop			;1768	00 	. 
l1769h:
	nop			;1769	00 	. 
	nop			;176a	00 	. 
	nop			;176b	00 	. 
	nop			;176c	00 	. 
	nop			;176d	00 	. 
	nop			;176e	00 	. 
	nop			;176f	00 	. 
	nop			;1770	00 	. 
	nop			;1771	00 	. 
	nop			;1772	00 	. 
	nop			;1773	00 	. 
	nop			;1774	00 	. 
	nop			;1775	00 	. 
	nop			;1776	00 	. 
	nop			;1777	00 	. 
	nop			;1778	00 	. 
	nop			;1779	00 	. 
	nop			;177a	00 	. 
	nop			;177b	00 	. 
	nop			;177c	00 	. 
	nop			;177d	00 	. 
	nop			;177e	00 	. 
	nop			;177f	00 	. 
	nop			;1780	00 	. 
	nop			;1781	00 	. 
	nop			;1782	00 	. 
	nop			;1783	00 	. 
	nop			;1784	00 	. 
	nop			;1785	00 	. 
	nop			;1786	00 	. 
	nop			;1787	00 	. 
	nop			;1788	00 	. 
retAddr__:
	nop			;1789	00 	. 
	nop			;178a	00 	. 
l178bh:
	nop			;178b	00 	. 
	nop			;178c	00 	. 
l178dh:
	nop			;178d	00 	. 
	nop			;178e	00 	. 
l178fh:
	nop			;178f	00 	. 
	nop			;1790	00 	. 
l1791h:
	nop			;1791	00 	. 
	nop			;1792	00 	. 
l1793h:
	nop			;1793	00 	. 
	nop			;1794	00 	. 
l1795h:
	nop			;1795	00 	. 
	nop			;1796	00 	. 
l1797h:
	nop			;1797	00 	. 
l1798h:
	nop			;1798	00 	. 
l1799h:
	nop			;1799	00 	. 
	nop			;179a	00 	. 
l179bh:
	nop			;179b	00 	. 
	nop			;179c	00 	. 
	nop			;179d	00 	. 
	nop			;179e	00 	. 
l179fh:
	nop			;179f	00 	. 
	nop			;17a0	00 	. 
l17a1h:
	nop			;17a1	00 	. 
	nop			;17a2	00 	. 
l17a3h:
	nop			;17a3	00 	. 
	nop			;17a4	00 	. 
l17a5h:
	nop			;17a5	00 	. 
	nop			;17a6	00 	. 
l17a7h:
	nop			;17a7	00 	. 
	nop			;17a8	00 	. 
iBufCurChrAddr:
	nop			;17a9	00 	. 
	nop			;17aa	00 	. 
inputBuf:
	nop			;17ab	00 	. 
	nop			;17ac	00 	. 
	nop			;17ad	00 	. 
	nop			;17ae	00 	. 
	nop			;17af	00 	. 
	nop			;17b0	00 	. 
	nop			;17b1	00 	. 
	nop			;17b2	00 	. 
	nop			;17b3	00 	. 
	nop			;17b4	00 	. 
	nop			;17b5	00 	. 
	nop			;17b6	00 	. 
	nop			;17b7	00 	. 
	nop			;17b8	00 	. 
	nop			;17b9	00 	. 
	nop			;17ba	00 	. 
	nop			;17bb	00 	. 
	nop			;17bc	00 	. 
	nop			;17bd	00 	. 
	nop			;17be	00 	. 
	nop			;17bf	00 	. 
	nop			;17c0	00 	. 
	nop			;17c1	00 	. 
	nop			;17c2	00 	. 
	nop			;17c3	00 	. 
	nop			;17c4	00 	. 
	nop			;17c5	00 	. 
	nop			;17c6	00 	. 
	nop			;17c7	00 	. 
	nop			;17c8	00 	. 
	nop			;17c9	00 	. 
	nop			;17ca	00 	. 
	nop			;17cb	00 	. 
	nop			;17cc	00 	. 
	nop			;17cd	00 	. 
	nop			;17ce	00 	. 
	nop			;17cf	00 	. 
	nop			;17d0	00 	. 
	nop			;17d1	00 	. 
	nop			;17d2	00 	. 
	nop			;17d3	00 	. 
	nop			;17d4	00 	. 
	nop			;17d5	00 	. 
	nop			;17d6	00 	. 
	nop			;17d7	00 	. 
	nop			;17d8	00 	. 
	nop			;17d9	00 	. 
	nop			;17da	00 	. 
	nop			;17db	00 	. 
	nop			;17dc	00 	. 
	nop			;17dd	00 	. 
	nop			;17de	00 	. 
	nop			;17df	00 	. 
	nop			;17e0	00 	. 
	nop			;17e1	00 	. 
	nop			;17e2	00 	. 
	nop			;17e3	00 	. 
	nop			;17e4	00 	. 
	nop			;17e5	00 	. 
	nop			;17e6	00 	. 
	nop			;17e7	00 	. 
	nop			;17e8	00 	. 
	nop			;17e9	00 	. 
	nop			;17ea	00 	. 
	nop			;17eb	00 	. 
	nop			;17ec	00 	. 
	nop			;17ed	00 	. 
	nop			;17ee	00 	. 
	nop			;17ef	00 	. 
	nop			;17f0	00 	. 
	nop			;17f1	00 	. 
	nop			;17f2	00 	. 
	nop			;17f3	00 	. 
	nop			;17f4	00 	. 
	nop			;17f5	00 	. 
	nop			;17f6	00 	. 
	nop			;17f7	00 	. 
	nop			;17f8	00 	. 
	nop			;17f9	00 	. 
	nop			;17fa	00 	. 
	nop			;17fb	00 	. 
	nop			;17fc	00 	. 
	nop			;17fd	00 	. 
	nop			;17fe	00 	. 
	nop			;17ff	00 	. 
RuntimeEnd:
	nop			;1800	00 	. 
lineBuf:

; BLOCK 'LineBuf' (start 0x1801 end 0x1851)
LineBuf_start:
	defb 000h		;1801	00 	. 
	defb 000h		;1802	00 	. 
	defb 000h		;1803	00 	. 
	defb 000h		;1804	00 	. 
	defb 000h		;1805	00 	. 
	defb 000h		;1806	00 	. 
	defb 000h		;1807	00 	. 
	defb 000h		;1808	00 	. 
	defb 000h		;1809	00 	. 
	defb 000h		;180a	00 	. 
	defb 000h		;180b	00 	. 
	defb 000h		;180c	00 	. 
	defb 000h		;180d	00 	. 
	defb 000h		;180e	00 	. 
	defb 000h		;180f	00 	. 
	defb 000h		;1810	00 	. 
	defb 000h		;1811	00 	. 
	defb 000h		;1812	00 	. 
	defb 000h		;1813	00 	. 
	defb 000h		;1814	00 	. 
	defb 000h		;1815	00 	. 
	defb 000h		;1816	00 	. 
	defb 000h		;1817	00 	. 
	defb 000h		;1818	00 	. 
l1819h:
	defb 000h		;1819	00 	. 
	defb 000h		;181a	00 	. 
	defb 000h		;181b	00 	. 
	defb 000h		;181c	00 	. 
	defb 000h		;181d	00 	. 
	defb 000h		;181e	00 	. 
	defb 000h		;181f	00 	. 
	defb 000h		;1820	00 	. 
	defb 000h		;1821	00 	. 
	defb 000h		;1822	00 	. 
	defb 000h		;1823	00 	. 
	defb 000h		;1824	00 	. 
	defb 000h		;1825	00 	. 
	defb 000h		;1826	00 	. 
	defb 000h		;1827	00 	. 
	defb 000h		;1828	00 	. 
	defb 000h		;1829	00 	. 
	defb 000h		;182a	00 	. 
	defb 000h		;182b	00 	. 
	defb 000h		;182c	00 	. 
	defb 000h		;182d	00 	. 
	defb 000h		;182e	00 	. 
	defb 000h		;182f	00 	. 
	defb 000h		;1830	00 	. 
	defb 000h		;1831	00 	. 
	defb 000h		;1832	00 	. 
sub_1833h:
	defb 000h		;1833	00 	. 
	defb 000h		;1834	00 	. 
	defb 000h		;1835	00 	. 
	defb 000h		;1836	00 	. 
	defb 000h		;1837	00 	. 
	defb 000h		;1838	00 	. 
	defb 000h		;1839	00 	. 
	defb 000h		;183a	00 	. 
	defb 000h		;183b	00 	. 
	defb 000h		;183c	00 	. 
	defb 000h		;183d	00 	. 
	defb 000h		;183e	00 	. 
	defb 000h		;183f	00 	. 
	defb 000h		;1840	00 	. 
	defb 000h		;1841	00 	. 
	defb 000h		;1842	00 	. 
	defb 000h		;1843	00 	. 
	defb 000h		;1844	00 	. 
	defb 000h		;1845	00 	. 
	defb 000h		;1846	00 	. 
	defb 000h		;1847	00 	. 
	defb 000h		;1848	00 	. 
	defb 000h		;1849	00 	. 
	defb 000h		;184a	00 	. 
	defb 000h		;184b	00 	. 
	defb 000h		;184c	00 	. 
	defb 000h		;184d	00 	. 
	defb 000h		;184e	00 	. 
	defb 000h		;184f	00 	. 
	defb 000h		;1850	00 	. 
l1851h:
	dec c			;1851	0d 	. 
stack_adr:
	nop			;1852	00 	. 
	nop			;1853	00 	. 
ram_end:
	nop			;1854	00 	. 
	nop			;1855	00 	. 
PasIDEStartAddr:

; BLOCK 'HeapEndAddr' (start 0x1856 end 0x1858)
HeapEndAddr_start:
	defw START_PASCAL		;1856	55 23 	U # 

; BLOCK 'PrcFncTab' (start 0x1858 end 0x1b35)
PrcFncTab_start:
	defb 000h		;1858	00 	. 
	defb 000h		;1859	00 	. 
	defb 053h		;185a	53 	S 
	defb 045h		;185b	45 	E 
	defb 054h		;185c	54 	T 
	defb 053h		;185d	53 	S 
	defb 059h		;185e	59 	Y 
	defb 0d3h		;185f	d3 	. 
	defb 006h		;1860	06 	. 
	defb 04ah		;1861	4a 	J 
	defb 051h		;1862	51 	Q 
	defb 058h		;1863	58 	X 
	defb 018h		;1864	18 	. 
	defb 047h		;1865	47 	G 
	defb 045h		;1866	45 	E 
	defb 054h		;1867	54 	T 
	defb 053h		;1868	53 	S 
	defb 059h		;1869	59 	Y 
	defb 0d3h		;186a	d3 	. 
	defb 009h		;186b	09 	. 
	defb 001h		;186c	01 	. 
	defb 000h		;186d	00 	. 
	defb 05bh		;186e	5b 	[ 
	defb 051h		;186f	51 	Q 
	defb 002h		;1870	02 	. 
	defb 063h		;1871	63 	c 
	defb 018h		;1872	18 	. 
	defb 050h		;1873	50 	P 
	defb 04ch		;1874	4c 	L 
	defb 04fh		;1875	4f 	O 
	defb 0d4h		;1876	d4 	. 
	defb 006h		;1877	06 	. 
	defb 074h		;1878	74 	t 
	defb 051h		;1879	51 	Q 
	defb 071h		;187a	71 	q 
	defb 018h		;187b	18 	. 
	defb 043h		;187c	43 	C 
	defb 04ch		;187d	4c 	L 
	defb 052h		;187e	52 	R 
	defb 050h		;187f	50 	P 
	defb 04ch		;1880	4c 	L 
	defb 04fh		;1881	4f 	O 
	defb 0d4h		;1882	d4 	. 
	defb 006h		;1883	06 	. 
	defb 0a0h		;1884	a0 	. 
	defb 051h		;1885	51 	Q 
	defb 07ah		;1886	7a 	z 
	defb 018h		;1887	18 	. 
	defb 050h		;1888	50 	P 
	defb 054h		;1889	54 	T 
	defb 045h		;188a	45 	E 
	defb 053h		;188b	53 	S 
	defb 0d4h		;188c	d4 	. 
	defb 009h		;188d	09 	. 
	defb 004h		;188e	04 	. 
	defb 000h		;188f	00 	. 
	defb 088h		;1890	88 	. 
	defb 051h		;1891	51 	Q 
	defb 003h		;1892	03 	. 
	defb 086h		;1893	86 	. 
	defb 018h		;1894	18 	. 
	defb 047h		;1895	47 	G 
	defb 045h		;1896	45 	E 
	defb 054h		;1897	54 	T 
	defb 0c3h		;1898	c3 	. 
	defb 009h		;1899	09 	. 
	defb 001h		;189a	01 	. 
	defb 000h		;189b	00 	. 
	defb 094h		;189c	94 	. 
	defb 051h		;189d	51 	Q 
	defb 003h		;189e	03 	. 
	defb 093h		;189f	93 	. 
	defb 018h		;18a0	18 	. 
	defb 053h		;18a1	53 	S 
	defb 045h		;18a2	45 	E 
	defb 054h		;18a3	54 	T 
	defb 0c3h		;18a4	c3 	. 
	defb 006h		;18a5	06 	. 
	defb 060h		;18a6	60 	` 
	defb 051h		;18a7	51 	Q 
	defb 09fh		;18a8	9f 	. 
	defb 018h		;18a9	18 	. 
	defb 04ch		;18aa	4c 	L 
	defb 049h		;18ab	49 	I 
	defb 04eh		;18ac	4e 	N 
	defb 045h		;18ad	45 	E 
	defb 050h		;18ae	50 	P 
	defb 04ch		;18af	4c 	L 
	defb 04fh		;18b0	4f 	O 
	defb 0d4h		;18b1	d4 	. 
	defb 006h		;18b2	06 	. 
	defb 0b4h		;18b3	b4 	. 
	defb 051h		;18b4	51 	Q 
	defb 0a8h		;18b5	a8 	. 
	defb 018h		;18b6	18 	. 
	defb 043h		;18b7	43 	C 
	defb 049h		;18b8	49 	I 
	defb 052h		;18b9	52 	R 
	defb 043h		;18ba	43 	C 
	defb 04ch		;18bb	4c 	L 
	defb 0c5h		;18bc	c5 	. 
	defb 006h		;18bd	06 	. 
	defb 0d0h		;18be	d0 	. 
	defb 051h		;18bf	51 	Q 
	defb 0b5h		;18c0	b5 	. 
	defb 018h		;18c1	18 	. 
	defb 047h		;18c2	47 	G 
	defb 04fh		;18c3	4f 	O 
	defb 054h		;18c4	54 	T 
	defb 04fh		;18c5	4f 	O 
	defb 058h		;18c6	58 	X 
	defb 0d9h		;18c7	d9 	. 
	defb 006h		;18c8	06 	. 
	defb 036h		;18c9	36 	6 
	defb 051h		;18ca	51 	Q 
	defb 0c0h		;18cb	c0 	. 
	defb 018h		;18cc	18 	. 
	defb 050h		;18cd	50 	P 
	defb 0c9h		;18ce	c9 	. 
	defb 001h		;18cf	01 	. 
	defb 002h		;18d0	02 	. 
	defb 000h		;18d1	00 	. 
	defb 0ech		;18d2	ec 	. 
	defb 001h		;18d3	01 	. 
	defb 087h		;18d4	87 	. 
	defb 064h		;18d5	64 	d 
	defb 0cbh		;18d6	cb 	. 
	defb 018h		;18d7	18 	. 
	defb 046h		;18d8	46 	F 
	defb 052h		;18d9	52 	R 
	defb 041h		;18da	41 	A 
	defb 0c3h		;18db	c3 	. 
	defb 00bh		;18dc	0b 	. 
	defb 0cch		;18dd	cc 	. 
	defb 012h		;18de	12 	. 
l18dfh:
	defb 0d6h		;18df	d6 	. 
	defb 018h		;18e0	18 	. 
	defb 052h		;18e1	52 	R 
	defb 045h		;18e2	45 	E 
	defb 041h		;18e3	41 	A 
	defb 044h		;18e4	44 	D 
	defb 04bh		;18e5	4b 	K 
	defb 042h		;18e6	42 	B 
	defb 0c4h		;18e7	c4 	. 
	defb 009h		;18e8	09 	. 
	defb 003h		;18e9	03 	. 
	defb 000h		;18ea	00 	. 
	defb 0e8h		;18eb	e8 	. 
	defb 051h		;18ec	51 	Q 
	defb 001h		;18ed	01 	. 
	defb 0dfh		;18ee	df 	. 
	defb 018h		;18ef	18 	. 
	defb 053h		;18f0	53 	S 
	defb 048h		;18f1	48 	H 
	defb 0d2h		;18f2	d2 	. 
	defb 009h		;18f3	09 	. 
	defb 001h		;18f4	01 	. 
	defb 000h		;18f5	00 	. 
	defb 019h		;18f6	19 	. 
	defb 052h		;18f7	52 	R 
	defb 003h		;18f8	03 	. 
	defb 0eeh		;18f9	ee 	. 
	defb 018h		;18fa	18 	. 
	defb 053h		;18fb	53 	S 
	defb 048h		;18fc	48 	H 
	defb 0cch		;18fd	cc 	. 
	defb 009h		;18fe	09 	. 
	defb 001h		;18ff	01 	. 
	defb 000h		;1900	00 	. 
	defb 027h		;1901	27 	' 
	defb 052h		;1902	52 	R 
	defb 003h		;1903	03 	. 
	defb 0f9h		;1904	f9 	. 
	defb 018h		;1905	18 	. 
	defb 04ch		;1906	4c 	L 
	defb 0cfh		;1907	cf 	. 
	defb 009h		;1908	09 	. 
	defb 001h		;1909	01 	. 
	defb 000h		;190a	00 	. 
	defb 010h		;190b	10 	. 
	defb 052h		;190c	52 	R 
	defb 002h		;190d	02 	. 
	defb 004h		;190e	04 	. 
	defb 019h		;190f	19 	. 
	defb 048h		;1910	48 	H 
	defb 0c9h		;1911	c9 	. 
	defb 009h		;1912	09 	. 
	defb 001h		;1913	01 	. 
	defb 000h		;1914	00 	. 
	defb 00bh		;1915	0b 	. 
	defb 052h		;1916	52 	R 
	defb 002h		;1917	02 	. 
	defb 00eh		;1918	0e 	. 
	defb 019h		;1919	19 	. 
	defb 053h		;191a	53 	S 
	defb 057h		;191b	57 	W 
	defb 041h		;191c	41 	A 
	defb 0d0h		;191d	d0 	. 
	defb 009h		;191e	09 	. 
	defb 001h		;191f	01 	. 
	defb 000h		;1920	00 	. 
	defb 014h		;1921	14 	. 
	defb 052h		;1922	52 	R 
	defb 002h		;1923	02 	. 
	defb 018h		;1924	18 	. 
	defb 019h		;1925	19 	. 
	defb 042h		;1926	42 	B 
	defb 058h		;1927	58 	X 
	defb 04fh		;1928	4f 	O 
	defb 0d2h		;1929	d2 	. 
	defb 009h		;192a	09 	. 
	defb 001h		;192b	01 	. 
	defb 000h		;192c	00 	. 
	defb 001h		;192d	01 	. 
	defb 052h		;192e	52 	R 
	defb 003h		;192f	03 	. 
	defb 024h		;1930	24 	$ 
	defb 019h		;1931	19 	. 
	defb 042h		;1932	42 	B 
	defb 04fh		;1933	4f 	O 
	defb 0d2h		;1934	d2 	. 
	defb 009h		;1935	09 	. 
	defb 001h		;1936	01 	. 
	defb 000h		;1937	00 	. 
	defb 0f7h		;1938	f7 	. 
	defb 051h		;1939	51 	Q 
	defb 003h		;193a	03 	. 
	defb 030h		;193b	30 	0 
	defb 019h		;193c	19 	. 
	defb 042h		;193d	42 	B 
	defb 041h		;193e	41 	A 
	defb 04eh		;193f	4e 	N 
	defb 0c4h		;1940	c4 	. 
	defb 009h		;1941	09 	. 
	defb 001h		;1942	01 	. 
	defb 000h		;1943	00 	. 
	defb 0edh		;1944	ed 	. 
	defb 051h		;1945	51 	Q 
	defb 003h		;1946	03 	. 
	defb 03bh		;1947	3b 	; 
	defb 019h		;1948	19 	. 
	defb 045h		;1949	45 	E 
	defb 058h		;194a	58 	X 
	defb 0d0h		;194b	d0 	. 
	defb 00bh		;194c	0b 	. 
	defb 007h		;194d	07 	. 
	defb 013h		;194e	13 	. 
	defb 047h		;194f	47 	G 
	defb 019h		;1950	19 	. 
	defb 04ch		;1951	4c 	L 
	defb 0ceh		;1952	ce 	. 
	defb 00bh		;1953	0b 	. 
	defb 0adh		;1954	ad 	. 
	defb 013h		;1955	13 	. 
	defb 04fh		;1956	4f 	O 
	defb 019h		;1957	19 	. 
	defb 041h		;1958	41 	A 
	defb 052h		;1959	52 	R 
	defb 043h		;195a	43 	C 
	defb 054h		;195b	54 	T 
	defb 041h		;195c	41 	A 
	defb 0ceh		;195d	ce 	. 
	defb 00bh		;195e	0b 	. 
	defb 0a7h		;195f	a7 	. 
	defb 015h		;1960	15 	. 
	defb 056h		;1961	56 	V 
	defb 019h		;1962	19 	. 
	defb 054h		;1963	54 	T 
	defb 041h		;1964	41 	A 
	defb 0ceh		;1965	ce 	. 
	defb 00bh		;1966	0b 	. 
	defb 078h		;1967	78 	x 
	defb 016h		;1968	16 	. 
	defb 061h		;1969	61 	a 
	defb 019h		;196a	19 	. 
	defb 043h		;196b	43 	C 
	defb 04fh		;196c	4f 	O 
	defb 0d3h		;196d	d3 	. 
	defb 00bh		;196e	0b 	. 
	defb 034h		;196f	34 	4 
	defb 014h		;1970	14 	. 
	defb 069h		;1971	69 	i 
	defb 019h		;1972	19 	. 
	defb 053h		;1973	53 	S 
	defb 049h		;1974	49 	I 
	defb 0ceh		;1975	ce 	. 
	defb 00bh		;1976	0b 	. 
	defb 052h		;1977	52 	R 
	defb 014h		;1978	14 	. 
	defb 071h		;1979	71 	q 
	defb 019h		;197a	19 	. 
	defb 049h		;197b	49 	I 
	defb 04eh		;197c	4e 	N 
	defb 0d0h		;197d	d0 	. 
	defb 009h		;197e	09 	. 
	defb 003h		;197f	03 	. 
	defb 000h		;1980	00 	. 
	defb 0ach		;1981	ac 	. 
	defb 052h		;1982	52 	R 
	defb 002h		;1983	02 	. 
	defb 079h		;1984	79 	y 
	defb 019h		;1985	19 	. 
	defb 04fh		;1986	4f 	O 
	defb 055h		;1987	55 	U 
	defb 0d4h		;1988	d4 	. 
	defb 006h		;1989	06 	. 
	defb 090h		;198a	90 	. 
	defb 052h		;198b	52 	R 
	defb 084h		;198c	84 	. 
	defb 019h		;198d	19 	. 
	defb 053h		;198e	53 	S 
	defb 049h		;198f	49 	I 
	defb 05ah		;1990	5a 	Z 
	defb 0c5h		;1991	c5 	. 
	defb 007h		;1992	07 	. 
	defb 06bh		;1993	6b 	k 
	defb 052h		;1994	52 	R 
	defb 08ch		;1995	8c 	. 
	defb 019h		;1996	19 	. 
	defb 041h		;1997	41 	A 
	defb 044h		;1998	44 	D 
	defb 044h		;1999	44 	D 
	defb 0d2h		;199a	d2 	. 
	defb 007h		;199b	07 	. 
	defb 07fh		;199c	7f 	 
	defb 052h		;199d	52 	R 
	defb 095h		;199e	95 	. 
	defb 019h		;199f	19 	. 
	defb 049h		;19a0	49 	I 
	defb 04eh		;19a1	4e 	N 
	defb 04ch		;19a2	4c 	L 
	defb 049h		;19a3	49 	I 
	defb 04eh		;19a4	4e 	N 
	defb 0c5h		;19a5	c5 	. 
	defb 006h		;19a6	06 	. 
	defb 08ah		;19a7	8a 	. 
	defb 043h		;19a8	43 	C 
	defb 09eh		;19a9	9e 	. 
	defb 019h		;19aa	19 	. 
	defb 045h		;19ab	45 	E 
	defb 04eh		;19ac	4e 	N 
	defb 054h		;19ad	54 	T 
	defb 049h		;19ae	49 	I 
	defb 045h		;19af	45 	E 
	defb 0d2h		;19b0	d2 	. 
	defb 00ch		;19b1	0c 	. 
	defb 0bbh		;19b2	bb 	. 
	defb 00eh		;19b3	0e 	. 
	defb 0a9h		;19b4	a9 	. 
	defb 019h		;19b5	19 	. 
	defb 055h		;19b6	55 	U 
	defb 053h		;19b7	53 	S 
	defb 045h		;19b8	45 	E 
	defb 0d2h		;19b9	d2 	. 
	defb 008h		;19ba	08 	. 
	defb 000h		;19bb	00 	. 
	defb 000h		;19bc	00 	. 
	defb 0bch		;19bd	bc 	. 
	defb 052h		;19be	52 	R 
	defb 002h		;19bf	02 	. 
l19c0h:
	defb 0b4h		;19c0	b4 	. 
	defb 019h		;19c1	19 	. 
	defb 052h		;19c2	52 	R 
	defb 041h		;19c3	41 	A 
	defb 04eh		;19c4	4e 	N 
	defb 044h		;19c5	44 	D 
	defb 04fh		;19c6	4f 	O 
	defb 0cdh		;19c7	cd 	. 
	defb 009h		;19c8	09 	. 
	defb 001h		;19c9	01 	. 
	defb 000h		;19ca	00 	. 
	defb 0c5h		;19cb	c5 	. 
	defb 052h		;19cc	52 	R 
	defb 001h		;19cd	01 	. 
	defb 0c0h		;19ce	c0 	. 
	defb 019h		;19cf	19 	. 
	defb 04bh		;19d0	4b 	K 
	defb 045h		;19d1	45 	E 
	defb 059h		;19d2	59 	Y 
	defb 050h		;19d3	50 	P 
	defb 052h		;19d4	52 	R 
	defb 045h		;19d5	45 	E 
	defb 053h		;19d6	53 	S 
	defb 053h		;19d7	53 	S 
	defb 045h		;19d8	45 	E 
	defb 0c4h		;19d9	c4 	. 
	defb 009h		;19da	09 	. 
	defb 004h		;19db	04 	. 
	defb 000h		;19dc	00 	. 
	defb 0b2h		;19dd	b2 	. 
	defb 052h		;19de	52 	R 
	defb 001h		;19df	01 	. 
	defb 0ceh		;19e0	ce 	. 
	defb 019h		;19e1	19 	. 
	defb 048h		;19e2	48 	H 
	defb 041h		;19e3	41 	A 
	defb 04ch		;19e4	4c 	L 
	defb 0d4h		;19e5	d4 	. 
	defb 008h		;19e6	08 	. 
	defb 000h		;19e7	00 	. 
	defb 000h		;19e8	00 	. 
	defb 0cah		;19e9	ca 	. 
	defb 052h		;19ea	52 	R 
	defb 001h		;19eb	01 	. 
l19ech:
	defb 0e0h		;19ec	e0 	. 
	defb 019h		;19ed	19 	. 
	defb 045h		;19ee	45 	E 
	defb 04fh		;19ef	4f 	O 
	defb 04ch		;19f0	4c 	L 
	defb 0ceh		;19f1	ce 	. 
	defb 009h		;19f2	09 	. 
	defb 004h		;19f3	04 	. 
	defb 000h		;19f4	00 	. 
	defb 0d1h		;19f5	d1 	. 
	defb 052h		;19f6	52 	R 
	defb 001h		;19f7	01 	. 
	defb 0ech		;19f8	ec 	. 
	defb 019h		;19f9	19 	. 
	defb 050h		;19fa	50 	P 
	defb 041h		;19fb	41 	A 
	defb 047h		;19fc	47 	G 
	defb 0c5h		;19fd	c5 	. 
	defb 008h		;19fe	08 	. 
	defb 000h		;19ff	00 	. 
	defb 000h		;1a00	00 	. 
	defb 0d6h		;1a01	d6 	. 
	defb 052h		;1a02	52 	R 
	defb 001h		;1a03	01 	. 
	defb 0f8h		;1a04	f8 	. 
	defb 019h		;1a05	19 	. 
	defb 053h		;1a06	53 	S 
	defb 051h		;1a07	51 	Q 
	defb 052h		;1a08	52 	R 
	defb 0d4h		;1a09	d4 	. 
	defb 00bh		;1a0a	0b 	. 
	defb 088h		;1a0b	88 	. 
	defb 011h		;1a0c	11 	. 
	defb 004h		;1a0d	04 	. 
	defb 01ah		;1a0e	1a 	. 
	defb 052h		;1a0f	52 	R 
	defb 04fh		;1a10	4f 	O 
	defb 055h		;1a11	55 	U 
	defb 04eh		;1a12	4e 	N 
	defb 0c4h		;1a13	c4 	. 
	defb 00ch		;1a14	0c 	. 
	defb 0b0h		;1a15	b0 	. 
	defb 00eh		;1a16	0e 	. 
	defb 00dh		;1a17	0d 	. 
	defb 01ah		;1a18	1a 	. 
	defb 054h		;1a19	54 	T 
	defb 052h		;1a1a	52 	R 
	defb 055h		;1a1b	55 	U 
	defb 04eh		;1a1c	4e 	N 
	defb 0c3h		;1a1d	c3 	. 
	defb 00ch		;1a1e	0c 	. 
	defb 069h		;1a1f	69 	i 
	defb 00eh		;1a20	0e 	. 
	defb 017h		;1a21	17 	. 
	defb 01ah		;1a22	1a 	. 
	defb 04dh		;1a23	4d 	M 
	defb 041h		;1a24	41 	A 
	defb 058h		;1a25	58 	X 
	defb 049h		;1a26	49 	I 
	defb 04eh		;1a27	4e 	N 
	defb 0d4h		;1a28	d4 	. 
	defb 001h		;1a29	01 	. 
	defb 001h		;1a2a	01 	. 
	defb 000h		;1a2b	00 	. 
	defb 0ffh		;1a2c	ff 	. 
	defb 07fh		;1a2d	7f 	 
	defb 021h		;1a2e	21 	! 
	defb 01ah		;1a2f	1a 	. 
	defb 053h		;1a30	53 	S 
	defb 055h		;1a31	55 	U 
	defb 043h		;1a32	43 	C 
	defb 0c3h		;1a33	c3 	. 
	defb 007h		;1a34	07 	. 
	defb 06ch		;1a35	6c 	l 
	defb 043h		;1a36	43 	C 
	defb 02eh		;1a37	2e 	. 
	defb 01ah		;1a38	1a 	. 
	defb 050h		;1a39	50 	P 
	defb 052h		;1a3a	52 	R 
	defb 045h		;1a3b	45 	E 
	defb 0c4h		;1a3c	c4 	. 
	defb 007h		;1a3d	07 	. 
	defb 05bh		;1a3e	5b 	[ 
	defb 043h		;1a3f	43 	C 
	defb 037h		;1a40	37 	7 
	defb 01ah		;1a41	1a 	. 
	defb 04fh		;1a42	4f 	O 
	defb 052h		;1a43	52 	R 
	defb 0c4h		;1a44	c4 	. 
	defb 007h		;1a45	07 	. 
	defb 04ch		;1a46	4c 	L 
	defb 043h		;1a47	43 	C 
	defb 040h		;1a48	40 	@ 
	defb 01ah		;1a49	1a 	. 
	defb 050h		;1a4a	50 	P 
	defb 045h		;1a4b	45 	E 
	defb 045h		;1a4c	45 	E 
	defb 0cbh		;1a4d	cb 	. 
	defb 007h		;1a4e	07 	. 
	defb 036h		;1a4f	36 	6 
	defb 045h		;1a50	45 	E 
	defb 048h		;1a51	48 	H 
	defb 01ah		;1a52	1a 	. 
	defb 050h		;1a53	50 	P 
	defb 04fh		;1a54	4f 	O 
	defb 04bh		;1a55	4b 	K 
	defb 0c5h		;1a56	c5 	. 
	defb 006h		;1a57	06 	. 
	defb 044h		;1a58	44 	D 
	defb 038h		;1a59	38 	8 
	defb 051h		;1a5a	51 	Q 
	defb 01ah		;1a5b	1a 	. 
	defb 052h		;1a5c	52 	R 
	defb 045h		;1a5d	45 	E 
	defb 04ch		;1a5e	4c 	L 
	defb 045h		;1a5f	45 	E 
	defb 041h		;1a60	41 	A 
	defb 053h		;1a61	53 	S 
	defb 0c5h		;1a62	c5 	. 
	defb 006h		;1a63	06 	. 
	defb 07bh		;1a64	7b 	{ 
	defb 050h		;1a65	50 	P 
	defb 05ah		;1a66	5a 	Z 
	defb 01ah		;1a67	1a 	. 
	defb 04dh		;1a68	4d 	M 
	defb 041h		;1a69	41 	A 
	defb 052h		;1a6a	52 	R 
	defb 0cbh		;1a6b	cb 	. 
	defb 006h		;1a6c	06 	. 
	defb 076h		;1a6d	76 	v 
	defb 050h		;1a6e	50 	P 
	defb 066h		;1a6f	66 	f 
	defb 01ah		;1a70	1a 	. 
	defb 04eh		;1a71	4e 	N 
	defb 045h		;1a72	45 	E 
	defb 0d7h		;1a73	d7 	. 
	defb 006h		;1a74	06 	. 
	defb 09eh		;1a75	9e 	. 
	defb 050h		;1a76	50 	P 
	defb 06fh		;1a77	6f 	o 
	defb 01ah		;1a78	1a 	. 
	defb 054h		;1a79	54 	T 
	defb 04fh		;1a7a	4f 	O 
	defb 055h		;1a7b	55 	U 
	defb 0d4h		;1a7c	d4 	. 
	defb 006h		;1a7d	06 	. 
	defb 0fah		;1a7e	fa 	. 
	defb 050h		;1a7f	50 	P 
	defb 077h		;1a80	77 	w 
	defb 01ah		;1a81	1a 	. 
	defb 054h		;1a82	54 	T 
	defb 049h		;1a83	49 	I 
	defb 0ceh		;1a84	ce 	. 
	defb 006h		;1a85	06 	. 
	defb 0eeh		;1a86	ee 	. 
	defb 050h		;1a87	50 	P 
	defb 080h		;1a88	80 	. 
	defb 01ah		;1a89	1a 	. 
	defb 043h		;1a8a	43 	C 
	defb 048h		;1a8b	48 	H 
	defb 0d2h		;1a8c	d2 	. 
	defb 009h		;1a8d	09 	. 
	defb 003h		;1a8e	03 	. 
	defb 000h		;1a8f	00 	. 
	defb 0ceh		;1a90	ce 	. 
	defb 052h		;1a91	52 	R 
	defb 002h		;1a92	02 	. 
	defb 088h		;1a93	88 	. 
	defb 01ah		;1a94	1a 	. 
	defb 04fh		;1a95	4f 	O 
	defb 044h		;1a96	44 	D 
	defb 0c4h		;1a97	c4 	. 
	defb 009h		;1a98	09 	. 
	defb 004h		;1a99	04 	. 
	defb 000h		;1a9a	00 	. 
	defb 0c0h		;1a9b	c0 	. 
	defb 052h		;1a9c	52 	R 
	defb 002h		;1a9d	02 	. 
	defb 093h		;1a9e	93 	. 
	defb 01ah		;1a9f	1a 	. 
	defb 041h		;1aa0	41 	A 
	defb 042h		;1aa1	42 	B 
	defb 0d3h		;1aa2	d3 	. 
	defb 00dh		;1aa3	0d 	. 
	defb 0e3h		;1aa4	e3 	. 
	defb 052h		;1aa5	52 	R 
	defb 0eeh		;1aa6	ee 	. 
	defb 052h		;1aa7	52 	R 
	defb 09eh		;1aa8	9e 	. 
	defb 01ah		;1aa9	1a 	. 
	defb 053h		;1aaa	53 	S 
	defb 051h		;1aab	51 	Q 
	defb 0d2h		;1aac	d2 	. 
	defb 00dh		;1aad	0d 	. 
	defb 0dch		;1aae	dc 	. 
	defb 052h		;1aaf	52 	R 
	defb 0e8h		;1ab0	e8 	. 
	defb 052h		;1ab1	52 	R 
l1ab2h:
	defb 0a8h		;1ab2	a8 	. 
	defb 01ah		;1ab3	1a 	. 
	defb 046h		;1ab4	46 	F 
	defb 041h		;1ab5	41 	A 
	defb 04ch		;1ab6	4c 	L 
	defb 053h		;1ab7	53 	S 
	defb 0c5h		;1ab8	c5 	. 
	defb 001h		;1ab9	01 	. 
	defb 004h		;1aba	04 	. 
	defb 000h		;1abb	00 	. 
	defb 000h		;1abc	00 	. 
	defb 001h		;1abd	01 	. 
	defb 0b2h		;1abe	b2 	. 
	defb 01ah		;1abf	1a 	. 
	defb 054h		;1ac0	54 	T 
	defb 052h		;1ac1	52 	R 
	defb 055h		;1ac2	55 	U 
	defb 0c5h		;1ac3	c5 	. 
	defb 001h		;1ac4	01 	. 
	defb 004h		;1ac5	04 	. 
	defb 000h		;1ac6	00 	. 
	defb 001h		;1ac7	01 	. 
	defb 001h		;1ac8	01 	. 
	defb 0beh		;1ac9	be 	. 
	defb 01ah		;1aca	1a 	. 
	defb 042h		;1acb	42 	B 
	defb 04fh		;1acc	4f 	O 
	defb 04fh		;1acd	4f 	O 
	defb 04ch		;1ace	4c 	L 
	defb 045h		;1acf	45 	E 
	defb 041h		;1ad0	41 	A 
	defb 0ceh		;1ad1	ce 	. 
	defb 003h		;1ad2	03 	. 
	defb 004h		;1ad3	04 	. 
	defb 000h		;1ad4	00 	. 
	defb 000h		;1ad5	00 	. 
	defb 001h		;1ad6	01 	. 
	defb 001h		;1ad7	01 	. 
	defb 001h		;1ad8	01 	. 
	defb 001h		;1ad9	01 	. 
	defb 000h		;1ada	00 	. 
	defb 0c9h		;1adb	c9 	. 
	defb 01ah		;1adc	1a 	. 
	defb 043h		;1add	43 	C 
	defb 048h		;1ade	48 	H 
	defb 041h		;1adf	41 	A 
	defb 0d2h		;1ae0	d2 	. 
	defb 003h		;1ae1	03 	. 
	defb 003h		;1ae2	03 	. 
	defb 000h		;1ae3	00 	. 
	defb 000h		;1ae4	00 	. 
	defb 0ffh		;1ae5	ff 	. 
	defb 0ffh		;1ae6	ff 	. 
	defb 0ffh		;1ae7	ff 	. 
	defb 001h		;1ae8	01 	. 
	defb 000h		;1ae9	00 	. 
	defb 0dbh		;1aea	db 	. 
	defb 01ah		;1aeb	1a 	. 
	defb 052h		;1aec	52 	R 
	defb 045h		;1aed	45 	E 
	defb 041h		;1aee	41 	A 
	defb 0cch		;1aef	cc 	. 
	defb 003h		;1af0	03 	. 
	defb 002h		;1af1	02 	. 
	defb 000h		;1af2	00 	. 
	defb 000h		;1af3	00 	. 
	defb 000h		;1af4	00 	. 
	defb 000h		;1af5	00 	. 
	defb 000h		;1af6	00 	. 
	defb 004h		;1af7	04 	. 
	defb 000h		;1af8	00 	. 
	defb 0eah		;1af9	ea 	. 
	defb 01ah		;1afa	1a 	. 
	defb 049h		;1afb	49 	I 
	defb 04eh		;1afc	4e 	N 
	defb 054h		;1afd	54 	T 
	defb 045h		;1afe	45 	E 
	defb 047h		;1aff	47 	G 
	defb 045h		;1b00	45 	E 
	defb 0d2h		;1b01	d2 	. 
	defb 003h		;1b02	03 	. 
	defb 001h		;1b03	01 	. 
	defb 000h		;1b04	00 	. 
	defb 001h		;1b05	01 	. 
	defb 080h		;1b06	80 	. 
	defb 0ffh		;1b07	ff 	. 
	defb 07fh		;1b08	7f 	 
	defb 002h		;1b09	02 	. 
	defb 000h		;1b0a	00 	. 
	defb 0f9h		;1b0b	f9 	. 
	defb 01ah		;1b0c	1a 	. 
	defb 052h		;1b0d	52 	R 
	defb 045h		;1b0e	45 	E 
	defb 041h		;1b0f	41 	A 
	defb 044h		;1b10	44 	D 
	defb 04ch		;1b11	4c 	L 
	defb 0ceh		;1b12	ce 	. 
	defb 006h		;1b13	06 	. 
	defb 0e5h		;1b14	e5 	. 
	defb 03eh		;1b15	3e 	> 
	defb 00bh		;1b16	0b 	. 
	defb 01bh		;1b17	1b 	. 
	defb 052h		;1b18	52 	R 
	defb 045h		;1b19	45 	E 
	defb 041h		;1b1a	41 	A 
	defb 0c4h		;1b1b	c4 	. 
	defb 006h		;1b1c	06 	. 
	defb 095h		;1b1d	95 	. 
	defb 03eh		;1b1e	3e 	> 
	defb 016h		;1b1f	16 	. 
	defb 01bh		;1b20	1b 	. 
	defb 057h		;1b21	57 	W 
	defb 052h		;1b22	52 	R 
	defb 049h		;1b23	49 	I 
	defb 054h		;1b24	54 	T 
	defb 045h		;1b25	45 	E 
	defb 04ch		;1b26	4c 	L 
	defb 0ceh		;1b27	ce 	. 
	defb 006h		;1b28	06 	. 
	defb 06eh		;1b29	6e 	n 
	defb 03dh		;1b2a	3d 	= 
l1b2bh:
	defb 01fh		;1b2b	1f 	. 
	defb 01bh		;1b2c	1b 	. 
	defb 057h		;1b2d	57 	W 
	defb 052h		;1b2e	52 	R 
	defb 049h		;1b2f	49 	I 
	defb 054h		;1b30	54 	T 
	defb 0c5h		;1b31	c5 	. 
	defb 006h		;1b32	06 	. 
	defb 081h		;1b33	81 	. 
	defb 03dh		;1b34	3d 	= 
	nop			;1b35	00 	. 
	nop			;1b36	00 	. 
	nop			;1b37	00 	. 
	nop			;1b38	00 	. 
	nop			;1b39	00 	. 
	nop			;1b3a	00 	. 
	nop			;1b3b	00 	. 
	nop			;1b3c	00 	. 
	nop			;1b3d	00 	. 
	nop			;1b3e	00 	. 
	nop			;1b3f	00 	. 
	nop			;1b40	00 	. 
	nop			;1b41	00 	. 
	nop			;1b42	00 	. 
	nop			;1b43	00 	. 
	nop			;1b44	00 	. 
	nop			;1b45	00 	. 
	nop			;1b46	00 	. 
	nop			;1b47	00 	. 
	nop			;1b48	00 	. 
	nop			;1b49	00 	. 
	nop			;1b4a	00 	. 
	nop			;1b4b	00 	. 
	nop			;1b4c	00 	. 
	nop			;1b4d	00 	. 
	nop			;1b4e	00 	. 
	nop			;1b4f	00 	. 
	nop			;1b50	00 	. 
	nop			;1b51	00 	. 
	nop			;1b52	00 	. 
	nop			;1b53	00 	. 
	nop			;1b54	00 	. 
	nop			;1b55	00 	. 
	nop			;1b56	00 	. 
	nop			;1b57	00 	. 
	nop			;1b58	00 	. 
	nop			;1b59	00 	. 
	nop			;1b5a	00 	. 
	nop			;1b5b	00 	. 
	nop			;1b5c	00 	. 
	nop			;1b5d	00 	. 
	nop			;1b5e	00 	. 
	nop			;1b5f	00 	. 
	nop			;1b60	00 	. 
	nop			;1b61	00 	. 
	nop			;1b62	00 	. 
	nop			;1b63	00 	. 
	nop			;1b64	00 	. 
	nop			;1b65	00 	. 
	nop			;1b66	00 	. 
	nop			;1b67	00 	. 
	nop			;1b68	00 	. 
	nop			;1b69	00 	. 
	nop			;1b6a	00 	. 
	nop			;1b6b	00 	. 
	nop			;1b6c	00 	. 
	nop			;1b6d	00 	. 
	nop			;1b6e	00 	. 
	nop			;1b6f	00 	. 
	nop			;1b70	00 	. 
	nop			;1b71	00 	. 
	nop			;1b72	00 	. 
	nop			;1b73	00 	. 
	nop			;1b74	00 	. 
	nop			;1b75	00 	. 
	nop			;1b76	00 	. 
	nop			;1b77	00 	. 
	nop			;1b78	00 	. 
	nop			;1b79	00 	. 
	nop			;1b7a	00 	. 
	nop			;1b7b	00 	. 
	nop			;1b7c	00 	. 
	nop			;1b7d	00 	. 
	nop			;1b7e	00 	. 
	nop			;1b7f	00 	. 
	nop			;1b80	00 	. 
	nop			;1b81	00 	. 
	nop			;1b82	00 	. 
	nop			;1b83	00 	. 
	nop			;1b84	00 	. 
	nop			;1b85	00 	. 
	nop			;1b86	00 	. 
	nop			;1b87	00 	. 
	nop			;1b88	00 	. 
	nop			;1b89	00 	. 
	nop			;1b8a	00 	. 
	nop			;1b8b	00 	. 
	nop			;1b8c	00 	. 
	nop			;1b8d	00 	. 
	nop			;1b8e	00 	. 
	nop			;1b8f	00 	. 
	nop			;1b90	00 	. 
	nop			;1b91	00 	. 
	nop			;1b92	00 	. 
	nop			;1b93	00 	. 
	nop			;1b94	00 	. 
	nop			;1b95	00 	. 
	nop			;1b96	00 	. 
	nop			;1b97	00 	. 
	nop			;1b98	00 	. 
	nop			;1b99	00 	. 
	nop			;1b9a	00 	. 
	nop			;1b9b	00 	. 
	nop			;1b9c	00 	. 
	nop			;1b9d	00 	. 
	nop			;1b9e	00 	. 
	nop			;1b9f	00 	. 
	nop			;1ba0	00 	. 
	nop			;1ba1	00 	. 
	nop			;1ba2	00 	. 
	nop			;1ba3	00 	. 
	nop			;1ba4	00 	. 
	nop			;1ba5	00 	. 
	nop			;1ba6	00 	. 
	nop			;1ba7	00 	. 
	nop			;1ba8	00 	. 
	nop			;1ba9	00 	. 
	nop			;1baa	00 	. 
	nop			;1bab	00 	. 
	nop			;1bac	00 	. 
	nop			;1bad	00 	. 
	nop			;1bae	00 	. 
	nop			;1baf	00 	. 
	nop			;1bb0	00 	. 
	nop			;1bb1	00 	. 
	nop			;1bb2	00 	. 
	nop			;1bb3	00 	. 
	nop			;1bb4	00 	. 
	nop			;1bb5	00 	. 
	nop			;1bb6	00 	. 
	nop			;1bb7	00 	. 
	nop			;1bb8	00 	. 
	nop			;1bb9	00 	. 
	nop			;1bba	00 	. 
	nop			;1bbb	00 	. 
	nop			;1bbc	00 	. 
	nop			;1bbd	00 	. 
	nop			;1bbe	00 	. 
	nop			;1bbf	00 	. 
	nop			;1bc0	00 	. 
	nop			;1bc1	00 	. 
	nop			;1bc2	00 	. 
	nop			;1bc3	00 	. 
	nop			;1bc4	00 	. 
	nop			;1bc5	00 	. 
	nop			;1bc6	00 	. 
	nop			;1bc7	00 	. 
	nop			;1bc8	00 	. 
	nop			;1bc9	00 	. 
	nop			;1bca	00 	. 
	nop			;1bcb	00 	. 
	nop			;1bcc	00 	. 
	nop			;1bcd	00 	. 
	nop			;1bce	00 	. 
	nop			;1bcf	00 	. 
	nop			;1bd0	00 	. 
	nop			;1bd1	00 	. 
	nop			;1bd2	00 	. 
	nop			;1bd3	00 	. 
	nop			;1bd4	00 	. 
	nop			;1bd5	00 	. 
	nop			;1bd6	00 	. 
	nop			;1bd7	00 	. 
	nop			;1bd8	00 	. 
	nop			;1bd9	00 	. 
	nop			;1bda	00 	. 
	nop			;1bdb	00 	. 
	nop			;1bdc	00 	. 
	nop			;1bdd	00 	. 
	nop			;1bde	00 	. 
	nop			;1bdf	00 	. 
	nop			;1be0	00 	. 
	nop			;1be1	00 	. 
	nop			;1be2	00 	. 
	nop			;1be3	00 	. 
	nop			;1be4	00 	. 
	nop			;1be5	00 	. 
	nop			;1be6	00 	. 
	nop			;1be7	00 	. 
	nop			;1be8	00 	. 
	nop			;1be9	00 	. 
	nop			;1bea	00 	. 
	nop			;1beb	00 	. 
	nop			;1bec	00 	. 
	nop			;1bed	00 	. 
	nop			;1bee	00 	. 
	nop			;1bef	00 	. 
	nop			;1bf0	00 	. 
	nop			;1bf1	00 	. 
	nop			;1bf2	00 	. 
	nop			;1bf3	00 	. 
	nop			;1bf4	00 	. 
	nop			;1bf5	00 	. 
	nop			;1bf6	00 	. 
	nop			;1bf7	00 	. 
	nop			;1bf8	00 	. 
	nop			;1bf9	00 	. 
	nop			;1bfa	00 	. 
	nop			;1bfb	00 	. 
	nop			;1bfc	00 	. 
	nop			;1bfd	00 	. 
	nop			;1bfe	00 	. 
	nop			;1bff	00 	. 
	nop			;1c00	00 	. 
	nop			;1c01	00 	. 
	nop			;1c02	00 	. 
	nop			;1c03	00 	. 
	nop			;1c04	00 	. 
	nop			;1c05	00 	. 
	nop			;1c06	00 	. 
	nop			;1c07	00 	. 
	nop			;1c08	00 	. 
	nop			;1c09	00 	. 
	nop			;1c0a	00 	. 
	nop			;1c0b	00 	. 
	nop			;1c0c	00 	. 
	nop			;1c0d	00 	. 
	nop			;1c0e	00 	. 
	nop			;1c0f	00 	. 
	nop			;1c10	00 	. 
	nop			;1c11	00 	. 
	nop			;1c12	00 	. 
	nop			;1c13	00 	. 
	nop			;1c14	00 	. 
	nop			;1c15	00 	. 
	nop			;1c16	00 	. 
	nop			;1c17	00 	. 
	nop			;1c18	00 	. 
	nop			;1c19	00 	. 
	nop			;1c1a	00 	. 
	nop			;1c1b	00 	. 
	nop			;1c1c	00 	. 
	nop			;1c1d	00 	. 
	nop			;1c1e	00 	. 
	nop			;1c1f	00 	. 
	nop			;1c20	00 	. 
	nop			;1c21	00 	. 
	nop			;1c22	00 	. 
	nop			;1c23	00 	. 
	nop			;1c24	00 	. 
	nop			;1c25	00 	. 
	nop			;1c26	00 	. 
	nop			;1c27	00 	. 
	nop			;1c28	00 	. 
	nop			;1c29	00 	. 
	nop			;1c2a	00 	. 
	nop			;1c2b	00 	. 
	nop			;1c2c	00 	. 
	nop			;1c2d	00 	. 
	nop			;1c2e	00 	. 
	nop			;1c2f	00 	. 
	nop			;1c30	00 	. 
	nop			;1c31	00 	. 
	nop			;1c32	00 	. 
	nop			;1c33	00 	. 
	nop			;1c34	00 	. 
	nop			;1c35	00 	. 
	nop			;1c36	00 	. 
	nop			;1c37	00 	. 
	nop			;1c38	00 	. 
	nop			;1c39	00 	. 
	nop			;1c3a	00 	. 
	nop			;1c3b	00 	. 
	nop			;1c3c	00 	. 
	nop			;1c3d	00 	. 
	nop			;1c3e	00 	. 
	nop			;1c3f	00 	. 
	nop			;1c40	00 	. 
	nop			;1c41	00 	. 
	nop			;1c42	00 	. 
	nop			;1c43	00 	. 
	nop			;1c44	00 	. 
	nop			;1c45	00 	. 
	nop			;1c46	00 	. 
	nop			;1c47	00 	. 
	nop			;1c48	00 	. 
	nop			;1c49	00 	. 
	nop			;1c4a	00 	. 
	nop			;1c4b	00 	. 
	nop			;1c4c	00 	. 
	nop			;1c4d	00 	. 
	nop			;1c4e	00 	. 
	nop			;1c4f	00 	. 
	nop			;1c50	00 	. 
	nop			;1c51	00 	. 
	nop			;1c52	00 	. 
	nop			;1c53	00 	. 
	nop			;1c54	00 	. 
	nop			;1c55	00 	. 
	nop			;1c56	00 	. 
	nop			;1c57	00 	. 
	nop			;1c58	00 	. 
	nop			;1c59	00 	. 
	nop			;1c5a	00 	. 
	nop			;1c5b	00 	. 
	nop			;1c5c	00 	. 
	nop			;1c5d	00 	. 
	nop			;1c5e	00 	. 
	nop			;1c5f	00 	. 
	nop			;1c60	00 	. 
	nop			;1c61	00 	. 
	nop			;1c62	00 	. 
	nop			;1c63	00 	. 
	nop			;1c64	00 	. 
	nop			;1c65	00 	. 
	nop			;1c66	00 	. 
	nop			;1c67	00 	. 
	nop			;1c68	00 	. 
	nop			;1c69	00 	. 
	nop			;1c6a	00 	. 
	nop			;1c6b	00 	. 
	nop			;1c6c	00 	. 
	nop			;1c6d	00 	. 
	nop			;1c6e	00 	. 
	nop			;1c6f	00 	. 
	nop			;1c70	00 	. 
	nop			;1c71	00 	. 
	nop			;1c72	00 	. 
	nop			;1c73	00 	. 
	nop			;1c74	00 	. 
	nop			;1c75	00 	. 
	nop			;1c76	00 	. 
	nop			;1c77	00 	. 
	nop			;1c78	00 	. 
	nop			;1c79	00 	. 
	nop			;1c7a	00 	. 
	nop			;1c7b	00 	. 
	nop			;1c7c	00 	. 
	nop			;1c7d	00 	. 
	nop			;1c7e	00 	. 
	nop			;1c7f	00 	. 
	nop			;1c80	00 	. 
	nop			;1c81	00 	. 
	nop			;1c82	00 	. 
	nop			;1c83	00 	. 
	nop			;1c84	00 	. 
	nop			;1c85	00 	. 
	nop			;1c86	00 	. 
	nop			;1c87	00 	. 
	nop			;1c88	00 	. 
	nop			;1c89	00 	. 
	nop			;1c8a	00 	. 
	nop			;1c8b	00 	. 
	nop			;1c8c	00 	. 
	nop			;1c8d	00 	. 
	nop			;1c8e	00 	. 
	nop			;1c8f	00 	. 
	nop			;1c90	00 	. 
	nop			;1c91	00 	. 
	nop			;1c92	00 	. 
	nop			;1c93	00 	. 
	nop			;1c94	00 	. 
	nop			;1c95	00 	. 
	nop			;1c96	00 	. 
	nop			;1c97	00 	. 
	nop			;1c98	00 	. 
	nop			;1c99	00 	. 
	nop			;1c9a	00 	. 
	nop			;1c9b	00 	. 
	nop			;1c9c	00 	. 
	nop			;1c9d	00 	. 
	nop			;1c9e	00 	. 
	nop			;1c9f	00 	. 
	nop			;1ca0	00 	. 
	nop			;1ca1	00 	. 
	nop			;1ca2	00 	. 
	nop			;1ca3	00 	. 
	nop			;1ca4	00 	. 
	nop			;1ca5	00 	. 
	nop			;1ca6	00 	. 
	nop			;1ca7	00 	. 
	nop			;1ca8	00 	. 
	nop			;1ca9	00 	. 
	nop			;1caa	00 	. 
	nop			;1cab	00 	. 
	nop			;1cac	00 	. 
	nop			;1cad	00 	. 
	nop			;1cae	00 	. 
	nop			;1caf	00 	. 
	nop			;1cb0	00 	. 
	nop			;1cb1	00 	. 
	nop			;1cb2	00 	. 
	nop			;1cb3	00 	. 
	nop			;1cb4	00 	. 
	nop			;1cb5	00 	. 
	nop			;1cb6	00 	. 
	nop			;1cb7	00 	. 
	nop			;1cb8	00 	. 
	nop			;1cb9	00 	. 
	nop			;1cba	00 	. 
	nop			;1cbb	00 	. 
	nop			;1cbc	00 	. 
	nop			;1cbd	00 	. 
	nop			;1cbe	00 	. 
	nop			;1cbf	00 	. 
	nop			;1cc0	00 	. 
	nop			;1cc1	00 	. 
	nop			;1cc2	00 	. 
	nop			;1cc3	00 	. 
	nop			;1cc4	00 	. 
	nop			;1cc5	00 	. 
	nop			;1cc6	00 	. 
	nop			;1cc7	00 	. 
	nop			;1cc8	00 	. 
	nop			;1cc9	00 	. 
	nop			;1cca	00 	. 
	nop			;1ccb	00 	. 
	nop			;1ccc	00 	. 
	nop			;1ccd	00 	. 
	nop			;1cce	00 	. 
	nop			;1ccf	00 	. 
	nop			;1cd0	00 	. 
	nop			;1cd1	00 	. 
	nop			;1cd2	00 	. 
	nop			;1cd3	00 	. 
	nop			;1cd4	00 	. 
	nop			;1cd5	00 	. 
	nop			;1cd6	00 	. 
	nop			;1cd7	00 	. 
	nop			;1cd8	00 	. 
	nop			;1cd9	00 	. 
	nop			;1cda	00 	. 
	nop			;1cdb	00 	. 
	nop			;1cdc	00 	. 
	nop			;1cdd	00 	. 
	nop			;1cde	00 	. 
	nop			;1cdf	00 	. 
	nop			;1ce0	00 	. 
	nop			;1ce1	00 	. 
	nop			;1ce2	00 	. 
	nop			;1ce3	00 	. 
	nop			;1ce4	00 	. 
	nop			;1ce5	00 	. 
	nop			;1ce6	00 	. 
	nop			;1ce7	00 	. 
	nop			;1ce8	00 	. 
	nop			;1ce9	00 	. 
	nop			;1cea	00 	. 
	nop			;1ceb	00 	. 
	nop			;1cec	00 	. 
	nop			;1ced	00 	. 
	nop			;1cee	00 	. 
	nop			;1cef	00 	. 
	nop			;1cf0	00 	. 
	nop			;1cf1	00 	. 
	nop			;1cf2	00 	. 
	nop			;1cf3	00 	. 
	nop			;1cf4	00 	. 
	nop			;1cf5	00 	. 
	nop			;1cf6	00 	. 
	nop			;1cf7	00 	. 
	nop			;1cf8	00 	. 
	nop			;1cf9	00 	. 
	nop			;1cfa	00 	. 
	nop			;1cfb	00 	. 
	nop			;1cfc	00 	. 
	nop			;1cfd	00 	. 
	nop			;1cfe	00 	. 
	nop			;1cff	00 	. 
	nop			;1d00	00 	. 
	nop			;1d01	00 	. 
	nop			;1d02	00 	. 
	nop			;1d03	00 	. 
	nop			;1d04	00 	. 
	nop			;1d05	00 	. 
	nop			;1d06	00 	. 
	nop			;1d07	00 	. 
	nop			;1d08	00 	. 
	nop			;1d09	00 	. 
	nop			;1d0a	00 	. 
	nop			;1d0b	00 	. 
	nop			;1d0c	00 	. 
	nop			;1d0d	00 	. 
	nop			;1d0e	00 	. 
	nop			;1d0f	00 	. 
	nop			;1d10	00 	. 
	nop			;1d11	00 	. 
	nop			;1d12	00 	. 
	nop			;1d13	00 	. 
	nop			;1d14	00 	. 
	nop			;1d15	00 	. 
	nop			;1d16	00 	. 
	nop			;1d17	00 	. 
	nop			;1d18	00 	. 
	nop			;1d19	00 	. 
	nop			;1d1a	00 	. 
	nop			;1d1b	00 	. 
	nop			;1d1c	00 	. 
	nop			;1d1d	00 	. 
	nop			;1d1e	00 	. 
	nop			;1d1f	00 	. 
	nop			;1d20	00 	. 
	nop			;1d21	00 	. 
	nop			;1d22	00 	. 
	nop			;1d23	00 	. 
	nop			;1d24	00 	. 
	nop			;1d25	00 	. 
	nop			;1d26	00 	. 
	nop			;1d27	00 	. 
	nop			;1d28	00 	. 
	nop			;1d29	00 	. 
	nop			;1d2a	00 	. 
	nop			;1d2b	00 	. 
	nop			;1d2c	00 	. 
	nop			;1d2d	00 	. 
	nop			;1d2e	00 	. 
	nop			;1d2f	00 	. 
	nop			;1d30	00 	. 
	nop			;1d31	00 	. 
	nop			;1d32	00 	. 
	nop			;1d33	00 	. 
	nop			;1d34	00 	. 
	nop			;1d35	00 	. 
	nop			;1d36	00 	. 
	nop			;1d37	00 	. 
	nop			;1d38	00 	. 
	nop			;1d39	00 	. 
	nop			;1d3a	00 	. 
	nop			;1d3b	00 	. 
	nop			;1d3c	00 	. 
	nop			;1d3d	00 	. 
	nop			;1d3e	00 	. 
	nop			;1d3f	00 	. 
	nop			;1d40	00 	. 
	nop			;1d41	00 	. 
	nop			;1d42	00 	. 
	nop			;1d43	00 	. 
	nop			;1d44	00 	. 
	nop			;1d45	00 	. 
	nop			;1d46	00 	. 
	nop			;1d47	00 	. 
	nop			;1d48	00 	. 
	nop			;1d49	00 	. 
	nop			;1d4a	00 	. 
	nop			;1d4b	00 	. 
	nop			;1d4c	00 	. 
	nop			;1d4d	00 	. 
	nop			;1d4e	00 	. 
	nop			;1d4f	00 	. 
	nop			;1d50	00 	. 
	nop			;1d51	00 	. 
	nop			;1d52	00 	. 
	nop			;1d53	00 	. 
	nop			;1d54	00 	. 
	nop			;1d55	00 	. 
	nop			;1d56	00 	. 
	nop			;1d57	00 	. 
	nop			;1d58	00 	. 
	nop			;1d59	00 	. 
	nop			;1d5a	00 	. 
	nop			;1d5b	00 	. 
	nop			;1d5c	00 	. 
	nop			;1d5d	00 	. 
	nop			;1d5e	00 	. 
	nop			;1d5f	00 	. 
	nop			;1d60	00 	. 
	nop			;1d61	00 	. 
	nop			;1d62	00 	. 
	nop			;1d63	00 	. 
	nop			;1d64	00 	. 
	nop			;1d65	00 	. 
	nop			;1d66	00 	. 
	nop			;1d67	00 	. 
	nop			;1d68	00 	. 
	nop			;1d69	00 	. 
	nop			;1d6a	00 	. 
	nop			;1d6b	00 	. 
	nop			;1d6c	00 	. 
	nop			;1d6d	00 	. 
	nop			;1d6e	00 	. 
	nop			;1d6f	00 	. 
	nop			;1d70	00 	. 
	nop			;1d71	00 	. 
	nop			;1d72	00 	. 
	nop			;1d73	00 	. 
	nop			;1d74	00 	. 
	nop			;1d75	00 	. 
	nop			;1d76	00 	. 
	nop			;1d77	00 	. 
	nop			;1d78	00 	. 
	nop			;1d79	00 	. 
	nop			;1d7a	00 	. 
	nop			;1d7b	00 	. 
	nop			;1d7c	00 	. 
	nop			;1d7d	00 	. 
	nop			;1d7e	00 	. 
	nop			;1d7f	00 	. 
	nop			;1d80	00 	. 
	nop			;1d81	00 	. 
	nop			;1d82	00 	. 
	nop			;1d83	00 	. 
	nop			;1d84	00 	. 
	nop			;1d85	00 	. 
	nop			;1d86	00 	. 
	nop			;1d87	00 	. 
	nop			;1d88	00 	. 
	nop			;1d89	00 	. 
	nop			;1d8a	00 	. 
	nop			;1d8b	00 	. 
	nop			;1d8c	00 	. 
	nop			;1d8d	00 	. 
	nop			;1d8e	00 	. 
	nop			;1d8f	00 	. 
	nop			;1d90	00 	. 
	nop			;1d91	00 	. 
	nop			;1d92	00 	. 
	nop			;1d93	00 	. 
	nop			;1d94	00 	. 
	nop			;1d95	00 	. 
	nop			;1d96	00 	. 
	nop			;1d97	00 	. 
	nop			;1d98	00 	. 
	nop			;1d99	00 	. 
	nop			;1d9a	00 	. 
	nop			;1d9b	00 	. 
	nop			;1d9c	00 	. 
	nop			;1d9d	00 	. 
	nop			;1d9e	00 	. 
	nop			;1d9f	00 	. 
	nop			;1da0	00 	. 
	nop			;1da1	00 	. 
	nop			;1da2	00 	. 
	nop			;1da3	00 	. 
	nop			;1da4	00 	. 
	nop			;1da5	00 	. 
	nop			;1da6	00 	. 
	nop			;1da7	00 	. 
	nop			;1da8	00 	. 
	nop			;1da9	00 	. 
	nop			;1daa	00 	. 
	nop			;1dab	00 	. 
	nop			;1dac	00 	. 
	nop			;1dad	00 	. 
	nop			;1dae	00 	. 
	nop			;1daf	00 	. 
	nop			;1db0	00 	. 
	nop			;1db1	00 	. 
	nop			;1db2	00 	. 
	nop			;1db3	00 	. 
	nop			;1db4	00 	. 
	nop			;1db5	00 	. 
	nop			;1db6	00 	. 
	nop			;1db7	00 	. 
	nop			;1db8	00 	. 
	nop			;1db9	00 	. 
	nop			;1dba	00 	. 
	nop			;1dbb	00 	. 
	nop			;1dbc	00 	. 
	nop			;1dbd	00 	. 
	nop			;1dbe	00 	. 
	nop			;1dbf	00 	. 
	nop			;1dc0	00 	. 
	nop			;1dc1	00 	. 
	nop			;1dc2	00 	. 
	nop			;1dc3	00 	. 
	nop			;1dc4	00 	. 
	nop			;1dc5	00 	. 
	nop			;1dc6	00 	. 
	nop			;1dc7	00 	. 
	nop			;1dc8	00 	. 
	nop			;1dc9	00 	. 
	nop			;1dca	00 	. 
	nop			;1dcb	00 	. 
	nop			;1dcc	00 	. 
	nop			;1dcd	00 	. 
	nop			;1dce	00 	. 
	nop			;1dcf	00 	. 
	nop			;1dd0	00 	. 
	nop			;1dd1	00 	. 
	nop			;1dd2	00 	. 
	nop			;1dd3	00 	. 
	nop			;1dd4	00 	. 
	nop			;1dd5	00 	. 
	nop			;1dd6	00 	. 
	nop			;1dd7	00 	. 
	nop			;1dd8	00 	. 
	nop			;1dd9	00 	. 
	nop			;1dda	00 	. 
	nop			;1ddb	00 	. 
	nop			;1ddc	00 	. 
	nop			;1ddd	00 	. 
	nop			;1dde	00 	. 
	nop			;1ddf	00 	. 
	nop			;1de0	00 	. 
	nop			;1de1	00 	. 
	nop			;1de2	00 	. 
	nop			;1de3	00 	. 
	nop			;1de4	00 	. 
	nop			;1de5	00 	. 
	nop			;1de6	00 	. 
	nop			;1de7	00 	. 
	nop			;1de8	00 	. 
	nop			;1de9	00 	. 
	nop			;1dea	00 	. 
	nop			;1deb	00 	. 
	nop			;1dec	00 	. 
	nop			;1ded	00 	. 
	nop			;1dee	00 	. 
	nop			;1def	00 	. 
	nop			;1df0	00 	. 
	nop			;1df1	00 	. 
	nop			;1df2	00 	. 
	nop			;1df3	00 	. 
	nop			;1df4	00 	. 
	nop			;1df5	00 	. 
	nop			;1df6	00 	. 
	nop			;1df7	00 	. 
	nop			;1df8	00 	. 
	nop			;1df9	00 	. 
	nop			;1dfa	00 	. 
	nop			;1dfb	00 	. 
	nop			;1dfc	00 	. 
	nop			;1dfd	00 	. 
	nop			;1dfe	00 	. 
	nop			;1dff	00 	. 
	nop			;1e00	00 	. 
	nop			;1e01	00 	. 
	nop			;1e02	00 	. 
	nop			;1e03	00 	. 
	nop			;1e04	00 	. 
	nop			;1e05	00 	. 
	nop			;1e06	00 	. 
	nop			;1e07	00 	. 
	nop			;1e08	00 	. 
	nop			;1e09	00 	. 
	nop			;1e0a	00 	. 
	nop			;1e0b	00 	. 
	nop			;1e0c	00 	. 
	nop			;1e0d	00 	. 
	nop			;1e0e	00 	. 
	nop			;1e0f	00 	. 
	nop			;1e10	00 	. 
	nop			;1e11	00 	. 
	nop			;1e12	00 	. 
	nop			;1e13	00 	. 
	nop			;1e14	00 	. 
	nop			;1e15	00 	. 
	nop			;1e16	00 	. 
	nop			;1e17	00 	. 
	nop			;1e18	00 	. 
	nop			;1e19	00 	. 
	nop			;1e1a	00 	. 
	nop			;1e1b	00 	. 
	nop			;1e1c	00 	. 
	nop			;1e1d	00 	. 
	nop			;1e1e	00 	. 
	nop			;1e1f	00 	. 
	nop			;1e20	00 	. 
	nop			;1e21	00 	. 
	nop			;1e22	00 	. 
	nop			;1e23	00 	. 
	nop			;1e24	00 	. 
	nop			;1e25	00 	. 
	nop			;1e26	00 	. 
	nop			;1e27	00 	. 
	nop			;1e28	00 	. 
	nop			;1e29	00 	. 
	nop			;1e2a	00 	. 
	nop			;1e2b	00 	. 
	nop			;1e2c	00 	. 
	nop			;1e2d	00 	. 
	nop			;1e2e	00 	. 
	nop			;1e2f	00 	. 
	nop			;1e30	00 	. 
	nop			;1e31	00 	. 
	nop			;1e32	00 	. 
	nop			;1e33	00 	. 
	nop			;1e34	00 	. 
	nop			;1e35	00 	. 
	nop			;1e36	00 	. 
	nop			;1e37	00 	. 
	nop			;1e38	00 	. 
	nop			;1e39	00 	. 
	nop			;1e3a	00 	. 
	nop			;1e3b	00 	. 
	nop			;1e3c	00 	. 
	nop			;1e3d	00 	. 
	nop			;1e3e	00 	. 
	nop			;1e3f	00 	. 
	nop			;1e40	00 	. 
	nop			;1e41	00 	. 
	nop			;1e42	00 	. 
	nop			;1e43	00 	. 
	nop			;1e44	00 	. 
	nop			;1e45	00 	. 
	nop			;1e46	00 	. 
	nop			;1e47	00 	. 
	nop			;1e48	00 	. 
	nop			;1e49	00 	. 
	nop			;1e4a	00 	. 
	nop			;1e4b	00 	. 
	nop			;1e4c	00 	. 
	nop			;1e4d	00 	. 
	nop			;1e4e	00 	. 
	nop			;1e4f	00 	. 
	nop			;1e50	00 	. 
	nop			;1e51	00 	. 
	nop			;1e52	00 	. 
	nop			;1e53	00 	. 
	nop			;1e54	00 	. 
	nop			;1e55	00 	. 
	nop			;1e56	00 	. 
	nop			;1e57	00 	. 
	nop			;1e58	00 	. 
	nop			;1e59	00 	. 
	nop			;1e5a	00 	. 
	nop			;1e5b	00 	. 
	nop			;1e5c	00 	. 
	nop			;1e5d	00 	. 
	nop			;1e5e	00 	. 
	nop			;1e5f	00 	. 
	nop			;1e60	00 	. 
	nop			;1e61	00 	. 
	nop			;1e62	00 	. 
	nop			;1e63	00 	. 
	nop			;1e64	00 	. 
	nop			;1e65	00 	. 
	nop			;1e66	00 	. 
	nop			;1e67	00 	. 
	nop			;1e68	00 	. 
	nop			;1e69	00 	. 
	nop			;1e6a	00 	. 
	nop			;1e6b	00 	. 
	nop			;1e6c	00 	. 
	nop			;1e6d	00 	. 
	nop			;1e6e	00 	. 
	nop			;1e6f	00 	. 
	nop			;1e70	00 	. 
	nop			;1e71	00 	. 
	nop			;1e72	00 	. 
	nop			;1e73	00 	. 
	nop			;1e74	00 	. 
	nop			;1e75	00 	. 
	nop			;1e76	00 	. 
	nop			;1e77	00 	. 
	nop			;1e78	00 	. 
	nop			;1e79	00 	. 
	nop			;1e7a	00 	. 
	nop			;1e7b	00 	. 
	nop			;1e7c	00 	. 
	nop			;1e7d	00 	. 
	nop			;1e7e	00 	. 
	nop			;1e7f	00 	. 
	nop			;1e80	00 	. 
	nop			;1e81	00 	. 
	nop			;1e82	00 	. 
	nop			;1e83	00 	. 
	nop			;1e84	00 	. 
	nop			;1e85	00 	. 
	nop			;1e86	00 	. 
	nop			;1e87	00 	. 
	nop			;1e88	00 	. 
	nop			;1e89	00 	. 
	nop			;1e8a	00 	. 
	nop			;1e8b	00 	. 
	nop			;1e8c	00 	. 
	nop			;1e8d	00 	. 
	nop			;1e8e	00 	. 
	nop			;1e8f	00 	. 
	nop			;1e90	00 	. 
	nop			;1e91	00 	. 
	nop			;1e92	00 	. 
	nop			;1e93	00 	. 
	nop			;1e94	00 	. 
	nop			;1e95	00 	. 
	nop			;1e96	00 	. 
	nop			;1e97	00 	. 
	nop			;1e98	00 	. 
	nop			;1e99	00 	. 
	nop			;1e9a	00 	. 
	nop			;1e9b	00 	. 
	nop			;1e9c	00 	. 
	nop			;1e9d	00 	. 
	nop			;1e9e	00 	. 
	nop			;1e9f	00 	. 
	nop			;1ea0	00 	. 
	nop			;1ea1	00 	. 
	nop			;1ea2	00 	. 
	nop			;1ea3	00 	. 
	nop			;1ea4	00 	. 
	nop			;1ea5	00 	. 
	nop			;1ea6	00 	. 
	nop			;1ea7	00 	. 
	nop			;1ea8	00 	. 
	nop			;1ea9	00 	. 
	nop			;1eaa	00 	. 
	nop			;1eab	00 	. 
	nop			;1eac	00 	. 
	nop			;1ead	00 	. 
	nop			;1eae	00 	. 
	nop			;1eaf	00 	. 
	nop			;1eb0	00 	. 
	nop			;1eb1	00 	. 
	nop			;1eb2	00 	. 
	nop			;1eb3	00 	. 
	nop			;1eb4	00 	. 
	nop			;1eb5	00 	. 
	nop			;1eb6	00 	. 
	nop			;1eb7	00 	. 
	nop			;1eb8	00 	. 
	nop			;1eb9	00 	. 
	nop			;1eba	00 	. 
	nop			;1ebb	00 	. 
	nop			;1ebc	00 	. 
	nop			;1ebd	00 	. 
	nop			;1ebe	00 	. 
	nop			;1ebf	00 	. 
	nop			;1ec0	00 	. 
	nop			;1ec1	00 	. 
	nop			;1ec2	00 	. 
	nop			;1ec3	00 	. 
	nop			;1ec4	00 	. 
	nop			;1ec5	00 	. 
	nop			;1ec6	00 	. 
	nop			;1ec7	00 	. 
	nop			;1ec8	00 	. 
	nop			;1ec9	00 	. 
	nop			;1eca	00 	. 
	nop			;1ecb	00 	. 
	nop			;1ecc	00 	. 
	nop			;1ecd	00 	. 
	nop			;1ece	00 	. 
	nop			;1ecf	00 	. 
	nop			;1ed0	00 	. 
	nop			;1ed1	00 	. 
	nop			;1ed2	00 	. 
	nop			;1ed3	00 	. 
	nop			;1ed4	00 	. 
	nop			;1ed5	00 	. 
	nop			;1ed6	00 	. 
	nop			;1ed7	00 	. 
	nop			;1ed8	00 	. 
	nop			;1ed9	00 	. 
	nop			;1eda	00 	. 
	nop			;1edb	00 	. 
	nop			;1edc	00 	. 
	nop			;1edd	00 	. 
	nop			;1ede	00 	. 
	nop			;1edf	00 	. 
	nop			;1ee0	00 	. 
	nop			;1ee1	00 	. 
	nop			;1ee2	00 	. 
	nop			;1ee3	00 	. 
	nop			;1ee4	00 	. 
	nop			;1ee5	00 	. 
	nop			;1ee6	00 	. 
	nop			;1ee7	00 	. 
	nop			;1ee8	00 	. 
	nop			;1ee9	00 	. 
	nop			;1eea	00 	. 
	nop			;1eeb	00 	. 
	nop			;1eec	00 	. 
	nop			;1eed	00 	. 
	nop			;1eee	00 	. 
	nop			;1eef	00 	. 
	nop			;1ef0	00 	. 
	nop			;1ef1	00 	. 
	nop			;1ef2	00 	. 
	nop			;1ef3	00 	. 
	nop			;1ef4	00 	. 
	nop			;1ef5	00 	. 
	nop			;1ef6	00 	. 
	nop			;1ef7	00 	. 
	nop			;1ef8	00 	. 
	nop			;1ef9	00 	. 
	nop			;1efa	00 	. 
	nop			;1efb	00 	. 
	nop			;1efc	00 	. 
	nop			;1efd	00 	. 
	nop			;1efe	00 	. 
	nop			;1eff	00 	. 
	nop			;1f00	00 	. 
	nop			;1f01	00 	. 
	nop			;1f02	00 	. 
	nop			;1f03	00 	. 
	nop			;1f04	00 	. 
	nop			;1f05	00 	. 
	nop			;1f06	00 	. 
	nop			;1f07	00 	. 
	nop			;1f08	00 	. 
	nop			;1f09	00 	. 
	nop			;1f0a	00 	. 
	nop			;1f0b	00 	. 
	nop			;1f0c	00 	. 
	nop			;1f0d	00 	. 
	nop			;1f0e	00 	. 
	nop			;1f0f	00 	. 
	nop			;1f10	00 	. 
	nop			;1f11	00 	. 
	nop			;1f12	00 	. 
	nop			;1f13	00 	. 
	nop			;1f14	00 	. 
	nop			;1f15	00 	. 
	nop			;1f16	00 	. 
	nop			;1f17	00 	. 
	nop			;1f18	00 	. 
	nop			;1f19	00 	. 
	nop			;1f1a	00 	. 
	nop			;1f1b	00 	. 
	nop			;1f1c	00 	. 
	nop			;1f1d	00 	. 
	nop			;1f1e	00 	. 
	nop			;1f1f	00 	. 
	nop			;1f20	00 	. 
	nop			;1f21	00 	. 
	nop			;1f22	00 	. 
	nop			;1f23	00 	. 
	nop			;1f24	00 	. 
	nop			;1f25	00 	. 
	nop			;1f26	00 	. 
	nop			;1f27	00 	. 
	nop			;1f28	00 	. 
	nop			;1f29	00 	. 
	nop			;1f2a	00 	. 
	nop			;1f2b	00 	. 
	nop			;1f2c	00 	. 
	nop			;1f2d	00 	. 
	nop			;1f2e	00 	. 
	nop			;1f2f	00 	. 
	nop			;1f30	00 	. 
	nop			;1f31	00 	. 
	nop			;1f32	00 	. 
	nop			;1f33	00 	. 
	nop			;1f34	00 	. 
	nop			;1f35	00 	. 
	nop			;1f36	00 	. 
	nop			;1f37	00 	. 
	nop			;1f38	00 	. 
	nop			;1f39	00 	. 
	nop			;1f3a	00 	. 
	nop			;1f3b	00 	. 
	nop			;1f3c	00 	. 
	nop			;1f3d	00 	. 
	nop			;1f3e	00 	. 
	nop			;1f3f	00 	. 
l1f40h:
	nop			;1f40	00 	. 
	nop			;1f41	00 	. 
	nop			;1f42	00 	. 
	nop			;1f43	00 	. 
	nop			;1f44	00 	. 
	nop			;1f45	00 	. 
	nop			;1f46	00 	. 
	nop			;1f47	00 	. 
	nop			;1f48	00 	. 
	nop			;1f49	00 	. 
	nop			;1f4a	00 	. 
	nop			;1f4b	00 	. 
	nop			;1f4c	00 	. 
	nop			;1f4d	00 	. 
	nop			;1f4e	00 	. 
	nop			;1f4f	00 	. 
	nop			;1f50	00 	. 
	nop			;1f51	00 	. 
	nop			;1f52	00 	. 
	nop			;1f53	00 	. 
	nop			;1f54	00 	. 
	nop			;1f55	00 	. 
	nop			;1f56	00 	. 
	nop			;1f57	00 	. 
	nop			;1f58	00 	. 
	nop			;1f59	00 	. 
	nop			;1f5a	00 	. 
	nop			;1f5b	00 	. 
	nop			;1f5c	00 	. 
	nop			;1f5d	00 	. 
	nop			;1f5e	00 	. 
	nop			;1f5f	00 	. 
	nop			;1f60	00 	. 
	nop			;1f61	00 	. 
	nop			;1f62	00 	. 
	nop			;1f63	00 	. 
	nop			;1f64	00 	. 
	nop			;1f65	00 	. 
	nop			;1f66	00 	. 
	nop			;1f67	00 	. 
	nop			;1f68	00 	. 
	nop			;1f69	00 	. 
	nop			;1f6a	00 	. 
	nop			;1f6b	00 	. 
	nop			;1f6c	00 	. 
	nop			;1f6d	00 	. 
	nop			;1f6e	00 	. 
	nop			;1f6f	00 	. 
	nop			;1f70	00 	. 
	nop			;1f71	00 	. 
	nop			;1f72	00 	. 
	nop			;1f73	00 	. 
	nop			;1f74	00 	. 
	nop			;1f75	00 	. 
	nop			;1f76	00 	. 
	nop			;1f77	00 	. 
	nop			;1f78	00 	. 
	nop			;1f79	00 	. 
	nop			;1f7a	00 	. 
	nop			;1f7b	00 	. 
	nop			;1f7c	00 	. 
	nop			;1f7d	00 	. 
	nop			;1f7e	00 	. 
	nop			;1f7f	00 	. 
	nop			;1f80	00 	. 
	nop			;1f81	00 	. 
	nop			;1f82	00 	. 
	nop			;1f83	00 	. 
	nop			;1f84	00 	. 
	nop			;1f85	00 	. 
	nop			;1f86	00 	. 
	nop			;1f87	00 	. 
	nop			;1f88	00 	. 
	nop			;1f89	00 	. 
	nop			;1f8a	00 	. 
	nop			;1f8b	00 	. 
	nop			;1f8c	00 	. 
	nop			;1f8d	00 	. 
	nop			;1f8e	00 	. 
	nop			;1f8f	00 	. 
	nop			;1f90	00 	. 
	nop			;1f91	00 	. 
	nop			;1f92	00 	. 
	nop			;1f93	00 	. 
	nop			;1f94	00 	. 
	nop			;1f95	00 	. 
	nop			;1f96	00 	. 
	nop			;1f97	00 	. 
	nop			;1f98	00 	. 
	nop			;1f99	00 	. 
	nop			;1f9a	00 	. 
	nop			;1f9b	00 	. 
	nop			;1f9c	00 	. 
	nop			;1f9d	00 	. 
	nop			;1f9e	00 	. 
	nop			;1f9f	00 	. 
	nop			;1fa0	00 	. 
	nop			;1fa1	00 	. 
	nop			;1fa2	00 	. 
	nop			;1fa3	00 	. 
	nop			;1fa4	00 	. 
	nop			;1fa5	00 	. 
	nop			;1fa6	00 	. 
	nop			;1fa7	00 	. 
	nop			;1fa8	00 	. 
	nop			;1fa9	00 	. 
	nop			;1faa	00 	. 
	nop			;1fab	00 	. 
	nop			;1fac	00 	. 
	nop			;1fad	00 	. 
	nop			;1fae	00 	. 
	nop			;1faf	00 	. 
	nop			;1fb0	00 	. 
	nop			;1fb1	00 	. 
	nop			;1fb2	00 	. 
	nop			;1fb3	00 	. 
	nop			;1fb4	00 	. 
	nop			;1fb5	00 	. 
	nop			;1fb6	00 	. 
	nop			;1fb7	00 	. 
	nop			;1fb8	00 	. 
	nop			;1fb9	00 	. 
	nop			;1fba	00 	. 
	nop			;1fbb	00 	. 
	nop			;1fbc	00 	. 
	nop			;1fbd	00 	. 
	nop			;1fbe	00 	. 
	nop			;1fbf	00 	. 
	nop			;1fc0	00 	. 
	nop			;1fc1	00 	. 
	nop			;1fc2	00 	. 
	nop			;1fc3	00 	. 
	nop			;1fc4	00 	. 
	nop			;1fc5	00 	. 
	nop			;1fc6	00 	. 
	nop			;1fc7	00 	. 
	nop			;1fc8	00 	. 
	nop			;1fc9	00 	. 
	nop			;1fca	00 	. 
	nop			;1fcb	00 	. 
	nop			;1fcc	00 	. 
	nop			;1fcd	00 	. 
	nop			;1fce	00 	. 
	nop			;1fcf	00 	. 
	nop			;1fd0	00 	. 
	nop			;1fd1	00 	. 
	nop			;1fd2	00 	. 
	nop			;1fd3	00 	. 
	nop			;1fd4	00 	. 
	nop			;1fd5	00 	. 
	nop			;1fd6	00 	. 
	nop			;1fd7	00 	. 
	nop			;1fd8	00 	. 
	nop			;1fd9	00 	. 
	nop			;1fda	00 	. 
	nop			;1fdb	00 	. 
	nop			;1fdc	00 	. 
	nop			;1fdd	00 	. 
	nop			;1fde	00 	. 
	nop			;1fdf	00 	. 
	nop			;1fe0	00 	. 
	nop			;1fe1	00 	. 
	nop			;1fe2	00 	. 
	nop			;1fe3	00 	. 
	nop			;1fe4	00 	. 
	nop			;1fe5	00 	. 
	nop			;1fe6	00 	. 
	nop			;1fe7	00 	. 
	nop			;1fe8	00 	. 
	nop			;1fe9	00 	. 
	nop			;1fea	00 	. 
	nop			;1feb	00 	. 
	nop			;1fec	00 	. 
	nop			;1fed	00 	. 
	nop			;1fee	00 	. 
	nop			;1fef	00 	. 
	nop			;1ff0	00 	. 
	nop			;1ff1	00 	. 
	nop			;1ff2	00 	. 
	nop			;1ff3	00 	. 
	nop			;1ff4	00 	. 
	nop			;1ff5	00 	. 
	nop			;1ff6	00 	. 
	nop			;1ff7	00 	. 
	nop			;1ff8	00 	. 
	nop			;1ff9	00 	. 
	nop			;1ffa	00 	. 
	nop			;1ffb	00 	. 
	nop			;1ffc	00 	. 
	nop			;1ffd	00 	. 
	nop			;1ffe	00 	. 
	nop			;1fff	00 	. 
	nop			;2000	00 	. 
	nop			;2001	00 	. 
	nop			;2002	00 	. 
	nop			;2003	00 	. 
	nop			;2004	00 	. 
	nop			;2005	00 	. 
	nop			;2006	00 	. 
	nop			;2007	00 	. 
	nop			;2008	00 	. 
	nop			;2009	00 	. 
	nop			;200a	00 	. 
	nop			;200b	00 	. 
	nop			;200c	00 	. 
	nop			;200d	00 	. 
	nop			;200e	00 	. 
	nop			;200f	00 	. 
	nop			;2010	00 	. 
	nop			;2011	00 	. 
	nop			;2012	00 	. 
	nop			;2013	00 	. 
	nop			;2014	00 	. 
	nop			;2015	00 	. 
	nop			;2016	00 	. 
	nop			;2017	00 	. 
	nop			;2018	00 	. 
	nop			;2019	00 	. 
	nop			;201a	00 	. 
	nop			;201b	00 	. 
	nop			;201c	00 	. 
	nop			;201d	00 	. 
	nop			;201e	00 	. 
	nop			;201f	00 	. 
	nop			;2020	00 	. 
	nop			;2021	00 	. 
	nop			;2022	00 	. 
	nop			;2023	00 	. 
	nop			;2024	00 	. 
	nop			;2025	00 	. 
	nop			;2026	00 	. 
	nop			;2027	00 	. 
	nop			;2028	00 	. 
	nop			;2029	00 	. 
	nop			;202a	00 	. 
	nop			;202b	00 	. 
	nop			;202c	00 	. 
	nop			;202d	00 	. 
	nop			;202e	00 	. 
	nop			;202f	00 	. 
	nop			;2030	00 	. 
	nop			;2031	00 	. 
	nop			;2032	00 	. 
	nop			;2033	00 	. 
	nop			;2034	00 	. 
	nop			;2035	00 	. 
	nop			;2036	00 	. 
	nop			;2037	00 	. 
	nop			;2038	00 	. 
	nop			;2039	00 	. 
	nop			;203a	00 	. 
	nop			;203b	00 	. 
	nop			;203c	00 	. 
	nop			;203d	00 	. 
	nop			;203e	00 	. 
	nop			;203f	00 	. 
	nop			;2040	00 	. 
	nop			;2041	00 	. 
	nop			;2042	00 	. 
	nop			;2043	00 	. 
	nop			;2044	00 	. 
	nop			;2045	00 	. 
	nop			;2046	00 	. 
	nop			;2047	00 	. 
	nop			;2048	00 	. 
	nop			;2049	00 	. 
	nop			;204a	00 	. 
	nop			;204b	00 	. 
	nop			;204c	00 	. 
	nop			;204d	00 	. 
	nop			;204e	00 	. 
	nop			;204f	00 	. 
	nop			;2050	00 	. 
	nop			;2051	00 	. 
	nop			;2052	00 	. 
l2053h:
	nop			;2053	00 	. 
	nop			;2054	00 	. 
	nop			;2055	00 	. 
l2056h:
	nop			;2056	00 	. 
	nop			;2057	00 	. 
	nop			;2058	00 	. 
	nop			;2059	00 	. 
	nop			;205a	00 	. 
	nop			;205b	00 	. 
	nop			;205c	00 	. 
	nop			;205d	00 	. 
	nop			;205e	00 	. 
	nop			;205f	00 	. 
	nop			;2060	00 	. 
	nop			;2061	00 	. 
	nop			;2062	00 	. 
	nop			;2063	00 	. 
	nop			;2064	00 	. 
	nop			;2065	00 	. 
	nop			;2066	00 	. 
	nop			;2067	00 	. 
	nop			;2068	00 	. 
	nop			;2069	00 	. 
	nop			;206a	00 	. 
	nop			;206b	00 	. 
	nop			;206c	00 	. 
	nop			;206d	00 	. 
	nop			;206e	00 	. 
	nop			;206f	00 	. 
	nop			;2070	00 	. 
	nop			;2071	00 	. 
	nop			;2072	00 	. 
	nop			;2073	00 	. 
	nop			;2074	00 	. 
	nop			;2075	00 	. 
	nop			;2076	00 	. 
	nop			;2077	00 	. 
	nop			;2078	00 	. 
	nop			;2079	00 	. 
	nop			;207a	00 	. 
	nop			;207b	00 	. 
	nop			;207c	00 	. 
	nop			;207d	00 	. 
	nop			;207e	00 	. 
	nop			;207f	00 	. 
	nop			;2080	00 	. 
	nop			;2081	00 	. 
	nop			;2082	00 	. 
	nop			;2083	00 	. 
	nop			;2084	00 	. 
	nop			;2085	00 	. 
	nop			;2086	00 	. 
	nop			;2087	00 	. 
	nop			;2088	00 	. 
	nop			;2089	00 	. 
	nop			;208a	00 	. 
	nop			;208b	00 	. 
	nop			;208c	00 	. 
	nop			;208d	00 	. 
	nop			;208e	00 	. 
	nop			;208f	00 	. 
	nop			;2090	00 	. 
	nop			;2091	00 	. 
	nop			;2092	00 	. 
	nop			;2093	00 	. 
	nop			;2094	00 	. 
	nop			;2095	00 	. 
	nop			;2096	00 	. 
	nop			;2097	00 	. 
	nop			;2098	00 	. 
	nop			;2099	00 	. 
	nop			;209a	00 	. 
	nop			;209b	00 	. 
	nop			;209c	00 	. 
	nop			;209d	00 	. 
	nop			;209e	00 	. 
	nop			;209f	00 	. 
	nop			;20a0	00 	. 
	nop			;20a1	00 	. 
	nop			;20a2	00 	. 
	nop			;20a3	00 	. 
	nop			;20a4	00 	. 
	nop			;20a5	00 	. 
	nop			;20a6	00 	. 
	nop			;20a7	00 	. 
	nop			;20a8	00 	. 
	nop			;20a9	00 	. 
	nop			;20aa	00 	. 
	nop			;20ab	00 	. 
	nop			;20ac	00 	. 
	nop			;20ad	00 	. 
	nop			;20ae	00 	. 
	nop			;20af	00 	. 
	nop			;20b0	00 	. 
	nop			;20b1	00 	. 
	nop			;20b2	00 	. 
	nop			;20b3	00 	. 
	nop			;20b4	00 	. 
	nop			;20b5	00 	. 
	nop			;20b6	00 	. 
	nop			;20b7	00 	. 
	nop			;20b8	00 	. 
	nop			;20b9	00 	. 
	nop			;20ba	00 	. 
	nop			;20bb	00 	. 
	nop			;20bc	00 	. 
	nop			;20bd	00 	. 
	nop			;20be	00 	. 
	nop			;20bf	00 	. 
	nop			;20c0	00 	. 
	nop			;20c1	00 	. 
	nop			;20c2	00 	. 
	nop			;20c3	00 	. 
	nop			;20c4	00 	. 
	nop			;20c5	00 	. 
	nop			;20c6	00 	. 
	nop			;20c7	00 	. 
	nop			;20c8	00 	. 
	nop			;20c9	00 	. 
	nop			;20ca	00 	. 
	nop			;20cb	00 	. 
	nop			;20cc	00 	. 
	nop			;20cd	00 	. 
	nop			;20ce	00 	. 
	nop			;20cf	00 	. 
	nop			;20d0	00 	. 
	nop			;20d1	00 	. 
	nop			;20d2	00 	. 
	nop			;20d3	00 	. 
	nop			;20d4	00 	. 
	nop			;20d5	00 	. 
	nop			;20d6	00 	. 
	nop			;20d7	00 	. 
	nop			;20d8	00 	. 
	nop			;20d9	00 	. 
	nop			;20da	00 	. 
	nop			;20db	00 	. 
	nop			;20dc	00 	. 
	nop			;20dd	00 	. 
	nop			;20de	00 	. 
	nop			;20df	00 	. 
	nop			;20e0	00 	. 
	nop			;20e1	00 	. 
	nop			;20e2	00 	. 
	nop			;20e3	00 	. 
	nop			;20e4	00 	. 
	nop			;20e5	00 	. 
	nop			;20e6	00 	. 
	nop			;20e7	00 	. 
	nop			;20e8	00 	. 
	nop			;20e9	00 	. 
	nop			;20ea	00 	. 
	nop			;20eb	00 	. 
	nop			;20ec	00 	. 
	nop			;20ed	00 	. 
	nop			;20ee	00 	. 
	nop			;20ef	00 	. 
	nop			;20f0	00 	. 
	nop			;20f1	00 	. 
	nop			;20f2	00 	. 
	nop			;20f3	00 	. 
	nop			;20f4	00 	. 
	nop			;20f5	00 	. 
	nop			;20f6	00 	. 
	nop			;20f7	00 	. 
	nop			;20f8	00 	. 
	nop			;20f9	00 	. 
	nop			;20fa	00 	. 
	nop			;20fb	00 	. 
	nop			;20fc	00 	. 
	nop			;20fd	00 	. 
	nop			;20fe	00 	. 
	nop			;20ff	00 	. 
	nop			;2100	00 	. 
	nop			;2101	00 	. 
	nop			;2102	00 	. 
	nop			;2103	00 	. 
	nop			;2104	00 	. 
	nop			;2105	00 	. 
	nop			;2106	00 	. 
	nop			;2107	00 	. 
	nop			;2108	00 	. 
	nop			;2109	00 	. 
	nop			;210a	00 	. 
	nop			;210b	00 	. 
	nop			;210c	00 	. 
	nop			;210d	00 	. 
	nop			;210e	00 	. 
	nop			;210f	00 	. 
	nop			;2110	00 	. 
	nop			;2111	00 	. 
	nop			;2112	00 	. 
	nop			;2113	00 	. 
	nop			;2114	00 	. 
	nop			;2115	00 	. 
	nop			;2116	00 	. 
	nop			;2117	00 	. 
	nop			;2118	00 	. 
	nop			;2119	00 	. 
	nop			;211a	00 	. 
	nop			;211b	00 	. 
	nop			;211c	00 	. 
	nop			;211d	00 	. 
	nop			;211e	00 	. 
	nop			;211f	00 	. 
	nop			;2120	00 	. 
	nop			;2121	00 	. 
	nop			;2122	00 	. 
	nop			;2123	00 	. 
	nop			;2124	00 	. 
	nop			;2125	00 	. 
	nop			;2126	00 	. 
	nop			;2127	00 	. 
	nop			;2128	00 	. 
	nop			;2129	00 	. 
	nop			;212a	00 	. 
	nop			;212b	00 	. 
	nop			;212c	00 	. 
	nop			;212d	00 	. 
	nop			;212e	00 	. 
	nop			;212f	00 	. 
	nop			;2130	00 	. 
	nop			;2131	00 	. 
	nop			;2132	00 	. 
	nop			;2133	00 	. 
	nop			;2134	00 	. 
	nop			;2135	00 	. 
	nop			;2136	00 	. 
	nop			;2137	00 	. 
	nop			;2138	00 	. 
	nop			;2139	00 	. 
	nop			;213a	00 	. 
	nop			;213b	00 	. 
	nop			;213c	00 	. 
	nop			;213d	00 	. 
	nop			;213e	00 	. 
	nop			;213f	00 	. 
	nop			;2140	00 	. 
	nop			;2141	00 	. 
	nop			;2142	00 	. 
	nop			;2143	00 	. 
	nop			;2144	00 	. 
	nop			;2145	00 	. 
	nop			;2146	00 	. 
	nop			;2147	00 	. 
	nop			;2148	00 	. 
	nop			;2149	00 	. 
	nop			;214a	00 	. 
	nop			;214b	00 	. 
	nop			;214c	00 	. 
	nop			;214d	00 	. 
	nop			;214e	00 	. 
	nop			;214f	00 	. 
	nop			;2150	00 	. 
	nop			;2151	00 	. 
	nop			;2152	00 	. 
	nop			;2153	00 	. 
	nop			;2154	00 	. 
	nop			;2155	00 	. 
	nop			;2156	00 	. 
	nop			;2157	00 	. 
	nop			;2158	00 	. 
	nop			;2159	00 	. 
	nop			;215a	00 	. 
	nop			;215b	00 	. 
	nop			;215c	00 	. 
	nop			;215d	00 	. 
	nop			;215e	00 	. 
	nop			;215f	00 	. 
	nop			;2160	00 	. 
	nop			;2161	00 	. 
	nop			;2162	00 	. 
	nop			;2163	00 	. 
	nop			;2164	00 	. 
	nop			;2165	00 	. 
	nop			;2166	00 	. 
	nop			;2167	00 	. 
	nop			;2168	00 	. 
	nop			;2169	00 	. 
	nop			;216a	00 	. 
	nop			;216b	00 	. 
	nop			;216c	00 	. 
	nop			;216d	00 	. 
	nop			;216e	00 	. 
	nop			;216f	00 	. 
	nop			;2170	00 	. 
	nop			;2171	00 	. 
	nop			;2172	00 	. 
	nop			;2173	00 	. 
	nop			;2174	00 	. 
	nop			;2175	00 	. 
	nop			;2176	00 	. 
	nop			;2177	00 	. 
	nop			;2178	00 	. 
	nop			;2179	00 	. 
	nop			;217a	00 	. 
	nop			;217b	00 	. 
	nop			;217c	00 	. 
	nop			;217d	00 	. 
	nop			;217e	00 	. 
	nop			;217f	00 	. 
	nop			;2180	00 	. 
	nop			;2181	00 	. 
	nop			;2182	00 	. 
	nop			;2183	00 	. 
	nop			;2184	00 	. 
	nop			;2185	00 	. 
	nop			;2186	00 	. 
	nop			;2187	00 	. 
	nop			;2188	00 	. 
	nop			;2189	00 	. 
	nop			;218a	00 	. 
	nop			;218b	00 	. 
	nop			;218c	00 	. 
	nop			;218d	00 	. 
	nop			;218e	00 	. 
	nop			;218f	00 	. 
	nop			;2190	00 	. 
	nop			;2191	00 	. 
	nop			;2192	00 	. 
	nop			;2193	00 	. 
	nop			;2194	00 	. 
	nop			;2195	00 	. 
	nop			;2196	00 	. 
	nop			;2197	00 	. 
	nop			;2198	00 	. 
	nop			;2199	00 	. 
	nop			;219a	00 	. 
	nop			;219b	00 	. 
	nop			;219c	00 	. 
	nop			;219d	00 	. 
	nop			;219e	00 	. 
	nop			;219f	00 	. 
	nop			;21a0	00 	. 
	nop			;21a1	00 	. 
	nop			;21a2	00 	. 
	nop			;21a3	00 	. 
	nop			;21a4	00 	. 
	nop			;21a5	00 	. 
	nop			;21a6	00 	. 
	nop			;21a7	00 	. 
	nop			;21a8	00 	. 
	nop			;21a9	00 	. 
	nop			;21aa	00 	. 
	nop			;21ab	00 	. 
	nop			;21ac	00 	. 
	nop			;21ad	00 	. 
	nop			;21ae	00 	. 
	nop			;21af	00 	. 
	nop			;21b0	00 	. 
	nop			;21b1	00 	. 
	nop			;21b2	00 	. 
	nop			;21b3	00 	. 
	nop			;21b4	00 	. 
	nop			;21b5	00 	. 
	nop			;21b6	00 	. 
l21b7h:
	nop			;21b7	00 	. 
	nop			;21b8	00 	. 
	nop			;21b9	00 	. 
	nop			;21ba	00 	. 
	nop			;21bb	00 	. 
	nop			;21bc	00 	. 
	nop			;21bd	00 	. 
	nop			;21be	00 	. 
	nop			;21bf	00 	. 
	nop			;21c0	00 	. 
	nop			;21c1	00 	. 
	nop			;21c2	00 	. 
	nop			;21c3	00 	. 
	nop			;21c4	00 	. 
	nop			;21c5	00 	. 
	nop			;21c6	00 	. 
	nop			;21c7	00 	. 
	nop			;21c8	00 	. 
	nop			;21c9	00 	. 
	nop			;21ca	00 	. 
	nop			;21cb	00 	. 
	nop			;21cc	00 	. 
	nop			;21cd	00 	. 
	nop			;21ce	00 	. 
	nop			;21cf	00 	. 
	nop			;21d0	00 	. 
	nop			;21d1	00 	. 
	nop			;21d2	00 	. 
	nop			;21d3	00 	. 
	nop			;21d4	00 	. 
	nop			;21d5	00 	. 
	nop			;21d6	00 	. 
	nop			;21d7	00 	. 
	nop			;21d8	00 	. 
	nop			;21d9	00 	. 
	nop			;21da	00 	. 
	nop			;21db	00 	. 
	nop			;21dc	00 	. 
	nop			;21dd	00 	. 
	nop			;21de	00 	. 
	nop			;21df	00 	. 
	nop			;21e0	00 	. 
	nop			;21e1	00 	. 
	nop			;21e2	00 	. 
	nop			;21e3	00 	. 
	nop			;21e4	00 	. 
	nop			;21e5	00 	. 
	nop			;21e6	00 	. 
	nop			;21e7	00 	. 
	nop			;21e8	00 	. 
	nop			;21e9	00 	. 
	nop			;21ea	00 	. 
	nop			;21eb	00 	. 
	nop			;21ec	00 	. 
	nop			;21ed	00 	. 
	nop			;21ee	00 	. 
	nop			;21ef	00 	. 
	nop			;21f0	00 	. 
	nop			;21f1	00 	. 
	nop			;21f2	00 	. 
	nop			;21f3	00 	. 
	nop			;21f4	00 	. 
	nop			;21f5	00 	. 
	nop			;21f6	00 	. 
	nop			;21f7	00 	. 
	nop			;21f8	00 	. 
	nop			;21f9	00 	. 
	nop			;21fa	00 	. 
	nop			;21fb	00 	. 
	nop			;21fc	00 	. 
	nop			;21fd	00 	. 
	nop			;21fe	00 	. 
	nop			;21ff	00 	. 
	nop			;2200	00 	. 
	nop			;2201	00 	. 
	nop			;2202	00 	. 
	nop			;2203	00 	. 
	nop			;2204	00 	. 
	nop			;2205	00 	. 
	nop			;2206	00 	. 
	nop			;2207	00 	. 
	nop			;2208	00 	. 
	nop			;2209	00 	. 
	nop			;220a	00 	. 
	nop			;220b	00 	. 
	nop			;220c	00 	. 
	nop			;220d	00 	. 
	nop			;220e	00 	. 
	nop			;220f	00 	. 
	nop			;2210	00 	. 
	nop			;2211	00 	. 
	nop			;2212	00 	. 
	nop			;2213	00 	. 
	nop			;2214	00 	. 
	nop			;2215	00 	. 
	nop			;2216	00 	. 
	nop			;2217	00 	. 
	nop			;2218	00 	. 
	nop			;2219	00 	. 
	nop			;221a	00 	. 
	nop			;221b	00 	. 
	nop			;221c	00 	. 
	nop			;221d	00 	. 
	nop			;221e	00 	. 
	nop			;221f	00 	. 
	nop			;2220	00 	. 
	nop			;2221	00 	. 
	nop			;2222	00 	. 
	nop			;2223	00 	. 
	nop			;2224	00 	. 
	nop			;2225	00 	. 
	nop			;2226	00 	. 
	nop			;2227	00 	. 
	nop			;2228	00 	. 
	nop			;2229	00 	. 
	nop			;222a	00 	. 
	nop			;222b	00 	. 
	nop			;222c	00 	. 
	nop			;222d	00 	. 
	nop			;222e	00 	. 
	nop			;222f	00 	. 
	nop			;2230	00 	. 
	nop			;2231	00 	. 
	nop			;2232	00 	. 
	nop			;2233	00 	. 
	nop			;2234	00 	. 
	nop			;2235	00 	. 
	nop			;2236	00 	. 
	nop			;2237	00 	. 
	nop			;2238	00 	. 
	nop			;2239	00 	. 
	nop			;223a	00 	. 
	nop			;223b	00 	. 
	nop			;223c	00 	. 
	nop			;223d	00 	. 
	nop			;223e	00 	. 
	nop			;223f	00 	. 
	nop			;2240	00 	. 
	nop			;2241	00 	. 
	nop			;2242	00 	. 
	nop			;2243	00 	. 
	nop			;2244	00 	. 
	nop			;2245	00 	. 
	nop			;2246	00 	. 
	nop			;2247	00 	. 
	nop			;2248	00 	. 
	nop			;2249	00 	. 
	nop			;224a	00 	. 
	nop			;224b	00 	. 
	nop			;224c	00 	. 
	nop			;224d	00 	. 
	nop			;224e	00 	. 
	nop			;224f	00 	. 
	nop			;2250	00 	. 
	nop			;2251	00 	. 
	nop			;2252	00 	. 
	nop			;2253	00 	. 
	nop			;2254	00 	. 
	nop			;2255	00 	. 
	nop			;2256	00 	. 
	nop			;2257	00 	. 
	nop			;2258	00 	. 
	nop			;2259	00 	. 
	nop			;225a	00 	. 
	nop			;225b	00 	. 
	nop			;225c	00 	. 
	nop			;225d	00 	. 
	nop			;225e	00 	. 
	nop			;225f	00 	. 
	nop			;2260	00 	. 
	nop			;2261	00 	. 
	nop			;2262	00 	. 
	nop			;2263	00 	. 
	nop			;2264	00 	. 
	nop			;2265	00 	. 
	nop			;2266	00 	. 
	nop			;2267	00 	. 
	nop			;2268	00 	. 
	nop			;2269	00 	. 
	nop			;226a	00 	. 
	nop			;226b	00 	. 
	nop			;226c	00 	. 
	nop			;226d	00 	. 
	nop			;226e	00 	. 
	nop			;226f	00 	. 
	nop			;2270	00 	. 
	nop			;2271	00 	. 
	nop			;2272	00 	. 
	nop			;2273	00 	. 
	nop			;2274	00 	. 
	nop			;2275	00 	. 
	nop			;2276	00 	. 
	nop			;2277	00 	. 
	nop			;2278	00 	. 
	nop			;2279	00 	. 
	nop			;227a	00 	. 
	nop			;227b	00 	. 
	nop			;227c	00 	. 
	nop			;227d	00 	. 
	nop			;227e	00 	. 
	nop			;227f	00 	. 
	nop			;2280	00 	. 
	nop			;2281	00 	. 
	nop			;2282	00 	. 
	nop			;2283	00 	. 
	nop			;2284	00 	. 
	nop			;2285	00 	. 
	nop			;2286	00 	. 
	nop			;2287	00 	. 
	nop			;2288	00 	. 
	nop			;2289	00 	. 
	nop			;228a	00 	. 
	nop			;228b	00 	. 
	nop			;228c	00 	. 
	nop			;228d	00 	. 
	nop			;228e	00 	. 
	nop			;228f	00 	. 
	nop			;2290	00 	. 
	nop			;2291	00 	. 
	nop			;2292	00 	. 
	nop			;2293	00 	. 
	nop			;2294	00 	. 
	nop			;2295	00 	. 
	nop			;2296	00 	. 
	nop			;2297	00 	. 
	nop			;2298	00 	. 
	nop			;2299	00 	. 
	nop			;229a	00 	. 
	nop			;229b	00 	. 
	nop			;229c	00 	. 
	nop			;229d	00 	. 
	nop			;229e	00 	. 
	nop			;229f	00 	. 
	nop			;22a0	00 	. 
	nop			;22a1	00 	. 
	nop			;22a2	00 	. 
	nop			;22a3	00 	. 
	nop			;22a4	00 	. 
	nop			;22a5	00 	. 
	nop			;22a6	00 	. 
	nop			;22a7	00 	. 
	nop			;22a8	00 	. 
	nop			;22a9	00 	. 
	nop			;22aa	00 	. 
	nop			;22ab	00 	. 
	nop			;22ac	00 	. 
	nop			;22ad	00 	. 
	nop			;22ae	00 	. 
	nop			;22af	00 	. 
	nop			;22b0	00 	. 
	nop			;22b1	00 	. 
	nop			;22b2	00 	. 
	nop			;22b3	00 	. 
	nop			;22b4	00 	. 
	nop			;22b5	00 	. 
	nop			;22b6	00 	. 
	nop			;22b7	00 	. 
	nop			;22b8	00 	. 
	nop			;22b9	00 	. 
	nop			;22ba	00 	. 
	nop			;22bb	00 	. 
	nop			;22bc	00 	. 
	nop			;22bd	00 	. 
	nop			;22be	00 	. 
	nop			;22bf	00 	. 
	nop			;22c0	00 	. 
	nop			;22c1	00 	. 
	nop			;22c2	00 	. 
	nop			;22c3	00 	. 
	nop			;22c4	00 	. 
	nop			;22c5	00 	. 
	nop			;22c6	00 	. 
	nop			;22c7	00 	. 
	nop			;22c8	00 	. 
	nop			;22c9	00 	. 
	nop			;22ca	00 	. 
	nop			;22cb	00 	. 
	nop			;22cc	00 	. 
	nop			;22cd	00 	. 
	nop			;22ce	00 	. 
	nop			;22cf	00 	. 
	nop			;22d0	00 	. 
	nop			;22d1	00 	. 
	nop			;22d2	00 	. 
	nop			;22d3	00 	. 
	nop			;22d4	00 	. 
	nop			;22d5	00 	. 
	nop			;22d6	00 	. 
	nop			;22d7	00 	. 
	nop			;22d8	00 	. 
	nop			;22d9	00 	. 
	nop			;22da	00 	. 
	nop			;22db	00 	. 
	nop			;22dc	00 	. 
	nop			;22dd	00 	. 
	nop			;22de	00 	. 
	nop			;22df	00 	. 
	nop			;22e0	00 	. 
	nop			;22e1	00 	. 
	nop			;22e2	00 	. 
	nop			;22e3	00 	. 
	nop			;22e4	00 	. 
	nop			;22e5	00 	. 
	nop			;22e6	00 	. 
	nop			;22e7	00 	. 
	nop			;22e8	00 	. 
	nop			;22e9	00 	. 
	nop			;22ea	00 	. 
	nop			;22eb	00 	. 
	nop			;22ec	00 	. 
	nop			;22ed	00 	. 
	nop			;22ee	00 	. 
	nop			;22ef	00 	. 
	nop			;22f0	00 	. 
	nop			;22f1	00 	. 
	nop			;22f2	00 	. 
	nop			;22f3	00 	. 
	nop			;22f4	00 	. 
	nop			;22f5	00 	. 
	nop			;22f6	00 	. 
	nop			;22f7	00 	. 
	nop			;22f8	00 	. 
	nop			;22f9	00 	. 
	nop			;22fa	00 	. 
	nop			;22fb	00 	. 
	nop			;22fc	00 	. 
	nop			;22fd	00 	. 
	nop			;22fe	00 	. 
	nop			;22ff	00 	. 
	nop			;2300	00 	. 
	nop			;2301	00 	. 
	nop			;2302	00 	. 
	nop			;2303	00 	. 
	nop			;2304	00 	. 
	nop			;2305	00 	. 
	nop			;2306	00 	. 
	nop			;2307	00 	. 
	nop			;2308	00 	. 
	nop			;2309	00 	. 
	nop			;230a	00 	. 
	nop			;230b	00 	. 
	nop			;230c	00 	. 
	nop			;230d	00 	. 
	nop			;230e	00 	. 
	nop			;230f	00 	. 
	nop			;2310	00 	. 
	nop			;2311	00 	. 
	nop			;2312	00 	. 
	nop			;2313	00 	. 
	nop			;2314	00 	. 
	nop			;2315	00 	. 
	nop			;2316	00 	. 
	nop			;2317	00 	. 
	nop			;2318	00 	. 
	nop			;2319	00 	. 
	nop			;231a	00 	. 
	nop			;231b	00 	. 
	nop			;231c	00 	. 
	nop			;231d	00 	. 
	nop			;231e	00 	. 
	nop			;231f	00 	. 
	nop			;2320	00 	. 
	nop			;2321	00 	. 
	nop			;2322	00 	. 
	nop			;2323	00 	. 
	nop			;2324	00 	. 
	nop			;2325	00 	. 
	nop			;2326	00 	. 
	nop			;2327	00 	. 
	nop			;2328	00 	. 
	nop			;2329	00 	. 
	nop			;232a	00 	. 
	nop			;232b	00 	. 
	nop			;232c	00 	. 
	nop			;232d	00 	. 
	nop			;232e	00 	. 
	nop			;232f	00 	. 
	nop			;2330	00 	. 
	nop			;2331	00 	. 
	nop			;2332	00 	. 
	nop			;2333	00 	. 
	nop			;2334	00 	. 
	nop			;2335	00 	. 
	nop			;2336	00 	. 
	nop			;2337	00 	. 
	nop			;2338	00 	. 
	nop			;2339	00 	. 
	nop			;233a	00 	. 
	nop			;233b	00 	. 
	nop			;233c	00 	. 
	nop			;233d	00 	. 
	nop			;233e	00 	. 
	nop			;233f	00 	. 
	nop			;2340	00 	. 
	nop			;2341	00 	. 
	nop			;2342	00 	. 
	nop			;2343	00 	. 
	nop			;2344	00 	. 
	nop			;2345	00 	. 
	nop			;2346	00 	. 
	nop			;2347	00 	. 
	nop			;2348	00 	. 
	nop			;2349	00 	. 
	nop			;234a	00 	. 
	nop			;234b	00 	. 
	nop			;234c	00 	. 
	nop			;234d	00 	. 
	nop			;234e	00 	. 
	nop			;234f	00 	. 
	nop			;2350	00 	. 
	nop			;2351	00 	. 
	nop			;2352	00 	. 
	nop			;2353	00 	. 
	nop			;2354	00 	. 
START_PASCAL:
	call GetRAMEnd		;2355	cd 7e 06 	. ~ . 
l2358h:
	ld (ram_end),de		;2358	ed 53 54 18 	. S T . 
	ld (stack_adr),hl		;235c	22 52 18 	" R . 
	ld sp,(stack_adr)		;235f	ed 7b 52 18 	. { R . 
	call InitEditor__		;2363	cd a0 2b 	. . + 
	ld a,02ch		;2366	3e 2c 	> , 
	ld (separator__),a		;2368	32 3e 2b 	2 > + 
	ld a,00ah		;236b	3e 0a 	> . 
	ld (listPageSize),a		;236d	32 4c 2b 	2 L + 
	ld hl,0000ah		;2370	21 0a 00 	! . . 
	ld (lineNumStart__),hl		;2373	22 34 2b 	" 4 + 
	ld (lineNumInc__),hl		;2376	22 36 2b 	" 6 + 
	ld hl,StartPASSrc		;2379	21 f3 52 	! . R 
	ld (endPASSrc_adr),hl		;237c	22 44 2b 	" D + 
	ld (startPASSrc_adr__),hl		;237f	22 46 2b 	" F + 
	ld (compiBinStart__),hl		;2382	22 7c 2b 	" | + 
	ld hl,banner		;2385	21 87 2c 	! . , 
	call OutZStr		;2388	cd a1 08 	. . . 
ResetPasStack:
	ld sp,(stack_adr)		;238b	ed 7b 52 18 	. { R . 
	call PrNL		;238f	cd 85 08 	. . . 
	call JResetPrintFlag		;2392	cd d7 06 	. . . 
l2395h:
	ld sp,(stack_adr)		;2395	ed 7b 52 18 	. { R . 
	call sub_2ba3h		;2399	cd a3 2b 	. . + 
	ld h,a			;239c	67 	g 
	ld l,a			;239d	6f 	o 
	ld (param1),hl		;239e	22 38 2b 	" 8 + 
	ld (param2),hl		;23a1	22 3a 2b 	" : + 
	ld hl,(endPASSrc_adr)		;23a4	2a 44 2b 	* D + 
	inc hl			;23a7	23 	# 
	ld de,(compiBinStart__)		;23a8	ed 5b 7c 2b 	. [ | + 
	sbc hl,de		;23ac	ed 52 	. R 
	jr c,ExecCmdLine		;23ae	38 06 	8 . 
	ld hl,l29cbh		;23b0	21 cb 29 	! . ) 
	ld (cmdTabRunAddr),hl		;23b3	22 c5 2a 	" . * 
ExecCmdLine:
	call sub_23edh		;23b6	cd ed 23 	. . # 
	jr nz,l23e5h		;23b9	20 2a 	  * 
	ld hl,l2395h		;23bb	21 95 23 	! . # 
	push hl			;23be	e5 	. 
	ld a,(l2b33h)		;23bf	3a 33 2b 	: 3 + 
	ld hl,cmdTab		;23c2	21 9d 2a 	! . * 
	ld b,013h		;23c5	06 13 	. . 
TestCmd:
	cp (hl)			;23c7	be 	. 
	jr z,RunCmd		;23c8	28 0d 	( . 
	sub 020h		;23ca	d6 20 	.   
	cp (hl)			;23cc	be 	. 
	jr z,RunCmd		;23cd	28 08 	( . 
	add a,020h		;23cf	c6 20 	.   
	inc hl			;23d1	23 	# 
	inc hl			;23d2	23 	# 
	inc hl			;23d3	23 	# 
	djnz TestCmd		;23d4	10 f1 	. . 
	ret			;23d6	c9 	. 
RunCmd:
	inc hl			;23d7	23 	# 
	ld e,(hl)			;23d8	5e 	^ 
	inc hl			;23d9	23 	# 
	ld d,(hl)			;23da	56 	V 
	ex de,hl			;23db	eb 	. 
	jp (hl)			;23dc	e9 	. 
LdHLSrcEnd:
	ld hl,(endPASSrc_adr)		;23dd	2a 44 2b 	* D + 
	ret			;23e0	c9 	. 
l23e1h:
	ld hl,param3		;23e1	21 09 2b 	! . + 
	ret			;23e4	c9 	. 
l23e5h:
	ld hl,tPardon		;23e5	21 00 2b 	! . + 
	call OutZStr		;23e8	cd a1 08 	. . . 
	jr l2395h		;23eb	18 a8 	. . 
sub_23edh:
	ld a,02bh		;23ed	3e 2b 	> + 
	call OutChr		;23ef	cd 29 07 	. ) . 
	ld d,001h		;23f2	16 01 	. . 
	call l0aach		;23f4	cd ac 0a 	. . . 
	ld hl,lineBuf		;23f7	21 01 18 	! . . 
	call sub_249dh		;23fa	cd 9d 24 	. . $ 
	ld (l2b33h),a		;23fd	32 33 2b 	2 3 + 
	ret z			;2400	c8 	. 
	cp 05ah		;2401	fe 5a 	. Z 
	jr z,l2409h		;2403	28 04 	( . 
	cp 07ah		;2405	fe 7a 	. z 
	jr nz,l2411h		;2407	20 08 	  . 
l2409h:
	push hl			;2409	e5 	. 
	ld hl,000afh		;240a	21 af 00 	! . . 
	ld (l24c4h),hl		;240d	22 c4 24 	" . $ 
	pop hl			;2410	e1 	. 
l2411h:
	call IsNum		;2411	cd 57 0a 	. W . 
	jr nc,l2434h		;2414	30 1e 	0 . 
	call sub_24abh		;2416	cd ab 24 	. . $ 
	ret nz			;2419	c0 	. 
	ld (curLineNum_safe__),hl		;241a	22 3c 2b 	" < + 
	inc de			;241d	13 	. 
	ld a,(de)			;241e	1a 	. 
	inc de			;241f	13 	. 
	cp 00dh		;2420	fe 0d 	. . 
	jr nz,l242fh		;2422	20 0b 	  . 
	ld (param1),hl		;2424	22 38 2b 	" 8 + 
	ld (param2),hl		;2427	22 3a 2b 	" : + 
	call DoCmdD		;242a	cd f3 24 	. . $ 
	xor a			;242d	af 	. 
	ret			;242e	c9 	. 
l242fh:
	call sub_28f5h		;242f	cd f5 28 	. . ( 
	xor a			;2432	af 	. 
	ret			;2433	c9 	. 
l2434h:
	call sub_249ch		;2434	cd 9c 24 	. . $ 
	ret z			;2437	c8 	. 
	cp b			;2438	b8 	. 
	jr z,l244ah		;2439	28 0f 	( . 
	call sub_24abh		;243b	cd ab 24 	. . $ 
	ret nz			;243e	c0 	. 
	ld (lineNumStart__),hl		;243f	22 34 2b 	" 4 + 
	ld (param1),hl		;2442	22 38 2b 	" 8 + 
	ex de,hl			;2445	eb 	. 
l2446h:
	call sub_249ch		;2446	cd 9c 24 	. . $ 
	ret z			;2449	c8 	. 
l244ah:
	cp b			;244a	b8 	. 
	jr nz,l2446h		;244b	20 f9 	  . 
	call sub_249ch		;244d	cd 9c 24 	. . $ 
	ret z			;2450	c8 	. 
	cp b			;2451	b8 	. 
	jr z,l2463h		;2452	28 0f 	( . 
	call sub_24abh		;2454	cd ab 24 	. . $ 
	ret nz			;2457	c0 	. 
	ld (lineNumInc__),hl		;2458	22 36 2b 	" 6 + 
	ld (param2),hl		;245b	22 3a 2b 	" : + 
	ex de,hl			;245e	eb 	. 
l245fh:
	call sub_249ch		;245f	cd 9c 24 	. . $ 
	ret z			;2462	c8 	. 
l2463h:
	cp b			;2463	b8 	. 
	jr nz,l245fh		;2464	20 f9 	  . 
	ld c,b			;2466	48 	H 
	inc hl			;2467	23 	# 
	ld a,(hl)			;2468	7e 	~ 
	cp c			;2469	b9 	. 
	jr z,l247dh		;246a	28 11 	( . 
	ld de,param3		;246c	11 09 2b 	. . + 
	call sub_2481h		;246f	cd 81 24 	. . $ 
	jr c,l247eh		;2472	38 0a 	8 . 
	ret z			;2474	c8 	. 
	dec hl			;2475	2b 	+ 
l2476h:
	call sub_249ch		;2476	cd 9c 24 	. . $ 
	ret z			;2479	c8 	. 
	cp b			;247a	b8 	. 
	jr nz,l2476h		;247b	20 f9 	  . 
l247dh:
	inc hl			;247d	23 	# 
l247eh:
	ld de,param4		;247e	11 1e 2b 	. . + 
sub_2481h:
	ld b,014h		;2481	06 14 	. . 
	ld a,00dh		;2483	3e 0d 	> . 
	push de			;2485	d5 	. 
	push bc			;2486	c5 	. 
l2487h:
	ld (de),a			;2487	12 	. 
	inc de			;2488	13 	. 
	djnz l2487h		;2489	10 fc 	. . 
	pop bc			;248b	c1 	. 
	pop de			;248c	d1 	. 
l248dh:
	ld a,(hl)			;248d	7e 	~ 
	inc hl			;248e	23 	# 
	cp c			;248f	b9 	. 
	jr nz,l2494h		;2490	20 02 	  . 
	scf			;2492	37 	7 
	ret			;2493	c9 	. 
l2494h:
	cp 00dh		;2494	fe 0d 	. . 
	ret z			;2496	c8 	. 
	ld (de),a			;2497	12 	. 
	inc de			;2498	13 	. 
	djnz l248dh		;2499	10 f2 	. . 
	ret			;249b	c9 	. 
sub_249ch:
	inc hl			;249c	23 	# 
sub_249dh:
	ld a,(separator__)		;249d	3a 3e 2b 	: > + 
	ld b,a			;24a0	47 	G 
l24a1h:
	ld a,(hl)			;24a1	7e 	~ 
	inc hl			;24a2	23 	# 
	cp 020h		;24a3	fe 20 	.   
	jr z,l24a1h		;24a5	28 fa 	( . 
	dec hl			;24a7	2b 	+ 
	cp 00dh		;24a8	fe 0d 	. . 
	ret			;24aa	c9 	. 
sub_24abh:
	ld a,(hl)			;24ab	7e 	~ 
	inc hl			;24ac	23 	# 
	ld (iBufCurChrAddr),hl		;24ad	22 a9 17 	" . . 
	call IsNum		;24b0	cd 57 0a 	. W . 
	jr nc,l24c7h		;24b3	30 12 	0 . 
	call sub_0b76h		;24b5	cd 76 0b 	. v . 
l24b8h:
	ld a,d			;24b8	7a 	z 
	or e			;24b9	b3 	. 
	ld de,(iBufCurChrAddr)		;24ba	ed 5b a9 17 	. [ . . 
	dec de			;24be	1b 	. 
	ret nz			;24bf	c0 	. 
	ld a,h			;24c0	7c 	| 
	or l			;24c1	b5 	. 
	jr z,l24b8h		;24c2	28 f4 	( . 
l24c4h:
	bit 7,h		;24c4	cb 7c 	. | 
	ret			;24c6	c9 	. 
l24c7h:
	or a			;24c7	b7 	. 
	ret			;24c8	c9 	. 
DoCmdI:
	ld hl,(lineNumStart__)		;24c9	2a 34 2b 	* 4 + 
InsNextLine:
	ld (curLineNum_safe__),hl		;24cc	22 3c 2b 	" < + 
	push hl			;24cf	e5 	. 
	call PrSrcLiNum		;24d0	cd ed 29 	. . ) 
	call EditSrcLine__		;24d3	cd aa 0a 	. . . 
	pop hl			;24d6	e1 	. 
	ret nc			;24d7	d0 	. 
	push hl			;24d8	e5 	. 
	call CompriLineBuf__		;24d9	cd f2 28 	. . ( 
	pop de			;24dc	d1 	. 
	ld hl,(lineNumInc__)		;24dd	2a 36 2b 	* 6 + 
	add hl,de			;24e0	19 	. 
	ld a,h			;24e1	7c 	| 
	rlca			;24e2	07 	. 
	ret c			;24e3	d8 	. 
	jr InsNextLine		;24e4	18 e6 	. . 
GetParams:
	ld bc,(param1)		;24e6	ed 4b 38 2b 	. K 8 + 
	ld a,c			;24ea	79 	y 
	or b			;24eb	b0 	. 
	ret z			;24ec	c8 	. 
	ld hl,(param2)		;24ed	2a 3a 2b 	* : + 
	ld a,l			;24f0	7d 	} 
	or h			;24f1	b4 	. 
	ret			;24f2	c9 	. 
DoCmdD:
	call GetParams		;24f3	cd e6 24 	. . $ 
	ret z			;24f6	c8 	. 
	push hl			;24f7	e5 	. 
	call GotoSrcLineBC		;24f8	cd 9c 29 	. . ) 
	pop bc			;24fb	c1 	. 
	ret c			;24fc	d8 	. 
	push hl			;24fd	e5 	. 
	call GotoSrcLineBC		;24fe	cd 9c 29 	. . ) 
	pop de			;2501	d1 	. 
	call z,INC_HL_toEOL		;2502	cc b6 29 	. . ) 
	or a			;2505	b7 	. 
	sbc hl,de		;2506	ed 52 	. R 
	add hl,de			;2508	19 	. 
	ret z			;2509	c8 	. 
	ret c			;250a	d8 	. 
	ld bc,(endPASSrc_adr)		;250b	ed 4b 44 2b 	. K D + 
	call MoveSrcLines		;250f	cd 17 25 	. . % 
	ld (endPASSrc_adr),de		;2512	ed 53 44 2b 	. S D + 
	ret			;2516	c9 	. 
MoveSrcLines:
	push de			;2517	d5 	. 
	ex de,hl			;2518	eb 	. 
	ld h,b			;2519	60 	` 
	ld l,c			;251a	69 	i 
	or a			;251b	b7 	. 
	sbc hl,de		;251c	ed 52 	. R 
	ld b,h			;251e	44 	D 
	ld c,l			;251f	4d 	M 
	pop hl			;2520	e1 	. 
	sbc hl,de		;2521	ed 52 	. R 
	add hl,de			;2523	19 	. 
	ex de,hl			;2524	eb 	. 
	jr c,MoveSrcLinesUp		;2525	38 0a 	8 . 
	add hl,bc			;2527	09 	. 
	ex de,hl			;2528	eb 	. 
	add hl,bc			;2529	09 	. 
	ex de,hl			;252a	eb 	. 
	inc bc			;252b	03 	. 
	push de			;252c	d5 	. 
	lddr		;252d	ed b8 	. . 
	pop de			;252f	d1 	. 
	ret			;2530	c9 	. 
MoveSrcLinesUp:
	inc bc			;2531	03 	. 
	ldir		;2532	ed b0 	. . 
	dec de			;2534	1b 	. 
	ret			;2535	c9 	. 
DoCmdS:
	ld a,(param3)		;2536	3a 09 2b 	: . + 
	cp 020h		;2539	fe 20 	.   
	ret z			;253b	c8 	. 
	ld (separator__),a		;253c	32 3e 2b 	2 > + 
	ret			;253f	c9 	. 
StartEditPrevLine:
	push bc			;2540	c5 	. 
TryPrevLineNum:
	dec bc			;2541	0b 	. 
	ld a,b			;2542	78 	x 
	or c			;2543	b1 	. 
	jr z,NoPrevLine		;2544	28 0a 	( . 
	call GotoSrcLineBC		;2546	cd 9c 29 	. . ) 
	jr c,NoPrevLine		;2549	38 05 	8 . 
	jr nz,TryPrevLineNum		;254b	20 f4 	  . 
	pop hl			;254d	e1 	. 
	jr PrevLineFound		;254e	18 01 	. . 
NoPrevLine:
	pop bc			;2550	c1 	. 
PrevLineFound:
	ld sp,(stack_adr)		;2551	ed 7b 52 18 	. { R . 
	ld (param1),bc		;2555	ed 43 38 2b 	. C 8 + 
	ld hl,l2395h		;2559	21 95 23 	! . # 
	push hl			;255c	e5 	. 
	push hl			;255d	e5 	. 
	call InitEditor__		;255e	cd a0 2b 	. . + 
	pop hl			;2561	e1 	. 
	call PrNL		;2562	cd 85 08 	. . . 
DoCmdE:
	ld bc,(param1)		;2565	ed 4b 38 2b 	. K 8 + 
	call GotoSrcLineBC		;2569	cd 9c 29 	. . ) 
	ret nz			;256c	c0 	. 
	inc hl			;256d	23 	# 
	inc hl			;256e	23 	# 
	call ExpSrcToLineBuf		;256f	cd b9 2b 	. . + 
	call sub_29d7h		;2572	cd d7 29 	. . ) 
	call sub_29d4h		;2575	cd d4 29 	. . ) 
l2578h:
	exx			;2578	d9 	. 
	res 0,d		;2579	cb 82 	. . 
	exx			;257b	d9 	. 
	ld a,05fh		;257c	3e 5f 	> _ 
	ld c,(ix+000h)		;257e	dd 4e 00 	. N . 
	bit 3,c		;2581	cb 59 	. Y 
	jr z,l2587h		;2583	28 02 	( . 
	ld a,02ah		;2585	3e 2a 	> * 
l2587h:
	bit 2,c		;2587	cb 51 	. Q 
	jr z,l258dh		;2589	28 02 	( . 
	ld a,02bh		;258b	3e 2b 	> + 
l258dh:
	call GetKey		;258d	cd 81 02 	. . . 
	ld de,l2578h		;2590	11 78 25 	. x % 
	push de			;2593	d5 	. 
	bit 2,c		;2594	cb 51 	. Q 
	jr nz,l2601h		;2596	20 69 	  i 
	bit 3,c		;2598	cb 59 	. Y 
	jr nz,l25a4h		;259a	20 08 	  . 
	ld hl,l2ad6h		;259c	21 d6 2a 	! . * 
	ld b,00eh		;259f	06 0e 	. . 
	jp TestCmd		;25a1	c3 c7 23 	. . # 
l25a4h:
	cp 00dh		;25a4	fe 0d 	. . 
	jr nz,l25ach		;25a6	20 04 	  . 
	res 3,(ix+000h)		;25a8	dd cb 00 9e 	. . . . 
l25ach:
	cp 00bh		;25ac	fe 0b 	. . 
	jr nz,l25b7h		;25ae	20 07 	  . 
	set 4,(ix+000h)		;25b0	dd cb 00 e6 	. . . . 
	or a			;25b4	b7 	. 
	jr l25cbh		;25b5	18 14 	. . 
l25b7h:
	cp 008h		;25b7	fe 08 	. . 
	jr nz,l25c0h		;25b9	20 05 	  . 
	call sub_2668h		;25bb	cd 68 26 	. h & 
	jr l2636h		;25be	18 76 	. v 
l25c0h:
	bit 4,(ix+000h)		;25c0	dd cb 00 66 	. . . f 
	jr z,l25d4h		;25c4	28 0e 	( . 
l25c6h:
	ld a,(l2b3fh)		;25c6	3a 3f 2b 	: ? + 
	and 003h		;25c9	e6 03 	. . 
l25cbh:
	ld a,020h		;25cb	3e 20 	>   
	jr nz,l25d4h		;25cd	20 05 	  . 
	res 4,(ix+000h)		;25cf	dd cb 00 a6 	. . . . 
	ret			;25d3	c9 	. 
l25d4h:
	cp 020h		;25d4	fe 20 	.   
	ret c			;25d6	d8 	. 
	ld e,a			;25d7	5f 	_ 
	ld a,(l2b40h)		;25d8	3a 40 2b 	: @ + 
	or a			;25db	b7 	. 
	ret z			;25dc	c8 	. 
	ld hl,lineBuf		;25dd	21 01 18 	! . . 
	call FindEOL_SetDistInA		;25e0	cd 8f 29 	. . ) 
	cp 051h		;25e3	fe 51 	. Q 
	ret z			;25e5	c8 	. 
	ld b,h			;25e6	44 	D 
	ld c,l			;25e7	4d 	M 
	dec bc			;25e8	0b 	. 
	ld hl,(l2b42h)		;25e9	2a 42 2b 	* B + 
	push de			;25ec	d5 	. 
	push hl			;25ed	e5 	. 
	ld d,h			;25ee	54 	T 
	ld e,l			;25ef	5d 	] 
	inc de			;25f0	13 	. 
	call MoveSrcLines		;25f1	cd 17 25 	. . % 
	pop hl			;25f4	e1 	. 
	pop de			;25f5	d1 	. 
	ld (hl),e			;25f6	73 	s 
	call sub_2619h		;25f7	cd 19 26 	. . & 
	bit 4,(ix+000h)		;25fa	dd cb 00 66 	. . . f 
	ret z			;25fe	c8 	. 
	jr l25c6h		;25ff	18 c5 	. . 
l2601h:
	cp 008h		;2601	fe 08 	. . 
	jr z,sub_2668h		;2603	28 63 	( c 
	cp 00dh		;2605	fe 0d 	. . 
	jr nz,l260dh		;2607	20 04 	  . 
	res 2,(ix+000h)		;2609	dd cb 00 96 	. . . . 
l260dh:
	cp 020h		;260d	fe 20 	.   
	ret c			;260f	d8 	. 
	ld hl,(l2b42h)		;2610	2a 42 2b 	* B + 
	ld d,a			;2613	57 	W 
	ld a,(hl)			;2614	7e 	~ 
	cp 00dh		;2615	fe 0d 	. . 
	ret z			;2617	c8 	. 
	ld (hl),d			;2618	72 	r 
sub_2619h:
	call sub_2653h		;2619	cd 53 26 	. S & 
	cp 00dh		;261c	fe 0d 	. . 
	ret z			;261e	c8 	. 
	call LineEdNextLine__		;261f	cd bc 0a 	. . . 
l2622h:
	ld a,e			;2622	7b 	{ 
	ex de,hl			;2623	eb 	. 
	ld hl,l2b3fh		;2624	21 3f 2b 	! ? + 
	ld (hl),b			;2627	70 	p 
	inc hl			;2628	23 	# 
	ld (hl),c			;2629	71 	q 
	inc hl			;262a	23 	# 
	ld (hl),a			;262b	77 	w 
	inc hl			;262c	23 	# 
	ld (hl),e			;262d	73 	s 
	inc hl			;262e	23 	# 
	ld (hl),d			;262f	72 	r 
	exx			;2630	d9 	. 
	res 1,d		;2631	cb 8a 	. . 
	exx			;2633	d9 	. 
	or a			;2634	b7 	. 
	ret			;2635	c9 	. 
l2636h:
	ld hl,(l2b42h)		;2636	2a 42 2b 	* B + 
	ld a,(hl)			;2639	7e 	~ 
	cp 00dh		;263a	fe 0d 	. . 
	ret z			;263c	c8 	. 
	ld bc,l1851h		;263d	01 51 18 	. Q . 
	ld d,h			;2640	54 	T 
	ld e,l			;2641	5d 	] 
	inc hl			;2642	23 	# 
	call MoveSrcLines		;2643	cd 17 25 	. . % 
	ret			;2646	c9 	. 
l2647h:
	ld a,(l2b3fh)		;2647	3a 3f 2b 	: ? + 
	and 007h		;264a	e6 07 	. . 
	ret z			;264c	c8 	. 
	call sub_2619h		;264d	cd 19 26 	. . & 
	ret z			;2650	c8 	. 
	jr l2647h		;2651	18 f4 	. . 
sub_2653h:
	exx			;2653	d9 	. 
	ld d,003h		;2654	16 03 	. . 
	exx			;2656	d9 	. 
	ld hl,l2b3fh		;2657	21 3f 2b 	! ? + 
	ld b,(hl)			;265a	46 	F 
	inc hl			;265b	23 	# 
	ld c,(hl)			;265c	4e 	N 
	inc hl			;265d	23 	# 
	ld e,(hl)			;265e	5e 	^ 
	inc hl			;265f	23 	# 
	ld a,(hl)			;2660	7e 	~ 
	inc hl			;2661	23 	# 
	ld h,(hl)			;2662	66 	f 
	ld l,a			;2663	6f 	o 
	ld d,006h		;2664	16 06 	. . 
	ld a,(hl)			;2666	7e 	~ 
	ret			;2667	c9 	. 
sub_2668h:
	call sub_2653h		;2668	cd 53 26 	. S & 
	ld a,008h		;266b	3e 08 	> . 
	call ItsCuL		;266d	cd f7 0a 	. . . 
	jr l2622h		;2670	18 b0 	. . 
	set 2,(ix+000h)		;2672	dd cb 00 d6 	. . . . 
	ret			;2676	c9 	. 
l2677h:
	call sub_2619h		;2677	cd 19 26 	. . & 
	jr nz,l2677h		;267a	20 fb 	  . 
	set 3,(ix+000h)		;267c	dd cb 00 de 	. . . . 
	ret			;2680	c9 	. 
l2681h:
	ld hl,(l2b42h)		;2681	2a 42 2b 	* B + 
	ld a,(hl)			;2684	7e 	~ 
	cp 00dh		;2685	fe 0d 	. . 
	ret z			;2687	c8 	. 
	call l2636h		;2688	cd 36 26 	. 6 & 
	jr l2681h		;268b	18 f4 	. . 
l268dh:
	pop hl			;268d	e1 	. 
	pop hl			;268e	e1 	. 
	pop hl			;268f	e1 	. 
	jr l26e8h		;2690	18 56 	. V 
	ld de,(l2b48h)		;2692	ed 5b 48 2b 	. [ H + 
	call sub_2749h		;2696	cd 49 27 	. I ' 
	jr nc,l269dh		;2699	30 02 	0 . 
	pop hl			;269b	e1 	. 
	ret			;269c	c9 	. 
l269dh:
	ld hl,param3		;269d	21 09 2b 	! . + 
	call FindEOL_SetDistInA		;26a0	cd 8f 29 	. . ) 
	dec a			;26a3	3d 	= 
	ld e,a			;26a4	5f 	_ 
	ld hl,param4		;26a5	21 1e 2b 	! . + 
	push hl			;26a8	e5 	. 
	call FindEOL_SetDistInA		;26a9	cd 8f 29 	. . ) 
	dec a			;26ac	3d 	= 
	push af			;26ad	f5 	. 
	sub e			;26ae	93 	. 
	ld b,000h		;26af	06 00 	. . 
	ld d,b			;26b1	50 	P 
	ld c,a			;26b2	4f 	O 
	jp p,l26b7h		;26b3	f2 b7 26 	. . & 
	dec b			;26b6	05 	. 
l26b7h:
	ld hl,lineBuf		;26b7	21 01 18 	! . . 
	call FindEOL_SetDistInA		;26ba	cd 8f 29 	. . ) 
	dec hl			;26bd	2b 	+ 
	push hl			;26be	e5 	. 
	sub 051h		;26bf	d6 51 	. Q 
	add a,c			;26c1	81 	. 
	jp p,l268dh		;26c2	f2 8d 26 	. . & 
	ld hl,(l2b48h)		;26c5	2a 48 2b 	* H + 
	add hl,de			;26c8	19 	. 
	push hl			;26c9	e5 	. 
	add hl,bc			;26ca	09 	. 
	ex de,hl			;26cb	eb 	. 
	pop hl			;26cc	e1 	. 
	pop bc			;26cd	c1 	. 
	call MoveSrcLines		;26ce	cd 17 25 	. . % 
	pop bc			;26d1	c1 	. 
	pop hl			;26d2	e1 	. 
	ld c,b			;26d3	48 	H 
	ld b,000h		;26d4	06 00 	. . 
	inc c			;26d6	0c 	. 
	dec c			;26d7	0d 	. 
	ld de,(l2b48h)		;26d8	ed 5b 48 2b 	. [ H + 
	jr z,l26e0h		;26dc	28 02 	( . 
	ldir		;26de	ed b0 	. . 
l26e0h:
	call sub_2746h		;26e0	cd 46 27 	. F ' 
	pop hl			;26e3	e1 	. 
	jp nc,l275eh		;26e4	d2 5e 27 	. ^ ' 
	ret			;26e7	c9 	. 
l26e8h:
	ld de,(l2b48h)		;26e8	ed 5b 48 2b 	. [ H + 
	inc de			;26ec	13 	. 
	jr l26e0h		;26ed	18 f1 	. . 
DoCmdL:
	ld bc,(param1)		;26ef	ed 4b 38 2b 	. K 8 + 
	ld a,b			;26f3	78 	x 
	or c			;26f4	b1 	. 
	jr nz,l26f8h		;26f5	20 01 	  . 
	inc c			;26f7	0c 	. 
l26f8h:
	call GotoSrcLineBC		;26f8	cd 9c 29 	. . ) 
	ret c			;26fb	d8 	. 
ListPage:
	exx			;26fc	d9 	. 
	set 0,d		;26fd	cb c2 	. . 
	ld a,(listPageSize)		;26ff	3a 4c 2b 	: L + 
	ld e,a			;2702	5f 	_ 
	exx			;2703	d9 	. 
ListLine:
	ld c,(hl)			;2704	4e 	N 
	inc hl			;2705	23 	# 
	ld b,(hl)			;2706	46 	F 
	ex de,hl			;2707	eb 	. 
	ld hl,(param2)		;2708	2a 3a 2b 	* : + 
	ld a,h			;270b	7c 	| 
	or l			;270c	b5 	. 
	jr nz,l2712h		;270d	20 03 	  . 
	ld hl,07fffh		;270f	21 ff 7f 	! .  
l2712h:
	sbc hl,bc		;2712	ed 42 	. B 
	ret c			;2714	d8 	. 
	ld h,b			;2715	60 	` 
	ld l,c			;2716	69 	i 
	push de			;2717	d5 	. 
	call PrSrcLiNum		;2718	cd ed 29 	. . ) 
	pop hl			;271b	e1 	. 
	push hl			;271c	e5 	. 
	inc hl			;271d	23 	# 
	call ExpSrcToLineBuf		;271e	cd b9 2b 	. . + 
	call EditSrcLine__		;2721	cd aa 0a 	. . . 
	pop hl			;2724	e1 	. 
	dec hl			;2725	2b 	+ 
	call INC_HL_toEOL		;2726	cd b6 29 	. . ) 
	ret z			;2729	c8 	. 
	exx			;272a	d9 	. 
	dec e			;272b	1d 	. 
	ld a,e			;272c	7b 	{ 
	dec a			;272d	3d 	= 
	exx			;272e	d9 	. 
	jp p,ListLine		;272f	f2 04 27 	. . ' 
	call GetKey		;2732	cd 81 02 	. . . 
	cp 003h		;2735	fe 03 	. . 
	ret z			;2737	c8 	. 
	jr ListPage		;2738	18 c2 	. . 
DoCmdK:
	ld a,(param1)		;273a	3a 38 2b 	: 8 + 
	or a			;273d	b7 	. 
	jr nz,l2742h		;273e	20 02 	  . 
	ld a,00ah		;2740	3e 0a 	> . 
l2742h:
	ld (listPageSize),a		;2742	32 4c 2b 	2 L + 
	ret			;2745	c9 	. 
sub_2746h:
	call PrNL		;2746	cd 85 08 	. . . 
sub_2749h:
	push de			;2749	d5 	. 
	ld hl,(param1)		;274a	2a 38 2b 	* 8 + 
	call CompriLineBuf__		;274d	cd f2 28 	. . ( 
	push hl			;2750	e5 	. 
	call ExpSrcToLineBuf		;2751	cd b9 2b 	. . + 
	pop bc			;2754	c1 	. 
	dec bc			;2755	0b 	. 
	dec bc			;2756	0b 	. 
	pop de			;2757	d1 	. 
	jr l279bh		;2758	18 41 	. A 
DoCmdF:
	call sub_277ah		;275a	cd 7a 27 	. z ' 
	ret c			;275d	d8 	. 
l275eh:
	ld de,(l2b48h)		;275e	ed 5b 48 2b 	. [ H + 
	push de			;2762	d5 	. 
	call sub_29d7h		;2763	cd d7 29 	. . ) 
	call sub_2653h		;2766	cd 53 26 	. S & 
l2769h:
	pop de			;2769	d1 	. 
	or a			;276a	b7 	. 
	sbc hl,de		;276b	ed 52 	. R 
	add hl,de			;276d	19 	. 
	jp z,l2578h		;276e	ca 78 25 	. x % 
	inc hl			;2771	23 	# 
	push de			;2772	d5 	. 
	push hl			;2773	e5 	. 
	call sub_2619h		;2774	cd 19 26 	. . & 
	pop hl			;2777	e1 	. 
	jr l2769h		;2778	18 ef 	. . 
sub_277ah:
	ld bc,(lineNumStart__)		;277a	ed 4b 34 2b 	. K 4 + 
	call GotoSrcLineBC		;277e	cd 9c 29 	. . ) 
	ret c			;2781	d8 	. 
l2782h:
	push hl			;2782	e5 	. 
	ld e,(hl)			;2783	5e 	^ 
	inc hl			;2784	23 	# 
	ld d,(hl)			;2785	56 	V 
	inc hl			;2786	23 	# 
	push de			;2787	d5 	. 
	call ExpSrcToLineBuf		;2788	cd b9 2b 	. . + 
	pop de			;278b	d1 	. 
	pop bc			;278c	c1 	. 
	ld hl,(lineNumInc__)		;278d	2a 36 2b 	* 6 + 
	or a			;2790	b7 	. 
	sbc hl,de		;2791	ed 52 	. R 
	ret c			;2793	d8 	. 
	ld (param1),de		;2794	ed 53 38 2b 	. S 8 + 
	ld de,lineBuf		;2798	11 01 18 	. . . 
l279bh:
	ld (l2b48h),de		;279b	ed 53 48 2b 	. S H + 
	ld hl,param3		;279f	21 09 2b 	! . + 
	ld a,(hl)			;27a2	7e 	~ 
	cp 00dh		;27a3	fe 0d 	. . 
	scf			;27a5	37 	7 
	ret z			;27a6	c8 	. 
l27a7h:
	ld a,(hl)			;27a7	7e 	~ 
	cp 00dh		;27a8	fe 0d 	. . 
	ret z			;27aa	c8 	. 
	ld a,(de)			;27ab	1a 	. 
	cp 00dh		;27ac	fe 0d 	. . 
	jr z,l27b7h		;27ae	28 07 	( . 
	cp (hl)			;27b0	be 	. 
	inc hl			;27b1	23 	# 
	inc de			;27b2	13 	. 
	jr z,l27a7h		;27b3	28 f2 	( . 
	jr l279bh		;27b5	18 e4 	. . 
l27b7h:
	ld h,b			;27b7	60 	` 
	ld l,c			;27b8	69 	i 
	call INC_HL_toEOL		;27b9	cd b6 29 	. . ) 
	jr nz,l2782h		;27bc	20 c4 	  . 
	scf			;27be	37 	7 
	ret			;27bf	c9 	. 
DoCmdP:
	ld bc,(lineNumStart__)		;27c0	ed 4b 34 2b 	. K 4 + 
	call GotoSrcLineBC		;27c4	cd 9c 29 	. . ) 
	ret c			;27c7	d8 	. 
	push hl			;27c8	e5 	. 
	ld bc,(lineNumInc__)		;27c9	ed 4b 36 2b 	. K 6 + 
	call GotoSrcLineBC		;27cd	cd 9c 29 	. . ) 
	pop de			;27d0	d1 	. 
	jr z,CmdPGotoEOL		;27d1	28 0b 	( . 
	jr nc,CmdPGotoEOL		;27d3	30 09 	0 . 
	ld hl,(endPASSrc_adr)		;27d5	2a 44 2b 	* D + 
	ld (hl),000h		;27d8	36 00 	6 . 
	inc hl			;27da	23 	# 
	ld (hl),000h		;27db	36 00 	6 . 
	inc hl			;27dd	23 	# 
CmdPGotoEOL:
	call z,INC_HL_toEOL		;27de	cc b6 29 	. . ) 
	or a			;27e1	b7 	. 
	sbc hl,de		;27e2	ed 52 	. R 
	ret z			;27e4	c8 	. 
	ret c			;27e5	d8 	. 
	ld b,h			;27e6	44 	D 
	ld c,l			;27e7	4d 	M 
	ex de,hl			;27e8	eb 	. 
	ld de,param3		;27e9	11 09 2b 	. . + 
	jp SaveSrcFile		;27ec	c3 a5 07 	. . . 
DoCmdG:
	ld hl,(endPASSrc_adr)		;27ef	2a 44 2b 	* D + 
	push hl			;27f2	e5 	. 
	ld de,param3		;27f3	11 09 2b 	. . + 
	call LoadSrcFile		;27f6	cd b8 07 	. . . 
l27f9h:
	dec de			;27f9	1b 	. 
	ld a,(de)			;27fa	1a 	. 
	or a			;27fb	b7 	. 
	jr z,l27f9h		;27fc	28 fb 	( . 
	inc de			;27fe	13 	. 
	ld (endPASSrc_adr),de		;27ff	ed 53 44 2b 	. S D + 
	pop de			;2803	d1 	. 
	ld hl,(startPASSrc_adr__)		;2804	2a 46 2b 	* F + 
	or a			;2807	b7 	. 
	sbc hl,de		;2808	ed 52 	. R 
	ret z			;280a	c8 	. 
	ld hl,00001h		;280b	21 01 00 	! . . 
	ld (param1),hl		;280e	22 38 2b 	" 8 + 
	ld (param2),hl		;2811	22 3a 2b 	" : + 
DoCmdN:
	call GetParams		;2814	cd e6 24 	. . $ 
	ret z			;2817	c8 	. 
	call sub_2820h		;2818	cd 20 28 	.   ( 
	ret m			;281b	f8 	. 
	set 5,(ix+000h)		;281c	dd cb 00 ee 	. . . . 
sub_2820h:
	ld hl,(param1)		;2820	2a 38 2b 	* 8 + 
	push hl			;2823	e5 	. 
	ld hl,(startPASSrc_adr__)		;2824	2a 46 2b 	* F + 
	call CMP_HL_srcEnd		;2827	cd c1 29 	. . ) 
l282ah:
	pop de			;282a	d1 	. 
	ret z			;282b	c8 	. 
	bit 5,(ix+000h)		;282c	dd cb 00 6e 	. . . n 
	jr z,l2836h		;2830	28 04 	( . 
	ld (hl),e			;2832	73 	s 
	inc hl			;2833	23 	# 
	ld (hl),d			;2834	72 	r 
	dec hl			;2835	2b 	+ 
l2836h:
	ex de,hl			;2836	eb 	. 
	ld bc,(param2)		;2837	ed 4b 3a 2b 	. K : + 
	or a			;283b	b7 	. 
	adc hl,bc		;283c	ed 4a 	. J 
	ret m			;283e	f8 	. 
	push hl			;283f	e5 	. 
	ex de,hl			;2840	eb 	. 
	call INC_HL_toEOL		;2841	cd b6 29 	. . ) 
	jr l282ah		;2844	18 e4 	. . 
DoCmdO:
	ld hl,(endPASSrc_adr)		;2846	2a 44 2b 	* D + 
	push hl			;2849	e5 	. 
	ld de,param3		;284a	11 09 2b 	. . + 
	call LoadSrcFile		;284d	cd b8 07 	. . . 
	ld (endPASSrc_adr),de		;2850	ed 53 44 2b 	. S D + 
	ld hl,(lineNumStart__)		;2854	2a 34 2b 	* 4 + 
	ld a,l			;2857	7d 	} 
	or h			;2858	b4 	. 
	jr z,l285ch		;2859	28 01 	( . 
	dec hl			;285b	2b 	+ 
l285ch:
	ld (l2b4ah),hl		;285c	22 4a 2b 	" J + 
	pop hl			;285f	e1 	. 
l2860h:
	ld de,lineBuf		;2860	11 01 18 	. . . 
	ld a,(lineNumInc__)		;2863	3a 36 2b 	: 6 + 
	ld c,a			;2866	4f 	O 
l2867h:
	ld a,(hl)			;2867	7e 	~ 
	bit 0,c		;2868	cb 41 	. A 
	call nz,Upper		;286a	c4 5a 07 	. Z . 
	ld (de),a			;286d	12 	. 
	cp 00dh		;286e	fe 0d 	. . 
	jr z,l2876h		;2870	28 04 	( . 
	inc hl			;2872	23 	# 
	inc de			;2873	13 	. 
	jr l2867h		;2874	18 f1 	. . 
l2876h:
	ld hl,(l2b4ah)		;2876	2a 4a 2b 	* J + 
	inc hl			;2879	23 	# 
	ld (l2b4ah),hl		;287a	22 4a 2b 	" J + 
	call CompriLineBuf__		;287d	cd f2 28 	. . ( 
	ex de,hl			;2880	eb 	. 
	push hl			;2881	e5 	. 
	push hl			;2882	e5 	. 
	ld a,00dh		;2883	3e 0d 	> . 
	ld bc,00000h		;2885	01 00 00 	. . . 
	cpir		;2888	ed b1 	. . 
	ld a,(hl)			;288a	7e 	~ 
	cp 00ah		;288b	fe 0a 	. . 
	jr nz,l2890h		;288d	20 01 	  . 
	inc hl			;288f	23 	# 
l2890h:
	ex de,hl			;2890	eb 	. 
	ld hl,(endPASSrc_adr)		;2891	2a 44 2b 	* D + 
	or a			;2894	b7 	. 
	sbc hl,de		;2895	ed 52 	. R 
	ld b,h			;2897	44 	D 
	ld c,l			;2898	4d 	M 
	pop hl			;2899	e1 	. 
	ex de,hl			;289a	eb 	. 
	ldir		;289b	ed b0 	. . 
	pop hl			;289d	e1 	. 
	ld a,(hl)			;289e	7e 	~ 
	cp 01ah		;289f	fe 1a 	. . 
	jr nz,l2860h		;28a1	20 bd 	  . 
	ld (hl),000h		;28a3	36 00 	6 . 
	ld (endPASSrc_adr),hl		;28a5	22 44 2b 	" D + 
	ret			;28a8	c9 	. 
SrcToLineBuf:
	or a			;28a9	b7 	. 
	sbc hl,de		;28aa	ed 52 	. R 
	ret z			;28ac	c8 	. 
	push bc			;28ad	c5 	. 
	ld b,h			;28ae	44 	D 
	ld c,l			;28af	4d 	M 
	ld a,00dh		;28b0	3e 0d 	> . 
	ld hl,0fffch		;28b2	21 fc ff 	! . . 
	add hl,bc			;28b5	09 	. 
	jr nc,NotFound		;28b6	30 0c 	0 . 
	inc hl			;28b8	23 	# 
	ld b,h			;28b9	44 	D 
	ld c,l			;28ba	4d 	M 
	ld h,d			;28bb	62 	b 
	ld l,e			;28bc	6b 	k 
	inc hl			;28bd	23 	# 
	inc hl			;28be	23 	# 
	inc hl			;28bf	23 	# 
	cpir		;28c0	ed b1 	. . 
	jr z,l28c8h		;28c2	28 04 	( . 
NotFound:
	scf			;28c4	37 	7 
	pop bc			;28c5	c1 	. 
	ex de,hl			;28c6	eb 	. 
	ret			;28c7	c9 	. 
l28c8h:
	ex de,hl			;28c8	eb 	. 
	ld c,(hl)			;28c9	4e 	N 
	inc hl			;28ca	23 	# 
	ld b,(hl)			;28cb	46 	F 
	inc hl			;28cc	23 	# 
	pop de			;28cd	d1 	. 
	push bc			;28ce	c5 	. 
	call ExpandLine		;28cf	cd bc 2b 	. . + 
	inc hl			;28d2	23 	# 
	pop de			;28d3	d1 	. 
	or a			;28d4	b7 	. 
	ret			;28d5	c9 	. 
DoCmdM:
	ld bc,(lineNumStart__)		;28d6	ed 4b 34 2b 	. K 4 + 
	call GotoSrcLineBC		;28da	cd 9c 29 	. . ) 
	ret nz			;28dd	c0 	. 
	inc hl			;28de	23 	# 
	inc hl			;28df	23 	# 
	call ExpSrcToLineBuf		;28e0	cd b9 2b 	. . + 
	ld hl,(lineNumInc__)		;28e3	2a 36 2b 	* 6 + 
	jr CompriLineBuf__		;28e6	18 0a 	. . 
	call sub_29cch		;28e8	cd cc 29 	. . ) 
	ld hl,(param1)		;28eb	2a 38 2b 	* 8 + 
	ld de,lineBuf		;28ee	11 01 18 	. . . 
	pop bc			;28f1	c1 	. 
CompriLineBuf__:
	ld de,lineBuf		;28f2	11 01 18 	. . . 
sub_28f5h:
	ex de,hl			;28f5	eb 	. 
	ld b,000h		;28f6	06 00 	. . 
SkipSpace:
	ld a,(hl)			;28f8	7e 	~ 
	cp 020h		;28f9	fe 20 	.   
	jr nz,WrNumLeadSp		;28fb	20 04 	  . 
	inc b			;28fd	04 	. 
	inc hl			;28fe	23 	# 
	jr SkipSpace		;28ff	18 f7 	. . 
WrNumLeadSp:
	dec hl			;2901	2b 	+ 
	ld (hl),b			;2902	70 	p 
	inc hl			;2903	23 	# 
	push hl			;2904	e5 	. 
	push de			;2905	d5 	. 
	ld (SP_safe),sp		;2906	ed 73 5a 2b 	. s Z + 
	ex de,hl			;290a	eb 	. 
CompriLine:
	call GetSrcChr		;290b	cd 4d 2b 	. M + 
	call IsAlpha		;290e	cd 94 2f 	. . / 
	jr nc,CompriLine		;2911	30 f8 	0 . 
	push de			;2913	d5 	. 
	call LxIdentifier		;2914	cd 38 31 	. 8 1 
	inc c			;2917	0c 	. 
	dec c			;2918	0d 	. 
	pop hl			;2919	e1 	. 
	jr z,CompriLine		;291a	28 ef 	( . 
	dec hl			;291c	2b 	+ 
	set 7,c		;291d	cb f9 	. . 
	ld (hl),c			;291f	71 	q 
	inc hl			;2920	23 	# 
	push hl			;2921	e5 	. 
	dec de			;2922	1b 	. 
	ld bc,l1851h		;2923	01 51 18 	. Q . 
	ex de,hl			;2926	eb 	. 
	call MoveSrcLines		;2927	cd 17 25 	. . % 
	pop de			;292a	d1 	. 
	jr CompriLine		;292b	18 de 	. . 
GetChr_LinBToSrc:
	bit 6,(ix+000h)		;292d	dd cb 00 76 	. . . v 
	jr nz,GetChr_LinBToSrc1		;2931	20 05 	  . 
	ld a,(de)			;2933	1a 	. 
	inc de			;2934	13 	. 
	jp SetAToSpaceIfEOL		;2935	c3 0b 2e 	. . . 
GetChr_LinBToSrc1:
	res 6,(ix+000h)		;2938	dd cb 00 b6 	. . . . 
	ld sp,(SP_safe)		;293c	ed 7b 5a 2b 	. { Z + 
	pop de			;2940	d1 	. 
	pop hl			;2941	e1 	. 
	push hl			;2942	e5 	. 
	push de			;2943	d5 	. 
	call FindEOL_SetDistInA		;2944	cd 8f 29 	. . ) 
	inc a			;2947	3c 	< 
	ld d,000h		;2948	16 00 	. . 
	ld e,a			;294a	5f 	_ 
	pop hl			;294b	e1 	. 
	push hl			;294c	e5 	. 
	push de			;294d	d5 	. 
	ld b,h			;294e	44 	D 
	ld c,l			;294f	4d 	M 
	call GotoSrcLineBC		;2950	cd 9c 29 	. . ) 
	pop de			;2953	d1 	. 
	jr z,OvwrtSrcLine		;2954	28 21 	( ! 
	ex de,hl			;2956	eb 	. 
	push hl			;2957	e5 	. 
	add hl,de			;2958	19 	. 
	inc hl			;2959	23 	# 
	inc hl			;295a	23 	# 
	ex de,hl			;295b	eb 	. 
	push hl			;295c	e5 	. 
MakeRoomAndInsert:
	ld bc,(endPASSrc_adr)		;295d	ed 4b 44 2b 	. K D + 
	call MoveSrcLines		;2961	cd 17 25 	. . % 
	ld (endPASSrc_adr),de		;2964	ed 53 44 2b 	. S D + 
	pop hl			;2968	e1 	. 
	pop bc			;2969	c1 	. 
	pop de			;296a	d1 	. 
	ld (hl),e			;296b	73 	s 
	inc hl			;296c	23 	# 
	ld (hl),d			;296d	72 	r 
	inc hl			;296e	23 	# 
	ex de,hl			;296f	eb 	. 
	pop hl			;2970	e1 	. 
	dec hl			;2971	2b 	+ 
	push de			;2972	d5 	. 
	ldir		;2973	ed b0 	. . 
	pop hl			;2975	e1 	. 
	ret			;2976	c9 	. 
OvwrtSrcLine:
	push de			;2977	d5 	. 
	push hl			;2978	e5 	. 
	inc hl			;2979	23 	# 
	inc hl			;297a	23 	# 
	inc hl			;297b	23 	# 
	call FindEOL_SetDistInA		;297c	cd 8f 29 	. . ) 
	inc a			;297f	3c 	< 
	push hl			;2980	e5 	. 
	ex de,hl			;2981	eb 	. 
	ld e,a			;2982	5f 	_ 
	ld d,000h		;2983	16 00 	. . 
	or a			;2985	b7 	. 
	sbc hl,de		;2986	ed 52 	. R 
	ex de,hl			;2988	eb 	. 
	pop hl			;2989	e1 	. 
	ex de,hl			;298a	eb 	. 
	add hl,de			;298b	19 	. 
	ex de,hl			;298c	eb 	. 
	jr MakeRoomAndInsert		;298d	18 ce 	. . 
FindEOL_SetDistInA:
	ld a,00dh		;298f	3e 0d 	> . 
	push bc			;2991	c5 	. 
	ld bc,00000h		;2992	01 00 00 	. . . 
	cpir		;2995	ed b1 	. . 
	ld a,c			;2997	79 	y 
	neg		;2998	ed 44 	. D 
	pop bc			;299a	c1 	. 
	ret			;299b	c9 	. 
GotoSrcLineBC:
	ld hl,(startPASSrc_adr__)		;299c	2a 46 2b 	* F + 
	call CMP_HL_srcEnd		;299f	cd c1 29 	. . ) 
TestSrcEnd:
	jr nz,CompLineNumBC		;29a2	20 03 	  . 
	sub 001h		;29a4	d6 01 	. . 
	ret			;29a6	c9 	. 
CompLineNumBC:
	ld e,(hl)			;29a7	5e 	^ 
	inc hl			;29a8	23 	# 
	ld d,(hl)			;29a9	56 	V 
	or a			;29aa	b7 	. 
	ex de,hl			;29ab	eb 	. 
	sbc hl,bc		;29ac	ed 42 	. B 
	ex de,hl			;29ae	eb 	. 
	dec hl			;29af	2b 	+ 
	ret nc			;29b0	d0 	. 
	call INC_HL_toEOL		;29b1	cd b6 29 	. . ) 
	jr TestSrcEnd		;29b4	18 ec 	. . 
INC_HL_toEOL:
	inc hl			;29b6	23 	# 
	inc hl			;29b7	23 	# 
	inc hl			;29b8	23 	# 
	ld a,00dh		;29b9	3e 0d 	> . 
	push bc			;29bb	c5 	. 
	ld c,000h		;29bc	0e 00 	. . 
	cpir		;29be	ed b1 	. . 
	pop bc			;29c0	c1 	. 
CMP_HL_srcEnd:
	push de			;29c1	d5 	. 
	ld de,(endPASSrc_adr)		;29c2	ed 5b 44 2b 	. [ D + 
	xor a			;29c6	af 	. 
	sbc hl,de		;29c7	ed 52 	. R 
	add hl,de			;29c9	19 	. 
	pop de			;29ca	d1 	. 
l29cbh:
	ret			;29cb	c9 	. 
sub_29cch:
	call sub_2619h		;29cc	cd 19 26 	. . & 
	jr nz,sub_29cch		;29cf	20 fb 	  . 
	jp PrNL		;29d1	c3 85 08 	. . . 
sub_29d4h:
	call sub_29cch		;29d4	cd cc 29 	. . ) 
sub_29d7h:
	ld de,lineBuf		;29d7	11 01 18 	. . . 
	ld hl,l2b3fh		;29da	21 3f 2b 	! ? + 
	ld a,022h		;29dd	3e 22 	> " 
	ld (hl),a			;29df	77 	w 
	inc hl			;29e0	23 	# 
	ld (hl),051h		;29e1	36 51 	6 Q 
	inc hl			;29e3	23 	# 
	ld (hl),000h		;29e4	36 00 	6 . 
	inc hl			;29e6	23 	# 
	ld (hl),e			;29e7	73 	s 
	inc hl			;29e8	23 	# 
	ld (hl),d			;29e9	72 	r 
	ld hl,(param1)		;29ea	2a 38 2b 	* 8 + 
PrSrcLiNum:
	ld a,005h		;29ed	3e 05 	> . 
	call PrDez		;29ef	cd 0a 08 	. . . 
	jp PrSpace		;29f2	c3 89 08 	. . . 
	pop hl			;29f5	e1 	. 
	jp PrNL		;29f6	c3 85 08 	. . . 
DoCmdX:
	ld de,StartPASSrc		;29f9	11 f3 52 	. . R 
	call PrWordHex		;29fc	cd bb 08 	. . . 
	call PrSpace		;29ff	cd 89 08 	. . . 
	ld de,(endPASSrc_adr)		;2a02	ed 5b 44 2b 	. [ D + 
	call PrWordHex		;2a06	cd bb 08 	. . . 
	call PrSpace		;2a09	cd 89 08 	. . . 
	ld de,(stack_adr)		;2a0c	ed 5b 52 18 	. [ R . 
	call PrWordHex		;2a10	cd bb 08 	. . . 
	call PrSpace		;2a13	cd 89 08 	. . . 
	ld de,(ram_end)		;2a16	ed 5b 54 18 	. [ T . 
	call PrWordHex		;2a1a	cd bb 08 	. . . 
	jp PrNL		;2a1d	c3 85 08 	. . . 
DoCmdV:
	ld a,005h		;2a20	3e 05 	> . 
	ld hl,(lineNumStart__)		;2a22	2a 34 2b 	* 4 + 
	call PrDez		;2a25	cd 0a 08 	. . . 
	call sub_2a6eh		;2a28	cd 6e 2a 	. n * 
	ld a,005h		;2a2b	3e 05 	> . 
	ld hl,(lineNumInc__)		;2a2d	2a 36 2b 	* 6 + 
	call PrDez		;2a30	cd 0a 08 	. . . 
	call sub_2a6eh		;2a33	cd 6e 2a 	. n * 
	ld hl,param3		;2a36	21 09 2b 	! . + 
	call sub_2a64h		;2a39	cd 64 2a 	. d * 
	call sub_2a6eh		;2a3c	cd 6e 2a 	. n * 
	ld hl,param4		;2a3f	21 1e 2b 	! . + 
	call sub_2a64h		;2a42	cd 64 2a 	. d * 
	jp PrNL		;2a45	c3 85 08 	. . . 
DoCmdZ:
	ld hl,(lineNumStart__)		;2a48	2a 34 2b 	* 4 + 
	ld de,(lineNumInc__)		;2a4b	ed 5b 36 2b 	. [ 6 + 
	ld bc,07ccbh		;2a4f	01 cb 7c 	. . | 
	ld (l24c4h),bc		;2a52	ed 43 c4 24 	. C . $ 
	ld a,h			;2a56	7c 	| 
	cp 054h		;2a57	fe 54 	. T 
	jr c,l2a5eh		;2a59	38 03 	8 . 
	ld a,d			;2a5b	7a 	z 
	cp 014h		;2a5c	fe 14 	. . 
l2a5eh:
	jp c,l23e5h		;2a5e	da e5 23 	. . # 
	jp l2358h		;2a61	c3 58 23 	. X # 
sub_2a64h:
	ld a,(hl)			;2a64	7e 	~ 
	cp 00dh		;2a65	fe 0d 	. . 
	ret z			;2a67	c8 	. 
	call OutChr		;2a68	cd 29 07 	. ) . 
	inc hl			;2a6b	23 	# 
	jr sub_2a64h		;2a6c	18 f6 	. . 
sub_2a6eh:
	ld a,(separator__)		;2a6e	3a 3e 2b 	: > + 
	jp OutChr		;2a71	c3 29 07 	. ) . 
DoCmdT:
	call GotoSrcLinePar1		;2a74	cd 8c 2a 	. . * 
	jp JCompileToRuntimeEnd		;2a77	c3 f5 06 	. . . 
DoCmdC:
	ld hl,PasPrgStart		;2a7a	21 c8 06 	! . . 
	ld (cmdTabRunAddr),hl		;2a7d	22 c5 2a 	" . * 
	call GotoSrcLinePar1		;2a80	cd 8c 2a 	. . * 
	ld de,(endPASSrc_adr)		;2a83	ed 5b 44 2b 	. [ D + 
	inc de			;2a87	13 	. 
	inc de			;2a88	13 	. 
	jp JCompile		;2a89	c3 f2 06 	. . . 
GotoSrcLinePar1:
	ld bc,(param1)		;2a8c	ed 4b 38 2b 	. K 8 + 
	ld a,b			;2a90	78 	x 
	or c			;2a91	b1 	. 
SetHLFirstSrcLine:
	ld hl,(startPASSrc_adr__)		;2a92	2a 46 2b 	* F + 
	ret z			;2a95	c8 	. 
	call GotoSrcLineBC		;2a96	cd 9c 29 	. . ) 
	ret nc			;2a99	d0 	. 
	xor a			;2a9a	af 	. 
	jr SetHLFirstSrcLine		;2a9b	18 f5 	. . 
cmdTab:

; BLOCK 'CmdTab' (start 0x2a9d end 0x2ad6)
CmdTab_start:
	defb 042h		;2a9d	42 	B 
	defb 0cbh		;2a9e	cb 	. 
	defb 006h		;2a9f	06 	. 
	defb 043h		;2aa0	43 	C 
	defb 07ah		;2aa1	7a 	z 
	defb 02ah		;2aa2	2a 	* 
	defb 044h		;2aa3	44 	D 
	defb 0f3h		;2aa4	f3 	. 
	defb 024h		;2aa5	24 	$ 
	defb 045h		;2aa6	45 	E 
	defb 065h		;2aa7	65 	e 
	defb 025h		;2aa8	25 	% 
	defb 046h		;2aa9	46 	F 
	defb 05ah		;2aaa	5a 	Z 
	defb 027h		;2aab	27 	' 
	defb 047h		;2aac	47 	G 
	defb 0efh		;2aad	ef 	. 
	defb 027h		;2aae	27 	' 
	defb 049h		;2aaf	49 	I 
	defb 0c9h		;2ab0	c9 	. 
	defb 024h		;2ab1	24 	$ 
	defb 04ch		;2ab2	4c 	L 
	defb 0efh		;2ab3	ef 	. 
	defb 026h		;2ab4	26 	& 
	defb 04bh		;2ab5	4b 	K 
	defb 03ah		;2ab6	3a 	: 
	defb 027h		;2ab7	27 	' 
	defb 04dh		;2ab8	4d 	M 
	defb 0d6h		;2ab9	d6 	. 
	defb 028h		;2aba	28 	( 
	defb 04eh		;2abb	4e 	N 
	defb 014h		;2abc	14 	. 
	defb 028h		;2abd	28 	( 
	defb 04fh		;2abe	4f 	O 
	defb 046h		;2abf	46 	F 
	defb 028h		;2ac0	28 	( 
	defb 050h		;2ac1	50 	P 
	defb 0c0h		;2ac2	c0 	. 
	defb 027h		;2ac3	27 	' 
	defb 052h		;2ac4	52 	R 
cmdTabRunAddr:
	defb 0c8h		;2ac5	c8 	. 
	defb 006h		;2ac6	06 	. 
	defb 053h		;2ac7	53 	S 
	defb 036h		;2ac8	36 	6 
	defb 025h		;2ac9	25 	% 
	defb 054h		;2aca	54 	T 
	defb 074h		;2acb	74 	t 
	defb 02ah		;2acc	2a 	* 
	defb 056h		;2acd	56 	V 
	defb 020h		;2ace	20 	  
	defb 02ah		;2acf	2a 	* 
	defb 058h		;2ad0	58 	X 
	defb 0f9h		;2ad1	f9 	. 
	defb 029h		;2ad2	29 	) 
	defb 05ah		;2ad3	5a 	Z 
	defb 048h		;2ad4	48 	H 
	defb 02ah		;2ad5	2a 	* 
l2ad6h:
	dec bc			;2ad6	0b 	. 
	ld c,l			;2ad7	4d 	M 
	ld h,009h		;2ad8	26 09 	& . 
	add hl,de			;2ada	19 	. 
	ld h,008h		;2adb	26 08 	& . 
	ld l,b			;2add	68 	h 
	ld h,043h		;2ade	26 43 	& C 
	ld (hl),d			;2ae0	72 	r 
	ld h,00dh		;2ae1	26 0d 	& . 
	ret pe			;2ae3	e8 	. 
	jr z,l2b2ch		;2ae4	28 46 	( F 
	ret pe			;2ae6	e8 	. 
	ld h,049h		;2ae7	26 49 	& I 
	ld a,h			;2ae9	7c 	| 
	ld h,04bh		;2aea	26 4b 	& K 
	ld (hl),026h		;2aec	36 26 	6 & 
	ld c,h			;2aee	4c 	L 
	call nc,05129h		;2aef	d4 29 51 	. ) Q 
	push af			;2af2	f5 	. 
	add hl,hl			;2af3	29 	) 
	ld d,e			;2af4	53 	S 
	sub d			;2af5	92 	. 
	ld h,052h		;2af6	26 52 	& R 
	ld h,c			;2af8	61 	a 
	dec h			;2af9	25 	% 
	ld e,b			;2afa	58 	X 
	ld (hl),a			;2afb	77 	w 
	ld h,05ah		;2afc	26 5a 	& Z 
	add a,c			;2afe	81 	. 
	defb 026h		;2aff	26 	& 
tPardon:
	defb 050h		;2b00	50 	P 
	defb 061h		;2b01	61 	a 
	defb 072h		;2b02	72 	r 
	defb 064h		;2b03	64 	d 
	defb 06fh		;2b04	6f 	o 
	defb 06eh		;2b05	6e 	n 
	defb 03fh		;2b06	3f 	? 
	defb 00dh		;2b07	0d 	. 
	defb 000h		;2b08	00 	. 
param3:
	defb 00dh		;2b09	0d 	. 
	defb 000h		;2b0a	00 	. 
	defb 000h		;2b0b	00 	. 
	defb 000h		;2b0c	00 	. 
	defb 000h		;2b0d	00 	. 
	defb 000h		;2b0e	00 	. 
	defb 000h		;2b0f	00 	. 
	defb 000h		;2b10	00 	. 
	defb 000h		;2b11	00 	. 
	defb 000h		;2b12	00 	. 
	defb 000h		;2b13	00 	. 
	defb 000h		;2b14	00 	. 
	defb 000h		;2b15	00 	. 
	defb 000h		;2b16	00 	. 
	defb 000h		;2b17	00 	. 
	defb 000h		;2b18	00 	. 
	defb 000h		;2b19	00 	. 
	defb 000h		;2b1a	00 	. 
	defb 000h		;2b1b	00 	. 
	defb 000h		;2b1c	00 	. 
	defb 000h		;2b1d	00 	. 
param4:
	defb 00dh		;2b1e	0d 	. 
	defb 000h		;2b1f	00 	. 
	defb 000h		;2b20	00 	. 
	defb 000h		;2b21	00 	. 
	defb 000h		;2b22	00 	. 
	defb 000h		;2b23	00 	. 
	defb 000h		;2b24	00 	. 
	defb 000h		;2b25	00 	. 
	defb 000h		;2b26	00 	. 
	defb 000h		;2b27	00 	. 
	defb 000h		;2b28	00 	. 
	defb 000h		;2b29	00 	. 
	defb 000h		;2b2a	00 	. 
	defb 000h		;2b2b	00 	. 
l2b2ch:
	defb 000h		;2b2c	00 	. 
	defb 000h		;2b2d	00 	. 
	defb 000h		;2b2e	00 	. 
	defb 000h		;2b2f	00 	. 
	defb 000h		;2b30	00 	. 
	defb 000h		;2b31	00 	. 
	defb 000h		;2b32	00 	. 
l2b33h:
	nop			;2b33	00 	. 
lineNumStart__:
	nop			;2b34	00 	. 
	nop			;2b35	00 	. 
lineNumInc__:
	nop			;2b36	00 	. 
	nop			;2b37	00 	. 
param1:
	nop			;2b38	00 	. 
	nop			;2b39	00 	. 
param2:
	nop			;2b3a	00 	. 
	nop			;2b3b	00 	. 
curLineNum_safe__:
	jr z,separator__		;2b3c	28 00 	( . 
separator__:
	nop			;2b3e	00 	. 
l2b3fh:
	dec c			;2b3f	0d 	. 
l2b40h:
	nop			;2b40	00 	. 
	nop			;2b41	00 	. 
l2b42h:
	nop			;2b42	00 	. 
	nop			;2b43	00 	. 
endPASSrc_adr:
	nop			;2b44	00 	. 
	nop			;2b45	00 	. 
startPASSrc_adr__:
	nop			;2b46	00 	. 
	nop			;2b47	00 	. 
l2b48h:
	nop			;2b48	00 	. 
	nop			;2b49	00 	. 
l2b4ah:
	nop			;2b4a	00 	. 
	nop			;2b4b	00 	. 
listPageSize:
	nop			;2b4c	00 	. 
GetSrcChr:
	jp l5491h		;2b4d	c3 91 54 	. . T 
curIdentifier:
	defb 000h		;2b50	00 	. 
	defb 000h		;2b51	00 	. 
	defb 000h		;2b52	00 	. 
	defb 000h		;2b53	00 	. 
	defb 000h		;2b54	00 	. 
	defb 000h		;2b55	00 	. 
	defb 000h		;2b56	00 	. 
	defb 000h		;2b57	00 	. 
	defb 000h		;2b58	00 	. 
	defb 000h		;2b59	00 	. 
SP_safe:
	defb 0f0h		;2b5a	f0 	. 
	defb 07fh		;2b5b	7f 	 
	defb 060h		;2b5c	60 	` 
curNum:
	defw 00000h		;2b5d	00 00 	. . 
curRealHWord:
	defw 00000h		;2b5f	00 00 	. . 
l2b61h:
	defw 00000h		;2b61	00 00 	. . 
l2b63h:
	defw 00000h		;2b63	00 00 	. . 
memEnd:
	defw 00000h		;2b65	00 00 	. . 
l2b67h:
	defw 00000h		;2b67	00 00 	. . 
lastChrRead__:
	defb 020h		;2b69	20 	  
labelListAddr:
	defw 00000h		;2b6a	00 00 	. . 
SymTabAddr__:
	defw 00000h		;2b6c	00 00 	. . 
TopOfHeapAddr__:
	defw 00000h		;2b6e	00 00 	. . 
	defw 00000h		;2b70	00 00 	. . 
BlockLevel__:
	defb 000h		;2b72	00 	. 
lastError__:
	defb 000h		;2b73	00 	. 
l2b74h:
	defb 006h		;2b74	06 	. 
l2b75h:
	defb 000h		;2b75	00 	. 
l2b76h:
	defw 00000h		;2b76	00 00 	. . 
lineBufPtr:
	defw 00000h		;2b78	00 00 	. . 
	defw 00000h		;2b7a	00 00 	. . 
compiBinStart__:
	defw 00000h		;2b7c	00 00 	. . 
l2b7eh:
	defw 00000h		;2b7e	00 00 	. . 
l2b80h:
	defb 000h		;2b80	00 	. 
	defb 000h		;2b81	00 	. 
	defb 000h		;2b82	00 	. 
	defb 000h		;2b83	00 	. 
	defb 000h		;2b84	00 	. 
	defb 000h		;2b85	00 	. 
	defb 000h		;2b86	00 	. 
Merker1:
	defb 000h		;2b87	00 	. 
	defb 000h		;2b88	00 	. 
l2b89h:
	nop			;2b89	00 	. 
	nop			;2b8a	00 	. 
l2b8bh:
	add a,080h		;2b8b	c6 80 	. . 
l2b8dh:
	nop			;2b8d	00 	. 
	nop			;2b8e	00 	. 
binMoveDistance__:
	nop			;2b8f	00 	. 
	nop			;2b90	00 	. 
binMoveDistanceNeg__:
	nop			;2b91	00 	. 
	nop			;2b92	00 	. 
l2b93h:
	nop			;2b93	00 	. 
	nop			;2b94	00 	. 
	nop			;2b95	00 	. 
	nop			;2b96	00 	. 
	nop			;2b97	00 	. 
	nop			;2b98	00 	. 
	nop			;2b99	00 	. 
	nop			;2b9a	00 	. 
	nop			;2b9b	00 	. 
nextLineAddr:
	nop			;2b9c	00 	. 
	nop			;2b9d	00 	. 
l2b9eh:
	ret			;2b9e	c9 	. 
	inc hl			;2b9f	23 	# 
InitEditor__:
	call JResetPrintFlag		;2ba0	cd d7 06 	. . . 
sub_2ba3h:
	ld a,0c3h		;2ba3	3e c3 	> . 
	ld (GetSrcChr),a		;2ba5	32 4d 2b 	2 M + 
	ld hl,GetChr_LinBToSrc		;2ba8	21 2d 29 	! - ) 
	ld (GetSrcChr+1),hl		;2bab	22 4e 2b 	" N + 
	ld ix,l2b75h		;2bae	dd 21 75 2b 	. ! u + 
	xor a			;2bb2	af 	. 
	ld (ix+000h),a		;2bb3	dd 77 00 	. w . 
	ld d,a			;2bb6	57 	W 
	exx			;2bb7	d9 	. 
	ret			;2bb8	c9 	. 
ExpSrcToLineBuf:
	ld de,lineBuf		;2bb9	11 01 18 	. . . 
ExpandLine:
	ld b,(hl)			;2bbc	46 	F 
	inc b			;2bbd	04 	. 
	dec b			;2bbe	05 	. 
	jr z,ExpandNextChar		;2bbf	28 06 	( . 
	ld a,020h		;2bc1	3e 20 	>   
ExpandSp:
	ld (de),a			;2bc3	12 	. 
	inc de			;2bc4	13 	. 
	djnz ExpandSp		;2bc5	10 fc 	. . 
ExpandNextChar:
	inc hl			;2bc7	23 	# 
ExpandLineSrc:
	ld a,(hl)			;2bc8	7e 	~ 
	or a			;2bc9	b7 	. 
	jp p,Expand_CopyChr		;2bca	f2 ed 2b 	. . + 
	sub 080h		;2bcd	d6 80 	. . 
	push hl			;2bcf	e5 	. 
	push de			;2bd0	d5 	. 
	ld hl,ResWordsEntry		;2bd1	21 6e 32 	! n 2 
FindResWord:
	ld e,(hl)			;2bd4	5e 	^ 
	inc hl			;2bd5	23 	# 
	ld d,(hl)			;2bd6	56 	V 
	dec hl			;2bd7	2b 	+ 
	dec hl			;2bd8	2b 	+ 
	cp (hl)			;2bd9	be 	. 
	ex de,hl			;2bda	eb 	. 
	jr nz,FindResWord		;2bdb	20 f7 	  . 
	inc hl			;2bdd	23 	# 
	inc hl			;2bde	23 	# 
	pop de			;2bdf	d1 	. 
ExpandResWord:
	ld a,(hl)			;2be0	7e 	~ 
	or a			;2be1	b7 	. 
	res 7,a		;2be2	cb bf 	. . 
	ld (de),a			;2be4	12 	. 
	inc de			;2be5	13 	. 
	inc hl			;2be6	23 	# 
	jp p,ExpandResWord		;2be7	f2 e0 2b 	. . + 
	pop hl			;2bea	e1 	. 
	jr ExpandNextChar		;2beb	18 da 	. . 
Expand_CopyChr:
	ld (de),a			;2bed	12 	. 
	inc de			;2bee	13 	. 
	cp 00dh		;2bef	fe 0d 	. . 
	jr nz,ExpandNextChar		;2bf1	20 d4 	  . 
	ret			;2bf3	c9 	. 
SetBinStartToRuntimeEnd:
	ld de,RuntimeEnd		;2bf4	11 00 18 	. . . 
Compile:
	ld sp,(stack_adr)		;2bf7	ed 7b 52 18 	. { R . 
	call CoInit		;2bfb	cd 0d 2c 	. . , 
l2bfeh:
	call sub_4781h		;2bfe	cd 81 47 	. . G 
	cp 0aeh		;2c01	fe ae 	. . 
	jp z,CloseCompi		;2c03	ca 6b 2e 	. k . 
	ld e,00bh		;2c06	1e 0b 	. . 
	call CompileErr		;2c08	cd 3a 2f 	. : / 
	jr l2bfeh		;2c0b	18 f1 	. . 
CoInit:
	push de			;2c0d	d5 	. 
	ld (nextLineAddr),hl		;2c0e	22 9c 2b 	" . + 
	call InitEditor__		;2c11	cd a0 2b 	. . + 
	ld hl,00000h		;2c14	21 00 00 	! . . 
	ld (curSrcLineNum),hl		;2c17	22 0c 07 	" . . 
	ld hl,CoVarInitData__		;2c1a	21 d2 2c 	! . , 
	ld de,lastChrRead__		;2c1d	11 69 2b 	. i + 
	ld bc,0000fh		;2c20	01 0f 00 	. . . 
	ldir		;2c23	ed b0 	. . 
	ld hl,CoErNumTooBig		;2c25	21 e4 2c 	! . , 
	ld (JPrError+1),hl		;2c28	22 d5 06 	" . . 
	ld a,0c3h		;2c2b	3e c3 	> . 
	ld (JCodeNextByte),a		;2c2d	32 d1 06 	2 . . 
	ld hl,CodeNextByte		;2c30	21 ee 33 	! . 3 
	ld (JCodeNextByte+1),hl		;2c33	22 d2 06 	" . . 
	ld hl,GetChr_SrcToLinB		;2c36	21 c7 2d 	! . - 
	ld (GetSrcChr+1),hl		;2c39	22 4e 2b 	" N + 
	ld hl,banner_nl		;2c3c	21 86 2c 	! . , 
	call OutZStr		;2c3f	cd a1 08 	. . . 
	call JLdHLSrcEnd		;2c42	cd e6 06 	. . . 
	inc hl			;2c45	23 	# 
	inc hl			;2c46	23 	# 
	ld (compiBinStart__),hl		;2c47	22 7c 2b 	" | + 
	pop hl			;2c4a	e1 	. 
	call PrNL		;2c4b	cd 85 08 	. . . 
	ld (PasPrgStart+1),hl		;2c4e	22 c9 06 	" . . 
	ld de,(compiBinStart__)		;2c51	ed 5b 7c 2b 	. [ | + 
	or a			;2c55	b7 	. 
	sbc hl,de		;2c56	ed 52 	. R 
	ld (binMoveDistance__),hl		;2c58	22 8f 2b 	" . + 
	ex de,hl			;2c5b	eb 	. 
	xor a			;2c5c	af 	. 
	ld l,a			;2c5d	6f 	o 
	ld h,a			;2c5e	67 	g 
	sbc hl,de		;2c5f	ed 52 	. R 
	ld (binMoveDistanceNeg__),hl		;2c61	22 91 2b 	" . + 
	ld hl,(stack_adr)		;2c64	2a 52 18 	* R . 
	jr z,StackAtRamEnd		;2c67	28 03 	( . 
	ld hl,(ram_end)		;2c69	2a 54 18 	* T . 
StackAtRamEnd:
	ld (memEnd),hl		;2c6c	22 65 2b 	" e + 
	exx			;2c6f	d9 	. 
	ld hl,(compiBinStart__)		;2c70	2a 7c 2b 	* | + 
	exx			;2c73	d9 	. 
	call GetLexem		;2c74	cd c3 2f 	. . / 
	ld de,00117h		;2c77	11 17 01 	. . . 
	call ChkLexem_GetLex		;2c7a	cd 08 33 	. . 3 
	ld de,00004h		;2c7d	11 04 00 	. . . 
	call ChkLexem_GetLex		;2c80	cd 08 33 	. . 3 
	jp ChkSemi_GetLex		;2c83	c3 d9 32 	. . 2 
banner_nl:

; BLOCK 'TBanner' (start 0x2c86 end 0x2cd1)
TBanner_start:
	defb 00dh		;2c86	0d 	. 
banner:
	defb 00ch		;2c87	0c 	. 
	defb 012h		;2c88	12 	. 
	defb 02ah		;2c89	2a 	* 
	defb 02ah		;2c8a	2a 	* 
	defb 02ah		;2c8b	2a 	* 
	defb 02ah		;2c8c	2a 	* 
	defb 020h		;2c8d	20 	  
	defb 04bh		;2c8e	4b 	K 
	defb 043h		;2c8f	43 	C 
	defb 02dh		;2c90	2d 	- 
	defb 050h		;2c91	50 	P 
	defb 041h		;2c92	41 	A 
	defb 053h		;2c93	53 	S 
	defb 043h		;2c94	43 	C 
	defb 041h		;2c95	41 	A 
	defb 04ch		;2c96	4c 	L 
	defb 020h		;2c97	20 	  
	defb 056h		;2c98	56 	V 
	defb 035h		;2c99	35 	5 
	defb 02eh		;2c9a	2e 	. 
	defb 031h		;2c9b	31 	1 
	defb 020h		;2c9c	20 	  
	defb 02ah		;2c9d	2a 	* 
	defb 02ah		;2c9e	2a 	* 
	defb 02ah		;2c9f	2a 	* 
	defb 02ah		;2ca0	2a 	* 
	defb 00dh		;2ca1	0d 	. 
	defb 00dh		;2ca2	0d 	. 
	defb 042h		;2ca3	42 	B 
	defb 045h		;2ca4	45 	E 
	defb 041h		;2ca5	41 	A 
	defb 052h		;2ca6	52 	R 
	defb 042h		;2ca7	42 	B 
	defb 02eh		;2ca8	2e 	. 
	defb 020h		;2ca9	20 	  
	defb 056h		;2caa	56 	V 
	defb 04fh		;2cab	4f 	O 
	defb 04eh		;2cac	4e 	N 
	defb 020h		;2cad	20 	  
	defb 020h		;2cae	20 	  
	defb 02bh		;2caf	2b 	+ 
	defb 02bh		;2cb0	2b 	+ 
	defb 02bh		;2cb1	2b 	+ 
	defb 020h		;2cb2	20 	  
	defb 041h		;2cb3	41 	A 
	defb 04dh		;2cb4	4d 	M 
	defb 039h		;2cb5	39 	9 
	defb 030h		;2cb6	30 	0 
	defb 020h		;2cb7	20 	  
	defb 02bh		;2cb8	2b 	+ 
	defb 02bh		;2cb9	2b 	+ 
	defb 02bh		;2cba	2b 	+ 
	defb 00dh		;2cbb	0d 	. 
	defb 00dh		;2cbc	0d 	. 
	defb 020h		;2cbd	20 	  
	defb 020h		;2cbe	20 	  
	defb 020h		;2cbf	20 	  
	defb 028h		;2cc0	28 	( 
	defb 056h		;2cc1	56 	V 
	defb 045h		;2cc2	45 	E 
	defb 052h		;2cc3	52 	R 
	defb 053h		;2cc4	53 	S 
	defb 049h		;2cc5	49 	I 
	defb 04fh		;2cc6	4f 	O 
	defb 04eh		;2cc7	4e 	N 
l2cc8h:
	defb 020h		;2cc8	20 	  
	defb 04bh		;2cc9	4b 	K 
	defb 043h		;2cca	43 	C 
	defb 038h		;2ccb	38 	8 
	defb 035h		;2ccc	35 	5 
	defb 02fh		;2ccd	2f 	/ 
	defb 034h		;2cce	34 	4 
l2ccfh:
	defb 029h		;2ccf	29 	) 
	defb 00dh		;2cd0	0d 	. 
	nop			;2cd1	00 	. 
CoVarInitData__:

; BLOCK 'CoVarInitData' (start 0x2cd2 end 0x2ce0)
CoVarInitData_start:
	defb 020h		;2cd2	20 	  
	defb 071h		;2cd3	71 	q 
	defb 031h		;2cd4	31 	1 
	defb 02bh		;2cd5	2b 	+ 
	defb 01bh		;2cd6	1b 	. 
	defb 035h		;2cd7	35 	5 
l2cd8h:
	defb 01bh		;2cd8	1b 	. 
	defb 0f3h		;2cd9	f3 	. 
	defb 052h		;2cda	52 	R 
	defb 000h		;2cdb	00 	. 
	defb 000h		;2cdc	00 	. 
	defb 006h		;2cdd	06 	. 
	defb 0efh		;2cde	ef 	. 
l2cdfh:
	defb 000h		;2cdf	00 	. 
	nop			;2ce0	00 	. 
CoErNumTooBigA:
	ld (lastChrRead__),a		;2ce1	32 69 2b 	2 i + 
CoErNumTooBig:
	ld e,001h		;2ce4	1e 01 	. . 
l2ce6h:
	call CompileErr		;2ce6	cd 3a 2f 	. : / 
l2ce9h:
	jp l30a8h		;2ce9	c3 a8 30 	. . 0 
l2cech:
	set 1,(ix+002h)		;2cec	dd cb 02 ce 	. . . . 
ChkExponent:
	ld c,d			;2cf0	4a 	J 
	cp 045h		;2cf1	fe 45 	. E 
	jr z,GetExp		;2cf3	28 69 	( i 
l2cf5h:
	ld (lastChrRead__),a		;2cf5	32 69 2b 	2 i + 
	xor a			;2cf8	af 	. 
	cp e			;2cf9	bb 	. 
	jr nz,l2d08h		;2cfa	20 0c 	  . 
	bit 7,h		;2cfc	cb 7c 	. | 
	jr nz,l2d08h		;2cfe	20 08 	  . 
	ld (curRealHWord),hl		;2d00	22 5f 2b 	" _ + 
	ld a,07fh		;2d03	3e 7f 	>  
	jp PrcEnd__		;2d05	c3 aa 30 	. . 0 
l2d08h:
	ld a,d			;2d08	7a 	z 
	jp GetFloatEnds		;2d09	c3 80 2d 	. . - 
GetFloat:
	ld hl,00000h		;2d0c	21 00 00 	! . . 
	ld d,h			;2d0f	54 	T 
	ld e,l			;2d10	5d 	] 
	ld b,007h		;2d11	06 07 	. . 
	push bc			;2d13	c5 	. 
	jr AddNumToResult		;2d14	18 04 	. . 
NextNumPos:
	push bc			;2d16	c5 	. 
	call MulBy10_HL_DE		;2d17	cd 5d 0b 	. ] . 
AddNumToResult:
	sub 030h		;2d1a	d6 30 	. 0 
	ld c,a			;2d1c	4f 	O 
	ld b,d			;2d1d	42 	B 
	add hl,bc			;2d1e	09 	. 
	jr nc,NoNumOverflow		;2d1f	30 01 	0 . 
	inc de			;2d21	13 	. 
NoNumOverflow:
	call GetCIsNum		;2d22	cd b8 2f 	. . / 
	pop bc			;2d25	c1 	. 
	dec b			;2d26	05 	. 
	jr nc,ChkDecPt		;2d27	30 08 	0 . 
	jr nz,NextNumPos		;2d29	20 eb 	  . 
TooManyDigits:
	inc d			;2d2b	14 	. 
	call GetCIsNum		;2d2c	cd b8 2f 	. . / 
	jr c,TooManyDigits		;2d2f	38 fa 	8 . 
ChkDecPt:
	cp 02eh		;2d31	fe 2e 	. . 
	jr nz,ChkExponent		;2d33	20 bb 	  . 
	call GetCIsNum		;2d35	cd b8 2f 	. . / 
	jr nc,l2cech		;2d38	30 b2 	0 . 
	dec b			;2d3a	05 	. 
	inc b			;2d3b	04 	. 
	ld c,d			;2d3c	4a 	J 
	jr z,TooManyFractDigits		;2d3d	28 15 	( . 
NextFractPos:
	push bc			;2d3f	c5 	. 
	call MulBy10_HL_DE		;2d40	cd 5d 0b 	. ] . 
	sub 030h		;2d43	d6 30 	. 0 
AddFractToResult:
	ld c,a			;2d45	4f 	O 
	ld b,d			;2d46	42 	B 
	add hl,bc			;2d47	09 	. 
	jr nc,NoFractOverflow		;2d48	30 01 	0 . 
	inc e			;2d4a	1c 	. 
NoFractOverflow:
	pop bc			;2d4b	c1 	. 
	dec c			;2d4c	0d 	. 
	call GetCIsNum		;2d4d	cd b8 2f 	. . / 
	jr nc,ChkExpF		;2d50	30 07 	0 . 
	djnz NextFractPos		;2d52	10 eb 	. . 
TooManyFractDigits:
	call GetCIsNum		;2d54	cd b8 2f 	. . / 
	jr c,TooManyFractDigits		;2d57	38 fb 	8 . 
ChkExpF:
	ld d,c			;2d59	51 	Q 
	cp 045h		;2d5a	fe 45 	. E 
	jr nz,FractEnds		;2d5c	20 12 	  . 
GetExp:
	push de			;2d5e	d5 	. 
	call GetSrcChr		;2d5f	cd 4d 2b 	. M + 
	cp 02dh		;2d62	fe 2d 	. - 
	jr nz,PosExp		;2d64	20 10 	  . 
	call GetSrcChr		;2d66	cd 4d 2b 	. M + 
	call Get2C_Dec		;2d69	cd 88 2d 	. . - 
	pop af			;2d6c	f1 	. 
	sub b			;2d6d	90 	. 
	jr GetFloatEnds		;2d6e	18 10 	. . 
FractEnds:
	ld (lastChrRead__),a		;2d70	32 69 2b 	2 i + 
	ld a,d			;2d73	7a 	z 
	jr GetFloatEnds		;2d74	18 0a 	. . 
PosExp:
	cp 02bh		;2d76	fe 2b 	. + 
	call z,GetSrcChr		;2d78	cc 4d 2b 	. M + 
	call Get2C_Dec		;2d7b	cd 88 2d 	. . - 
	pop af			;2d7e	f1 	. 
	add a,b			;2d7f	80 	. 
GetFloatEnds:
	jp NumToFloat__		;2d80	c3 32 12 	. 2 . 
l2d83h:
	ld e,01fh		;2d83	1e 1f 	. . 
	jp l2ce6h		;2d85	c3 e6 2c 	. . , 
Get2C_Dec:
	call IsNum		;2d88	cd 57 0a 	. W . 
	jr nc,l2d83h		;2d8b	30 f6 	0 . 
	sub 030h		;2d8d	d6 30 	. 0 
	ld b,a			;2d8f	47 	G 
	call GetCIsNum		;2d90	cd b8 2f 	. . / 
	jr nc,OneDigit		;2d93	30 11 	0 . 
	sub 030h		;2d95	d6 30 	. 0 
	ld c,a			;2d97	4f 	O 
	ld a,b			;2d98	78 	x 
	add a,a			;2d99	87 	. 
	ld b,a			;2d9a	47 	G 
	add a,a			;2d9b	87 	. 
	add a,a			;2d9c	87 	. 
	add a,b			;2d9d	80 	. 
	add a,c			;2d9e	81 	. 
	ld b,a			;2d9f	47 	G 
	call GetCIsNum		;2da0	cd b8 2f 	. . / 
	jp c,CoErNumTooBigA		;2da3	da e1 2c 	. . , 
OneDigit:
	ld (lastChrRead__),a		;2da6	32 69 2b 	2 i + 
	ret			;2da9	c9 	. 
PrSrcLine:
	push de			;2daa	d5 	. 
	call Break		;2dab	cd 15 09 	. . . 
	ld hl,(curSrcLineNum)		;2dae	2a 0c 07 	* . . 
	ld a,005h		;2db1	3e 05 	> . 
	call PrDez		;2db3	cd 0a 08 	. . . 
	call PrSpace		;2db6	cd 89 08 	. . . 
	ld hl,lineBuf		;2db9	21 01 18 	! . . 
PrSrcChr:
	ld a,(hl)			;2dbc	7e 	~ 
	call OutChr		;2dbd	cd 29 07 	. ) . 
	cp 00dh		;2dc0	fe 0d 	. . 
	inc hl			;2dc2	23 	# 
	jr nz,PrSrcChr		;2dc3	20 f7 	  . 
	pop de			;2dc5	d1 	. 
	ret			;2dc6	c9 	. 
GetChr_SrcToLinB:
	push hl			;2dc7	e5 	. 
	bit 6,(ix+000h)		;2dc8	dd cb 00 76 	. . . v 
	jr z,l2e02h		;2dcc	28 34 	( 4 
	push de			;2dce	d5 	. 
	push bc			;2dcf	c5 	. 
l2dd0h:
	call JLdHLSrcEnd		;2dd0	cd e6 06 	. . . 
	ld bc,lineBuf		;2dd3	01 01 18 	. . . 
	ld (lineBufPtr),bc		;2dd6	ed 43 78 2b 	. C x + 
	ld de,(nextLineAddr)		;2dda	ed 5b 9c 2b 	. [ . + 
	call JSrcToLineBuf		;2dde	cd e3 06 	. . . 
	jr z,ErrKeinTxt		;2de1	28 3b 	( ; 
	jr c,l2e15h		;2de3	38 30 	8 0 
	ld (nextLineAddr),hl		;2de5	22 9c 2b 	" . + 
	ld (curSrcLineNum),de		;2de8	ed 53 0c 07 	. S . . 
	res 6,(ix+000h)		;2dec	dd cb 00 b6 	. . . . 
	bit 0,(ix+000h)		;2df0	dd cb 00 46 	. . . F 
	jr z,Quiet1		;2df4	28 0a 	( . 
	call GetTargetAddrInHL__		;2df6	cd d8 33 	. . 3 
	ex de,hl			;2df9	eb 	. 
	call PrWordHex		;2dfa	cd bb 08 	. . . 
	call PrSrcLine		;2dfd	cd aa 2d 	. . - 
Quiet1:
	pop bc			;2e00	c1 	. 
	pop de			;2e01	d1 	. 
l2e02h:
	ld hl,(lineBufPtr)		;2e02	2a 78 2b 	* x + 
	ld a,(hl)			;2e05	7e 	~ 
	inc hl			;2e06	23 	# 
	ld (lineBufPtr),hl		;2e07	22 78 2b 	" x + 
	pop hl			;2e0a	e1 	. 
SetAToSpaceIfEOL:
	cp 00dh		;2e0b	fe 0d 	. . 
	ret nz			;2e0d	c0 	. 
	set 6,(ix+000h)		;2e0e	dd cb 00 f6 	. . . . 
	ld a,020h		;2e12	3e 20 	>   
	ret			;2e14	c9 	. 
l2e15h:
	ld hl,(l2b9eh)		;2e15	2a 9e 2b 	* . + 
	ld (nextLineAddr),hl		;2e18	22 9c 2b 	" . + 
	jp l2dd0h		;2e1b	c3 d0 2d 	. . - 
ErrKeinTxt:
	ld hl,TKeTx_start		;2e1e	21 8e 32 	! . 2 
OutErrAndReset:
	call OutZStr		;2e21	cd a1 08 	. . . 
	jp Reset		;2e24	c3 dd 06 	. . . 
ReadCompOpt:
	ld a,(de)			;2e27	1a 	. 
	inc de			;2e28	13 	. 
	ld hl,compOptTab		;2e29	21 65 31 	! e 1 
	ld b,006h		;2e2c	06 06 	. . 
RCO_CheckChr:
	cp (hl)			;2e2e	be 	. 
	inc hl			;2e2f	23 	# 
	jr z,RCO_ChkPluMin		;2e30	28 0e 	( . 
	inc hl			;2e32	23 	# 
	djnz RCO_CheckChr		;2e33	10 f9 	. . 
	cp 050h		;2e35	fe 50 	. P 
	scf			;2e37	37 	7 
	ret nz			;2e38	c0 	. 
	ld a,010h		;2e39	3e 10 	> . 
	call OutChr		;2e3b	cd 29 07 	. ) . 
	jr RCO_ChkNextOpt		;2e3e	18 12 	. . 
RCO_ChkPluMin:
	ld a,(de)			;2e40	1a 	. 
	inc de			;2e41	13 	. 
	cp 02bh		;2e42	fe 2b 	. + 
	jr z,RCO_SetOn		;2e44	28 14 	( . 
	cp 02dh		;2e46	fe 2d 	. - 
	jr nz,RCO_End		;2e48	20 0e 	  . 
	ld a,(hl)			;2e4a	7e 	~ 
	cpl			;2e4b	2f 	/ 
	and (ix+000h)		;2e4c	dd a6 00 	. . . 
RCO_SetOpts:
	ld (ix+000h),a		;2e4f	dd 77 00 	. w . 
RCO_ChkNextOpt:
	ld a,(de)			;2e52	1a 	. 
	inc de			;2e53	13 	. 
	cp 02ch		;2e54	fe 2c 	. , 
	jr z,ReadCompOpt		;2e56	28 cf 	( . 
RCO_End:
	or a			;2e58	b7 	. 
	ret			;2e59	c9 	. 
RCO_SetOn:
	ld a,(hl)			;2e5a	7e 	~ 
	or (ix+000h)		;2e5b	dd b6 00 	. . . 
	jr RCO_SetOpts		;2e5e	18 ef 	. . 
CSq_Init:
	defb 006h		;2e60	06 	. 
	call SaveCAOS_SP		;2e61	cd 13 07 	. . . 
	call JResetPrintFlag		;2e64	cd d7 06 	. . . 
CSq_InitJRTErr:
	defb 006h		;2e67	06 	. 
	call InitRuntimeErr__		;2e68	cd e1 07 	. . . 
CloseCompi:
	ld hl,TEadr		;2e6b	21 70 32 	! p 2 
	call OutZStr		;2e6e	cd a1 08 	. . . 
	ld hl,CSq_JReset		;2e71	21 2e 2f 	! . / 
	call WCode		;2e74	cd cc 33 	. . 3 
	ex de,hl			;2e77	eb 	. 
	dec de			;2e78	1b 	. 
	call PrWordHex		;2e79	cd bb 08 	. . . 
	call PrNL		;2e7c	cd 85 08 	. . . 
	ld hl,0ffcdh		;2e7f	21 cd ff 	! . . 
	or a			;2e82	b7 	. 
	sbc hl,de		;2e83	ed 52 	. R 
	ex de,hl			;2e85	eb 	. 
	ld hl,(l2b8dh)		;2e86	2a 8d 2b 	* . + 
	dec hl			;2e89	2b 	+ 
	dec hl			;2e8a	2b 	+ 
	call WrDE_ByTargAddr_pl2		;2e8b	cd 17 34 	. . 4 
	ld a,(lastError__)		;2e8e	3a 73 2b 	: s + 
	or a			;2e91	b7 	. 
	jr z,l2ea7h		;2e92	28 13 	( . 
	push af			;2e94	f5 	. 
	ld hl,TFeh1		;2e95	21 7d 32 	! } 2 
	call OutZStr		;2e98	cd a1 08 	. . . 
	pop af			;2e9b	f1 	. 
	ld l,a			;2e9c	6f 	o 
	ld h,000h		;2e9d	26 00 	& . 
	ld a,003h		;2e9f	3e 03 	> . 
	call PrDez		;2ea1	cd 0a 08 	. . . 
	jp Reset		;2ea4	c3 dd 06 	. . . 
l2ea7h:
	ld hl,(binMoveDistance__)		;2ea7	2a 8f 2b 	* . + 
	ld a,h			;2eaa	7c 	| 
	or l			;2eab	b5 	. 
	jr z,RunOrReset		;2eac	28 62 	( b 
	ld hl,TOk		;2eae	21 24 2f 	! $ / 
	call OutZStr		;2eb1	cd a1 08 	. . . 
	call GetKey		;2eb4	cd 81 02 	. . . 
	cp 04ah		;2eb7	fe 4a 	. J 
	jp nz,Reset		;2eb9	c2 dd 06 	. . . 
	ld hl,PasPrgStart		;2ebc	21 c8 06 	! . . 
	ld (l0710h),hl		;2ebf	22 10 07 	" . . 
	ld hl,(JEndPascal+1)		;2ec2	2a cc 06 	* . . 
	ld (Reset+1),hl		;2ec5	22 de 06 	" . . 
	exx			;2ec8	d9 	. 
	push hl			;2ec9	e5 	. 
	ex de,hl			;2eca	eb 	. 
	call sub_06e9h		;2ecb	cd e9 06 	. . . 
	ld bc,00008h		;2ece	01 08 00 	. . . 
	ldir		;2ed1	ed b0 	. . 
	ex de,hl			;2ed3	eb 	. 
	push hl			;2ed4	e5 	. 
	exx			;2ed5	d9 	. 
	call JCodeNextByte		;2ed6	cd d1 06 	. . . 
	defb 0edh		;2ed9	ed 	. 
	call JCodeNextByte		;2eda	cd d1 06 	. . . 
	defb 0b0h		;2edd	b0 	. 
	call JCodeNextByte		;2ede	cd d1 06 	. . . 
	defb 001h		;2ee1	01 	. 
	pop de			;2ee2	d1 	. 
	pop hl			;2ee3	e1 	. 
	push hl			;2ee4	e5 	. 
	push de			;2ee5	d5 	. 
	ld de,(compiBinStart__)		;2ee6	ed 5b 7c 2b 	. [ | + 
	or a			;2eea	b7 	. 
	sbc hl,de		;2eeb	ed 52 	. R 
	push hl			;2eed	e5 	. 
	push hl			;2eee	e5 	. 
	ld hl,RuntimeEnd		;2eef	21 00 18 	! . . 
	ld de,l0200h		;2ef2	11 00 02 	. . . 
	or a			;2ef5	b7 	. 
	sbc hl,de		;2ef6	ed 52 	. R 
	ex de,hl			;2ef8	eb 	. 
	pop hl			;2ef9	e1 	. 
	add hl,de			;2efa	19 	. 
	ld (l0704h),hl		;2efb	22 04 07 	" . . 
	ex de,hl			;2efe	eb 	. 
	call StoreDE		;2eff	cd 0c 34 	. . 4 
	ld hl,CSq_SaveCom		;2f02	21 32 2f 	! 2 / 
	call WCode		;2f05	cd cc 33 	. . 3 
	pop bc			;2f08	c1 	. 
	ld de,RuntimeEnd		;2f09	11 00 18 	. . . 
	ld hl,(compiBinStart__)		;2f0c	2a 7c 2b 	* | + 
	ret			;2f0f	c9 	. 
RunOrReset:
	ld hl,TLauf		;2f10	21 28 2f 	! ( / 
	call OutZStr		;2f13	cd a1 08 	. . . 
	call PrGetKey		;2f16	cd ff 07 	. . . 
	cp 04ah		;2f19	fe 4a 	. J 
	jp nz,Reset		;2f1b	c2 dd 06 	. . . 
	call PrNL		;2f1e	cd 85 08 	. . . 
	jp PasPrgStart		;2f21	c3 c8 06 	. . . 
TOk:

; BLOCK 'TOk' (start 0x2f24 end 0x2f27)
TOk_start:
	defb 04fh		;2f24	4f 	O 
	defb 06bh		;2f25	6b 	k 
	defb 03fh		;2f26	3f 	? 
	nop			;2f27	00 	. 
TLauf:

; BLOCK 'TLauf' (start 0x2f28 end 0x2f2d)
TLauf_start:
	defb 04ch		;2f28	4c 	L 
	defb 061h		;2f29	61 	a 
	defb 075h		;2f2a	75 	u 
	defb 066h		;2f2b	66 	f 
	defb 03fh		;2f2c	3f 	? 
	nop			;2f2d	00 	. 
CSq_JReset:
	defb 003h		;2f2e	03 	. 
	jp Reset		;2f2f	c3 dd 06 	. . . 
CSq_SaveCom:
	defb 00ah		;2f32	0a 	. 
	pop de			;2f33	d1 	. 
	call SaveCom		;2f34	cd d2 07 	. . . 
	jp JEndPascal		;2f37	c3 cb 06 	. . . 
CompileErr:
	push af			;2f3a	f5 	. 
	push bc			;2f3b	c5 	. 
	push hl			;2f3c	e5 	. 
	bit 0,(ix+000h)		;2f3d	dd cb 00 46 	. . . F 
	jr nz,CoEPrFehler		;2f41	20 0a 	  . 
	ld b,004h		;2f43	06 04 	. . 
CoEPr4Spc:
	call PrSpace		;2f45	cd 89 08 	. . . 
	djnz CoEPr4Spc		;2f48	10 fb 	. . 
	call PrSrcLine		;2f4a	cd aa 2d 	. . - 
CoEPrFehler:
	ld hl,TFeh2_start		;2f4d	21 85 32 	! . 2 
	call OutZStr		;2f50	cd a1 08 	. . . 
	ld hl,(lineBufPtr)		;2f53	2a 78 2b 	* x + 
	ld bc,lineBuf		;2f56	01 01 18 	. . . 
	sbc hl,bc		;2f59	ed 42 	. B 
	ld b,l			;2f5b	45 	E 
CoEToErrCol:
	call PrSpace		;2f5c	cd 89 08 	. . . 
	djnz CoEToErrCol		;2f5f	10 fb 	. . 
	ld a,05eh		;2f61	3e 5e 	> ^ 
	call OutChr		;2f63	cd 29 07 	. ) . 
	ld l,e			;2f66	6b 	k 
	ld h,000h		;2f67	26 00 	& . 
	ld a,002h		;2f69	3e 02 	> . 
	call PrDez		;2f6b	cd 0a 08 	. . . 
	ld hl,lastError__		;2f6e	21 73 2b 	! s + 
	inc (hl)			;2f71	34 	4 
	call PrGetKey		;2f72	cd ff 07 	. . . 
	cp 045h		;2f75	fe 45 	. E 
	ld bc,(curSrcLineNum)		;2f77	ed 4b 0c 07 	. K . . 
	jp z,StartEditLine		;2f7b	ca e0 06 	. . . 
	cp 050h		;2f7e	fe 50 	. P 
	jp z,StartEditPrevLine		;2f80	ca 40 25 	. @ % 
	call PrNL		;2f83	cd 85 08 	. . . 
	pop hl			;2f86	e1 	. 
	pop bc			;2f87	c1 	. 
	pop af			;2f88	f1 	. 
	ret			;2f89	c9 	. 
GetCIsAlNum:
	call GetSrcChr		;2f8a	cd 4d 2b 	. M + 
	cp 030h		;2f8d	fe 30 	. 0 
	ccf			;2f8f	3f 	? 
	ret nc			;2f90	d0 	. 
	cp 03ah		;2f91	fe 3a 	. : 
	ret c			;2f93	d8 	. 
IsAlpha:
	cp 041h		;2f94	fe 41 	. A 
	ccf			;2f96	3f 	? 
	ret nc			;2f97	d0 	. 
	cp 05bh		;2f98	fe 5b 	. [ 
	ret c			;2f9a	d8 	. 
	cp 061h		;2f9b	fe 61 	. a 
	ccf			;2f9d	3f 	? 
	ret nc			;2f9e	d0 	. 
	cp 07bh		;2f9f	fe 7b 	. { 
	ret			;2fa1	c9 	. 
GetCIsHex_ToNum:
	call GetSrcChr		;2fa2	cd 4d 2b 	. M + 
	cp 041h		;2fa5	fe 41 	. A 
	jr c,IsNum_ToNum		;2fa7	38 07 	8 . 
	cp 047h		;2fa9	fe 47 	. G 
	ccf			;2fab	3f 	? 
	ret c			;2fac	d8 	. 
	sub 037h		;2fad	d6 37 	. 7 
	ret			;2faf	c9 	. 
IsNum_ToNum:
	call IsNum		;2fb0	cd 57 0a 	. W . 
	ccf			;2fb3	3f 	? 
	ret c			;2fb4	d8 	. 
	sub 030h		;2fb5	d6 30 	. 0 
	ret			;2fb7	c9 	. 
GetCIsNum:
	call GetSrcChr		;2fb8	cd 4d 2b 	. M + 
	jp IsNum		;2fbb	c3 57 0a 	. W . 
LxSrcEnd__:
	ld a,0aeh		;2fbe	3e ae 	> . 
	jp GetLexEnd		;2fc0	c3 3e 30 	. > 0 
GetLexem:
	push hl			;2fc3	e5 	. 
	push de			;2fc4	d5 	. 
	push bc			;2fc5	c5 	. 
	bit 1,(ix+002h)		;2fc6	dd cb 02 4e 	. . . N 
	jr nz,LxSrcEnd__		;2fca	20 f2 	  . 
	ld a,(lastChrRead__)		;2fcc	3a 69 2b 	: i + 
LxSkipSpace:
	cp 020h		;2fcf	fe 20 	.   
	jr nz,SignificantChr		;2fd1	20 05 	  . 
	call GetSrcChr		;2fd3	cd 4d 2b 	. M + 
	jr LxSkipSpace		;2fd6	18 f7 	. . 
SignificantChr:
	cp 041h		;2fd8	fe 41 	. A 
	jr c,LxNumOrPkt		;2fda	38 47 	8 G 
	cp 05bh		;2fdc	fe 5b 	. [ 
	jr nc,LxLowCOrPkt		;2fde	30 06 	0 . 
l2fe0h:
	call LxIdentifier		;2fe0	cd 38 31 	. 8 1 
	jp l303ah		;2fe3	c3 3a 30 	. : 0 
LxLowCOrPkt:
	cp 07bh		;2fe6	fe 7b 	. { 
	jr z,l2ff4h		;2fe8	28 0a 	( . 
	jp nc,l305fh		;2fea	d2 5f 30 	. _ 0 
	cp 061h		;2fed	fe 61 	. a 
	jr nc,l2fe0h		;2fef	30 ef 	0 . 
	jp l305fh		;2ff1	c3 5f 30 	. _ 0 
l2ff4h:
	call GetSrcChr		;2ff4	cd 4d 2b 	. M + 
	cp 024h		;2ff7	fe 24 	. $ 
	jr nz,l300eh		;2ff9	20 13 	  . 
	ld de,(lineBufPtr)		;2ffb	ed 5b 78 2b 	. [ x + 
	call ReadCompOpt		;2fff	cd 27 2e 	. ' . 
	ld (lineBufPtr),de		;3002	ed 53 78 2b 	. S x + 
	call SetAToSpaceIfEOL		;3006	cd 0b 2e 	. . . 
	jr l300eh		;3009	18 03 	. . 
l300bh:
	call GetSrcChr		;300b	cd 4d 2b 	. M + 
l300eh:
	cp 07dh		;300e	fe 7d 	. } 
	jr z,l301dh		;3010	28 0b 	( . 
	cp 02ah		;3012	fe 2a 	. * 
	jr nz,l300bh		;3014	20 f5 	  . 
	call GetSrcChr		;3016	cd 4d 2b 	. M + 
	cp 029h		;3019	fe 29 	. ) 
	jr nz,l300eh		;301b	20 f1 	  . 
l301dh:
	call GetSrcChr		;301d	cd 4d 2b 	. M + 
	jp LxSkipSpace		;3020	c3 cf 2f 	. . / 
LxNumOrPkt:
	call IsNum		;3023	cd 57 0a 	. W . 
	jr c,GetUnsigNum		;3026	38 72 	8 r 
	cp 03ah		;3028	fe 3a 	. : 
	jr nz,l306ah		;302a	20 3e 	  > 
	call GetSrcChr		;302c	cd 4d 2b 	. M + 
	ld c,0bah		;302f	0e ba 	. . 
	cp 03dh		;3031	fe 3d 	. = 
	jr nz,l303ah		;3033	20 05 	  . 
	ld c,07dh		;3035	0e 7d 	. } 
l3037h:
	call GetSrcChr		;3037	cd 4d 2b 	. M + 
l303ah:
	ld (lastChrRead__),a		;303a	32 69 2b 	2 i + 
	ld a,c			;303d	79 	y 
GetLexEnd:
	res 1,(ix+002h)		;303e	dd cb 02 8e 	. . . . 
	pop bc			;3042	c1 	. 
	pop de			;3043	d1 	. 
	pop hl			;3044	e1 	. 
	ret			;3045	c9 	. 
l3046h:
	cp 027h		;3046	fe 27 	. ' 
	jp z,l30d9h		;3048	ca d9 30 	. . 0 
	cp 023h		;304b	fe 23 	. # 
	jr z,l30b2h		;304d	28 63 	( c 
	cp 028h		;304f	fe 28 	. ( 
	jr nz,l305fh		;3051	20 0c 	  . 
	call GetSrcChr		;3053	cd 4d 2b 	. M + 
	cp 02ah		;3056	fe 2a 	. * 
	jp z,l2ff4h		;3058	ca f4 2f 	. . / 
	ld c,0a8h		;305b	0e a8 	. . 
	jr l303ah		;305d	18 db 	. . 
l305fh:
	add a,080h		;305f	c6 80 	. . 
	ld c,a			;3061	4f 	O 
	cp 0aeh		;3062	fe ae 	. . 
	jr nz,l3037h		;3064	20 d1 	  . 
	ld a,020h		;3066	3e 20 	>   
	jr l303ah		;3068	18 d0 	. . 
l306ah:
	jr c,l3046h		;306a	38 da 	8 . 
	ld c,078h		;306c	0e 78 	. x 
	cp 03dh		;306e	fe 3d 	. = 
	jr z,l3037h		;3070	28 c5 	( . 
	cp 03ch		;3072	fe 3c 	. < 
	jr nz,l3089h		;3074	20 13 	  . 
	call GetSrcChr		;3076	cd 4d 2b 	. M + 
	ld c,077h		;3079	0e 77 	. w 
	cp 03eh		;307b	fe 3e 	. > 
	jr z,l3037h		;307d	28 b8 	( . 
	ld c,07ah		;307f	0e 7a 	. z 
	cp 03dh		;3081	fe 3d 	. = 
	jr nz,l303ah		;3083	20 b5 	  . 
	ld c,07ch		;3085	0e 7c 	. | 
	jr l3037h		;3087	18 ae 	. . 
l3089h:
	cp 03eh		;3089	fe 3e 	. > 
	jr nz,l305fh		;308b	20 d2 	  . 
	call GetSrcChr		;308d	cd 4d 2b 	. M + 
	cp 03dh		;3090	fe 3d 	. = 
	ld c,079h		;3092	0e 79 	. y 
	jr nz,l303ah		;3094	20 a4 	  . 
	ld c,07bh		;3096	0e 7b 	. { 
	jr l3037h		;3098	18 9d 	. . 
GetUnsigNum:
	ld (SP_safe),sp		;309a	ed 73 5a 2b 	. s Z + 
	call GetFloat		;309e	cd 0c 2d 	. . - 
	ld (curRealHWord),hl		;30a1	22 5f 2b 	" _ + 
	ld (curNum),de		;30a4	ed 53 5d 2b 	. S ] + 
l30a8h:
	ld a,07eh		;30a8	3e 7e 	> ~ 
PrcEnd__:
	ld sp,(SP_safe)		;30aa	ed 7b 5a 2b 	. { Z + 
	pop bc			;30ae	c1 	. 
	pop de			;30af	d1 	. 
	pop hl			;30b0	e1 	. 
	ret			;30b1	c9 	. 
l30b2h:
	call GetCIsHex_ToNum		;30b2	cd a2 2f 	. . / 
	jr c,CoErrHexExpected		;30b5	38 15 	8 . 
	ld l,a			;30b7	6f 	o 
	ld h,000h		;30b8	26 00 	& . 
	ld b,004h		;30ba	06 04 	. . 
l30bch:
	call GetCIsHex_ToNum		;30bc	cd a2 2f 	. . / 
	jr c,l30d1h		;30bf	38 10 	8 . 
	add hl,hl			;30c1	29 	) 
	add hl,hl			;30c2	29 	) 
	add hl,hl			;30c3	29 	) 
	add hl,hl			;30c4	29 	) 
	or l			;30c5	b5 	. 
	ld l,a			;30c6	6f 	o 
	djnz l30bch		;30c7	10 f3 	. . 
	call GetSrcChr		;30c9	cd 4d 2b 	. M + 
CoErrHexExpected:
	ld e,033h		;30cc	1e 33 	. 3 
	call CompileErr		;30ce	cd 3a 2f 	. : / 
l30d1h:
	ld c,07fh		;30d1	0e 7f 	.  
	ld (curRealHWord),hl		;30d3	22 5f 2b 	" _ + 
	jp l303ah		;30d6	c3 3a 30 	. : 0 
l30d9h:
	call WrJump		;30d9	cd c9 33 	. . 3 
	ld (curRealHWord),hl		;30dc	22 5f 2b 	" _ + 
	ld c,000h		;30df	0e 00 	. . 
ChkEOLInStr:
	call GetSrcChr		;30e1	cd 4d 2b 	. M + 
	bit 6,(ix+000h)		;30e4	dd cb 00 76 	. . . v 
	jr nz,CErrStrLiEnd		;30e8	20 47 	  G 
	cp 027h		;30ea	fe 27 	. ' 
	jr z,ChkDblApos		;30ec	28 06 	( . 
WStrChrToTarget:
	call StoreAToHL2		;30ee	cd e3 33 	. . 3 
	inc c			;30f1	0c 	. 
	jr ChkEOLInStr		;30f2	18 ed 	. . 
ChkDblApos:
	call GetSrcChr		;30f4	cd 4d 2b 	. M + 
	cp 027h		;30f7	fe 27 	. ' 
	jr z,WStrChrToTarget		;30f9	28 f3 	( . 
OnEndOfStr__:
	ld (lastChrRead__),a		;30fb	32 69 2b 	2 i + 
	dec c			;30fe	0d 	. 
	jr nz,ChkEmptyStr		;30ff	20 11 	  . 
	exx			;3101	d9 	. 
	dec hl			;3102	2b 	+ 
	ld a,(hl)			;3103	7e 	~ 
l3104h:
	dec hl			;3104	2b 	+ 
	dec hl			;3105	2b 	+ 
	dec hl			;3106	2b 	+ 
	exx			;3107	d9 	. 
	ld l,a			;3108	6f 	o 
	ld h,0ffh		;3109	26 ff 	& . 
	ld (curRealHWord),hl		;310b	22 5f 2b 	" _ + 
	ld a,076h		;310e	3e 76 	> v 
	jr JGetLexEnd		;3110	18 1c 	. . 
ChkEmptyStr:
	inc c			;3112	0c 	. 
	jr nz,WStrLit__		;3113	20 09 	  . 
	ld e,021h		;3115	1e 21 	. ! 
	call CompileErr		;3117	cd 3a 2f 	. : / 
	xor a			;311a	af 	. 
	exx			;311b	d9 	. 
	jr l3104h		;311c	18 e6 	. . 
WStrLit__:
	ld a,c			;311e	79 	y 
	ld (curNum),a		;311f	32 5d 2b 	2 ] + 
	call GetTargetAddrInHL__		;3122	cd d8 33 	. . 3 
	ex de,hl			;3125	eb 	. 
	ld hl,(curRealHWord)		;3126	2a 5f 2b 	* _ + 
	call WrDE_ByTargAddr_pl2		;3129	cd 17 34 	. . 4 
	ld a,075h		;312c	3e 75 	> u 
JGetLexEnd:
	jp GetLexEnd		;312e	c3 3e 30 	. > 0 
CErrStrLiEnd:
	ld e,044h		;3131	1e 44 	. D 
	call CompileErr		;3133	cd 3a 2f 	. : / 
	jr OnEndOfStr__		;3136	18 c3 	. . 
LxIdentifier:
	ld hl,curIdentifier		;3138	21 50 2b 	! P + 
	ld b,00ah		;313b	06 0a 	. . 
LxIdNextChr:
	ld (hl),a			;313d	77 	w 
	call GetCIsAlNum		;313e	cd 8a 2f 	. . / 
	jr nc,LxIdAllChrsRead		;3141	30 09 	0 . 
	inc hl			;3143	23 	# 
	djnz LxIdNextChr		;3144	10 f7 	. . 
	dec hl			;3146	2b 	+ 
LxIdSkipTrailingChr:
	call GetCIsAlNum		;3147	cd 8a 2f 	. . / 
	jr c,LxIdSkipTrailingChr		;314a	38 fb 	8 . 
LxIdAllChrsRead:
	push af			;314c	f5 	. 
	set 7,(hl)		;314d	cb fe 	. . 
	ld a,(curIdentifier)		;314f	3a 50 2b 	: P + 
	cp 061h		;3152	fe 61 	. a 
	jr nc,LxIdSetLxCode		;3154	30 08 	0 . 
	ld hl,ResWordsEntry2		;3156	21 62 32 	! b 2 
	push de			;3159	d5 	. 
	call SearchInSymTab__		;315a	cd 69 33 	. i 3 
	pop de			;315d	d1 	. 
LxIdSetLxCode:
	ld c,000h		;315e	0e 00 	. . 
	jr nc,LxIdEnd		;3160	30 01 	0 . 
	ld c,(hl)			;3162	4e 	N 
LxIdEnd:
	pop af			;3163	f1 	. 
	ret			;3164	c9 	. 
compOptTab:

; BLOCK 'compOptTab' (start 0x3165 end 0x3171)
compOptTab_start:
	defb 04ch		;3165	4c 	L 
	defb 001h		;3166	01 	. 
	defb 04fh		;3167	4f 	O 
	defb 002h		;3168	02 	. 
	defb 043h		;3169	43 	C 
	defb 004h		;316a	04 	. 
	defb 053h		;316b	53 	S 
	defb 008h		;316c	08 	. 
	defb 049h		;316d	49 	I 
	defb 010h		;316e	10 	. 
	defb 041h		;316f	41 	A 
	defb 020h		;3170	20 	  

; BLOCK 'resWords' (start 0x3171 end 0x326f)
resWords_start:
	defb 000h		;3171	00 	. 
l3172h:
	defb 000h		;3172	00 	. 
	defb 050h		;3173	50 	P 
	defb 041h		;3174	41 	A 
	defb 043h		;3175	43 	C 
	defb 04bh		;3176	4b 	K 
	defb 045h		;3177	45 	E 
	defb 0c4h		;3178	c4 	. 
	defb 023h		;3179	23 	# 
	defb 071h		;317a	71 	q 
	defb 031h		;317b	31 	1 
	defb 04eh		;317c	4e 	N 
	defb 049h		;317d	49 	I 
	defb 0cch		;317e	cc 	. 
	defb 022h		;317f	22 	" 
	defb 07ah		;3180	7a 	z 
	defb 031h		;3181	31 	1 
	defb 046h		;3182	46 	F 
	defb 04fh		;3183	4f 	O 
	defb 052h		;3184	52 	R 
	defb 057h		;3185	57 	W 
	defb 041h		;3186	41 	A 
	defb 052h		;3187	52 	R 
	defb 0c4h		;3188	c4 	. 
	defb 01dh		;3189	1d 	. 
	defb 080h		;318a	80 	. 
	defb 031h		;318b	31 	1 
	defb 050h		;318c	50 	P 
	defb 052h		;318d	52 	R 
	defb 04fh		;318e	4f 	O 
	defb 047h		;318f	47 	G 
	defb 052h		;3190	52 	R 
	defb 041h		;3191	41 	A 
	defb 0cdh		;3192	cd 	. 
	defb 001h		;3193	01 	. 
	defb 08ah		;3194	8a 	. 
	defb 031h		;3195	31 	1 
	defb 049h		;3196	49 	I 
	defb 0ceh		;3197	ce 	. 
	defb 020h		;3198	20 	  
	defb 094h		;3199	94 	. 
	defb 031h		;319a	31 	1 
	defb 04fh		;319b	4f 	O 
	defb 0d2h		;319c	d2 	. 
	defb 007h		;319d	07 	. 
	defb 099h		;319e	99 	. 
	defb 031h		;319f	31 	1 
	defb 04fh		;31a0	4f 	O 
	defb 0c6h		;31a1	c6 	. 
	defb 00bh		;31a2	0b 	. 
	defb 09eh		;31a3	9e 	. 
	defb 031h		;31a4	31 	1 
	defb 054h		;31a5	54 	T 
	defb 0cfh		;31a6	cf 	. 
	defb 00ch		;31a7	0c 	. 
l31a8h:
	defb 0a3h		;31a8	a3 	. 
	defb 031h		;31a9	31 	1 
	defb 044h		;31aa	44 	D 
	defb 0cfh		;31ab	cf 	. 
	defb 011h		;31ac	11 	. 
	defb 0a8h		;31ad	a8 	. 
	defb 031h		;31ae	31 	1 
	defb 049h		;31af	49 	I 
	defb 0c6h		;31b0	c6 	. 
	defb 017h		;31b1	17 	. 
	defb 0adh		;31b2	ad 	. 
	defb 031h		;31b3	31 	1 
	defb 053h		;31b4	53 	S 
	defb 045h		;31b5	45 	E 
	defb 0d4h		;31b6	d4 	. 
	defb 01bh		;31b7	1b 	. 
	defb 0b2h		;31b8	b2 	. 
	defb 031h		;31b9	31 	1 
	defb 04eh		;31ba	4e 	N 
	defb 04fh		;31bb	4f 	O 
	defb 0d4h		;31bc	d4 	. 
	defb 006h		;31bd	06 	. 
	defb 0b8h		;31be	b8 	. 
	defb 031h		;31bf	31 	1 
	defb 04dh		;31c0	4d 	M 
	defb 04fh		;31c1	4f 	O 
	defb 0c4h		;31c2	c4 	. 
	defb 009h		;31c3	09 	. 
	defb 0beh		;31c4	be 	. 
	defb 031h		;31c5	31 	1 
	defb 044h		;31c6	44 	D 
	defb 049h		;31c7	49 	I 
	defb 0d6h		;31c8	d6 	. 
	defb 002h		;31c9	02 	. 
	defb 0c4h		;31ca	c4 	. 
	defb 031h		;31cb	31 	1 
	defb 056h		;31cc	56 	V 
	defb 041h		;31cd	41 	A 
	defb 0d2h		;31ce	d2 	. 
	defb 00ah		;31cf	0a 	. 
	defb 0cah		;31d0	ca 	. 
	defb 031h		;31d1	31 	1 
	defb 041h		;31d2	41 	A 
	defb 04eh		;31d3	4e 	N 
	defb 0c4h		;31d4	c4 	. 
	defb 008h		;31d5	08 	. 
	defb 0d0h		;31d6	d0 	. 
	defb 031h		;31d7	31 	1 
	defb 046h		;31d8	46 	F 
	defb 04fh		;31d9	4f 	O 
	defb 0d2h		;31da	d2 	. 
	defb 016h		;31db	16 	. 
	defb 0d6h		;31dc	d6 	. 
	defb 031h		;31dd	31 	1 
	defb 045h		;31de	45 	E 
	defb 04eh		;31df	4e 	N 
	defb 0c4h		;31e0	c4 	. 
	defb 010h		;31e1	10 	. 
	defb 0dch		;31e2	dc 	. 
	defb 031h		;31e3	31 	1 
	defb 047h		;31e4	47 	G 
	defb 04fh		;31e5	4f 	O 
	defb 054h		;31e6	54 	T 
	defb 0cfh		;31e7	cf 	. 
	defb 01ah		;31e8	1a 	. 
	defb 0e2h		;31e9	e2 	. 
	defb 031h		;31ea	31 	1 
	defb 057h		;31eb	57 	W 
	defb 049h		;31ec	49 	I 
	defb 054h		;31ed	54 	T 
	defb 0c8h		;31ee	c8 	. 
	defb 019h		;31ef	19 	. 
	defb 0e9h		;31f0	e9 	. 
	defb 031h		;31f1	31 	1 
	defb 054h		;31f2	54 	T 
	defb 059h		;31f3	59 	Y 
	defb 050h		;31f4	50 	P 
	defb 0c5h		;31f5	c5 	. 
	defb 01fh		;31f6	1f 	. 
	defb 0f0h		;31f7	f0 	. 
	defb 031h		;31f8	31 	1 
	defb 043h		;31f9	43 	C 
	defb 041h		;31fa	41 	A 
	defb 053h		;31fb	53 	S 
	defb 0c5h		;31fc	c5 	. 
	defb 014h		;31fd	14 	. 
	defb 0f7h		;31fe	f7 	. 
	defb 031h		;31ff	31 	1 
	defb 045h		;3200	45 	E 
	defb 04ch		;3201	4c 	L 
	defb 053h		;3202	53 	S 
	defb 0c5h		;3203	c5 	. 
	defb 012h		;3204	12 	. 
	defb 0feh		;3205	fe 	. 
	defb 031h		;3206	31 	1 
	defb 054h		;3207	54 	T 
	defb 048h		;3208	48 	H 
	defb 045h		;3209	45 	E 
	defb 0ceh		;320a	ce 	. 
	defb 00eh		;320b	0e 	. 
	defb 005h		;320c	05 	. 
	defb 032h		;320d	32 	2 
	defb 04ch		;320e	4c 	L 
	defb 041h		;320f	41 	A 
	defb 042h		;3210	42 	B 
	defb 045h		;3211	45 	E 
	defb 0cch		;3212	cc 	. 
	defb 021h		;3213	21 	! 
	defb 00ch		;3214	0c 	. 
	defb 032h		;3215	32 	2 
	defb 043h		;3216	43 	C 
	defb 04fh		;3217	4f 	O 
	defb 04eh		;3218	4e 	N 
	defb 053h		;3219	53 	S 
	defb 0d4h		;321a	d4 	. 
	defb 003h		;321b	03 	. 
	defb 014h		;321c	14 	. 
	defb 032h		;321d	32 	2 
	defb 041h		;321e	41 	A 
	defb 052h		;321f	52 	R 
	defb 052h		;3220	52 	R 
	defb 041h		;3221	41 	A 
	defb 0d9h		;3222	d9 	. 
	defb 01ch		;3223	1c 	. 
	defb 01ch		;3224	1c 	. 
	defb 032h		;3225	32 	2 
	defb 055h		;3226	55 	U 
	defb 04eh		;3227	4e 	N 
	defb 054h		;3228	54 	T 
	defb 049h		;3229	49 	I 
	defb 0cch		;322a	cc 	. 
	defb 00fh		;322b	0f 	. 
	defb 024h		;322c	24 	$ 
	defb 032h		;322d	32 	2 
	defb 057h		;322e	57 	W 
	defb 048h		;322f	48 	H 
	defb 049h		;3230	49 	I 
	defb 04ch		;3231	4c 	L 
	defb 0c5h		;3232	c5 	. 
	defb 015h		;3233	15 	. 
	defb 02ch		;3234	2c 	, 
	defb 032h		;3235	32 	2 
	defb 042h		;3236	42 	B 
	defb 045h		;3237	45 	E 
	defb 047h		;3238	47 	G 
	defb 049h		;3239	49 	I 
	defb 0ceh		;323a	ce 	. 
	defb 018h		;323b	18 	. 
	defb 034h		;323c	34 	4 
	defb 032h		;323d	32 	2 
	defb 052h		;323e	52 	R 
	defb 045h		;323f	45 	E 
	defb 043h		;3240	43 	C 
	defb 04fh		;3241	4f 	O 
	defb 052h		;3242	52 	R 
	defb 0c4h		;3243	c4 	. 
	defb 01eh		;3244	1e 	. 
	defb 03ch		;3245	3c 	< 
	defb 032h		;3246	32 	2 
	defb 044h		;3247	44 	D 
	defb 04fh		;3248	4f 	O 
	defb 057h		;3249	57 	W 
	defb 04eh		;324a	4e 	N 
	defb 054h		;324b	54 	T 
	defb 0cfh		;324c	cf 	. 
	defb 00dh		;324d	0d 	. 
	defb 045h		;324e	45 	E 
	defb 032h		;324f	32 	2 
	defb 052h		;3250	52 	R 
	defb 045h		;3251	45 	E 
	defb 050h		;3252	50 	P 
	defb 045h		;3253	45 	E 
	defb 041h		;3254	41 	A 
	defb 0d4h		;3255	d4 	. 
	defb 013h		;3256	13 	. 
	defb 04eh		;3257	4e 	N 
	defb 032h		;3258	32 	2 
	defb 046h		;3259	46 	F 
	defb 055h		;325a	55 	U 
	defb 04eh		;325b	4e 	N 
	defb 043h		;325c	43 	C 
	defb 054h		;325d	54 	T 
	defb 049h		;325e	49 	I 
	defb 04fh		;325f	4f 	O 
	defb 0ceh		;3260	ce 	. 
	defb 005h		;3261	05 	. 
ResWordsEntry2:
	defb 057h		;3262	57 	W 
	defb 032h		;3263	32 	2 
	defb 050h		;3264	50 	P 
	defb 052h		;3265	52 	R 
	defb 04fh		;3266	4f 	O 
	defb 043h		;3267	43 	C 
	defb 045h		;3268	45 	E 
	defb 044h		;3269	44 	D 
	defb 055h		;326a	55 	U 
	defb 052h		;326b	52 	R 
	defb 0c5h		;326c	c5 	. 
	defb 004h		;326d	04 	. 
ResWordsEntry:
	defb 062h		;326e	62 	b 
	defb 032h		;326f	32 	2 
TEadr:

; BLOCK 'TEadr' (start 0x3270 end 0x327c)
TEadr_start:
	defb 045h		;3270	45 	E 
	defb 06eh		;3271	6e 	n 
	defb 064h		;3272	64 	d 
	defb 061h		;3273	61 	a 
	defb 064h		;3274	64 	d 
	defb 072h		;3275	72 	r 
	defb 065h		;3276	65 	e 
	defb 073h		;3277	73 	s 
	defb 073h		;3278	73 	s 
	defb 065h		;3279	65 	e 
	defb 03ah		;327a	3a 	: 
	defb 020h		;327b	20 	  
	nop			;327c	00 	. 
TFeh1:

; BLOCK 'TFeh1' (start 0x327d end 0x3284)
TFeh1_start:
	defb 046h		;327d	46 	F 
	defb 065h		;327e	65 	e 
	defb 068h		;327f	68 	h 
	defb 06ch		;3280	6c 	l 
	defb 065h		;3281	65 	e 
	defb 072h		;3282	72 	r 
	defb 03ah		;3283	3a 	: 
	nop			;3284	00 	. 

; BLOCK 'TFeh2' (start 0x3285 end 0x328d)
TFeh2_start:
	defb 02ah		;3285	2a 	* 
	defb 046h		;3286	46 	F 
	defb 045h		;3287	45 	E 
	defb 048h		;3288	48 	H 
	defb 04ch		;3289	4c 	L 
	defb 045h		;328a	45 	E 
	defb 052h		;328b	52 	R 
	defb 02ah		;328c	2a 	* 
	nop			;328d	00 	. 

; BLOCK 'TKeTx' (start 0x328e end 0x329e)
TKeTx_start:
	defb 00dh		;328e	0d 	. 
	defb 04bh		;328f	4b 	K 
	defb 065h		;3290	65 	e 
	defb 069h		;3291	69 	i 
	defb 06eh		;3292	6e 	n 
	defb 020h		;3293	20 	  
	defb 054h		;3294	54 	T 
	defb 065h		;3295	65 	e 
	defb 078h		;3296	78 	x 
	defb 074h		;3297	74 	t 
	defb 020h		;3298	20 	  
	defb 06dh		;3299	6d 	m 
	defb 065h		;329a	65 	e 
	defb 068h		;329b	68 	h 
	defb 072h		;329c	72 	r 
	defb 021h		;329d	21 	! 
	nop			;329e	00 	. 

; BLOCK 'TTabU' (start 0x329f end 0x32b1)
TTabU_start:
	defb 054h		;329f	54 	T 
	defb 061h		;32a0	61 	a 
	defb 062h		;32a1	62 	b 
	defb 065h		;32a2	65 	e 
	defb 06ch		;32a3	6c 	l 
	defb 06ch		;32a4	6c 	l 
	defb 065h		;32a5	65 	e 
	defb 06eh		;32a6	6e 	n 
	defb 075h		;32a7	75 	u 
	defb 065h		;32a8	65 	e 
	defb 062h		;32a9	62 	b 
	defb 065h		;32aa	65 	e 
	defb 072h		;32ab	72 	r 
	defb 06ch		;32ac	6c 	l 
	defb 061h		;32ad	61 	a 
	defb 075h		;32ae	75 	u 
	defb 066h		;32af	66 	f 
	defb 021h		;32b0	21 	! 
	nop			;32b1	00 	. 
sub_32b2h:
	ld de,00004h		;32b2	11 04 00 	. . . 
	jr ChkType__		;32b5	18 03 	. . 
sub_32b7h:
	ld de,00001h		;32b7	11 01 00 	. . . 
ChkType__:
	ex de,hl			;32ba	eb 	. 
	or a			;32bb	b7 	. 
	sbc hl,bc		;32bc	ed 42 	. B 
	add hl,bc			;32be	09 	. 
	ex de,hl			;32bf	eb 	. 
	ret z			;32c0	c8 	. 
	bit 7,b		;32c1	cb 78 	. x 
	jr z,CErrWroType		;32c3	28 0f 	( . 
	bit 7,d		;32c5	cb 7a 	. z 
	jr z,CErrWroType		;32c7	28 0b 	( . 
	ld e,a			;32c9	5f 	_ 
	ld a,b			;32ca	78 	x 
	cp 080h		;32cb	fe 80 	. . 
	ld a,e			;32cd	7b 	{ 
	ret z			;32ce	c8 	. 
	ld a,d			;32cf	7a 	z 
	cp 080h		;32d0	fe 80 	. . 
	ld a,e			;32d2	7b 	{ 
	ret z			;32d3	c8 	. 
CErrWroType:
	ld e,00ah		;32d4	1e 0a 	. . 
	jp CompileErr		;32d6	c3 3a 2f 	. : / 
ChkSemi_GetLex:
	cp 0bbh		;32d9	fe bb 	. . 
	ld e,002h		;32db	1e 02 	. . 
	jp z,GetLexem		;32dd	ca c3 2f 	. . / 
	call CompileErr		;32e0	cd 3a 2f 	. : / 
	jp GetLexem		;32e3	c3 c3 2f 	. . / 
NextChkOF_GetLex:
	call GetLexem		;32e6	cd c3 2f 	. . / 
ChkOF_GetLex:
	ld de,00b14h		;32e9	11 14 0b 	. . . 
	jr ChkLexem_GetLex		;32ec	18 1a 	. . 
ChkColEq_GetLex:
	ld de,07d08h		;32ee	11 08 7d 	. . } 
	jr ChkLexem_GetLex		;32f1	18 15 	. . 
ChkCloSqBra_GetLex:
	ld de,0dd23h		;32f3	11 23 dd 	. # . 
	jr ChkLexem_GetLex		;32f6	18 10 	. . 
ChkComma_GetLex:
	ld de,0ac15h		;32f8	11 15 ac 	. . . 
	jr ChkLexem_GetLex		;32fb	18 0b 	. . 
NextChkOpBra_GetLex:
	call GetLexem		;32fd	cd c3 2f 	. . / 
ChkOpBra_GetLex:
	ld de,0a812h		;3300	11 12 a8 	. . . 
	jr ChkLexem_GetLex		;3303	18 03 	. . 
ChkCloBra_GetLex:
	ld de,0a909h		;3305	11 09 a9 	. . . 
ChkLexem_GetLex:
	cp d			;3308	ba 	. 
	jp z,GetLexem		;3309	ca c3 2f 	. . / 
	jp CompileErr		;330c	c3 3a 2f 	. : / 
IdentToSymtab:
	push de			;330f	d5 	. 
	ld hl,(TopOfHeapAddr__)		;3310	2a 6e 2b 	* n + 
	ld de,(SymTabAddr__)		;3313	ed 5b 6c 2b 	. [ l + 
	ld (SymTabAddr__),hl		;3317	22 6c 2b 	" l + 
	ld (hl),e			;331a	73 	s 
	inc hl			;331b	23 	# 
	ld (hl),d			;331c	72 	r 
	inc hl			;331d	23 	# 
	or a			;331e	b7 	. 
	jr nz,ItS_ErrIdExpected		;331f	20 24 	  $ 
	ex de,hl			;3321	eb 	. 
	ld hl,curIdentifier		;3322	21 50 2b 	! P + 
	ld bc,00000h		;3325	01 00 00 	. . . 
ItS_StoreChr:
	ld a,(hl)			;3328	7e 	~ 
	ldi		;3329	ed a0 	. . 
	or a			;332b	b7 	. 
	jp p,ItS_StoreChr		;332c	f2 28 33 	. ( 3 
ItS_ChkHeapEnd:
	pop hl			;332f	e1 	. 
	add hl,de			;3330	19 	. 
	ld (TopOfHeapAddr__),hl		;3331	22 6e 2b 	" n + 
	ld hl,(PasIDEStartAddr)		;3334	2a 56 18 	* V . 
	ld bc,0fff4h		;3337	01 f4 ff 	. . . 
	add hl,bc			;333a	09 	. 
	sbc hl,de		;333b	ed 52 	. R 
	ex de,hl			;333d	eb 	. 
	ret nc			;333e	d0 	. 
	ld hl,TTabU_start		;333f	21 9f 32 	! . 2 
	jp OutErrAndReset		;3342	c3 21 2e 	. ! . 
ItS_ErrIdExpected:
	ld e,004h		;3345	1e 04 	. . 
	call CompileErr		;3347	cd 3a 2f 	. : / 
	ld (hl),080h		;334a	36 80 	6 . 
	inc hl			;334c	23 	# 
	ex de,hl			;334d	eb 	. 
	jr ItS_ChkHeapEnd		;334e	18 df 	. . 
GetIdentInfoInABC:
	ld hl,(SymTabAddr__)		;3350	2a 6c 2b 	* l + 
	call SearchInSymTab__		;3353	cd 69 33 	. i 3 
	jr nc,SiS_NotFound		;3356	30 07 	0 . 
	ld a,(hl)			;3358	7e 	~ 
	inc hl			;3359	23 	# 
	ld c,(hl)			;335a	4e 	N 
	inc hl			;335b	23 	# 
	ld b,(hl)			;335c	46 	F 
	inc hl			;335d	23 	# 
	ret			;335e	c9 	. 
SiS_NotFound:
	ld e,003h		;335f	1e 03 	. . 
	xor a			;3361	af 	. 
	jp CompileErr		;3362	c3 3a 2f 	. : / 
SiS_GotoNextId:
	ld a,d			;3365	7a 	z 
	or e			;3366	b3 	. 
	ret z			;3367	c8 	. 
	ex de,hl			;3368	eb 	. 
SearchInSymTab__:
	ld bc,curIdentifier		;3369	01 50 2b 	. P + 
	ld e,(hl)			;336c	5e 	^ 
	inc hl			;336d	23 	# 
	ld d,(hl)			;336e	56 	V 
	inc hl			;336f	23 	# 
SiS_CompChr:
	ld a,(bc)			;3370	0a 	. 
	cp (hl)			;3371	be 	. 
	jr nz,SiS_GotoNextId		;3372	20 f1 	  . 
	or a			;3374	b7 	. 
	inc bc			;3375	03 	. 
	inc hl			;3376	23 	# 
	jp p,SiS_CompChr		;3377	f2 70 33 	. p 3 
	scf			;337a	37 	7 
	ret			;337b	c9 	. 
ChkLabelList__:
	ld hl,(labelListAddr)		;337c	2a 6a 2b 	* j + 
NextListEntry:
	ld a,h			;337f	7c 	| 
	or l			;3380	b5 	. 
	ld e,03eh		;3381	1e 3e 	. > 
	ccf			;3383	3f 	? 
	jp z,CompileErr		;3384	ca 3a 2f 	. : / 
	ld e,(hl)			;3387	5e 	^ 
	inc hl			;3388	23 	# 
	ld d,(hl)			;3389	56 	V 
	push de			;338a	d5 	. 
	inc hl			;338b	23 	# 
	ld c,(hl)			;338c	4e 	N 
	inc hl			;338d	23 	# 
	ld b,(hl)			;338e	46 	F 
	ex de,hl			;338f	eb 	. 
	ld hl,(curRealHWord)		;3390	2a 5f 2b 	* _ + 
	or a			;3393	b7 	. 
	sbc hl,bc		;3394	ed 42 	. B 
	pop hl			;3396	e1 	. 
	jr nz,NextListEntry		;3397	20 e6 	  . 
	ex de,hl			;3399	eb 	. 
	inc hl			;339a	23 	# 
	ld e,(hl)			;339b	5e 	^ 
	inc hl			;339c	23 	# 
	ld d,(hl)			;339d	56 	V 
	inc hl			;339e	23 	# 
	ld a,(BlockLevel__)		;339f	3a 72 2b 	: r + 
	cp (hl)			;33a2	be 	. 
	ret z			;33a3	c8 	. 
	ld e,03dh		;33a4	1e 3d 	. = 
	scf			;33a6	37 	7 
	jp CompileErr		;33a7	c3 3a 2f 	. : / 
CodeLdBC_0n_from_0x2b8b:
	push hl			;33aa	e5 	. 
	ld e,a			;33ab	5f 	_ 
	call JCodeNextByte		;33ac	cd d1 06 	. . . 
	defb 001h		;33af	01 	. 
	ld a,(l2b8bh)		;33b0	3a 8b 2b 	: . + 
	inc a			;33b3	3c 	< 
	call StoreAToHL2		;33b4	cd e3 33 	. . 3 
	call JCodeNextByte		;33b7	cd d1 06 	. . . 
	defb 000h		;33ba	00 	. 
	ld a,e			;33bb	7b 	{ 
	jr WCode1		;33bc	18 0f 	. . 
l33beh:
	push hl			;33be	e5 	. 
	exx			;33bf	d9 	. 
	dec hl			;33c0	2b 	+ 
	dec hl			;33c1	2b 	+ 
	jr WCode2		;33c2	18 0a 	. . 
sub_33c4h:
	push hl			;33c4	e5 	. 
	exx			;33c5	d9 	. 
	dec hl			;33c6	2b 	+ 
	jr WCode2		;33c7	18 05 	. . 
WrJump:
	ld hl,CSq_JP		;33c9	21 49 34 	! I 4 
WCode:
	push hl			;33cc	e5 	. 
WCode1:
	exx			;33cd	d9 	. 
WCode2:
	ex (sp),hl			;33ce	e3 	. 
	ld c,(hl)			;33cf	4e 	N 
	inc hl			;33d0	23 	# 
	ld b,000h		;33d1	06 00 	. . 
	pop de			;33d3	d1 	. 
	ldir		;33d4	ed b0 	. . 
	ex de,hl			;33d6	eb 	. 
	exx			;33d7	d9 	. 
GetTargetAddrInHL__:
	exx			;33d8	d9 	. 
	push hl			;33d9	e5 	. 
	ld bc,(binMoveDistance__)		;33da	ed 4b 8f 2b 	. K . + 
	add hl,bc			;33de	09 	. 
	ex (sp),hl			;33df	e3 	. 
	exx			;33e0	d9 	. 
	pop hl			;33e1	e1 	. 
	ret			;33e2	c9 	. 
StoreAToHL2:
	exx			;33e3	d9 	. 
	ld (hl),a			;33e4	77 	w 
	inc hl			;33e5	23 	# 
	exx			;33e6	d9 	. 
	ret			;33e7	c9 	. 
StoreA_GetTarget:
	call StoreAToHL2		;33e8	cd e3 33 	. . 3 
	jp GetTargetAddrInHL__		;33eb	c3 d8 33 	. . 3 
CodeNextByte:
	pop hl			;33ee	e1 	. 
	push af			;33ef	f5 	. 
	ld a,(hl)			;33f0	7e 	~ 
	inc hl			;33f1	23 	# 
	call StoreAToHL2		;33f2	cd e3 33 	. . 3 
	pop af			;33f5	f1 	. 
	push hl			;33f6	e5 	. 
	jp GetTargetAddrInHL__		;33f7	c3 d8 33 	. . 3 
sub_33fah:
	ex de,hl			;33fa	eb 	. 
sub_33fbh:
	call JCodeNextByte		;33fb	cd d1 06 	. . . 
	defb 011h		;33fe	11 	. 
	jr StoreDE		;33ff	18 0b 	. . 
sub_3401h:
	call JCodeNextByte		;3401	cd d1 06 	. . . 
	defb 02ah		;3404	2a 	* 
	jr StoreDE		;3405	18 05 	. . 
sub_3407h:
	ex de,hl			;3407	eb 	. 
WLdHLnnIsDE:
	call JCodeNextByte		;3408	cd d1 06 	. . . 
	defb 021h		;340b	21 	! 
StoreDE:
	push af			;340c	f5 	. 
	ld a,e			;340d	7b 	{ 
	call StoreAToHL2		;340e	cd e3 33 	. . 3 
	ld a,d			;3411	7a 	z 
	call StoreA_GetTarget		;3412	cd e8 33 	. . 3 
	pop af			;3415	f1 	. 
	ret			;3416	c9 	. 
WrDE_ByTargAddr_pl2:
	dec hl			;3417	2b 	+ 
WrDE_ByTargAddr_pl1:
	push bc			;3418	c5 	. 
	push hl			;3419	e5 	. 
	call TargAddrToCompAddr		;341a	cd 37 34 	. 7 4 
	ld (hl),d			;341d	72 	r 
	dec hl			;341e	2b 	+ 
	ld (hl),e			;341f	73 	s 
	pop hl			;3420	e1 	. 
	pop bc			;3421	c1 	. 
	ret			;3422	c9 	. 
WrDE_ByTargAddr:
	push bc			;3423	c5 	. 
	push hl			;3424	e5 	. 
	call TargAddrToCompAddr		;3425	cd 37 34 	. 7 4 
	ld (hl),e			;3428	73 	s 
	inc hl			;3429	23 	# 
	ld (hl),d			;342a	72 	r 
	pop hl			;342b	e1 	. 
	pop bc			;342c	c1 	. 
	ret			;342d	c9 	. 
WrA_ByTargAddr:
	push bc			;342e	c5 	. 
	push hl			;342f	e5 	. 
	call TargAddrToCompAddr		;3430	cd 37 34 	. 7 4 
	ld (hl),a			;3433	77 	w 
	pop hl			;3434	e1 	. 
	pop bc			;3435	c1 	. 
	ret			;3436	c9 	. 
TargAddrToCompAddr:
	ld bc,(binMoveDistanceNeg__)		;3437	ed 4b 91 2b 	. K . + 
	add hl,bc			;343b	09 	. 
	ret			;343c	c9 	. 
sub_343dh:
	exx			;343d	d9 	. 
	dec hl			;343e	2b 	+ 
	exx			;343f	d9 	. 
	dec hl			;3440	2b 	+ 
	call JCodeNextByte		;3441	cd d1 06 	. . . 
	defb 006h		;3444	06 	. 
	ld e,c			;3445	59 	Y 
	jp l381ah		;3446	c3 1a 38 	. . 8 
CSq_JP:
	defb 003h		;3449	03 	. 
	jp 0bbfeh		;344a	c3 fe bb 	. . . 
	ret z			;344d	c8 	. 
	or a			;344e	b7 	. 
	jr z,l3454h		;344f	28 03 	( . 
	cp 024h		;3451	fe 24 	. $ 
	ret c			;3453	d8 	. 
l3454h:
	call GetLexem		;3454	cd c3 2f 	. . / 
	jr $-12		;3457	18 f2 	. . 
PCVNegNum:
	call GetLexem		;3459	cd c3 2f 	. . / 
	call ParseConstVal		;345c	cd 79 34 	. y 4 
	call PCVChkNum		;345f	cd e6 34 	. . 4 
	dec c			;3462	0d 	. 
	jr z,PCVNegInt		;3463	28 0b 	( . 
	inc c			;3465	0c 	. 
	bit 6,h		;3466	cb 74 	. t 
	ret z			;3468	c8 	. 
	push af			;3469	f5 	. 
	ld a,080h		;346a	3e 80 	> . 
	xor h			;346c	ac 	. 
	ld h,a			;346d	67 	g 
	pop af			;346e	f1 	. 
	ret			;346f	c9 	. 
PCVNegInt:
	inc c			;3470	0c 	. 
	ex de,hl			;3471	eb 	. 
	ld hl,00000h		;3472	21 00 00 	! . . 
	or a			;3475	b7 	. 
	sbc hl,de		;3476	ed 52 	. R 
	ret			;3478	c9 	. 
ParseConstVal:
	or a			;3479	b7 	. 
	jr z,PCVIdent		;347a	28 29 	( ) 
	cp 0abh		;347c	fe ab 	. . 
	jr z,PCVPosNum		;347e	28 60 	( ` 
	cp 0adh		;3480	fe ad 	. . 
	jr z,PCVNegNum		;3482	28 d5 	( . 
	ld hl,(curRealHWord)		;3484	2a 5f 2b 	* _ + 
	cp 075h		;3487	fe 75 	. u 
	jr z,l34d8h		;3489	28 4d 	( M 
	ld bc,00001h		;348b	01 01 00 	. . . 
	cp 07fh		;348e	fe 7f 	.  
	jr z,PCVEnds__		;3490	28 43 	( C 
	inc c			;3492	0c 	. 
	ld de,(curNum)		;3493	ed 5b 5d 2b 	. [ ] + 
	cp 07eh		;3497	fe 7e 	. ~ 
	jr z,PCVEnds__		;3499	28 3a 	( : 
	inc c			;349b	0c 	. 
	cp 076h		;349c	fe 76 	. v 
	jr z,PCVEnds__		;349e	28 35 	( 5 
	ld e,00dh		;34a0	1e 0d 	. . 
	jp CompileErr		;34a2	c3 3a 2f 	. : / 
PCVIdent:
	call GetIdentInfoInABC		;34a5	cd 50 33 	. P 3 
	ld e,(hl)			;34a8	5e 	^ 
	inc hl			;34a9	23 	# 
	ld d,(hl)			;34aa	56 	V 
	dec a			;34ab	3d 	= 
	jr z,l34cfh		;34ac	28 21 	( ! 
	cp 008h		;34ae	fe 08 	. . 
	jr nz,l34c8h		;34b0	20 16 	  . 
	ld hl,l52ceh		;34b2	21 ce 52 	! . R 
	sbc hl,de		;34b5	ed 52 	. R 
	jr nz,l34c8h		;34b7	20 0f 	  . 
	call NextChkOpBra_GetLex		;34b9	cd fd 32 	. . 2 
	call ParseConstVal		;34bc	cd 79 34 	. y 4 
	call sub_32b7h		;34bf	cd b7 32 	. . 2 
	ld bc,00003h		;34c2	01 03 00 	. . . 
	jp ChkCloBra_GetLex		;34c5	c3 05 33 	. . 3 
l34c8h:
	ld e,00eh		;34c8	1e 0e 	. . 
	call CompileErr		;34ca	cd 3a 2f 	. : / 
	jr PCVEnds__		;34cd	18 06 	. . 
l34cfh:
	inc hl			;34cf	23 	# 
	ld a,(hl)			;34d0	7e 	~ 
	inc hl			;34d1	23 	# 
	ld l,(hl)			;34d2	6e 	n 
	ld h,a			;34d3	67 	g 
	ex de,hl			;34d4	eb 	. 
PCVEnds__:
	jp GetLexem		;34d5	c3 c3 2f 	. . / 
l34d8h:
	ld a,(curNum)		;34d8	3a 5d 2b 	: ] + 
	ld c,a			;34db	4f 	O 
	ld b,002h		;34dc	06 02 	. . 
	jr PCVEnds__		;34de	18 f5 	. . 
PCVPosNum:
	call GetLexem		;34e0	cd c3 2f 	. . / 
	call ParseConstVal		;34e3	cd 79 34 	. y 4 
PCVChkNum:
	push af			;34e6	f5 	. 
	xor a			;34e7	af 	. 
	cp b			;34e8	b8 	. 
	jr nz,CErrIntOrRealExpected		;34e9	20 09 	  . 
	ld a,c			;34eb	79 	y 
	dec a			;34ec	3d 	= 
	jr z,PCVNumOk		;34ed	28 03 	( . 
	dec a			;34ef	3d 	= 
	jr nz,CErrIntOrRealExpected		;34f0	20 02 	  . 
PCVNumOk:
	pop af			;34f2	f1 	. 
	ret			;34f3	c9 	. 
CErrIntOrRealExpected:
	ld e,01ch		;34f4	1e 1c 	. . 
	pop af			;34f6	f1 	. 
	jp CompileErr		;34f7	c3 3a 2f 	. : / 
sub_34fah:
	ld de,00004h		;34fa	11 04 00 	. . . 
	add hl,de			;34fd	19 	. 
	ld e,(hl)			;34fe	5e 	^ 
	inc hl			;34ff	23 	# 
	ld d,(hl)			;3500	56 	V 
	inc hl			;3501	23 	# 
	ld b,(hl)			;3502	46 	F 
	xor a			;3503	af 	. 
	cp b			;3504	b8 	. 
	ld a,(BlockLevel__)		;3505	3a 72 2b 	: r + 
	ret			;3508	c9 	. 
sub_3509h:
	call JCodeNextByte		;3509	cd d1 06 	. . . 
	defb 006h		;350c	06 	. 
	call StoreAToHL2		;350d	cd e3 33 	. . 3 
	ld hl,l3534h		;3510	21 34 35 	! 4 5 
	call WCode		;3513	cd cc 33 	. . 3 
	jr l351eh		;3516	18 06 	. . 
sub_3518h:
	ld hl,l3538h		;3518	21 38 35 	! 8 5 
	call WCode		;351b	cd cc 33 	. . 3 
l351eh:
	call WLdHLnnIsDE		;351e	cd 08 34 	. . 4 
	call JCodeNextByte		;3521	cd d1 06 	. . . 
	defb 019h		;3524	19 	. 
	ret			;3525	c9 	. 
sub_3526h:
	ld a,d			;3526	7a 	z 
	or a			;3527	b7 	. 
	inc a			;3528	3c 	< 
	jr nz,l352eh		;3529	20 03 	  . 
	ld a,e			;352b	7b 	{ 
	add a,a			;352c	87 	. 
	ret			;352d	c9 	. 
l352eh:
	dec a			;352e	3d 	= 
	ret nz			;352f	c0 	. 
	ld a,e			;3530	7b 	{ 
	sub 07dh		;3531	d6 7d 	. } 
	ret			;3533	c9 	. 
l3534h:
	inc bc			;3534	03 	. 
	call sub_09b1h		;3535	cd b1 09 	. . . 
l3538h:
	inc bc			;3538	03 	. 
	push ix		;3539	dd e5 	. . 
	pop de			;353b	d1 	. 
WCaBreak_IfCoCo_C:
	bit 2,(ix+000h)		;353c	dd cb 00 56 	. . . V 
	ret z			;3540	c8 	. 
	ld hl,CSq_CallBreak		;3541	21 47 35 	! G 5 
	jp WCode		;3544	c3 cc 33 	. . 3 
CSq_CallBreak:
	defb 003h		;3547	03 	. 
	call Break		;3548	cd 15 09 	. . . 
ChkScalar:
	push af			;354b	f5 	. 
	xor a			;354c	af 	. 
	cp b			;354d	b8 	. 
	jr nz,CErrScalarExpected		;354e	20 05 	  . 
	ld a,c			;3550	79 	y 
	cp 002h		;3551	fe 02 	. . 
	jr nz,l355bh		;3553	20 06 	  . 
CErrScalarExpected:
	ld e,02fh		;3555	1e 2f 	. / 
	pop af			;3557	f1 	. 
	jp CompileErr		;3558	c3 3a 2f 	. : / 
l355bh:
	pop af			;355b	f1 	. 
	ret			;355c	c9 	. 
	ex af,af'			;355d	08 	. 
	pop bc			;355e	c1 	. 
	sub b			;355f	90 	. 
	ld a,001h		;3560	3e 01 	> . 
	jr z,l3565h		;3562	28 01 	( . 
	xor a			;3564	af 	. 
l3565h:
	push af			;3565	f5 	. 
	rlca			;3566	07 	. 
	pop bc			;3567	c1 	. 
	sub b			;3568	90 	. 
	jr z,l356dh		;3569	28 02 	( . 
	ld a,001h		;356b	3e 01 	> . 
l356dh:
	push af			;356d	f5 	. 
	ld b,0c1h		;356e	06 c1 	. . 
	sub b			;3570	90 	. 
	ld a,000h		;3571	3e 00 	> . 
	rla			;3573	17 	. 
	push af			;3574	f5 	. 
	rlca			;3575	07 	. 
	ld b,a			;3576	47 	G 
	pop af			;3577	f1 	. 
	sub b			;3578	90 	. 
	ld a,000h		;3579	3e 00 	> . 
	rla			;357b	17 	. 
	push af			;357c	f5 	. 
	ex af,af'			;357d	08 	. 
	ld b,a			;357e	47 	G 
	pop af			;357f	f1 	. 
	sub b			;3580	90 	. 
	ccf			;3581	3f 	? 
	ld a,000h		;3582	3e 00 	> . 
	rla			;3584	17 	. 
	push af			;3585	f5 	. 
	rlca			;3586	07 	. 
	pop bc			;3587	c1 	. 
	sub b			;3588	90 	. 
	ccf			;3589	3f 	? 
	ld a,000h		;358a	3e 00 	> . 
	rla			;358c	17 	. 
	push af			;358d	f5 	. 
	ex af,af'			;358e	08 	. 
	pop de			;358f	d1 	. 
	xor a			;3590	af 	. 
	sbc hl,de		;3591	ed 52 	. R 
	jr nz,l3596h		;3593	20 01 	  . 
	inc a			;3595	3c 	< 
l3596h:
	push af			;3596	f5 	. 
	ex af,af'			;3597	08 	. 
	pop de			;3598	d1 	. 
	xor a			;3599	af 	. 
	sbc hl,de		;359a	ed 52 	. R 
	jr z,l359fh		;359c	28 01 	( . 
	inc a			;359e	3c 	< 
l359fh:
	push af			;359f	f5 	. 
	add hl,bc			;35a0	09 	. 
	pop de			;35a1	d1 	. 
	or a			;35a2	b7 	. 
	sbc hl,de		;35a3	ed 52 	. R 
	ld a,080h		;35a5	3e 80 	> . 
	and h			;35a7	a4 	. 
	rlca			;35a8	07 	. 
	push af			;35a9	f5 	. 
	dec b			;35aa	05 	. 
	pop de			;35ab	d1 	. 
	call sub_0c6fh		;35ac	cd 6f 0c 	. o . 
	push af			;35af	f5 	. 
	ld a,(bc)			;35b0	0a 	. 
	ex de,hl			;35b1	eb 	. 
	pop hl			;35b2	e1 	. 
	or a			;35b3	b7 	. 
	sbc hl,de		;35b4	ed 52 	. R 
	ld a,080h		;35b6	3e 80 	> . 
	and h			;35b8	a4 	. 
	rlca			;35b9	07 	. 
	push af			;35ba	f5 	. 
	ld b,0ebh		;35bb	06 eb 	. . 
	pop hl			;35bd	e1 	. 
	call sub_0c6fh		;35be	cd 6f 0c 	. o . 
	push af			;35c1	f5 	. 
	inc c			;35c2	0c 	. 
	ex de,hl			;35c3	eb 	. 
	pop hl			;35c4	e1 	. 
	or a			;35c5	b7 	. 
	sbc hl,de		;35c6	ed 52 	. R 
	ld a,080h		;35c8	3e 80 	> . 
	and h			;35ca	a4 	. 
	rlca			;35cb	07 	. 
	xor 001h		;35cc	ee 01 	. . 
	push af			;35ce	f5 	. 
	ld b,0ebh		;35cf	06 eb 	. . 
	pop hl			;35d1	e1 	. 
	call sub_0c7ah		;35d2	cd 7a 0c 	. z . 
	push af			;35d5	f5 	. 
	dec bc			;35d6	0b 	. 
	pop de			;35d7	d1 	. 
	or a			;35d8	b7 	. 
	sbc hl,de		;35d9	ed 52 	. R 
	ld a,080h		;35db	3e 80 	> . 
	and h			;35dd	a4 	. 
	rlca			;35de	07 	. 
	xor 001h		;35df	ee 01 	. . 
	push af			;35e1	f5 	. 
	dec b			;35e2	05 	. 
	pop de			;35e3	d1 	. 
	call sub_0c7ah		;35e4	cd 7a 0c 	. z . 
	push af			;35e7	f5 	. 
l35e8h:
	rlca			;35e8	07 	. 
	pop de			;35e9	d1 	. 
	ld a,(de)			;35ea	1a 	. 
	sub (hl)			;35eb	96 	. 
l35ech:
	inc hl			;35ec	23 	# 
	inc de			;35ed	13 	. 
	jr nz,l35f0h		;35ee	20 00 	  . 
l35f0h:
	ex af,af'			;35f0	08 	. 
	dec b			;35f1	05 	. 
l35f2h:
	djnz l35ech		;35f2	10 f8 	. . 
	inc a			;35f4	3c 	< 
l35f5h:
	jr l35f8h		;35f5	18 01 	. . 
	xor a			;35f7	af 	. 
l35f8h:
	push af			;35f8	f5 	. 
	ex af,af'			;35f9	08 	. 
	inc b			;35fa	04 	. 
	djnz l35f5h		;35fb	10 f8 	. . 
	jr l3601h		;35fd	18 02 	. . 
	ld a,001h		;35ff	3e 01 	> . 
l3601h:
	push af			;3601	f5 	. 
	dec bc			;3602	0b 	. 
	inc b			;3603	04 	. 
	djnz $-6		;3604	10 f8 	. . 
	jr l360dh		;3606	18 05 	. . 
	ld a,000h		;3608	3e 00 	> . 
l360ah:
	jr c,l360dh		;360a	38 01 	8 . 
	inc a			;360c	3c 	< 
l360dh:
	push af			;360d	f5 	. 
	dec bc			;360e	0b 	. 
	inc b			;360f	04 	. 
	djnz l360ah		;3610	10 f8 	. . 
	jr l3619h		;3612	18 05 	. . 
	ld a,000h		;3614	3e 00 	> . 
l3616h:
	jr nc,l3619h		;3616	30 01 	0 . 
	inc a			;3618	3c 	< 
l3619h:
	push af			;3619	f5 	. 
	dec bc			;361a	0b 	. 
	inc b			;361b	04 	. 
	djnz l3616h		;361c	10 f8 	. . 
	jr l3624h		;361e	18 04 	. . 
	ld a,000h		;3620	3e 00 	> . 
l3622h:
	jr c,l3625h		;3622	38 01 	8 . 
l3624h:
	inc a			;3624	3c 	< 
l3625h:
	push af			;3625	f5 	. 
	dec bc			;3626	0b 	. 
	inc b			;3627	04 	. 
	djnz l3622h		;3628	10 f8 	. . 
	jr l3630h		;362a	18 04 	. . 
	ld a,000h		;362c	3e 00 	> . 
	jr nc,l3631h		;362e	30 01 	0 . 
l3630h:
	inc a			;3630	3c 	< 
l3631h:
	push af			;3631	f5 	. 
	rrca			;3632	0f 	. 
	ex de,hl			;3633	eb 	. 
	pop bc			;3634	c1 	. 
	xor a			;3635	af 	. 
	sbc hl,bc		;3636	ed 42 	. B 
	pop bc			;3638	c1 	. 
	jr nz,l3641h		;3639	20 06 	  . 
	ex de,hl			;363b	eb 	. 
	sbc hl,bc		;363c	ed 42 	. B 
	jr nz,l3641h		;363e	20 01 	  . 
	inc a			;3640	3c 	< 
l3641h:
	push af			;3641	f5 	. 
	rrca			;3642	0f 	. 
	ex de,hl			;3643	eb 	. 
	pop bc			;3644	c1 	. 
	xor a			;3645	af 	. 
	sbc hl,bc		;3646	ed 42 	. B 
	pop bc			;3648	c1 	. 
	jr nz,l3650h		;3649	20 05 	  . 
	ex de,hl			;364b	eb 	. 
	sbc hl,bc		;364c	ed 42 	. B 
	jr z,l3651h		;364e	28 01 	( . 
l3650h:
	inc a			;3650	3c 	< 
l3651h:
	push af			;3651	f5 	. 
	inc c			;3652	0c 	. 
	ld a,080h		;3653	3e 80 	> . 
	xor h			;3655	ac 	. 
	ld h,a			;3656	67 	g 
	call sub_0ca1h		;3657	cd a1 0c 	. . . 
	ld a,080h		;365a	3e 80 	> . 
	and h			;365c	a4 	. 
	rlca			;365d	07 	. 
	push af			;365e	f5 	. 
	inc d			;365f	14 	. 
	pop bc			;3660	c1 	. 
	ex (sp),hl			;3661	e3 	. 
	bit 6,h		;3662	cb 74 	. t 
	jr z,l366ah		;3664	28 04 	( . 
	ld a,080h		;3666	3e 80 	> . 
	xor h			;3668	ac 	. 
	ld h,a			;3669	67 	g 
l366ah:
	ex (sp),hl			;366a	e3 	. 
	push bc			;366b	c5 	. 
	call sub_0ca1h		;366c	cd a1 0c 	. . . 
	ld a,080h		;366f	3e 80 	> . 
	and h			;3671	a4 	. 
	rlca			;3672	07 	. 
	push af			;3673	f5 	. 
	ld d,0c1h		;3674	16 c1 	. . 
	ex (sp),hl			;3676	e3 	. 
	bit 6,h		;3677	cb 74 	. t 
	jr z,l367fh		;3679	28 04 	( . 
	ld a,080h		;367b	3e 80 	> . 
	xor h			;367d	ac 	. 
	ld h,a			;367e	67 	g 
l367fh:
	ex (sp),hl			;367f	e3 	. 
	push bc			;3680	c5 	. 
	call sub_0ca1h		;3681	cd a1 0c 	. . . 
	ld a,080h		;3684	3e 80 	> . 
	and h			;3686	a4 	. 
	rlca			;3687	07 	. 
	xor 001h		;3688	ee 01 	. . 
	push af			;368a	f5 	. 
	ld c,03eh		;368b	0e 3e 	. > 
	add a,b			;368d	80 	. 
	xor h			;368e	ac 	. 
	ld h,a			;368f	67 	g 
	call sub_0ca1h		;3690	cd a1 0c 	. . . 
	ld a,080h		;3693	3e 80 	> . 
	and h			;3695	a4 	. 
	rlca			;3696	07 	. 
	xor 001h		;3697	ee 01 	. . 
	push af			;3699	f5 	. 
	ld a,(bc)			;369a	0a 	. 
	ld hl,l0c5ah		;369b	21 5a 0c 	! Z . 
	ld (l0c4ch+1),hl		;369e	22 4d 0c 	" M . 
	call sub_0c40h		;36a1	cd 40 0c 	. @ . 
	push af			;36a4	f5 	. 
	inc c			;36a5	0c 	. 
	ld hl,l0c5ah		;36a6	21 5a 0c 	! Z . 
	ld (l0c4ch+1),hl		;36a9	22 4d 0c 	" M . 
	call sub_0c40h		;36ac	cd 40 0c 	. @ . 
	xor 001h		;36af	ee 01 	. . 
	push af			;36b1	f5 	. 
	ld a,(bc)			;36b2	0a 	. 
	ld hl,l0c63h		;36b3	21 63 0c 	! c . 
	ld (l0c4ch+1),hl		;36b6	22 4d 0c 	" M . 
	call sub_0c40h		;36b9	cd 40 0c 	. @ . 
	push af			;36bc	f5 	. 
	ld a,(bc)			;36bd	0a 	. 
	ld hl,l0c68h		;36be	21 68 0c 	! h . 
	ld (l0c4ch+1),hl		;36c1	22 4d 0c 	" M . 
	call sub_0c40h		;36c4	cd 40 0c 	. @ . 
	push af			;36c7	f5 	. 
	sub a			;36c8	97 	. 
	dec (hl)			;36c9	35 	5 
	adc a,(hl)			;36ca	8e 	. 
	dec (hl)			;36cb	35 	5 
	and b			;36cc	a0 	. 
	dec (hl)			;36cd	35 	5 
	or b			;36ce	b0 	. 
	dec (hl)			;36cf	35 	5 
	jp nz,0d635h		;36d0	c2 35 d6 	. 5 . 
	dec (hl)			;36d3	35 	5 
	sub a			;36d4	97 	. 
	dec (hl)			;36d5	35 	5 
	adc a,(hl)			;36d6	8e 	. 
	dec (hl)			;36d7	35 	5 
	xor d			;36d8	aa 	. 
	dec (hl)			;36d9	35 	5 
	cp e			;36da	bb 	. 
	dec (hl)			;36db	35 	5 
	rst 8			;36dc	cf 	. 
	dec (hl)			;36dd	35 	5 
	jp po,06635h		;36de	e2 35 66 	. 5 f 
	dec (hl)			;36e1	35 	5 
	ld e,l			;36e2	5d 	] 
	dec (hl)			;36e3	35 	5 
	ld l,(hl)			;36e4	6e 	n 
	dec (hl)			;36e5	35 	5 
	ld (hl),l			;36e6	75 	u 
	dec (hl)			;36e7	35 	5 
	ld a,l			;36e8	7d 	} 
	dec (hl)			;36e9	35 	5 
	add a,(hl)			;36ea	86 	. 
	dec (hl)			;36eb	35 	5 
	ld sp,hl			;36ec	f9 	. 
	dec (hl)			;36ed	35 	5 
	ret p			;36ee	f0 	. 
	dec (hl)			;36ef	35 	5 
	add a,b			;36f0	80 	. 
	ld (hl),00eh		;36f1	36 0e 	6 . 
	ld (hl),01ah		;36f3	36 1a 	6 . 
	ld (hl),026h		;36f5	36 26 	6 & 
	ld (hl),042h		;36f7	36 42 	6 B 
	ld (hl),032h		;36f9	36 32 	6 2 
	ld (hl),05fh		;36fb	36 5f 	6 _ 
	ld (hl),052h		;36fd	36 52 	6 R 
	ld (hl),08bh		;36ff	36 8b 	6 . 
	ld (hl),074h		;3701	36 74 	6 t 
	ld (hl),0a5h		;3703	36 a5 	6 . 
	ld (hl),09ah		;3705	36 9a 	6 . 
	ld (hl),000h		;3707	36 00 	6 . 
	nop			;3709	00 	. 
	nop			;370a	00 	. 
	nop			;370b	00 	. 
	cp l			;370c	bd 	. 
	ld (hl),0b2h		;370d	36 b2 	6 . 
	ld (hl),0cdh		;370f	36 cd 	6 . 
	jp 0cd2fh		;3711	c3 2f cd 	. / . 
	ccf			;3714	3f 	? 
	ccf			;3715	3f 	? 
	call sub_32b2h		;3716	cd b2 32 	. . 2 
	ld hl,l3722h		;3719	21 22 37 	! " 7 
	call sub_33c4h		;371c	cd c4 33 	. . 3 
	dec hl			;371f	2b 	+ 
	dec hl			;3720	2b 	+ 
	ret			;3721	c9 	. 
l3722h:
	inc b			;3722	04 	. 
	or a			;3723	b7 	. 
	jp z,07ccdh		;3724	ca cd 7c 	. . | 
	inc sp			;3727	33 	3 
	jp c,GetLexem		;3728	da c3 2f 	. . / 
	push hl			;372b	e5 	. 
	call GetTargetAddrInHL__		;372c	cd d8 33 	. . 3 
	ex de,hl			;372f	eb 	. 
	inc hl			;3730	23 	# 
	call WrDE_ByTargAddr		;3731	cd 23 34 	. # 4 
	pop hl			;3734	e1 	. 
	dec hl			;3735	2b 	+ 
	ld (hl),d			;3736	72 	r 
	dec hl			;3737	2b 	+ 
	ld (hl),e			;3738	73 	s 
	call GetLexem		;3739	cd c3 2f 	. . / 
	ld de,0ba16h		;373c	11 16 ba 	. . . 
	call ChkLexem_GetLex		;373f	cd 08 33 	. . 3 
	jr l3777h		;3742	18 33 	. 3 
	or h			;3744	b4 	. 
	inc a			;3745	3c 	< 
	sbc a,l			;3746	9d 	. 
	add hl,sp			;3747	39 	9 
	ld l,c			;3748	69 	i 
	inc a			;3749	3c 	< 
	pop bc			;374a	c1 	. 
	ld a,(l3c8ah)		;374b	3a 8a 3c 	: . < 
	pop de			;374e	d1 	. 
	inc a			;374f	3c 	< 
	rst 20h			;3750	e7 	. 
	inc a			;3751	3c 	< 
	ld d,a			;3752	57 	W 
	dec a			;3753	3d 	= 
l3754h:
	cp 07fh		;3754	fe 7f 	.  
	jr z,$-49		;3756	28 cd 	( . 
	cp 013h		;3758	fe 13 	. . 
	ret c			;375a	d8 	. 
	cp 01bh		;375b	fe 1b 	. . 
	ret nc			;375d	d0 	. 
	add a,a			;375e	87 	. 
	ld l,a			;375f	6f 	o 
	ld h,000h		;3760	26 00 	& . 
	ld de,0371eh		;3762	11 1e 37 	. . 7 
	add hl,de			;3765	19 	. 
	ld e,(hl)			;3766	5e 	^ 
	inc hl			;3767	23 	# 
	ld d,(hl)			;3768	56 	V 
	ex de,hl			;3769	eb 	. 
	jp (hl)			;376a	e9 	. 
l376bh:
	push bc			;376b	c5 	. 
	ret			;376c	c9 	. 
sub_376dh:
	ex af,af'			;376d	08 	. 
	ld de,l1110h		;376e	11 10 11 	. . . 
	call ChkLexem_GetLex		;3771	cd 08 33 	. . 3 
	call WCaBreak_IfCoCo_C		;3774	cd 3c 35 	. < 5 
l3777h:
	res 0,(ix+001h)		;3777	dd cb 01 86 	. . . . 
	or a			;377b	b7 	. 
	ld hl,l2b89h		;377c	21 89 2b 	! . + 
	ld (hl),000h		;377f	36 00 	6 . 
	jp nz,l3754h		;3781	c2 54 37 	. T 7 
	call GetIdentInfoInABC		;3784	cd 50 33 	. P 3 
	cp 004h		;3787	fe 04 	. . 
	jp z,l38c0h		;3789	ca c0 38 	. . 8 
	cp 006h		;378c	fe 06 	. . 
	jr z,l376bh		;378e	28 db 	( . 
	cp 008h		;3790	fe 08 	. . 
	jp z,l42fdh		;3792	ca fd 42 	. . B 
	cp 005h		;3795	fe 05 	. . 
	jp z,l3887h		;3797	ca 87 38 	. . 8 
	ld e,007h		;379a	1e 07 	. . 
	call sub_4e7dh		;379c	cd 7d 4e 	. } N 
l379fh:
	push hl			;379f	e5 	. 
	push de			;37a0	d5 	. 
	dec b			;37a1	05 	. 
	jr nz,l37aah		;37a2	20 06 	  . 
	ld hl,CSq_SaveHL		;37a4	21 b7 46 	! . F 
	call sub_33c4h		;37a7	cd c4 33 	. . 3 
l37aah:
	inc b			;37aa	04 	. 
	call ChkColEq_GetLex		;37ab	cd ee 32 	. . 2 
	call sub_3f29h		;37ae	cd 29 3f 	. ) ? 
	pop hl			;37b1	e1 	. 
	pop de			;37b2	d1 	. 
	dec b			;37b3	05 	. 
	jp z,l383eh		;37b4	ca 3e 38 	. > 8 
	inc b			;37b7	04 	. 
	jp nz,l3865h		;37b8	c2 65 38 	. e 8 
l37bbh:
	dec h			;37bb	25 	% 
	jp m,l3827h		;37bc	fa 27 38 	. ' 8 
	exx			;37bf	d9 	. 
	dec hl			;37c0	2b 	+ 
	exx			;37c1	d9 	. 
	jr nz,l37e2h		;37c2	20 1e 	  . 
	dec c			;37c4	0d 	. 
	jr z,l37dbh		;37c5	28 14 	( . 
	dec c			;37c7	0d 	. 
	jp nz,l3aafh		;37c8	c2 af 3a 	. . : 
	exx			;37cb	d9 	. 
	dec hl			;37cc	2b 	+ 
	exx			;37cd	d9 	. 
	call JCodeNextByte		;37ce	cd d1 06 	. . . 
	defb 0edh		;37d1	ed 	. 
	call JCodeNextByte		;37d2	cd d1 06 	. . . 
	defb 053h		;37d5	53 	S 
	call StoreDE		;37d6	cd 0c 34 	. . 4 
	inc de			;37d9	13 	. 
	inc de			;37da	13 	. 
l37dbh:
	call JCodeNextByte		;37db	cd d1 06 	. . . 
	defb 022h		;37de	22 	" 
	jp StoreDE		;37df	c3 0c 34 	. . 4 
l37e2h:
	dec c			;37e2	0d 	. 
	jr z,l3804h		;37e3	28 1f 	( . 
	dec c			;37e5	0d 	. 
	jr nz,l3804h		;37e6	20 1c 	  . 
	exx			;37e8	d9 	. 
	dec hl			;37e9	2b 	+ 
	exx			;37ea	d9 	. 
	call JCodeNextByte		;37eb	cd d1 06 	. . . 
	defb 0ddh		;37ee	dd 	. 
	call JCodeNextByte		;37ef	cd d1 06 	. . . 
	ld (hl),e			;37f2	73 	s 
	call l381ah		;37f3	cd 1a 38 	. . 8 
	inc e			;37f6	1c 	. 
	call JCodeNextByte		;37f7	cd d1 06 	. . . 
	defb 0ddh		;37fa	dd 	. 
	call JCodeNextByte		;37fb	cd d1 06 	. . . 
	ld (hl),d			;37fe	72 	r 
	call l381ah		;37ff	cd 1a 38 	. . 8 
	inc e			;3802	1c 	. 
	cp a			;3803	bf 	. 
l3804h:
	call JCodeNextByte		;3804	cd d1 06 	. . . 
	defb 0ddh		;3807	dd 	. 
	jr nz,l3821h		;3808	20 17 	  . 
	call JCodeNextByte		;380a	cd d1 06 	. . . 
	defb 075h		;380d	75 	u 
	call l381ah		;380e	cd 1a 38 	. . 8 
	call JCodeNextByte		;3811	cd d1 06 	. . . 
	defb 0ddh		;3814	dd 	. 
	inc e			;3815	1c 	. 
	call JCodeNextByte		;3816	cd d1 06 	. . . 
	ld (hl),h			;3819	74 	t 
l381ah:
	push af			;381a	f5 	. 
	ld a,e			;381b	7b 	{ 
	call StoreA_GetTarget		;381c	cd e8 33 	. . 3 
	pop af			;381f	f1 	. 
	ret			;3820	c9 	. 
l3821h:
	call JCodeNextByte		;3821	cd d1 06 	. . . 
	defb 077h		;3824	77 	w 
	jr l381ah		;3825	18 f3 	. . 
l3827h:
	dec c			;3827	0d 	. 
	jr z,l3832h		;3828	28 08 	( . 
	dec c			;382a	0d 	. 
	jr z,l3838h		;382b	28 0b 	( . 
	ld hl,l389ch		;382d	21 9c 38 	! . 8 
	jr l3835h		;3830	18 03 	. . 
l3832h:
	ld hl,l389fh		;3832	21 9f 38 	! . 8 
l3835h:
	jp sub_33c4h		;3835	c3 c4 33 	. . 3 
l3838h:
	ld hl,l38a9h		;3838	21 a9 38 	! . 8 
	jp l33beh		;383b	c3 be 33 	. . 3 
l383eh:
	ld hl,l38b4h		;383e	21 b4 38 	! . 8 
	jp CodeLdBC_0n_from_0x2b8b		;3841	c3 aa 33 	. . 3 
	call NextChkOpBra_GetLex		;3844	cd fd 32 	. . 2 
	call sub_3f10h		;3847	cd 10 3f 	. . ? 
	call ChkComma_GetLex		;384a	cd f8 32 	. . 2 
	call sub_3f3fh		;384d	cd 3f 3f 	. ? ? 
	call ChkCloBra_GetLex		;3850	cd 05 33 	. . 3 
	dec b			;3853	05 	. 
	jr z,l387dh		;3854	28 27 	( ' 
	dec b			;3856	05 	. 
	jr nz,l385fh		;3857	20 06 	  . 
	ld (Merker1),bc		;3859	ed 43 87 2b 	. C . + 
	jr l3865h		;385d	18 06 	. . 
l385fh:
	inc b			;385f	04 	. 
	inc b			;3860	04 	. 
	ld h,000h		;3861	26 00 	& . 
	jr z,l3827h		;3863	28 c2 	( . 
l3865h:
	bit 7,b		;3865	cb 78 	. x 
	jr nz,l3882h		;3867	20 19 	  . 
	exx			;3869	d9 	. 
	dec hl			;386a	2b 	+ 
	exx			;386b	d9 	. 
	call JCodeNextByte		;386c	cd d1 06 	. . . 
	defb 001h		;386f	01 	. 
	ld de,(Merker1)		;3870	ed 5b 87 2b 	. [ . + 
	call StoreDE		;3874	cd 0c 34 	. . 4 
	ld hl,l38a5h		;3877	21 a5 38 	! . 8 
	jp WCode		;387a	c3 cc 33 	. . 3 
l387dh:
	ld e,034h		;387d	1e 34 	. 4 
	jp CompileErr		;387f	c3 3a 2f 	. : / 
l3882h:
	ld c,001h		;3882	0e 01 	. . 
	jp l37bbh		;3884	c3 bb 37 	. . 7 
l3887h:
	ld a,(bc)			;3887	0a 	. 
	ld c,a			;3888	4f 	O 
	inc hl			;3889	23 	# 
	inc hl			;388a	23 	# 
	ld b,(hl)			;388b	46 	F 
	inc b			;388c	04 	. 
	inc hl			;388d	23 	# 
	inc hl			;388e	23 	# 
	inc hl			;388f	23 	# 
	ld e,(hl)			;3890	5e 	^ 
	inc hl			;3891	23 	# 
	ld d,(hl)			;3892	56 	V 
	ld a,(BlockLevel__)		;3893	3a 72 2b 	: r + 
	call sub_4faah		;3896	cd aa 4f 	. . O 
	jp l379fh		;3899	c3 9f 37 	. . 7 
l389ch:
	ld (bc),a			;389c	02 	. 
	pop hl			;389d	e1 	. 
	ld (hl),a			;389e	77 	w 
l389fh:
	dec b			;389f	05 	. 
	ex de,hl			;38a0	eb 	. 
	pop hl			;38a1	e1 	. 
	ld (hl),e			;38a2	73 	s 
	inc hl			;38a3	23 	# 
	ld (hl),d			;38a4	72 	r 
l38a5h:
	inc bc			;38a5	03 	. 
	pop de			;38a6	d1 	. 
	ldir		;38a7	ed b0 	. . 
l38a9h:
	ld a,(bc)			;38a9	0a 	. 
	ld b,h			;38aa	44 	D 
	ld c,l			;38ab	4d 	M 
	pop hl			;38ac	e1 	. 
	ld (hl),e			;38ad	73 	s 
	inc hl			;38ae	23 	# 
	ld (hl),d			;38af	72 	r 
	inc hl			;38b0	23 	# 
	ld (hl),c			;38b1	71 	q 
	inc hl			;38b2	23 	# 
	ld (hl),b			;38b3	70 	p 
l38b4h:
	dec bc			;38b4	0b 	. 
	ld de,(l1798h)		;38b5	ed 5b 98 17 	. [ . . 
	ld hl,00000h		;38b9	21 00 00 	! . . 
	add hl,sp			;38bc	39 	9 
	ldir		;38bd	ed b0 	. . 
	ld sp,hl			;38bf	f9 	. 
l38c0h:
	push hl			;38c0	e5 	. 
	push bc			;38c1	c5 	. 
	ld de,00004h		;38c2	11 04 00 	. . . 
	add hl,de			;38c5	19 	. 
	ld b,(hl)			;38c6	46 	F 
	call GetLexem		;38c7	cd c3 2f 	. . / 
	dec b			;38ca	05 	. 
	inc b			;38cb	04 	. 
	jp z,l3931h		;38cc	ca 31 39 	. 1 9 
	call ChkOpBra_GetLex		;38cf	cd 00 33 	. . 3 
	ld de,00005h		;38d2	11 05 00 	. . . 
	add hl,de			;38d5	19 	. 
l38d6h:
	call sub_4d6dh		;38d6	cd 6d 4d 	. m M 
	push bc			;38d9	c5 	. 
	ld e,a			;38da	5f 	_ 
	dec hl			;38db	2b 	+ 
	ld a,(hl)			;38dc	7e 	~ 
	inc hl			;38dd	23 	# 
	ld c,(hl)			;38de	4e 	N 
	inc hl			;38df	23 	# 
	ld b,(hl)			;38e0	46 	F 
	push hl			;38e1	e5 	. 
	cp 002h		;38e2	fe 02 	. . 
	ld a,e			;38e4	7b 	{ 
	jr z,l38f3h		;38e5	28 0c 	( . 
	ld e,018h		;38e7	1e 18 	. . 
	push bc			;38e9	c5 	. 
	call sub_5027h		;38ea	cd 27 50 	. ' P 
	pop de			;38ed	d1 	. 
	call ChkType__		;38ee	cd ba 32 	. . 2 
	jr l3914h		;38f1	18 21 	. ! 
l38f3h:
	call sub_3f29h		;38f3	cd 29 3f 	. ) ? 
	bit 7,b		;38f6	cb 78 	. x 
	jr nz,l3914h		;38f8	20 1a 	  . 
	dec b			;38fa	05 	. 
	jr z,l3914h		;38fb	28 17 	( . 
	inc b			;38fd	04 	. 
	jr z,l3922h		;38fe	28 22 	( " 
	exx			;3900	d9 	. 
	dec hl			;3901	2b 	+ 
	exx			;3902	d9 	. 
	call JCodeNextByte		;3903	cd d1 06 	. . . 
	defb 001h		;3906	01 	. 
	ld de,(Merker1)		;3907	ed 5b 87 2b 	. [ . + 
	call StoreDE		;390b	cd 0c 34 	. . 4 
	ld hl,l395fh		;390e	21 5f 39 	! _ 9 
	call WCode		;3911	cd cc 33 	. . 3 
l3914h:
	pop hl			;3914	e1 	. 
	pop bc			;3915	c1 	. 
	dec b			;3916	05 	. 
	jr z,l392eh		;3917	28 15 	( . 
	call ChkComma_GetLex		;3919	cd f8 32 	. . 2 
	ld de,0000ah		;391c	11 0a 00 	. . . 
	add hl,de			;391f	19 	. 
	jr l38d6h		;3920	18 b4 	. . 
l3922h:
	dec c			;3922	0d 	. 
	jr z,l3914h		;3923	28 ef 	( . 
	dec c			;3925	0d 	. 
	jr z,l3914h		;3926	28 ec 	( . 
	call JCodeNextByte		;3928	cd d1 06 	. . . 
	defb 033h		;392b	33 	3 
	jr l3914h		;392c	18 e6 	. . 
l392eh:
	call ChkCloBra_GetLex		;392e	cd 05 33 	. . 3 
l3931h:
	res 3,(ix+002h)		;3931	dd cb 02 9e 	. . . . 
	pop hl			;3935	e1 	. 
	ld c,(hl)			;3936	4e 	N 
	inc hl			;3937	23 	# 
	ld b,(hl)			;3938	46 	F 
	pop hl			;3939	e1 	. 
	push af			;393a	f5 	. 
	ld e,(hl)			;393b	5e 	^ 
	inc hl			;393c	23 	# 
	ld d,(hl)			;393d	56 	V 
	inc hl			;393e	23 	# 
	ld a,(hl)			;393f	7e 	~ 
	ld hl,BlockLevel__		;3940	21 72 2b 	! r + 
	sub (hl)			;3943	96 	. 
	jp p,l395ah		;3944	f2 5a 39 	. Z 9 
	neg		;3947	ed 44 	. D 
	call JCodeNextByte		;3949	cd d1 06 	. . . 
	defb 006h		;394c	06 	. 
	call StoreAToHL2		;394d	cd e3 33 	. . 3 
	ld hl,l396bh		;3950	21 6b 39 	! k 9 
l3953h:
	call WCode		;3953	cd cc 33 	. . 3 
	pop af			;3956	f1 	. 
	jp StoreDE		;3957	c3 0c 34 	. . 4 
l395ah:
	ld hl,03971h		;395a	21 71 39 	! q 9 
	jr l3953h		;395d	18 f4 	. . 
l395fh:
	dec bc			;395f	0b 	. 
	ex de,hl			;3960	eb 	. 
	xor a			;3961	af 	. 
	ld l,a			;3962	6f 	o 
	ld h,a			;3963	67 	g 
	sbc hl,bc		;3964	ed 42 	. B 
	add hl,sp			;3966	39 	9 
	ld sp,hl			;3967	f9 	. 
	ex de,hl			;3968	eb 	. 
	ldir		;3969	ed b0 	. . 
l396bh:
	dec b			;396b	05 	. 
	call sub_09b1h		;396c	cd b1 09 	. . . 
	push de			;396f	d5 	. 
	call 0dd03h		;3970	cd 03 dd 	. . . 
	push hl			;3973	e5 	. 
	call 079cdh		;3974	cd cd 79 	. . y 
	inc (hl)			;3977	34 	4 
	push hl			;3978	e5 	. 
	ld hl,l2b80h		;3979	21 80 2b 	! . + 
	ld e,(hl)			;397c	5e 	^ 
	ld d,000h		;397d	16 00 	. . 
	call ChkType__		;397f	cd ba 32 	. . 2 
	pop de			;3982	d1 	. 
	call JCodeNextByte		;3983	cd d1 06 	. . . 
	defb 0feh		;3986	fe 	. 
	call l381ah		;3987	cd 1a 38 	. . 8 
	ld hl,03a62h		;398a	21 62 3a 	! b : 
	call WCode		;398d	cd cc 33 	. . 3 
	cp 0bah		;3990	fe ba 	. . 
	jr z,l3999h		;3992	28 05 	( . 
	call ChkComma_GetLex		;3994	cd f8 32 	. . 2 
	jr $-34		;3997	18 dc 	. . 
l3999h:
	ld a,0fbh		;3999	3e fb 	> . 
	jr l39d8h		;399b	18 3b 	. ; 
	ld bc,0ffffh		;399d	01 ff ff 	. . . 
	push bc			;39a0	c5 	. 
	call GetLexem		;39a1	cd c3 2f 	. . / 
	call sub_3f3fh		;39a4	cd 3f 3f 	. ? ? 
	exx			;39a7	d9 	. 
	dec hl			;39a8	2b 	+ 
	exx			;39a9	d9 	. 
	call GetTargetAddrInHL__		;39aa	cd d8 33 	. . 3 
	dec hl			;39ad	2b 	+ 
	push hl			;39ae	e5 	. 
	ld de,00b14h		;39af	11 14 0b 	. . . 
	call ChkLexem_GetLex		;39b2	cd 08 33 	. . 3 
	ld b,a			;39b5	47 	G 
	ld a,c			;39b6	79 	y 
	ld (l2b80h),a		;39b7	32 80 2b 	2 . + 
l39bah:
	dec a			;39ba	3d 	= 
	ld a,b			;39bb	78 	x 
	jr nz,$-71		;39bc	20 b7 	  . 
l39beh:
	call ParseConstVal		;39be	cd 79 34 	. y 4 
	call sub_32b7h		;39c1	cd b7 32 	. . 2 
	call sub_33fah		;39c4	cd fa 33 	. . 3 
	ld hl,l3a5ch		;39c7	21 5c 3a 	! \ : 
	call WCode		;39ca	cd cc 33 	. . 3 
	cp 0bah		;39cd	fe ba 	. . 
	jr z,l39d6h		;39cf	28 05 	( . 
	call ChkComma_GetLex		;39d1	cd f8 32 	. . 2 
	jr l39beh		;39d4	18 e8 	. . 
l39d6h:
	ld a,0f6h		;39d6	3e f6 	> . 
l39d8h:
	ld d,h			;39d8	54 	T 
	ld e,l			;39d9	5d 	] 
	dec hl			;39da	2b 	+ 
l39dbh:
	ld b,0ffh		;39db	06 ff 	. . 
	ld c,a			;39dd	4f 	O 
	add hl,bc			;39de	09 	. 
	pop bc			;39df	c1 	. 
	push bc			;39e0	c5 	. 
	or a			;39e1	b7 	. 
	sbc hl,bc		;39e2	ed 42 	. B 
	add hl,bc			;39e4	09 	. 
	jr z,l39ech		;39e5	28 05 	( . 
	call WrDE_ByTargAddr_pl1		;39e7	cd 18 34 	. . 4 
	jr l39dbh		;39ea	18 ef 	. . 
l39ech:
	pop bc			;39ec	c1 	. 
	dec de			;39ed	1b 	. 
	push de			;39ee	d5 	. 
	ld hl,l2b80h		;39ef	21 80 2b 	! . + 
	ld b,(hl)			;39f2	46 	F 
	push bc			;39f3	c5 	. 
	call GetLexem		;39f4	cd c3 2f 	. . / 
	call l3777h		;39f7	cd 77 37 	. w 7 
	pop bc			;39fa	c1 	. 
	ld hl,l2b80h		;39fb	21 80 2b 	! . + 
	ld (hl),b			;39fe	70 	p 
	call WrJump		;39ff	cd c9 33 	. . 3 
	dec hl			;3a02	2b 	+ 
	pop de			;3a03	d1 	. 
	pop bc			;3a04	c1 	. 
	push hl			;3a05	e5 	. 
	inc b			;3a06	04 	. 
	push bc			;3a07	c5 	. 
	push hl			;3a08	e5 	. 
	ex de,hl			;3a09	eb 	. 
	inc de			;3a0a	13 	. 
	call WrDE_ByTargAddr_pl1		;3a0b	cd 18 34 	. . 4 
	dec hl			;3a0e	2b 	+ 
	dec hl			;3a0f	2b 	+ 
	push af			;3a10	f5 	. 
	ld a,0c2h		;3a11	3e c2 	> . 
	call WrA_ByTargAddr		;3a13	cd 2e 34 	. . 4 
	pop af			;3a16	f1 	. 
	cp 012h		;3a17	fe 12 	. . 
	jr z,l3a49h		;3a19	28 2e 	( . 
	cp 010h		;3a1b	fe 10 	. . 
	jr z,l3a29h		;3a1d	28 0a 	( . 
	call ChkSemi_GetLex		;3a1f	cd d9 32 	. . 2 
	ld b,a			;3a22	47 	G 
	ld a,(l2b80h)		;3a23	3a 80 2b 	: . + 
	jp l39bah		;3a26	c3 ba 39 	. . 9 
l3a29h:
	inc hl			;3a29	23 	# 
	dec de			;3a2a	1b 	. 
	dec de			;3a2b	1b 	. 
	dec de			;3a2c	1b 	. 
	call WrDE_ByTargAddr		;3a2d	cd 23 34 	. # 4 
	pop de			;3a30	d1 	. 
	pop bc			;3a31	c1 	. 
	pop hl			;3a32	e1 	. 
	exx			;3a33	d9 	. 
	dec hl			;3a34	2b 	+ 
	dec hl			;3a35	2b 	+ 
	dec hl			;3a36	2b 	+ 
	exx			;3a37	d9 	. 
	call GetLexem		;3a38	cd c3 2f 	. . / 
l3a3bh:
	call GetTargetAddrInHL__		;3a3b	cd d8 33 	. . 3 
	ex de,hl			;3a3e	eb 	. 
	dec b			;3a3f	05 	. 
	inc b			;3a40	04 	. 
	ret z			;3a41	c8 	. 
l3a42h:
	pop hl			;3a42	e1 	. 
	call WrDE_ByTargAddr_pl1		;3a43	cd 18 34 	. . 4 
	djnz l3a42h		;3a46	10 fa 	. . 
	ret			;3a48	c9 	. 
l3a49h:
	pop de			;3a49	d1 	. 
	pop bc			;3a4a	c1 	. 
	inc b			;3a4b	04 	. 
	pop hl			;3a4c	e1 	. 
	call GetTargetAddrInHL__		;3a4d	cd d8 33 	. . 3 
	dec hl			;3a50	2b 	+ 
	push hl			;3a51	e5 	. 
	push bc			;3a52	c5 	. 
	call GetLexem		;3a53	cd c3 2f 	. . / 
	call l3777h		;3a56	cd 77 37 	. w 7 
	pop bc			;3a59	c1 	. 
	jr l3a3bh		;3a5a	18 df 	. . 
l3a5ch:
	rlca			;3a5c	07 	. 
	or a			;3a5d	b7 	. 
	sbc hl,de		;3a5e	ed 52 	. R 
	add hl,de			;3a60	19 	. 
	jp z,0ca03h		;3a61	ca 03 ca 	. . . 
sub_3a64h:
	call StoreAToHL2		;3a64	cd e3 33 	. . 3 
	inc c			;3a67	0c 	. 
sub_3a68h:
	push af			;3a68	f5 	. 
	call sub_3a6eh		;3a69	cd 6e 3a 	. n : 
	pop af			;3a6c	f1 	. 
	ret			;3a6d	c9 	. 
sub_3a6eh:
	ld hl,(l2b7eh)		;3a6e	2a 7e 2b 	* ~ + 
	call sub_34fah		;3a71	cd fa 34 	. . 4 
	jr z,l3aabh		;3a74	28 35 	( 5 
	sub b			;3a76	90 	. 
	jr z,l3a91h		;3a77	28 18 	( . 
	dec c			;3a79	0d 	. 
	jr z,l3a84h		;3a7a	28 08 	( . 
	call sub_3509h		;3a7c	cd 09 35 	. . 5 
l3a7fh:
	call JCodeNextByte		;3a7f	cd d1 06 	. . . 
	defb 077h		;3a82	77 	w 
	ret			;3a83	c9 	. 
l3a84h:
	call JCodeNextByte		;3a84	cd d1 06 	. . . 
	defb 0e5h		;3a87	e5 	. 
	call sub_3509h		;3a88	cd 09 35 	. . 5 
l3a8bh:
	ld hl,l3ab6h		;3a8b	21 b6 3a 	! . : 
	jp WCode		;3a8e	c3 cc 33 	. . 3 
l3a91h:
	call sub_3526h		;3a91	cd 26 35 	. & 5 
	jr nc,l3a9ah		;3a94	30 04 	0 . 
	dec c			;3a96	0d 	. 
	jp l3804h		;3a97	c3 04 38 	. . 8 
l3a9ah:
	dec c			;3a9a	0d 	. 
	jr z,l3aa2h		;3a9b	28 05 	( . 
	call sub_3518h		;3a9d	cd 18 35 	. . 5 
	jr l3a7fh		;3aa0	18 dd 	. . 
l3aa2h:
	call JCodeNextByte		;3aa2	cd d1 06 	. . . 
	defb 0e5h		;3aa5	e5 	. 
	call sub_3518h		;3aa6	cd 18 35 	. . 5 
	jr l3a8bh		;3aa9	18 e0 	. . 
l3aabh:
	dec c			;3aab	0d 	. 
	jp z,l37dbh		;3aac	ca db 37 	. . 7 
l3aafh:
	call JCodeNextByte		;3aaf	cd d1 06 	. . . 
	defb 032h		;3ab2	32 	2 
	jp StoreDE		;3ab3	c3 0c 34 	. . 4 
l3ab6h:
	dec b			;3ab6	05 	. 
	pop de			;3ab7	d1 	. 
	ld (hl),e			;3ab8	73 	s 
	inc hl			;3ab9	23 	# 
	ld (hl),d			;3aba	72 	r 
	ex de,hl			;3abb	eb 	. 
l3abch:
	inc b			;3abc	04 	. 
	ld e,(hl)			;3abd	5e 	^ 
	inc hl			;3abe	23 	# 
	ld d,(hl)			;3abf	56 	V 
	ex de,hl			;3ac0	eb 	. 
	call GetLexem		;3ac1	cd c3 2f 	. . / 
	or a			;3ac4	b7 	. 
	ld e,004h		;3ac5	1e 04 	. . 
	call nz,CompileErr		;3ac7	c4 3a 2f 	. : / 
	call GetIdentInfoInABC		;3aca	cd 50 33 	. P 3 
	cp 002h		;3acd	fe 02 	. . 
	ld e,007h		;3acf	1e 07 	. . 
	call nz,CompileErr		;3ad1	c4 3a 2f 	. : / 
	ld a,c			;3ad4	79 	y 
	ld (l2b80h),a		;3ad5	32 80 2b 	2 . + 
	ld (l2b7eh),hl		;3ad8	22 7e 2b 	" ~ + 
	call GetLexem		;3adb	cd c3 2f 	. . / 
	call ChkColEq_GetLex		;3ade	cd ee 32 	. . 2 
	call sub_3f13h		;3ae1	cd 13 3f 	. . ? 
	exx			;3ae4	d9 	. 
	ld (Merker1),hl		;3ae5	22 87 2b 	" . + 
	exx			;3ae8	d9 	. 
	call sub_3a68h		;3ae9	cd 68 3a 	. h : 
	cp 00dh		;3aec	fe 0d 	. . 
	jr z,l3af7h		;3aee	28 07 	( . 
	cp 00ch		;3af0	fe 0c 	. . 
	ld e,011h		;3af2	1e 11 	. . 
	call nz,CompileErr		;3af4	c4 3a 2f 	. : / 
l3af7h:
	push af			;3af7	f5 	. 
	call GetLexem		;3af8	cd c3 2f 	. . / 
	ld hl,(l2b80h)		;3afb	2a 80 2b 	* . + 
	ld h,000h		;3afe	26 00 	& . 
	exx			;3b00	d9 	. 
	push hl			;3b01	e5 	. 
	exx			;3b02	d9 	. 
	call sub_3f23h		;3b03	cd 23 3f 	. # ? 
	ex af,af'			;3b06	08 	. 
	ld a,c			;3b07	79 	y 
	dec a			;3b08	3d 	= 
	exx			;3b09	d9 	. 
	pop bc			;3b0a	c1 	. 
	exx			;3b0b	d9 	. 
	jr nz,l3b4eh		;3b0c	20 40 	  @ 
	add a,021h		;3b0e	c6 21 	. ! 
	call sub_41bfh		;3b10	cd bf 41 	. . A 
	exx			;3b13	d9 	. 
	inc hl			;3b14	23 	# 
	cp (hl)			;3b15	be 	. 
	jr nz,l3b37h		;3b16	20 1f 	  . 
	sbc hl,bc		;3b18	ed 42 	. B 
	add hl,bc			;3b1a	09 	. 
	jr nz,l3b37h		;3b1b	20 1a 	  . 
	ld de,(Merker1)		;3b1d	ed 5b 87 2b 	. [ . + 
	sbc hl,de		;3b21	ed 52 	. R 
	ld b,h			;3b23	44 	D 
	ld c,l			;3b24	4d 	M 
	ld h,d			;3b25	62 	b 
	ld l,e			;3b26	6b 	k 
	dec de			;3b27	1b 	. 
	ldir		;3b28	ed b0 	. . 
	dec hl			;3b2a	2b 	+ 
	exx			;3b2b	d9 	. 
	pop af			;3b2c	f1 	. 
	push hl			;3b2d	e5 	. 
	set 2,(ix+001h)		;3b2e	dd cb 01 d6 	. . . . 
	call WrJump		;3b32	cd c9 33 	. . 3 
	jr l3b46h		;3b35	18 0f 	. . 
l3b37h:
	inc hl			;3b37	23 	# 
	inc hl			;3b38	23 	# 
	inc hl			;3b39	23 	# 
	exx			;3b3a	d9 	. 
	res 2,(ix+001h)		;3b3b	dd cb 01 96 	. . . . 
	ld hl,03c50h		;3b3f	21 50 3c 	! P < 
	call WCode		;3b42	cd cc 33 	. . 3 
	pop af			;3b45	f1 	. 
l3b46h:
	dec hl			;3b46	2b 	+ 
	push hl			;3b47	e5 	. 
	push af			;3b48	f5 	. 
	ld hl,(l2b7eh)		;3b49	2a 7e 2b 	* ~ + 
	jr l3b81h		;3b4c	18 33 	. 3 
l3b4eh:
	pop af			;3b4e	f1 	. 
	cp 00ch		;3b4f	fe 0c 	. . 
	jr nz,l3b5bh		;3b51	20 08 	  . 
	ld hl,03c53h		;3b53	21 53 3c 	! S < 
	ld de,03c57h		;3b56	11 57 3c 	. W < 
	jr l3b61h		;3b59	18 06 	. . 
l3b5bh:
	ld hl,l3c5ch		;3b5b	21 5c 3c 	! \ < 
	ld de,03c61h		;3b5e	11 61 3c 	. a < 
l3b61h:
	call sub_33c4h		;3b61	cd c4 33 	. . 3 
	push hl			;3b64	e5 	. 
	ex de,hl			;3b65	eb 	. 
	call WCode		;3b66	cd cc 33 	. . 3 
	push hl			;3b69	e5 	. 
	call JCodeNextByte		;3b6a	cd d1 06 	. . . 
	defb 0c5h		;3b6d	c5 	. 
	push af			;3b6e	f5 	. 
	ld hl,(l2b7eh)		;3b6f	2a 7e 2b 	* ~ + 
	push hl			;3b72	e5 	. 
	ld a,(l2b80h)		;3b73	3a 80 2b 	: . + 
	push af			;3b76	f5 	. 
	call sub_376dh		;3b77	cd 6d 37 	. m 7 
	ex af,af'			;3b7a	08 	. 
	pop af			;3b7b	f1 	. 
	ld c,a			;3b7c	4f 	O 
	pop hl			;3b7d	e1 	. 
	ld (l2b7eh),hl		;3b7e	22 7e 2b 	" ~ + 
l3b81h:
	call sub_34fah		;3b81	cd fa 34 	. . 4 
	jr z,l3bd9h		;3b84	28 53 	( S 
	sub b			;3b86	90 	. 
	jr z,l3baah		;3b87	28 21 	( ! 
	call sub_3509h		;3b89	cd 09 35 	. . 5 
l3b8ch:
	dec c			;3b8c	0d 	. 
	jr z,l3beah		;3b8d	28 5b 	( [ 
	call JCodeNextByte		;3b8f	cd d1 06 	. . . 
	defb 077h		;3b92	77 	w 
l3b93h:
	pop af			;3b93	f1 	. 
	add a,030h		;3b94	c6 30 	. 0 
	call sub_3a64h		;3b96	cd 64 3a 	. d : 
	ld hl,l3c65h		;3b99	21 65 3c 	! e < 
	call WCode		;3b9c	cd cc 33 	. . 3 
	pop de			;3b9f	d1 	. 
	call WrDE_ByTargAddr_pl2		;3ba0	cd 17 34 	. . 4 
	inc hl			;3ba3	23 	# 
	ex de,hl			;3ba4	eb 	. 
	pop hl			;3ba5	e1 	. 
	ex af,af'			;3ba6	08 	. 
	jp WrDE_ByTargAddr		;3ba7	c3 23 34 	. # 4 
l3baah:
	call sub_3526h		;3baa	cd 26 35 	. & 5 
	jr nc,l3bd4h		;3bad	30 25 	0 % 
	call JCodeNextByte		;3baf	cd d1 06 	. . . 
	defb 0ddh		;3bb2	dd 	. 
	dec c			;3bb3	0d 	. 
	jr nz,l3bcbh		;3bb4	20 15 	  . 
	call JCodeNextByte		;3bb6	cd d1 06 	. . . 
	defb 06eh		;3bb9	6e 	n 
	call l381ah		;3bba	cd 1a 38 	. . 8 
	inc e			;3bbd	1c 	. 
	call JCodeNextByte		;3bbe	cd d1 06 	. . . 
	defb 0ddh		;3bc1	dd 	. 
	call JCodeNextByte		;3bc2	cd d1 06 	. . . 
	ld h,(hl)			;3bc5	66 	f 
	call l381ah		;3bc6	cd 1a 38 	. . 8 
	jr l3bf0h		;3bc9	18 25 	. % 
l3bcbh:
	call JCodeNextByte		;3bcb	cd d1 06 	. . . 
	defb 07eh		;3bce	7e 	~ 
	call l381ah		;3bcf	cd 1a 38 	. . 8 
	jr l3b93h		;3bd2	18 bf 	. . 
l3bd4h:
	call sub_3518h		;3bd4	cd 18 35 	. . 5 
	jr l3b8ch		;3bd7	18 b3 	. . 
l3bd9h:
	dec c			;3bd9	0d 	. 
	jr z,l3be5h		;3bda	28 09 	( . 
	call JCodeNextByte		;3bdc	cd d1 06 	. . . 
	defb 03ah		;3bdf	3a 	: 
	call StoreDE		;3be0	cd 0c 34 	. . 4 
	jr l3b93h		;3be3	18 ae 	. . 
l3be5h:
	call sub_3401h		;3be5	cd 01 34 	. . 4 
	jr l3bf0h		;3be8	18 06 	. . 
l3beah:
	ld hl,l3abch		;3bea	21 bc 3a 	! . : 
	call WCode		;3bed	cd cc 33 	. . 3 
l3bf0h:
	pop af			;3bf0	f1 	. 
	rlca			;3bf1	07 	. 
	rlca			;3bf2	07 	. 
	rlca			;3bf3	07 	. 
	sub 03dh		;3bf4	d6 3d 	. = 
	call sub_3a64h		;3bf6	cd 64 3a 	. d : 
	call GetTargetAddrInHL__		;3bf9	cd d8 33 	. . 3 
	ex de,hl			;3bfc	eb 	. 
	pop hl			;3bfd	e1 	. 
	push hl			;3bfe	e5 	. 
	call WrDE_ByTargAddr_pl1		;3bff	cd 18 34 	. . 4 
	bit 2,(ix+001h)		;3c02	dd cb 01 56 	. . . V 
	jr nz,l3c43h		;3c06	20 3b 	  ; 
	call JCodeNextByte		;3c08	cd d1 06 	. . . 
	defb 0d1h		;3c0b	d1 	. 
	call JCodeNextByte		;3c0c	cd d1 06 	. . . 
	defb 0d5h		;3c0f	d5 	. 
l3c10h:
	cp 02bh		;3c10	fe 2b 	. + 
	jr z,l3c18h		;3c12	28 04 	( . 
	call JCodeNextByte		;3c14	cd d1 06 	. . . 
	defb 0ebh		;3c17	eb 	. 
l3c18h:
	ld hl,l3c4bh		;3c18	21 4b 3c 	! K < 
	call WCode		;3c1b	cd cc 33 	. . 3 
sub_3c1eh:
	dec hl			;3c1e	2b 	+ 
	push hl			;3c1f	e5 	. 
	ld h,(ix+001h)		;3c20	dd 66 01 	. f . 
	push hl			;3c23	e5 	. 
	call sub_376dh		;3c24	cd 6d 37 	. m 7 
	pop hl			;3c27	e1 	. 
	ld (ix+001h),h		;3c28	dd 74 01 	. t . 
	call WrJump		;3c2b	cd c9 33 	. . 3 
	ex de,hl			;3c2e	eb 	. 
	pop hl			;3c2f	e1 	. 
	call WrDE_ByTargAddr_pl1		;3c30	cd 18 34 	. . 4 
	ex de,hl			;3c33	eb 	. 
	pop de			;3c34	d1 	. 
	inc de			;3c35	13 	. 
	call WrDE_ByTargAddr_pl2		;3c36	cd 17 34 	. . 4 
	bit 2,(ix+001h)		;3c39	dd cb 01 56 	. . . V 
	ret nz			;3c3d	c0 	. 
	call JCodeNextByte		;3c3e	cd d1 06 	. . . 
	defb 0d1h		;3c41	d1 	. 
	ret			;3c42	c9 	. 
l3c43h:
	pop bc			;3c43	c1 	. 
	pop de			;3c44	d1 	. 
	call sub_33fbh		;3c45	cd fb 33 	. . 3 
	push bc			;3c48	c5 	. 
	jr l3c10h		;3c49	18 c5 	. . 
l3c4bh:
	ld b,0b7h		;3c4b	06 b7 	. . 
	sbc hl,de		;3c4d	ed 52 	. R 
	jp m,0e304h		;3c4f	fa 04 e3 	. . . 
	jp 0c103h		;3c52	c3 03 c1 	. . . 
	cp b			;3c55	b8 	. 
	jp c,00004h		;3c56	da 04 00 	. . . 
	nop			;3c59	00 	. 
	inc a			;3c5a	3c 	< 
	ld b,a			;3c5b	47 	G 
l3c5ch:
	inc b			;3c5c	04 	. 
	ld b,a			;3c5d	47 	G 
	pop af			;3c5e	f1 	. 
	cp b			;3c5f	b8 	. 
	jp c,00003h		;3c60	da 03 00 	. . . 
	nop			;3c63	00 	. 
	dec b			;3c64	05 	. 
l3c65h:
	dec b			;3c65	05 	. 
	pop bc			;3c66	c1 	. 
	cp b			;3c67	b8 	. 
	jp nz,0d8cdh		;3c68	c2 cd d8 	. . . 
	inc sp			;3c6b	33 	3 
	push hl			;3c6c	e5 	. 
	call WCaBreak_IfCoCo_C		;3c6d	cd 3c 35 	. < 5 
	call 03710h		;3c70	cd 10 37 	. . 7 
	push hl			;3c73	e5 	. 
	ld de,l1110h		;3c74	11 10 11 	. . . 
	call ChkLexem_GetLex		;3c77	cd 08 33 	. . 3 
	call l3777h		;3c7a	cd 77 37 	. w 7 
	call WrJump		;3c7d	cd c9 33 	. . 3 
	pop de			;3c80	d1 	. 
	ex de,hl			;3c81	eb 	. 
	call WrDE_ByTargAddr		;3c82	cd 23 34 	. # 4 
	ex de,hl			;3c85	eb 	. 
	pop de			;3c86	d1 	. 
	jp WrDE_ByTargAddr_pl2		;3c87	c3 17 34 	. . 4 
l3c8ah:
	call 03710h		;3c8a	cd 10 37 	. . 7 
	push hl			;3c8d	e5 	. 
	ld de,l0e0fh		;3c8e	11 0f 0e 	. . . 
	call ChkLexem_GetLex		;3c91	cd 08 33 	. . 3 
	call l3777h		;3c94	cd 77 37 	. w 7 
	cp 012h		;3c97	fe 12 	. . 
	jr nz,l3cach		;3c99	20 11 	  . 
	call WrJump		;3c9b	cd c9 33 	. . 3 
	ex de,hl			;3c9e	eb 	. 
	pop hl			;3c9f	e1 	. 
	call WrDE_ByTargAddr		;3ca0	cd 23 34 	. # 4 
	dec de			;3ca3	1b 	. 
	dec de			;3ca4	1b 	. 
	push de			;3ca5	d5 	. 
	call GetLexem		;3ca6	cd c3 2f 	. . / 
	call l3777h		;3ca9	cd 77 37 	. w 7 
l3cach:
	call GetTargetAddrInHL__		;3cac	cd d8 33 	. . 3 
	ex de,hl			;3caf	eb 	. 
	pop hl			;3cb0	e1 	. 
	jp WrDE_ByTargAddr		;3cb1	c3 23 34 	. # 4 
	call GetTargetAddrInHL__		;3cb4	cd d8 33 	. . 3 
	push hl			;3cb7	e5 	. 
	call GetLexem		;3cb8	cd c3 2f 	. . / 
	call WCaBreak_IfCoCo_C		;3cbb	cd 3c 35 	. < 5 
l3cbeh:
	call l3777h		;3cbe	cd 77 37 	. w 7 
	cp 00fh		;3cc1	fe 0f 	. . 
	jr z,l3ccah		;3cc3	28 05 	( . 
	call ChkSemi_GetLex		;3cc5	cd d9 32 	. . 2 
	jr l3cbeh		;3cc8	18 f4 	. . 
l3ccah:
	call 03710h		;3cca	cd 10 37 	. . 7 
	pop de			;3ccd	d1 	. 
	jp WrDE_ByTargAddr		;3cce	c3 23 34 	. # 4 
	call GetLexem		;3cd1	cd c3 2f 	. . / 
l3cd4h:
	call l3777h		;3cd4	cd 77 37 	. w 7 
	cp 010h		;3cd7	fe 10 	. . 
	jp z,GetLexem		;3cd9	ca c3 2f 	. . / 
	call ChkSemi_GetLex		;3cdc	cd d9 32 	. . 2 
	jr l3cd4h		;3cdf	18 f3 	. . 
l3ce1h:
	pop af			;3ce1	f1 	. 
	ld e,039h		;3ce2	1e 39 	. 9 
	jp CompileErr		;3ce4	c3 3a 2f 	. : / 
sub_3ce7h:
	call GetLexem		;3ce7	cd c3 2f 	. . / 
	ld e,038h		;3cea	1e 38 	. 8 
	call sub_5027h		;3cec	cd 27 50 	. ' P 
	exx			;3cef	d9 	. 
	dec hl			;3cf0	2b 	+ 
	exx			;3cf1	d9 	. 
	call JCodeNextByte		;3cf2	cd d1 06 	. . . 
	defb 022h		;3cf5	22 	" 
	ld de,00005h		;3cf6	11 05 00 	. . . 
	add hl,de			;3cf9	19 	. 
	ex de,hl			;3cfa	eb 	. 
	call StoreDE		;3cfb	cd 0c 34 	. . 4 
	call JCodeNextByte		;3cfe	cd d1 06 	. . . 
	defb 0c3h		;3d01	c3 	. 
	ld de,00004h		;3d02	11 04 00 	. . . 
	add hl,de			;3d05	19 	. 
	ex de,hl			;3d06	eb 	. 
	call StoreDE		;3d07	cd 0c 34 	. . 4 
	exx			;3d0a	d9 	. 
	inc hl			;3d0b	23 	# 
	inc hl			;3d0c	23 	# 
	exx			;3d0d	d9 	. 
	push af			;3d0e	f5 	. 
	ld a,b			;3d0f	78 	x 
	cp 003h		;3d10	fe 03 	. . 
	jr c,l3ce1h		;3d12	38 cd 	8 . 
	inc bc			;3d14	03 	. 
	ld a,(bc)			;3d15	0a 	. 
	dec bc			;3d16	0b 	. 
	or a			;3d17	b7 	. 
	jr z,l3ce1h		;3d18	28 c7 	( . 
	push bc			;3d1a	c5 	. 
	ld b,h			;3d1b	44 	D 
	ld c,l			;3d1c	4d 	M 
	pop hl			;3d1d	e1 	. 
	push hl			;3d1e	e5 	. 
	call sub_3d41h		;3d1f	cd 41 3d 	. A = 
	pop hl			;3d22	e1 	. 
	pop af			;3d23	f1 	. 
	push hl			;3d24	e5 	. 
	cp 0ach		;3d25	fe ac 	. . 
	jr z,l3d3ch		;3d27	28 13 	( . 
	ld de,l1110h		;3d29	11 10 11 	. . . 
	call ChkLexem_GetLex		;3d2c	cd 08 33 	. . 3 
	call l3777h		;3d2f	cd 77 37 	. w 7 
l3d32h:
	pop hl			;3d32	e1 	. 
	ld bc,00000h		;3d33	01 00 00 	. . . 
	push af			;3d36	f5 	. 
	call sub_3d41h		;3d37	cd 41 3d 	. A = 
	pop af			;3d3a	f1 	. 
	ret			;3d3b	c9 	. 
l3d3ch:
	call sub_3ce7h		;3d3c	cd e7 3c 	. . < 
	jr l3d32h		;3d3f	18 f1 	. . 
sub_3d41h:
	ld a,c			;3d41	79 	y 
	call sub_4d6dh		;3d42	cd 6d 4d 	. m M 
	ld c,a			;3d45	4f 	O 
	ld de,00008h		;3d46	11 08 00 	. . . 
	add hl,de			;3d49	19 	. 
	ld (hl),c			;3d4a	71 	q 
	inc hl			;3d4b	23 	# 
	ld (hl),b			;3d4c	70 	p 
	inc hl			;3d4d	23 	# 
	ld e,(hl)			;3d4e	5e 	^ 
	inc hl			;3d4f	23 	# 
	ld d,(hl)			;3d50	56 	V 
	ld a,d			;3d51	7a 	z 
	or e			;3d52	b3 	. 
	ret z			;3d53	c8 	. 
	ex de,hl			;3d54	eb 	. 
	jr sub_3d41h		;3d55	18 ea 	. . 
	call GetLexem		;3d57	cd c3 2f 	. . / 
	ld e,03ch		;3d5a	1e 3c 	. < 
	cp 07fh		;3d5c	fe 7f 	.  
	jp nz,CompileErr		;3d5e	c2 3a 2f 	. : / 
	call ChkLabelList__		;3d61	cd 7c 33 	. | 3 
	call JCodeNextByte		;3d64	cd d1 06 	. . . 
	defb 0c3h		;3d67	c3 	. 
	call StoreDE		;3d68	cd 0c 34 	. . 4 
	jp GetLexem		;3d6b	c3 c3 2f 	. . / 
	call GetLexem		;3d6e	cd c3 2f 	. . / 
	cp 0a8h		;3d71	fe a8 	. . 
	jr nz,l3d7bh		;3d73	20 06 	  . 
	call GetLexem		;3d75	cd c3 2f 	. . / 
	call sub_3d84h		;3d78	cd 84 3d 	. . = 
l3d7bh:
	ld hl,l3e3dh		;3d7b	21 3d 3e 	! = > 
	jp WCode		;3d7e	c3 cc 33 	. . 3 
	call NextChkOpBra_GetLex		;3d81	cd fd 32 	. . 2 
sub_3d84h:
	call sub_3f3fh		;3d84	cd 3f 3f 	. ? ? 
	dec b			;3d87	05 	. 
	inc b			;3d88	04 	. 
	jp nz,l3e15h		;3d89	c2 15 3e 	. . > 
	dec c			;3d8c	0d 	. 
	jr z,l3da1h		;3d8d	28 12 	( . 
	dec c			;3d8f	0d 	. 
	jp z,l3df7h		;3d90	ca f7 3d 	. . = 
	dec c			;3d93	0d 	. 
	jr z,l3dceh		;3d94	28 38 	( 8 
	dec c			;3d96	0d 	. 
	jp z,l3dd6h		;3d97	ca d6 3d 	. . = 
l3d9ah:
	ld e,013h		;3d9a	1e 13 	. . 
	call CompileErr		;3d9c	cd 3a 2f 	. : / 
	jr l3dedh		;3d9f	18 4c 	. L 
l3da1h:
	cp 0bah		;3da1	fe ba 	. . 
	ld hl,l3e41h		;3da3	21 41 3e 	! A > 
	jr nz,l3dc9h		;3da6	20 21 	  ! 
	call sub_3f0dh		;3da8	cd 0d 3f 	. . ? 
	ld hl,l3e48h		;3dab	21 48 3e 	! H > 
	cp 0bah		;3dae	fe ba 	. . 
	jr nz,l3dc9h		;3db0	20 17 	  . 
	call GetLexem		;3db2	cd c3 2f 	. . / 
	or a			;3db5	b7 	. 
	ld e,043h		;3db6	1e 43 	. C 
	call nz,CompileErr		;3db8	c4 3a 2f 	. : / 
	ld a,(curIdentifier)		;3dbb	3a 50 2b 	: P + 
	cp 0c8h		;3dbe	fe c8 	. . 
	call nz,CompileErr		;3dc0	c4 3a 2f 	. : / 
	call GetLexem		;3dc3	cd c3 2f 	. . / 
	ld hl,l3e4eh		;3dc6	21 4e 3e 	! N > 
l3dc9h:
	call sub_33c4h		;3dc9	cd c4 33 	. . 3 
	jr l3dedh		;3dcc	18 1f 	. . 
l3dceh:
	ld de,l3e6ch		;3dce	11 6c 3e 	. l > 
	ld hl,l3e73h		;3dd1	21 73 3e 	! s > 
	jr l3ddch		;3dd4	18 06 	. . 
l3dd6h:
	ld de,l3e5eh		;3dd6	11 5e 3e 	. ^ > 
	ld hl,l3e68h		;3dd9	21 68 3e 	! h > 
l3ddch:
	cp 0bah		;3ddc	fe ba 	. . 
	jr nz,l3dc9h		;3dde	20 e9 	  . 
	push hl			;3de0	e5 	. 
	push de			;3de1	d5 	. 
	call sub_3f0dh		;3de2	cd 0d 3f 	. . ? 
	pop hl			;3de5	e1 	. 
	call sub_33c4h		;3de6	cd c4 33 	. . 3 
	pop hl			;3de9	e1 	. 
l3deah:
	call WCode		;3dea	cd cc 33 	. . 3 
l3dedh:
	cp 0ach		;3ded	fe ac 	. . 
	jp nz,ChkCloBra_GetLex		;3def	c2 05 33 	. . 3 
	call GetLexem		;3df2	cd c3 2f 	. . / 
	jr sub_3d84h		;3df5	18 8d 	. . 
l3df7h:
	cp 0bah		;3df7	fe ba 	. . 
	jr nz,l3e0dh		;3df9	20 12 	  . 
	call sub_3f0dh		;3dfb	cd 0d 3f 	. . ? 
	cp 0bah		;3dfe	fe ba 	. . 
	ld hl,l3e77h		;3e00	21 77 3e 	! w > 
	jr nz,l3dc9h		;3e03	20 c4 	  . 
	call sub_3f0dh		;3e05	cd 0d 3f 	. . ? 
	ld hl,l3e82h		;3e08	21 82 3e 	! . > 
	jr l3dc9h		;3e0b	18 bc 	. . 
l3e0dh:
	ld hl,l3e7eh		;3e0d	21 7e 3e 	! ~ > 
	call l33beh		;3e10	cd be 33 	. . 3 
	jr l3dedh		;3e13	18 d8 	. . 
l3e15h:
	dec b			;3e15	05 	. 
	dec b			;3e16	05 	. 
	jp nz,l3d9ah		;3e17	c2 9a 3d 	. . = 
	cp 0bah		;3e1a	fe ba 	. . 
	jr nz,l3e35h		;3e1c	20 17 	  . 
	push bc			;3e1e	c5 	. 
	call sub_3f0dh		;3e1f	cd 0d 3f 	. . ? 
	pop de			;3e22	d1 	. 
	exx			;3e23	d9 	. 
	dec hl			;3e24	2b 	+ 
	exx			;3e25	d9 	. 
	call JCodeNextByte		;3e26	cd d1 06 	. . . 
	defb 03eh		;3e29	3e 	> 
	call l381ah		;3e2a	cd 1a 38 	. . 8 
	ld hl,l3e53h		;3e2d	21 53 3e 	! S > 
	call WCode		;3e30	cd cc 33 	. . 3 
	jr l3e38h		;3e33	18 03 	. . 
l3e35h:
	call sub_343dh		;3e35	cd 3d 34 	. = 4 
l3e38h:
	ld hl,l3e5ah		;3e38	21 5a 3e 	! Z > 
	jr l3deah		;3e3b	18 ad 	. . 
l3e3dh:
	inc bc			;3e3d	03 	. 
	call PrNL		;3e3e	cd 85 08 	. . . 
l3e41h:
	ld b,0cdh		;3e41	06 cd 	. . 
	ld (hl),008h		;3e43	36 08 	6 . 
	call PrSpace		;3e45	cd 89 08 	. . . 
l3e48h:
	dec b			;3e48	05 	. 
	ld a,l			;3e49	7d 	} 
	pop hl			;3e4a	e1 	. 
	call PrDez		;3e4b	cd 0a 08 	. . . 
l3e4eh:
	inc b			;3e4e	04 	. 
l3e4fh:
	pop de			;3e4f	d1 	. 
	call PrHex		;3e50	cd aa 08 	. . . 
l3e53h:
	ld b,04fh		;3e53	06 4f 	. O 
	call PrFillSpc		;3e55	cd 7a 08 	. z . 
	pop hl			;3e58	e1 	. 
	ld b,c			;3e59	41 	A 
l3e5ah:
	inc bc			;3e5a	03 	. 
	call OutNStr		;3e5b	cd 8e 08 	. . . 
l3e5eh:
	add hl,bc			;3e5e	09 	. 
	ld a,005h		;3e5f	3e 05 	> . 
	pop bc			;3e61	c1 	. 
	push bc			;3e62	c5 	. 
	sub b			;3e63	90 	. 
	call PrFillSpc		;3e64	cd 7a 08 	. z . 
	pop af			;3e67	f1 	. 
l3e68h:
	inc bc			;3e68	03 	. 
	call PrBool		;3e69	cd 96 08 	. . . 
l3e6ch:
	ld b,03eh		;3e6c	06 3e 	. > 
	ld bc,07acdh		;3e6e	01 cd 7a 	. . z 
	ex af,af'			;3e71	08 	. 
	pop af			;3e72	f1 	. 
l3e73h:
	inc bc			;3e73	03 	. 
	call OutChr		;3e74	cd 29 07 	. ) . 
l3e77h:
	ld b,07dh		;3e77	06 7d 	. } 
	pop de			;3e79	d1 	. 
	pop hl			;3e7a	e1 	. 
	call l106fh		;3e7b	cd 6f 10 	. o . 
l3e7eh:
	inc bc			;3e7e	03 	. 
	call l1074h		;3e7f	cd 74 10 	. t . 
l3e82h:
	inc b			;3e82	04 	. 
	pop de			;3e83	d1 	. 
	call sub_0f6eh		;3e84	cd 6e 0f 	. n . 
sub_3e87h:
	or a			;3e87	b7 	. 
	ld e,01ah		;3e88	1e 1a 	. . 
	jp nz,CompileErr		;3e8a	c2 3a 2f 	. : / 
	call GetIdentInfoInABC		;3e8d	cd 50 33 	. P 3 
	ld e,01ah		;3e90	1e 1a 	. . 
	jp sub_4e7dh		;3e92	c3 7d 4e 	. } N 
	call NextChkOpBra_GetLex		;3e95	cd fd 32 	. . 2 
l3e98h:
	call sub_3e87h		;3e98	cd 87 3e 	. . > 
	push af			;3e9b	f5 	. 
	push hl			;3e9c	e5 	. 
	push de			;3e9d	d5 	. 
	xor a			;3e9e	af 	. 
	cp b			;3e9f	b8 	. 
	jr nz,l3ed3h		;3ea0	20 31 	  1 
	ld a,c			;3ea2	79 	y 
	dec a			;3ea3	3d 	= 
	jr z,l3ec1h		;3ea4	28 1b 	( . 
	dec a			;3ea6	3d 	= 
	jr z,l3ec9h		;3ea7	28 20 	(   
	dec a			;3ea9	3d 	= 
	jr z,l3eceh		;3eaa	28 22 	( " 
l3each:
	ld e,01dh		;3eac	1e 1d 	. . 
	call CompileErr		;3eae	cd 3a 2f 	. : / 
l3eb1h:
	pop hl			;3eb1	e1 	. 
	pop de			;3eb2	d1 	. 
	pop af			;3eb3	f1 	. 
	call l37bbh		;3eb4	cd bb 37 	. . 7 
l3eb7h:
	cp 0ach		;3eb7	fe ac 	. . 
	jp nz,ChkCloBra_GetLex		;3eb9	c2 05 33 	. . 3 
sub_3ebch:
	call GetLexem		;3ebc	cd c3 2f 	. . / 
	jr l3e98h		;3ebf	18 d7 	. . 
l3ec1h:
	ld hl,l3ef9h		;3ec1	21 f9 3e 	! . > 
l3ec4h:
	call WCode		;3ec4	cd cc 33 	. . 3 
	jr l3eb1h		;3ec7	18 e8 	. . 
l3ec9h:
	ld hl,l3f07h		;3ec9	21 07 3f 	! . ? 
	jr l3ec4h		;3ecc	18 f6 	. . 
l3eceh:
	ld hl,l3efeh		;3ece	21 fe 3e 	! . > 
	jr l3ec4h		;3ed1	18 f1 	. . 
l3ed3h:
	dec b			;3ed3	05 	. 
	dec b			;3ed4	05 	. 
	jr nz,l3each		;3ed5	20 d5 	  . 
	call sub_343dh		;3ed7	cd 3d 34 	. = 4 
	ld hl,l3f03h		;3eda	21 03 3f 	! . ? 
	call WCode		;3edd	cd cc 33 	. . 3 
	pop de			;3ee0	d1 	. 
	pop hl			;3ee1	e1 	. 
	pop af			;3ee2	f1 	. 
	jr l3eb7h		;3ee3	18 d2 	. . 
	call GetLexem		;3ee5	cd c3 2f 	. . / 
	cp 0a8h		;3ee8	fe a8 	. . 
	jr nz,l3eefh		;3eea	20 03 	  . 
	call sub_3ebch		;3eec	cd bc 3e 	. . > 
l3eefh:
	ld hl,l3ef5h		;3eef	21 f5 3e 	! . > 
	jp WCode		;3ef2	c3 cc 33 	. . 3 
l3ef5h:
	inc bc			;3ef5	03 	. 
	call l0aa2h		;3ef6	cd a2 0a 	. . . 
l3ef9h:
	inc b			;3ef9	04 	. 
	call sub_0bb3h		;3efa	cd b3 0b 	. . . 
	push hl			;3efd	e5 	. 
l3efeh:
	inc b			;3efe	04 	. 
	call JReadEditIBuf__		;3eff	cd ce 06 	. . . 
	push af			;3f02	f5 	. 
l3f03h:
	inc bc			;3f03	03 	. 
	call l0bd4h		;3f04	cd d4 0b 	. . . 
l3f07h:
	dec b			;3f07	05 	. 
	call sub_11b1h		;3f08	cd b1 11 	. . . 
	push hl			;3f0b	e5 	. 
	push de			;3f0c	d5 	. 
sub_3f0dh:
	call GetLexem		;3f0d	cd c3 2f 	. . / 
sub_3f10h:
	ld bc,00001h		;3f10	01 01 00 	. . . 
sub_3f13h:
	push bc			;3f13	c5 	. 
	jr l3f24h		;3f14	18 0e 	. . 
sub_3f16h:
	ld hl,(l2b89h)		;3f16	2a 89 2b 	* . + 
	dec h			;3f19	25 	% 
	push hl			;3f1a	e5 	. 
	call sub_3f3fh		;3f1b	cd 3f 3f 	. ? ? 
	exx			;3f1e	d9 	. 
	dec hl			;3f1f	2b 	+ 
	exx			;3f20	d9 	. 
	jr l3f2dh		;3f21	18 0a 	. . 
sub_3f23h:
	push hl			;3f23	e5 	. 
l3f24h:
	call sub_3f3fh		;3f24	cd 3f 3f 	. ? ? 
	jr l3f2dh		;3f27	18 04 	. . 
sub_3f29h:
	push bc			;3f29	c5 	. 
	call sub_3f31h		;3f2a	cd 31 3f 	. 1 ? 
l3f2dh:
	pop de			;3f2d	d1 	. 
	jp ChkType__		;3f2e	c3 ba 32 	. . 2 
sub_3f31h:
	ld hl,00002h		;3f31	21 02 00 	! . . 
	or a			;3f34	b7 	. 
	sbc hl,bc		;3f35	ed 42 	. B 
	jr nz,sub_3f3fh		;3f37	20 06 	  . 
	set 0,(ix+001h)		;3f39	dd cb 01 c6 	. . . . 
	jr l3f43h		;3f3d	18 04 	. . 
sub_3f3fh:
	res 0,(ix+001h)		;3f3f	dd cb 01 86 	. . . . 
l3f43h:
	call sub_4075h		;3f43	cd 75 40 	. u @ 
	cp 020h		;3f46	fe 20 	.   
	jp z,l3febh		;3f48	ca eb 3f 	. . ? 
	cp 077h		;3f4b	fe 77 	. w 
	ret c			;3f4d	d8 	. 
	cp 07dh		;3f4e	fe 7d 	. } 
	ret nc			;3f50	d0 	. 
	add a,a			;3f51	87 	. 
	ld l,a			;3f52	6f 	o 
	ld h,000h		;3f53	26 00 	& . 
	push hl			;3f55	e5 	. 
	push bc			;3f56	c5 	. 
	call sub_4072h		;3f57	cd 72 40 	. r @ 
	ld e,a			;3f5a	5f 	_ 
	ld a,b			;3f5b	78 	x 
	or a			;3f5c	b7 	. 
	jr nz,l3f9eh		;3f5d	20 3f 	  ? 
	ld a,c			;3f5f	79 	y 
	dec a			;3f60	3d 	= 
	jr z,l3f8bh		;3f61	28 28 	( ( 
	dec a			;3f63	3d 	= 
	ld a,e			;3f64	7b 	{ 
	jr nz,l3f82h		;3f65	20 1b 	  . 
	pop bc			;3f67	c1 	. 
	call PCVChkNum		;3f68	cd e6 34 	. . 4 
	exx			;3f6b	d9 	. 
	dec hl			;3f6c	2b 	+ 
	exx			;3f6d	d9 	. 
	bit 0,c		;3f6e	cb 41 	. A 
	jr z,l3f78h		;3f70	28 06 	( . 
	ld hl,l4184h		;3f72	21 84 41 	! . A 
	call sub_33c4h		;3f75	cd c4 33 	. . 3 
l3f78h:
	ld bc,l360ah		;3f78	01 0a 36 	. . 6 
l3f7bh:
	pop hl			;3f7b	e1 	. 
	call sub_401ch		;3f7c	cd 1c 40 	. . @ 
	jp sub_33c4h		;3f7f	c3 c4 33 	. . 3 
l3f82h:
	pop de			;3f82	d1 	. 
	call ChkType__		;3f83	cd ba 32 	. . 2 
	ld bc,l35f2h		;3f86	01 f2 35 	. . 5 
	jr l3f7bh		;3f89	18 f0 	. . 
l3f8bh:
	ld a,e			;3f8b	7b 	{ 
	pop de			;3f8c	d1 	. 
	call ChkType__		;3f8d	cd ba 32 	. . 2 
	bit 4,(ix+000h)		;3f90	dd cb 00 66 	. . . f 
	ld bc,035dah		;3f94	01 da 35 	. . 5 
	jr z,l3f7bh		;3f97	28 e2 	( . 
	ld bc,035e6h		;3f99	01 e6 35 	. . 5 
	jr l3f7bh		;3f9c	18 dd 	. . 
l3f9eh:
	ld a,e			;3f9e	7b 	{ 
	pop de			;3f9f	d1 	. 
	call ChkType__		;3fa0	cd ba 32 	. . 2 
	bit 7,d		;3fa3	cb 7a 	. z 
	jr nz,l3fdbh		;3fa5	20 34 	  4 
	dec d			;3fa7	15 	. 
	jr z,l3fbbh		;3fa8	28 11 	( . 
	dec d			;3faa	15 	. 
	jr nz,l3fd0h		;3fab	20 23 	  # 
	call sub_343dh		;3fad	cd 3d 34 	. = 4 
	ld hl,l35e8h		;3fb0	21 e8 35 	! . 5 
	call WCode		;3fb3	cd cc 33 	. . 3 
	ld bc,035feh		;3fb6	01 fe 35 	. . 5 
	jr l3f7bh		;3fb9	18 c0 	. . 
l3fbbh:
	pop hl			;3fbb	e1 	. 
	ld e,a			;3fbc	5f 	_ 
	ld a,l			;3fbd	7d 	} 
	cp 0f2h		;3fbe	fe f2 	. . 
	jr z,l3fd6h		;3fc0	28 14 	( . 
	cp 0f4h		;3fc2	fe f4 	. . 
	ld a,e			;3fc4	7b 	{ 
	jr z,l3fd7h		;3fc5	28 10 	( . 
	ld bc,l3616h		;3fc7	01 16 36 	. . 6 
	call sub_401ch		;3fca	cd 1c 40 	. . @ 
	jp CodeLdBC_0n_from_0x2b8b		;3fcd	c3 aa 33 	. . 3 
l3fd0h:
	ld e,01bh		;3fd0	1e 1b 	. . 
l3fd2h:
	pop hl			;3fd2	e1 	. 
l3fd3h:
	jp CompileErr		;3fd3	c3 3a 2f 	. : / 
l3fd6h:
	ld a,e			;3fd6	7b 	{ 
l3fd7h:
	ld e,031h		;3fd7	1e 31 	. 1 
	jr l3fd3h		;3fd9	18 f8 	. . 
l3fdbh:
	ld e,a			;3fdb	5f 	_ 
	pop hl			;3fdc	e1 	. 
	push hl			;3fdd	e5 	. 
	ld a,l			;3fde	7d 	} 
	cp 0f2h		;3fdf	fe f2 	. . 
	ld bc,035dah		;3fe1	01 da 35 	. . 5 
	ld a,e			;3fe4	7b 	{ 
	jr c,l3f7bh		;3fe5	38 94 	8 . 
	ld e,040h		;3fe7	1e 40 	. @ 
	jr l3fd2h		;3fe9	18 e7 	. . 
l3febh:
	call sub_46bfh		;3feb	cd bf 46 	. . F 
	exx			;3fee	d9 	. 
	dec hl			;3fef	2b 	+ 
	exx			;3ff0	d9 	. 
	jr c,l3ff7h		;3ff1	38 04 	8 . 
	call JCodeNextByte		;3ff3	cd d1 06 	. . . 
	defb 07dh		;3ff6	7d 	} 
l3ff7h:
	ld hl,l4026h		;3ff7	21 26 40 	! & @ 
	call WCode		;3ffa	cd cc 33 	. . 3 
	push bc			;3ffd	c5 	. 
	call sub_4072h		;3ffe	cd 72 40 	. r @ 
	pop de			;4001	d1 	. 
	call ChkType__		;4002	cd ba 32 	. . 2 
	ld hl,l402ah		;4005	21 2a 40 	! * @ 
	call WCode		;4008	cd cc 33 	. . 3 
	ld c,a			;400b	4f 	O 
	ld hl,(l2b8bh)		;400c	2a 8b 2b 	* . + 
	ld h,000h		;400f	26 00 	& . 
	inc l			;4011	2c 	, 
	call sub_4037h		;4012	cd 37 40 	. 7 @ 
	ld a,c			;4015	79 	y 
	call JCodeNextByte		;4016	cd d1 06 	. . . 
	defb 0f5h		;4019	f5 	. 
	jr l4022h		;401a	18 06 	. . 
sub_401ch:
	add hl,bc			;401c	09 	. 
	ld e,(hl)			;401d	5e 	^ 
	inc hl			;401e	23 	# 
	ld d,(hl)			;401f	56 	V 
	inc hl			;4020	23 	# 
	ex de,hl			;4021	eb 	. 
l4022h:
	ld bc,00004h		;4022	01 04 00 	. . . 
	ret			;4025	c9 	. 
l4026h:
	inc bc			;4026	03 	. 
	ld (l1798h),a		;4027	32 98 17 	2 . . 
l402ah:
	inc c			;402a	0c 	. 
	ld a,(l1798h)		;402b	3a 98 17 	: . . 
	call sub_0be9h		;402e	cd e9 0b 	. . . 
	and (hl)			;4031	a6 	. 
	neg		;4032	ed 44 	. D 
	ld a,000h		;4034	3e 00 	> . 
	rla			;4036	17 	. 
sub_4037h:
	ld a,h			;4037	7c 	| 
	or a			;4038	b7 	. 
	jr nz,l4051h		;4039	20 16 	  . 
	ld a,l			;403b	7d 	} 
	cp 006h		;403c	fe 06 	. . 
	jr nc,l4051h		;403e	30 11 	0 . 
	srl a		;4040	cb 3f 	. ? 
	jr nc,l4049h		;4042	30 05 	0 . 
	call JCodeNextByte		;4044	cd d1 06 	. . . 
	defb 033h		;4047	33 	3 
	or a			;4048	b7 	. 
l4049h:
	ret z			;4049	c8 	. 
	call JCodeNextByte		;404a	cd d1 06 	. . . 
	defb 0e1h		;404d	e1 	. 
	dec a			;404e	3d 	= 
	jr l4049h		;404f	18 f8 	. . 
l4051h:
	call sub_3407h		;4051	cd 07 34 	. . 4 
	call JCodeNextByte		;4054	cd d1 06 	. . . 
	defb 039h		;4057	39 	9 
	call JCodeNextByte		;4058	cd d1 06 	. . . 
	defb 0f9h		;405b	f9 	. 
	ret			;405c	c9 	. 
l405dh:
	call sub_41d2h		;405d	cd d2 41 	. . A 
	call PCVChkNum		;4060	cd e6 34 	. . 4 
	bit 0,c		;4063	cb 41 	. A 
	ld hl,l414bh		;4065	21 4b 41 	! K A 
	jr nz,l40a0h		;4068	20 36 	  6 
	ld hl,l4150h		;406a	21 50 41 	! P A 
	call l33beh		;406d	cd be 33 	. . 3 
	jr l4089h		;4070	18 17 	. . 
sub_4072h:
	call GetLexem		;4072	cd c3 2f 	. . / 
sub_4075h:
	cp 0adh		;4075	fe ad 	. . 
	jp z,l405dh		;4077	ca 5d 40 	. ] @ 
	cp 0abh		;407a	fe ab 	. . 
	jr nz,l4086h		;407c	20 08 	  . 
	call sub_41d2h		;407e	cd d2 41 	. . A 
	call PCVChkNum		;4081	cd e6 34 	. . 4 
	jr l4089h		;4084	18 03 	. . 
l4086h:
	call sub_41d5h		;4086	cd d5 41 	. . A 
l4089h:
	cp 0abh		;4089	fe ab 	. . 
	jr z,l40a5h		;408b	28 18 	( . 
	cp 0adh		;408d	fe ad 	. . 
	jr z,l40a5h		;408f	28 14 	( . 
	cp 007h		;4091	fe 07 	. . 
	ret nz			;4093	c0 	. 
	call sub_32b2h		;4094	cd b2 32 	. . 2 
	call sub_41d2h		;4097	cd d2 41 	. . A 
	call sub_32b2h		;409a	cd b2 32 	. . 2 
	ld hl,l416fh		;409d	21 6f 41 	! o A 
l40a0h:
	call sub_33c4h		;40a0	cd c4 33 	. . 3 
	jr l4089h		;40a3	18 e4 	. . 
l40a5h:
	dec b			;40a5	05 	. 
	jp z,l411ch		;40a6	ca 1c 41 	. . A 
	inc b			;40a9	04 	. 
	call PCVChkNum		;40aa	cd e6 34 	. . 4 
	ld b,a			;40ad	47 	G 
	push bc			;40ae	c5 	. 
	call sub_41d2h		;40af	cd d2 41 	. . A 
	call PCVChkNum		;40b2	cd e6 34 	. . 4 
	bit 0,c		;40b5	cb 41 	. A 
	pop bc			;40b7	c1 	. 
	jr nz,l40ddh		;40b8	20 23 	  # 
	exx			;40ba	d9 	. 
	dec hl			;40bb	2b 	+ 
	dec hl			;40bc	2b 	+ 
	exx			;40bd	d9 	. 
	bit 2,b		;40be	cb 50 	. P 
	jr z,l40c8h		;40c0	28 06 	( . 
	ld hl,l4173h		;40c2	21 73 41 	! s A 
	call WCode		;40c5	cd cc 33 	. . 3 
l40c8h:
	bit 0,c		;40c8	cb 41 	. A 
	jr z,l40d2h		;40ca	28 06 	( . 
	ld hl,l417eh		;40cc	21 7e 41 	! ~ A 
	call WCode		;40cf	cd cc 33 	. . 3 
l40d2h:
	ld hl,l4188h		;40d2	21 88 41 	! . A 
	ld bc,00002h		;40d5	01 02 00 	. . . 
	call WCode		;40d8	cd cc 33 	. . 3 
	jr l4089h		;40db	18 ac 	. . 
l40ddh:
	push af			;40dd	f5 	. 
	xor a			;40de	af 	. 
	call sub_41bbh		;40df	cd bb 41 	. . A 
	jr z,l40feh		;40e2	28 1a 	( . 
	bit 2,b		;40e4	cb 50 	. P 
	jr z,l40edh		;40e6	28 05 	( . 
	ex de,hl			;40e8	eb 	. 
	ld l,a			;40e9	6f 	o 
	ld h,a			;40ea	67 	g 
	sbc hl,de		;40eb	ed 52 	. R 
l40edh:
	bit 1,(ix+000h)		;40ed	dd cb 00 4e 	. . . N 
	call sub_418eh		;40f1	cd 8e 41 	. . A 
l40f4h:
	pop af			;40f4	f1 	. 
	call JCodeNextByte		;40f5	cd d1 06 	. . . 
	defb 0e5h		;40f8	e5 	. 
	ld bc,00001h		;40f9	01 01 00 	. . . 
	jr l4089h		;40fc	18 8b 	. . 
l40feh:
	bit 2,b		;40fe	cb 50 	. P 
	jr nz,l410bh		;4100	20 09 	  . 
	bit 1,(ix+000h)		;4102	dd cb 00 4e 	. . . N 
	call sub_41b0h		;4106	cd b0 41 	. . A 
	jr l40f4h		;4109	18 e9 	. . 
l410bh:
	bit 1,(ix+000h)		;410b	dd cb 00 4e 	. . . N 
	ld hl,l4162h		;410f	21 62 41 	! b A 
	jr nz,l4117h		;4112	20 03 	  . 
	ld hl,l416ah		;4114	21 6a 41 	! j A 
l4117h:
	call WCode		;4117	cd cc 33 	. . 3 
	jr l40f4h		;411a	18 d8 	. . 
l411ch:
	push af			;411c	f5 	. 
	inc b			;411d	04 	. 
	push bc			;411e	c5 	. 
	call sub_41d2h		;411f	cd d2 41 	. . A 
	pop de			;4122	d1 	. 
	call ChkType__		;4123	cd ba 32 	. . 2 
	pop de			;4126	d1 	. 
	bit 2,d		;4127	cb 52 	. R 
	ld hl,CSq_StorNotDEAndM		;4129	21 41 41 	! A A 
	jr nz,A_was_0xad_this_is_not_0xab		;412c	20 03 	  . 
	ld hl,CSq_StorOrM		;412e	21 37 41 	! 7 A 
A_was_0xad_this_is_not_0xab:
	call CodeLdBC_0n_from_0x2b8b		;4131	cd aa 33 	. . 3 
	jp l4089h		;4134	c3 89 40 	. . @ 
CSq_StorOrM:
	defb 009h		;4137	09 	. 
	ld hl,000b6h		;4138	21 b6 00 	! . . 
	ld (opCodes),hl		;413b	22 33 0c 	" 3 . 
	call MaskBytes__		;413e	cd 26 0c 	. & . 
CSq_StorNotDEAndM:
	defb 009h		;4141	09 	. 
	ld hl,0a62fh		;4142	21 2f a6 	! / . 
	ld (opCodes),hl		;4145	22 33 0c 	" 3 . 
	call MaskBytes__		;4148	cd 26 0c 	. & . 
l414bh:
	inc b			;414b	04 	. 
l414ch:
	call NegHL		;414c	cd 11 0a 	. . . 
	push hl			;414f	e5 	. 
l4150h:
	ld a,(bc)			;4150	0a 	. 
	bit 6,h		;4151	cb 74 	. t 
	jr z,l4159h		;4153	28 04 	( . 
	ld a,080h		;4155	3e 80 	> . 
	xor h			;4157	ac 	. 
	ld h,a			;4158	67 	g 
l4159h:
	push hl			;4159	e5 	. 
	push de			;415a	d5 	. 
l415bh:
	ld b,0b7h		;415b	06 b7 	. . 
	adc hl,de		;415d	ed 5a 	. Z 
	call pe,ErrOverflow		;415f	ec f2 08 	. . . 
l4162h:
	rlca			;4162	07 	. 
	ex de,hl			;4163	eb 	. 
	or a			;4164	b7 	. 
	sbc hl,de		;4165	ed 52 	. R 
	call pe,ErrOverflow		;4167	ec f2 08 	. . . 
l416ah:
	inc b			;416a	04 	. 
	ex de,hl			;416b	eb 	. 
	or a			;416c	b7 	. 
	sbc hl,de		;416d	ed 52 	. R 
l416fh:
	inc bc			;416f	03 	. 
	pop bc			;4170	c1 	. 
	or b			;4171	b0 	. 
	push af			;4172	f5 	. 
l4173h:
	inc b			;4173	04 	. 
	ld a,080h		;4174	3e 80 	> . 
	xor h			;4176	ac 	. 
	ld h,a			;4177	67 	g 
l4178h:
	dec b			;4178	05 	. 
	call sub_0e45h		;4179	cd 45 0e 	. E . 
	push hl			;417c	e5 	. 
	push de			;417d	d5 	. 
l417eh:
	dec b			;417e	05 	. 
	ex (sp),hl			;417f	e3 	. 
	push de			;4180	d5 	. 
	call sub_0e45h		;4181	cd 45 0e 	. E . 
l4184h:
	inc bc			;4184	03 	. 
	call sub_0e45h		;4185	cd 45 0e 	. E . 
l4188h:
	dec b			;4188	05 	. 
	call sub_0ca1h		;4189	cd a1 0c 	. . . 
	push hl			;418c	e5 	. 
	push de			;418d	d5 	. 
sub_418eh:
	push af			;418e	f5 	. 
	ld a,h			;418f	7c 	| 
	or a			;4190	b7 	. 
	jr nz,l41a4h		;4191	20 11 	  . 
	ld a,l			;4193	7d 	} 
	ld e,023h		;4194	1e 23 	. # 
l4196h:
	cp 005h		;4196	fe 05 	. . 
	jr nc,l41ach		;4198	30 12 	0 . 
	pop bc			;419a	c1 	. 
	or a			;419b	b7 	. 
	ret z			;419c	c8 	. 
	ld b,a			;419d	47 	G 
l419eh:
	call l381ah		;419e	cd 1a 38 	. . 8 
	djnz l419eh		;41a1	10 fb 	. . 
l41a3h:
	ret			;41a3	c9 	. 
l41a4h:
	inc a			;41a4	3c 	< 
	jr nz,l41ach		;41a5	20 05 	  . 
	sub l			;41a7	95 	. 
	ld e,02bh		;41a8	1e 2b 	. + 
	jr nz,l4196h		;41aa	20 ea 	  . 
l41ach:
	call sub_33fah		;41ac	cd fa 33 	. . 3 
	pop af			;41af	f1 	. 
sub_41b0h:
	ld hl,l415bh		;41b0	21 5b 41 	! [ A 
	jp nz,WCode		;41b3	c2 cc 33 	. . 3 
	call JCodeNextByte		;41b6	cd d1 06 	. . . 
	defb 019h		;41b9	19 	. 
	ret			;41ba	c9 	. 
sub_41bbh:
	bit 3,(ix+002h)		;41bb	dd cb 02 5e 	. . . ^ 
sub_41bfh:
	exx			;41bf	d9 	. 
	dec hl			;41c0	2b 	+ 
	jr z,l41cdh		;41c1	28 0a 	( . 
	dec hl			;41c3	2b 	+ 
	ld d,(hl)			;41c4	56 	V 
	dec hl			;41c5	2b 	+ 
	ld e,(hl)			;41c6	5e 	^ 
	dec hl			;41c7	2b 	+ 
	dec hl			;41c8	2b 	+ 
	push de			;41c9	d5 	. 
	exx			;41ca	d9 	. 
	pop hl			;41cb	e1 	. 
	ret			;41cc	c9 	. 
l41cdh:
	ld (hl),0d1h		;41cd	36 d1 	6 . 
	inc hl			;41cf	23 	# 
	exx			;41d0	d9 	. 
	ret			;41d1	c9 	. 
sub_41d2h:
	call GetLexem		;41d2	cd c3 2f 	. . / 
sub_41d5h:
	call sub_43b8h		;41d5	cd b8 43 	. . C 
l41d8h:
	cp 0aah		;41d8	fe aa 	. . 
	jr z,l424ah		;41da	28 6e 	( n 
	cp 002h		;41dc	fe 02 	. . 
	jr z,l41fch		;41de	28 1c 	( . 
	cp 009h		;41e0	fe 09 	. . 
	jr z,l41fch		;41e2	28 18 	( . 
	cp 0afh		;41e4	fe af 	. . 
	jr z,l422bh		;41e6	28 43 	( C 
	cp 008h		;41e8	fe 08 	. . 
	ret nz			;41ea	c0 	. 
	call sub_32b2h		;41eb	cd b2 32 	. . 2 
	call sub_43b5h		;41ee	cd b5 43 	. . C 
	call sub_32b2h		;41f1	cd b2 32 	. . 2 
	ld hl,l42edh		;41f4	21 ed 42 	! . B 
	call sub_33c4h		;41f7	cd c4 33 	. . 3 
	jr l41d8h		;41fa	18 dc 	. . 
l41fch:
	call sub_32b7h		;41fc	cd b7 32 	. . 2 
	push af			;41ff	f5 	. 
	call sub_43b5h		;4200	cd b5 43 	. . C 
	call sub_32b7h		;4203	cd b7 32 	. . 2 
	call sub_41bbh		;4206	cd bb 41 	. . A 
	jr z,l4213h		;4209	28 08 	( . 
	ex de,hl			;420b	eb 	. 
	call JCodeNextByte		;420c	cd d1 06 	. . . 
	defb 0ebh		;420f	eb 	. 
	call WLdHLnnIsDE		;4210	cd 08 34 	. . 4 
l4213h:
	pop de			;4213	d1 	. 
	bit 0,d		;4214	cb 42 	. B 
	ld hl,l42e9h		;4216	21 e9 42 	! . B 
	jr nz,l421eh		;4219	20 03 	  . 
	ld hl,l42e4h		;421b	21 e4 42 	! . B 
l421eh:
	call WCode		;421e	cd cc 33 	. . 3 
l4221h:
	call JCodeNextByte		;4221	cd d1 06 	. . . 
	defb 0e5h		;4224	e5 	. 
	res 3,(ix+002h)		;4225	dd cb 02 9e 	. . . . 
	jr l41d8h		;4229	18 ad 	. . 
l422bh:
	call PCVChkNum		;422b	cd e6 34 	. . 4 
	bit 0,c		;422e	cb 41 	. A 
	jr z,l423ch		;4230	28 0a 	( . 
	ld hl,l4178h		;4232	21 78 41 	! x A 
	call sub_33c4h		;4235	cd c4 33 	. . 3 
	set 0,(ix+001h)		;4238	dd cb 01 c6 	. . . . 
l423ch:
	call sub_43b5h		;423c	cd b5 43 	. . C 
	call PCVChkNum		;423f	cd e6 34 	. . 4 
	ld hl,l42f1h		;4242	21 f1 42 	! . B 
	call l33beh		;4245	cd be 33 	. . 3 
	jr l41d8h		;4248	18 8e 	. . 
l424ah:
	push bc			;424a	c5 	. 
	dec b			;424b	05 	. 
	jr z,l4274h		;424c	28 26 	( & 
	inc b			;424e	04 	. 
	call PCVChkNum		;424f	cd e6 34 	. . 4 
	call sub_43b5h		;4252	cd b5 43 	. . C 
	call PCVChkNum		;4255	cd e6 34 	. . 4 
	bit 0,c		;4258	cb 41 	. A 
	pop de			;425a	d1 	. 
	jr nz,l4283h		;425b	20 26 	  & 
	exx			;425d	d9 	. 
	dec hl			;425e	2b 	+ 
	dec hl			;425f	2b 	+ 
	exx			;4260	d9 	. 
	bit 0,e		;4261	cb 43 	. C 
	jr z,l426bh		;4263	28 06 	( . 
	ld hl,l417eh		;4265	21 7e 41 	! ~ A 
	call WCode		;4268	cd cc 33 	. . 3 
l426bh:
	ld hl,l42f7h		;426b	21 f7 42 	! . B 
	call WCode		;426e	cd cc 33 	. . 3 
l4271h:
	jp l41d8h		;4271	c3 d8 41 	. . A 
l4274h:
	call sub_43b5h		;4274	cd b5 43 	. . C 
	pop de			;4277	d1 	. 
	call ChkType__		;4278	cd ba 32 	. . 2 
	ld hl,CSq_StorAndM		;427b	21 d6 42 	! . B 
	call CodeLdBC_0n_from_0x2b8b		;427e	cd aa 33 	. . 3 
	jr l4271h		;4281	18 ee 	. . 
l4283h:
	call sub_41bbh		;4283	cd bb 41 	. . A 
	ex de,hl			;4286	eb 	. 
	ld hl,l42e0h		;4287	21 e0 42 	! . B 
	jr z,l421eh		;428a	28 92 	( . 
	push af			;428c	f5 	. 
	push bc			;428d	c5 	. 
	call sub_4295h		;428e	cd 95 42 	. . B 
	pop bc			;4291	c1 	. 
	pop af			;4292	f1 	. 
	jr l4221h		;4293	18 8c 	. . 
sub_4295h:
	push hl			;4295	e5 	. 
	ld a,d			;4296	7a 	z 
	or a			;4297	b7 	. 
	jr nz,l42c6h		;4298	20 2c 	  , 
	ld a,e			;429a	7b 	{ 
	cp 011h		;429b	fe 11 	. . 
	jr nc,l42c6h		;429d	30 27 	0 ' 
	or a			;429f	b7 	. 
	jr z,l42c6h		;42a0	28 24 	( $ 
	cp 001h		;42a2	fe 01 	. . 
	pop hl			;42a4	e1 	. 
	ret z			;42a5	c8 	. 
	push hl			;42a6	e5 	. 
	exx			;42a7	d9 	. 
	push hl			;42a8	e5 	. 
	exx			;42a9	d9 	. 
	ld c,0feh		;42aa	0e fe 	. . 
l42ach:
	srl a		;42ac	cb 3f 	. ? 
	jr z,l42cdh		;42ae	28 1d 	( . 
	jr nc,l42bdh		;42b0	30 0b 	0 . 
	inc c			;42b2	0c 	. 
	jr z,l42c3h		;42b3	28 0e 	( . 
	call JCodeNextByte		;42b5	cd d1 06 	. . . 
	defb 054h		;42b8	54 	T 
	call JCodeNextByte		;42b9	cd d1 06 	. . . 
	defb 05dh		;42bc	5d 	] 
l42bdh:
	call JCodeNextByte		;42bd	cd d1 06 	. . . 
	defb 029h		;42c0	29 	) 
	jr l42ach		;42c1	18 e9 	. . 
l42c3h:
	exx			;42c3	d9 	. 
	pop hl			;42c4	e1 	. 
	exx			;42c5	d9 	. 
l42c6h:
	call sub_33fbh		;42c6	cd fb 33 	. . 3 
	pop hl			;42c9	e1 	. 
	jp WCode		;42ca	c3 cc 33 	. . 3 
l42cdh:
	pop hl			;42cd	e1 	. 
	pop hl			;42ce	e1 	. 
	inc c			;42cf	0c 	. 
	ret nz			;42d0	c0 	. 
	call JCodeNextByte		;42d1	cd d1 06 	. . . 
	defb 019h		;42d4	19 	. 
	ret			;42d5	c9 	. 
CSq_StorAndM:
	add hl,bc			;42d6	09 	. 
	ld hl,000a6h		;42d7	21 a6 00 	! . . 
	ld (opCodes),hl		;42da	22 33 0c 	" 3 . 
	call MaskBytes__		;42dd	cd 26 0c 	. & . 
l42e0h:
	inc bc			;42e0	03 	. 
	call Mul16x8sgn		;42e1	cd dc 09 	. . . 
l42e4h:
	inc b			;42e4	04 	. 
	call Div		;42e5	cd 19 0a 	. . . 
	ex de,hl			;42e8	eb 	. 
l42e9h:
	inc bc			;42e9	03 	. 
	call Div		;42ea	cd 19 0a 	. . . 
l42edh:
	inc bc			;42ed	03 	. 
	pop bc			;42ee	c1 	. 
	and b			;42ef	a0 	. 
	push af			;42f0	f5 	. 
l42f1h:
	dec b			;42f1	05 	. 
	call RealDiv__		;42f2	cd cd 0d 	. . . 
	push hl			;42f5	e5 	. 
	push de			;42f6	d5 	. 
l42f7h:
	dec b			;42f7	05 	. 
	call RealMul__		;42f8	cd 57 0d 	. W . 
	push hl			;42fb	e5 	. 
	push de			;42fc	d5 	. 
l42fdh:
	ld a,(l2b76h)		;42fd	3a 76 2b 	: v + 
	push af			;4300	f5 	. 
	push bc			;4301	c5 	. 
	ld e,(hl)			;4302	5e 	^ 
	inc hl			;4303	23 	# 
	ld d,(hl)			;4304	56 	V 
l4305h:
	push de			;4305	d5 	. 
	inc hl			;4306	23 	# 
	ld b,(hl)			;4307	46 	F 
	call GetLexem		;4308	cd c3 2f 	. . / 
	dec b			;430b	05 	. 
	jr z,l4323h		;430c	28 15 	( . 
	call ChkOpBra_GetLex		;430e	cd 00 33 	. . 3 
	jr l4316h		;4311	18 03 	. . 
l4313h:
	call ChkComma_GetLex		;4313	cd f8 32 	. . 2 
l4316h:
	push bc			;4316	c5 	. 
	call sub_3f10h		;4317	cd 10 3f 	. . ? 
	pop bc			;431a	c1 	. 
	djnz l4313h		;431b	10 f6 	. . 
	call ChkCloBra_GetLex		;431d	cd 05 33 	. . 3 
	exx			;4320	d9 	. 
	dec hl			;4321	2b 	+ 
	exx			;4322	d9 	. 
l4323h:
	pop hl			;4323	e1 	. 
	pop bc			;4324	c1 	. 
	pop de			;4325	d1 	. 
	ld (ix+001h),d		;4326	dd 72 01 	. r . 
	call WCode		;4329	cd cc 33 	. . 3 
	ld hl,00001h		;432c	21 01 00 	! . . 
	or a			;432f	b7 	. 
	sbc hl,bc		;4330	ed 42 	. B 
	ret nz			;4332	c0 	. 
	jp l45a0h		;4333	c3 a0 45 	. . E 
sub_4336h:
	ld a,(l2b76h)		;4336	3a 76 2b 	: v + 
	push af			;4339	f5 	. 
	call NextChkOpBra_GetLex		;433a	cd fd 32 	. . 2 
	call sub_3f3fh		;433d	cd 3f 3f 	. ? ? 
	call ChkScalar		;4340	cd 4b 35 	. K 5 
	call ChkCloBra_GetLex		;4343	cd 05 33 	. . 3 
	dec c			;4346	0d 	. 
	pop de			;4347	d1 	. 
	ld (ix+001h),d		;4348	dd 72 01 	. r . 
l434bh:
	ret			;434b	c9 	. 
	call sub_4336h		;434c	cd 36 43 	. 6 C 
	jr z,l4358h		;434f	28 07 	( . 
	ld hl,l4379h		;4351	21 79 43 	! y C 
	ld c,b			;4354	48 	H 
l4355h:
	call sub_33c4h		;4355	cd c4 33 	. . 3 
l4358h:
	jp l459fh		;4358	c3 9f 45 	. . E 
	call sub_4336h		;435b	cd 36 43 	. 6 C 
	jr z,l4367h		;435e	28 07 	( . 
	ld hl,l4381h		;4360	21 81 43 	! . C 
l4363h:
	inc c			;4363	0c 	. 
	jp sub_33c4h		;4364	c3 c4 33 	. . 3 
l4367h:
	ld hl,l4387h		;4367	21 87 43 	! . C 
	jr l4355h		;436a	18 e9 	. . 
	call sub_4336h		;436c	cd 36 43 	. 6 C 
	ld hl,l437eh		;436f	21 7e 43 	! ~ C 
	jr nz,l4363h		;4372	20 ef 	  . 
	ld hl,l4384h		;4374	21 84 43 	! . C 
	jr l4355h		;4377	18 dc 	. . 
l4379h:
	inc b			;4379	04 	. 
	ld l,a			;437a	6f 	o 
	ld h,000h		;437b	26 00 	& . 
	push hl			;437d	e5 	. 
l437eh:
	ld (bc),a			;437e	02 	. 
	inc a			;437f	3c 	< 
	push af			;4380	f5 	. 
l4381h:
	ld (bc),a			;4381	02 	. 
	dec a			;4382	3d 	= 
	push af			;4383	f5 	. 
l4384h:
	ld (bc),a			;4384	02 	. 
	inc hl			;4385	23 	# 
	push hl			;4386	e5 	. 
l4387h:
	ld (bc),a			;4387	02 	. 
	dec hl			;4388	2b 	+ 
	push hl			;4389	e5 	. 
	call NextChkOpBra_GetLex		;438a	cd fd 32 	. . 2 
l438dh:
	call ParseConstVal		;438d	cd 79 34 	. y 4 
	ld c,a			;4390	4f 	O 
	ld a,l			;4391	7d 	} 
	call StoreAToHL2		;4392	cd e3 33 	. . 3 
	ld a,c			;4395	79 	y 
	cp 0ach		;4396	fe ac 	. . 
	jp nz,ChkCloBra_GetLex		;4398	c2 05 33 	. . 3 
	call GetLexem		;439b	cd c3 2f 	. . / 
	jr l438dh		;439e	18 ed 	. . 
l43a0h:
	call sub_43b5h		;43a0	cd b5 43 	. . C 
	call sub_32b2h		;43a3	cd b2 32 	. . 2 
	ld hl,l4650h		;43a6	21 50 46 	! P F 
	jp sub_33c4h		;43a9	c3 c4 33 	. . 3 
l43ach:
	call GetLexem		;43ac	cd c3 2f 	. . / 
	call l3f43h		;43af	cd 43 3f 	. C ? 
	jp l4511h		;43b2	c3 11 45 	. . E 
sub_43b5h:
	call GetLexem		;43b5	cd c3 2f 	. . / 
sub_43b8h:
	res 3,(ix+002h)		;43b8	dd cb 02 9e 	. . . . 
	or a			;43bc	b7 	. 
	jr z,l440fh		;43bd	28 50 	( P 
	cp 076h		;43bf	fe 76 	. v 
	jr z,WLdChr		;43c1	28 31 	( 1 
	cp 075h		;43c3	fe 75 	. u 
	jr z,l43fch		;43c5	28 35 	( 5 
	cp 0a8h		;43c7	fe a8 	. . 
	jr z,l43ach		;43c9	28 e1 	( . 
	cp 0dbh		;43cb	fe db 	. . 
	jp z,l46edh		;43cd	ca ed 46 	. . F 
	cp 022h		;43d0	fe 22 	. " 
	jp z,l4467h		;43d2	ca 67 44 	. g D 
	set 3,(ix+002h)		;43d5	dd cb 02 de 	. . . . 
	cp 07fh		;43d9	fe 7f 	.  
	ld hl,(curRealHWord)		;43db	2a 5f 2b 	* _ + 
	jr z,l4446h		;43de	28 66 	( f 
	ld de,(curNum)		;43e0	ed 5b 5d 2b 	. [ ] + 
	cp 07eh		;43e4	fe 7e 	. ~ 
	jr z,l444fh		;43e6	28 67 	( g 
	cp 006h		;43e8	fe 06 	. . 
	jr z,l43a0h		;43ea	28 b4 	( . 
	ld e,00ch		;43ec	1e 0c 	. . 
	call CompileErr		;43ee	cd 3a 2f 	. : / 
	jp 0344bh		;43f1	c3 4b 34 	. K 4 
WLdChr:
	ld a,(curRealHWord)		;43f4	3a 5f 2b 	: _ + 
	ld bc,00003h		;43f7	01 03 00 	. . . 
	jr WLdChrInA		;43fa	18 33 	. 3 
l43fch:
	ld de,(curRealHWord)		;43fc	ed 5b 5f 2b 	. [ _ + 
	ld a,(curNum)		;4400	3a 5d 2b 	: ] + 
	ld c,a			;4403	4f 	O 
	ld b,002h		;4404	06 02 	. . 
l4406h:
	ld l,c			;4406	69 	i 
	ld h,000h		;4407	26 00 	& . 
	ld (Merker1),hl		;4409	22 87 2b 	" . + 
	jp WLdStrAddr		;440c	c3 72 44 	. r D 
l440fh:
	call GetIdentInfoInABC		;440f	cd 50 33 	. P 3 
	cp 001h		;4412	fe 01 	. . 
	ret m			;4414	f8 	. 
	jp nz,l44c7h		;4415	c2 c7 44 	. . D 
	set 3,(ix+002h)		;4418	dd cb 02 de 	. . . . 
	ld e,(hl)			;441c	5e 	^ 
	inc hl			;441d	23 	# 
	ld d,(hl)			;441e	56 	V 
	ld a,b			;441f	78 	x 
	or a			;4420	b7 	. 
	jr nz,l4406h		;4421	20 e3 	  . 
	ld a,c			;4423	79 	y 
	dec a			;4424	3d 	= 
	jr z,l4445h		;4425	28 1e 	( . 
	dec a			;4427	3d 	= 
	jr z,l447bh		;4428	28 51 	( Q 
	ld a,d			;442a	7a 	z 
	ld (l2b8bh+1),a		;442b	32 8c 2b 	2 . + 
	ld a,e			;442e	7b 	{ 
WLdChrInA:
	or a			;442f	b7 	. 
	jr z,WLd0		;4430	28 0d 	( . 
	call JCodeNextByte		;4432	cd d1 06 	. . . 
	defb 03eh		;4435	3e 	> 
	call StoreAToHL2		;4436	cd e3 33 	. . 3 
WPushAF:
	call JCodeNextByte		;4439	cd d1 06 	. . . 
	defb 0f5h		;443c	f5 	. 
	jr l4464h		;443d	18 25 	. % 
WLd0:
	call JCodeNextByte		;443f	cd d1 06 	. . . 
	defb 0afh		;4442	af 	. 
	jr WPushAF		;4443	18 f4 	. . 
l4445h:
	ex de,hl			;4445	eb 	. 
l4446h:
	bit 0,(ix+001h)		;4446	dd cb 01 46 	. . . F 
	jr z,l446eh		;444a	28 22 	( " 
	call NormalisiereZahl__		;444c	cd 2f 46 	. / F 
l444fh:
	ex de,hl			;444f	eb 	. 
	push hl			;4450	e5 	. 
l4451h:
	ex de,hl			;4451	eb 	. 
	ex (sp),hl			;4452	e3 	. 
	call sub_33fah		;4453	cd fa 33 	. . 3 
	pop de			;4456	d1 	. 
	call WLdHLnnIsDE		;4457	cd 08 34 	. . 4 
	call sub_45c2h		;445a	cd c2 45 	. . E 
	ld bc,00002h		;445d	01 02 00 	. . . 
	set 0,(ix+001h)		;4460	dd cb 01 c6 	. . . . 
l4464h:
	jp GetLexem		;4464	c3 c3 2f 	. . / 
l4467h:
	ld bc,08000h		;4467	01 00 80 	. . . 
	ld d,c			;446a	51 	Q 
	ld e,c			;446b	59 	Y 
	jr WLdStrAddr		;446c	18 04 	. . 
l446eh:
	ld bc,00001h		;446e	01 01 00 	. . . 
	ex de,hl			;4471	eb 	. 
WLdStrAddr:
	call WLdHLnnIsDE		;4472	cd 08 34 	. . 4 
	call JCodeNextByte		;4475	cd d1 06 	. . . 
	defb 0e5h		;4478	e5 	. 
	jr l4464h		;4479	18 e9 	. . 
l447bh:
	push de			;447b	d5 	. 
	inc hl			;447c	23 	# 
	ld e,(hl)			;447d	5e 	^ 
	inc hl			;447e	23 	# 
	ld d,(hl)			;447f	56 	V 
	jr l4451h		;4480	18 cf 	. . 
l4482h:
	ld a,(l2b76h)		;4482	3a 76 2b 	: v + 
	push af			;4485	f5 	. 
	ld a,(bc)			;4486	0a 	. 
	ld c,a			;4487	4f 	O 
	ld b,000h		;4488	06 00 	. . 
	push bc			;448a	c5 	. 
	push hl			;448b	e5 	. 
	dec a			;448c	3d 	= 
	ld hl,l4676h		;448d	21 76 46 	! v F 
	jr z,l449bh		;4490	28 09 	( . 
	dec a			;4492	3d 	= 
	ld hl,l4676h+2		;4493	21 78 46 	! x F 
	jr z,l449bh		;4496	28 03 	( . 
	ld hl,l4660h		;4498	21 60 46 	! ` F 
l449bh:
	call WCode		;449b	cd cc 33 	. . 3 
	pop hl			;449e	e1 	. 
	call l38c0h		;449f	cd c0 38 	. . 8 
	pop bc			;44a2	c1 	. 
	pop de			;44a3	d1 	. 
	ld (ix+001h),d		;44a4	dd 72 01 	. r . 
	dec c			;44a7	0d 	. 
	jr nz,l44b3h		;44a8	20 09 	  . 
	ld hl,l4654h		;44aa	21 54 46 	! T F 
	call WCode		;44ad	cd cc 33 	. . 3 
	jp l459fh		;44b0	c3 9f 45 	. . E 
l44b3h:
	dec c			;44b3	0d 	. 
	jr z,l44bbh		;44b4	28 05 	( . 
	ld hl,l4657h		;44b6	21 57 46 	! W F 
	jr l44c2h		;44b9	18 07 	. . 
l44bbh:
	ld hl,l465bh		;44bb	21 5b 46 	! [ F 
	set 0,(ix+001h)		;44be	dd cb 01 c6 	. . . . 
l44c2h:
	inc c			;44c2	0c 	. 
	inc c			;44c3	0c 	. 
	jp WCode		;44c4	c3 cc 33 	. . 3 
l44c7h:
	cp 009h		;44c7	fe 09 	. . 
	jp z,l42fdh		;44c9	ca fd 42 	. . B 
	cp 00ah		;44cc	fe 0a 	. . 
	jp z,l456fh		;44ce	ca 6f 45 	. o E 
	jr nc,l4518h		;44d1	30 45 	0 E 
	cp 007h		;44d3	fe 07 	. . 
	jp z,l376bh		;44d5	ca 6b 37 	. k 7 
	cp 005h		;44d8	fe 05 	. . 
	jr z,l4482h		;44da	28 a6 	( . 
	jp l456fh		;44dc	c3 6f 45 	. o E 
sub_44dfh:
	push bc			;44df	c5 	. 
	set 0,(ix+001h)		;44e0	dd cb 01 c6 	. . . . 
	call sub_4508h		;44e4	cd 08 45 	. . E 
	exx			;44e7	d9 	. 
	dec hl			;44e8	2b 	+ 
	dec hl			;44e9	2b 	+ 
	exx			;44ea	d9 	. 
	call JCodeNextByte		;44eb	cd d1 06 	. . . 
	defb 0cdh		;44ee	cd 	. 
	pop de			;44ef	d1 	. 
	call StoreDE		;44f0	cd 0c 34 	. . 4 
	jp sub_45c2h		;44f3	c3 c2 45 	. . E 
l44f6h:
	ld a,(l2b76h)		;44f6	3a 76 2b 	: v + 
	push af			;44f9	f5 	. 
	call sub_44dfh		;44fa	cd df 44 	. . D 
	pop de			;44fd	d1 	. 
	ld (ix+001h),d		;44fe	dd 72 01 	. r . 
	dec c			;4501	0d 	. 
	exx			;4502	d9 	. 
	dec hl			;4503	2b 	+ 
	exx			;4504	d9 	. 
	jp l45a0h		;4505	c3 a0 45 	. . E 
sub_4508h:
	call NextChkOpBra_GetLex		;4508	cd fd 32 	. . 2 
	call l3f43h		;450b	cd 43 3f 	. C ? 
	call PCVChkNum		;450e	cd e6 34 	. . 4 
l4511h:
	res 3,(ix+002h)		;4511	dd cb 02 9e 	. . . . 
	jp ChkCloBra_GetLex		;4515	c3 05 33 	. . 3 
l4518h:
	cp 00ch		;4518	fe 0c 	. . 
	jr c,sub_44dfh		;451a	38 c3 	8 . 
	jr z,l44f6h		;451c	28 d8 	( . 
	cp 00fh		;451e	fe 0f 	. . 
	jp z,l456fh		;4520	ca 6f 45 	. o E 
	push bc			;4523	c5 	. 
	ld e,(hl)			;4524	5e 	^ 
	inc hl			;4525	23 	# 
	ld d,(hl)			;4526	56 	V 
	push de			;4527	d5 	. 
	call sub_4508h		;4528	cd 08 45 	. . E 
	bit 0,c		;452b	cb 41 	. A 
	pop de			;452d	d1 	. 
	pop hl			;452e	e1 	. 
	jp nz,sub_33c4h		;452f	c2 c4 33 	. . 3 
	ex de,hl			;4532	eb 	. 
	jp l33beh		;4533	c3 be 33 	. . 3 
	ld a,(l2b76h)		;4536	3a 76 2b 	: v + 
	push af			;4539	f5 	. 
	call NextChkOpBra_GetLex		;453a	cd fd 32 	. . 2 
	call sub_3f10h		;453d	cd 10 3f 	. . ? 
	pop de			;4540	d1 	. 
	ld (ix+001h),d		;4541	dd 72 01 	. r . 
	call ChkComma_GetLex		;4544	cd f8 32 	. . 2 
	ld hl,l2b93h		;4547	21 93 2b 	! . + 
	push hl			;454a	e5 	. 
	call sub_4af1h		;454b	cd f1 4a 	. . J 
	call ChkCloBra_GetLex		;454e	cd 05 33 	. . 3 
	pop hl			;4551	e1 	. 
l4552h:
	ld c,(hl)			;4552	4e 	N 
l4553h:
	inc hl			;4553	23 	# 
	ld b,(hl)			;4554	46 	F 
	inc hl			;4555	23 	# 
	call sub_5045h		;4556	cd 45 50 	. E P 
	ld d,000h		;4559	16 00 	. . 
	jr l4574h		;455b	18 17 	. . 
l455dh:
	push bc			;455d	c5 	. 
	ld c,001h		;455e	0e 01 	. . 
	call sub_457dh		;4560	cd 7d 45 	. } E 
	pop bc			;4563	c1 	. 
	ret			;4564	c9 	. 
l4565h:
	exx			;4565	d9 	. 
	dec hl			;4566	2b 	+ 
	exx			;4567	d9 	. 
	ld hl,l395fh		;4568	21 5f 39 	! _ 9 
	inc b			;456b	04 	. 
	jp CodeLdBC_0n_from_0x2b8b		;456c	c3 aa 33 	. . 3 
l456fh:
	ld e,00ch		;456f	1e 0c 	. . 
	call sub_4e7dh		;4571	cd 7d 4e 	. } N 
l4574h:
	bit 7,b		;4574	cb 78 	. x 
	jr nz,l455dh		;4576	20 e5 	  . 
	dec b			;4578	05 	. 
	jr z,l4565h		;4579	28 ea 	( . 
	inc b			;457b	04 	. 
	ret nz			;457c	c0 	. 
sub_457dh:
	dec d			;457d	15 	. 
	jp m,l4612h		;457e	fa 12 46 	. . F 
	ex de,hl			;4581	eb 	. 
	jr nz,l45cbh		;4582	20 47 	  G 
	dec c			;4584	0d 	. 
	jr z,l4598h		;4585	28 11 	( . 
	dec c			;4587	0d 	. 
	jr z,l45ach		;4588	28 22 	( " 
	call JCodeNextByte		;458a	cd d1 06 	. . . 
	defb 03ah		;458d	3a 	: 
	call StoreDE		;458e	cd 0c 34 	. . 4 
l4591h:
	inc c			;4591	0c 	. 
	call JCodeNextByte		;4592	cd d1 06 	. . . 
	defb 0f5h		;4595	f5 	. 
	inc c			;4596	0c 	. 
	ret			;4597	c9 	. 
l4598h:
	call sub_3401h		;4598	cd 01 34 	. . 4 
l459bh:
	call JCodeNextByte		;459b	cd d1 06 	. . . 
	defb 0e5h		;459e	e5 	. 
l459fh:
	inc c			;459f	0c 	. 
l45a0h:
	bit 0,(ix+001h)		;45a0	dd cb 01 46 	. . . F 
	ret z			;45a4	c8 	. 
	inc c			;45a5	0c 	. 
	ld hl,l4178h		;45a6	21 78 41 	! x A 
	jp sub_33c4h		;45a9	c3 c4 33 	. . 3 
l45ach:
	call JCodeNextByte		;45ac	cd d1 06 	. . . 
	defb 0edh		;45af	ed 	. 
	call JCodeNextByte		;45b0	cd d1 06 	. . . 
	defb 05bh		;45b3	5b 	[ 
	call StoreDE		;45b4	cd 0c 34 	. . 4 
	inc de			;45b7	13 	. 
	inc de			;45b8	13 	. 
	call sub_3401h		;45b9	cd 01 34 	. . 4 
l45bch:
	set 0,(ix+001h)		;45bc	dd cb 01 c6 	. . . . 
	inc c			;45c0	0c 	. 
	inc c			;45c1	0c 	. 
sub_45c2h:
	call JCodeNextByte		;45c2	cd d1 06 	. . . 
	defb 0e5h		;45c5	e5 	. 
	call JCodeNextByte		;45c6	cd d1 06 	. . . 
	defb 0d5h		;45c9	d5 	. 
	ret			;45ca	c9 	. 
l45cbh:
	ld d,0ddh		;45cb	16 dd 	. . 
	call JCodeNextByte		;45cd	cd d1 06 	. . . 
	defb 0ddh		;45d0	dd 	. 
	dec c			;45d1	0d 	. 
	jr z,l45e0h		;45d2	28 0c 	( . 
	dec c			;45d4	0d 	. 
	jr z,l45f1h		;45d5	28 1a 	( . 
	call JCodeNextByte		;45d7	cd d1 06 	. . . 
	defb 07eh		;45da	7e 	~ 
	call l381ah		;45db	cd 1a 38 	. . 8 
	jr l4591h		;45de	18 b1 	. . 
l45e0h:
	call JCodeNextByte		;45e0	cd d1 06 	. . . 
	defb 06eh		;45e3	6e 	n 
	call StoreDE		;45e4	cd 0c 34 	. . 4 
	inc e			;45e7	1c 	. 
	call JCodeNextByte		;45e8	cd d1 06 	. . . 
	defb 066h		;45eb	66 	f 
	call l381ah		;45ec	cd 1a 38 	. . 8 
	jr l459bh		;45ef	18 aa 	. . 
l45f1h:
	call JCodeNextByte		;45f1	cd d1 06 	. . . 
	defb 05eh		;45f4	5e 	^ 
	call StoreDE		;45f5	cd 0c 34 	. . 4 
	inc e			;45f8	1c 	. 
	call JCodeNextByte		;45f9	cd d1 06 	. . . 
	defb 056h		;45fc	56 	V 
	call StoreDE		;45fd	cd 0c 34 	. . 4 
	inc e			;4600	1c 	. 
	call JCodeNextByte		;4601	cd d1 06 	. . . 
	defb 06eh		;4604	6e 	n 
	call StoreDE		;4605	cd 0c 34 	. . 4 
	inc e			;4608	1c 	. 
	call JCodeNextByte		;4609	cd d1 06 	. . . 
	defb 066h		;460c	66 	f 
	call l381ah		;460d	cd 1a 38 	. . 8 
	jr l45bch		;4610	18 aa 	. . 
l4612h:
	dec c			;4612	0d 	. 
	jr z,l461dh		;4613	28 08 	( . 
	dec c			;4615	0d 	. 
	jr z,l4623h		;4616	28 0b 	( . 
	ld hl,l4660h+2		;4618	21 62 46 	! b F 
	jr l462ah		;461b	18 0d 	. . 
l461dh:
	ld hl,l4665h		;461d	21 65 46 	! e F 
	jp l4355h		;4620	c3 55 43 	. U C 
l4623h:
	ld hl,l466bh		;4623	21 6b 46 	! k F 
	set 0,(ix+001h)		;4626	dd cb 01 c6 	. . . . 
l462ah:
	inc c			;462a	0c 	. 
	inc c			;462b	0c 	. 
	jp sub_33c4h		;462c	c3 c4 33 	. . 3 
NormalisiereZahl__:
	ld a,080h		;462f	3e 80 	> . 
	and h			;4631	a4 	. 
	jr z,HL_is_Pos		;4632	28 07 	( . 
	ex de,hl			;4634	eb 	. 
	ld hl,00000h		;4635	21 00 00 	! . . 
	sbc hl,de		;4638	ed 52 	. R 
	or a			;463a	b7 	. 
HL_is_Pos:
	ld de,00000h		;463b	11 00 00 	. . . 
	adc hl,de		;463e	ed 5a 	. Z 
	ret z			;4640	c8 	. 
	ld d,00eh		;4641	16 0e 	. . 
ShlHL:
	bit 6,h		;4643	cb 74 	. t 
	jr nz,RestoreSignBit		;4645	20 04 	  . 
	add hl,hl			;4647	29 	) 
	dec d			;4648	15 	. 
	jr ShlHL		;4649	18 f8 	. . 
RestoreSignBit:
	ld e,000h		;464b	1e 00 	. . 
	or h			;464d	b4 	. 
	ld h,a			;464e	67 	g 
	ret			;464f	c9 	. 
l4650h:
	inc bc			;4650	03 	. 
	xor 001h		;4651	ee 01 	. . 
	push af			;4653	f5 	. 
l4654h:
	ld (bc),a			;4654	02 	. 
	pop hl			;4655	e1 	. 
	push hl			;4656	e5 	. 
l4657h:
	inc bc			;4657	03 	. 
	dec sp			;4658	3b 	; 
	pop af			;4659	f1 	. 
	push af			;465a	f5 	. 
l465bh:
	inc b			;465b	04 	. 
	pop de			;465c	d1 	. 
	pop hl			;465d	e1 	. 
	push hl			;465e	e5 	. 
	push de			;465f	d5 	. 
l4660h:
	ld bc,l023bh		;4660	01 3b 02 	. ; . 
	ld a,(hl)			;4663	7e 	~ 
	push af			;4664	f5 	. 
l4665h:
	dec b			;4665	05 	. 
	ld e,(hl)			;4666	5e 	^ 
	inc hl			;4667	23 	# 
	ld d,(hl)			;4668	56 	V 
	ex de,hl			;4669	eb 	. 
	push hl			;466a	e5 	. 
l466bh:
	ld a,(bc)			;466b	0a 	. 
	ld e,(hl)			;466c	5e 	^ 
	inc hl			;466d	23 	# 
	ld d,(hl)			;466e	56 	V 
	inc hl			;466f	23 	# 
	ld c,(hl)			;4670	4e 	N 
	inc hl			;4671	23 	# 
	ld h,(hl)			;4672	66 	f 
	ld l,c			;4673	69 	i 
	push hl			;4674	e5 	. 
	push de			;4675	d5 	. 
l4676h:
	ld bc,l02e5h		;4676	01 e5 02 	. . . 
	push hl			;4679	e5 	. 
	push de			;467a	d5 	. 
sub_467bh:
	or a			;467b	b7 	. 
	ld hl,CSq_PrepCaPrc_NoLVar__		;467c	21 b2 46 	! . F 
	jr z,l468bh		;467f	28 0a 	( . 
	call JCodeNextByte		;4681	cd d1 06 	. . . 
	defb 00eh		;4684	0e 	. 
	call StoreAToHL2		;4685	cd e3 33 	. . 3 
	ld hl,CSq_IniLVar_CaPrc		;4688	21 8e 46 	! . F 
l468bh:
	jp WCode		;468b	c3 cc 33 	. . 3 
CSq_IniLVar_CaPrc:
	defb 003h		;468e	03 	. 
	call InitLocVar_CaPrc__		;468f	cd 10 0c 	. . . 
	inc bc			;4692	03 	. 
	call sub_0be9h		;4693	cd e9 0b 	. . . 
l4696h:
	dec b			;4696	05 	. 
	call sub_0be9h		;4697	cd e9 0b 	. . . 
	or (hl)			;469a	b6 	. 
	ld (hl),a			;469b	77 	w 
	inc b			;469c	04 	. 
	ld a,l			;469d	7d 	} 
	call sub_0be9h		;469e	cd e9 0b 	. . . 
l46a1h:
	rlca			;46a1	07 	. 
	ld e,a			;46a2	5f 	_ 
	call sub_0be9h		;46a3	cd e9 0b 	. . . 
	ld d,a			;46a6	57 	W 
	push hl			;46a7	e5 	. 
	push de			;46a8	d5 	. 
l46a9h:
	ex af,af'			;46a9	08 	. 
	pop de			;46aa	d1 	. 
	pop hl			;46ab	e1 	. 
	sub e			;46ac	93 	. 
	jr c,CSq_PrepCaPrc_NoLVar__		;46ad	38 03 	8 . 
	call sub_0c03h		;46af	cd 03 0c 	. . . 
CSq_PrepCaPrc_NoLVar__:
	defb 004h		;46b2	04 	. 
	ld b,000h		;46b3	06 00 	. . 
	push bc			;46b5	c5 	. 
	inc sp			;46b6	33 	3 
CSq_SaveHL:
	defb 003h		;46b7	03 	. 
	ld (l1798h),hl		;46b8	22 98 17 	" . . 
CSq_RestHL:
	defb 003h		;46bb	03 	. 
	ld hl,(l1798h)		;46bc	2a 98 17 	* . . 
sub_46bfh:
	call ChkScalar		;46bf	cd 4b 35 	. K 5 
	inc b			;46c2	04 	. 
	ld (l2b89h),bc		;46c3	ed 43 89 2b 	. C . + 
	ld a,c			;46c7	79 	y 
	dec a			;46c8	3d 	= 
	jr z,l46dfh		;46c9	28 14 	( . 
	cp 002h		;46cb	fe 02 	. . 
	ld a,01fh		;46cd	3e 1f 	> . 
	jr z,l46dah		;46cf	28 09 	( . 
	ld a,(l2b8bh+1)		;46d1	3a 8c 2b 	: . + 
	srl a		;46d4	cb 3f 	. ? 
	srl a		;46d6	cb 3f 	. ? 
	srl a		;46d8	cb 3f 	. ? 
l46dah:
	ld (l2b8bh),a		;46da	32 8b 2b 	2 . + 
	scf			;46dd	37 	7 
	ret			;46de	c9 	. 
l46dfh:
	ld a,01fh		;46df	3e 1f 	> . 
	ld (l2b8bh),a		;46e1	32 8b 2b 	2 . + 
	or a			;46e4	b7 	. 
	ret			;46e5	c9 	. 
l46e6h:
	ld bc,(l2b89h)		;46e6	ed 4b 89 2b 	. K . + 
	jp GetLexem		;46ea	c3 c3 2f 	. . / 
l46edh:
	ld a,(l2b89h)		;46ed	3a 89 2b 	: . + 
	or a			;46f0	b7 	. 
	jp z,l474eh		;46f1	ca 4e 47 	. N G 
	ld a,(l2b8bh)		;46f4	3a 8b 2b 	: . + 
	call sub_467bh		;46f7	cd 7b 46 	. { F 
	call GetLexem		;46fa	cd c3 2f 	. . / 
	cp 0ddh		;46fd	fe dd 	. . 
	jr z,l46e6h		;46ff	28 e5 	( . 
l4701h:
	call sub_3f16h		;4701	cd 16 3f 	. . ? 
l4704h:
	cp 0aeh		;4704	fe ae 	. . 
	jr z,l4721h		;4706	28 19 	( . 
	dec c			;4708	0d 	. 
	jr nz,l470fh		;4709	20 04 	  . 
	call JCodeNextByte		;470b	cd d1 06 	. . . 
	defb 07dh		;470e	7d 	} 
l470fh:
	ld hl,l4696h		;470f	21 96 46 	! . F 
l4712h:
	call WCode		;4712	cd cc 33 	. . 3 
	cp 0ddh		;4715	fe dd 	. . 
	jr z,l46e6h		;4717	28 cd 	( . 
	ld de,0ac2ah		;4719	11 2a ac 	. * . 
	call ChkLexem_GetLex		;471c	cd 08 33 	. . 3 
	jr l4701h		;471f	18 e0 	. . 
l4721h:
	call GetLexem		;4721	cd c3 2f 	. . / 
	ld de,0ae2bh		;4724	11 2b ae 	. + . 
	call ChkLexem_GetLex		;4727	cd 08 33 	. . 3 
	dec c			;472a	0d 	. 
	jr z,l4738h		;472b	28 0b 	( . 
	ld hl,l46a1h		;472d	21 a1 46 	! . F 
	call WCode		;4730	cd cc 33 	. . 3 
	call sub_3f16h		;4733	cd 16 3f 	. . ? 
	jr l4749h		;4736	18 11 	. . 
l4738h:
	call JCodeNextByte		;4738	cd d1 06 	. . . 
	defb 07dh		;473b	7d 	} 
	ld hl,l46a1h		;473c	21 a1 46 	! . F 
	call WCode		;473f	cd cc 33 	. . 3 
	call sub_3f16h		;4742	cd 16 3f 	. . ? 
	call JCodeNextByte		;4745	cd d1 06 	. . . 
	defb 07dh		;4748	7d 	} 
l4749h:
	ld hl,l46a9h		;4749	21 a9 46 	! . F 
	jr l4712h		;474c	18 c4 	. . 
l474eh:
	call GetLexem		;474e	cd c3 2f 	. . / 
	cp 0ddh		;4751	fe dd 	. . 
	jr z,CoErrEmptySet		;4753	28 24 	( $ 
	call sub_3f3fh		;4755	cd 3f 3f 	. ? ? 
	push af			;4758	f5 	. 
	call sub_46bfh		;4759	cd bf 46 	. . F 
	jr nc,l4768h		;475c	30 0a 	0 . 
	exx			;475e	d9 	. 
	dec hl			;475f	2b 	+ 
	exx			;4760	d9 	. 
	call sub_467bh		;4761	cd 7b 46 	. { F 
l4764h:
	pop af			;4764	f1 	. 
	jp l4704h		;4765	c3 04 47 	. . G 
l4768h:
	ld hl,CSq_SaveHL		;4768	21 b7 46 	! . F 
	call sub_33c4h		;476b	cd c4 33 	. . 3 
	call sub_467bh		;476e	cd 7b 46 	. { F 
	ld hl,CSq_RestHL		;4771	21 bb 46 	! . F 
	call WCode		;4774	cd cc 33 	. . 3 
	jr l4764h		;4777	18 eb 	. . 
CoErrEmptySet:
	ld e,02dh		;4779	1e 2d 	. - 
	call CompileErr		;477b	cd 3a 2f 	. : / 
	jp GetLexem		;477e	c3 c3 2f 	. . / 
sub_4781h:
	cp 021h		;4781	fe 21 	. ! 
	jr nz,ChkConst		;4783	20 4a 	  J 
	call WrJump		;4785	cd c9 33 	. . 3 
	push hl			;4788	e5 	. 
ChkLabelNum__:
	call GetLexem		;4789	cd c3 2f 	. . / 
	cp 07fh		;478c	fe 7f 	.  
	ld e,03bh		;478e	1e 3b 	. ; 
	jp nz,CompileErr		;4790	c2 3a 2f 	. : / 
	ld hl,(TopOfHeapAddr__)		;4793	2a 6e 2b 	* n + 
	ld de,(labelListAddr)		;4796	ed 5b 6a 2b 	. [ j + 
	ld (labelListAddr),hl		;479a	22 6a 2b 	" j + 
	ld (hl),e			;479d	73 	s 
	inc hl			;479e	23 	# 
	ld (hl),d			;479f	72 	r 
	inc hl			;47a0	23 	# 
	ld de,(curRealHWord)		;47a1	ed 5b 5f 2b 	. [ _ + 
	ld (hl),e			;47a5	73 	s 
	inc hl			;47a6	23 	# 
	ld (hl),d			;47a7	72 	r 
	inc hl			;47a8	23 	# 
	ex de,hl			;47a9	eb 	. 
	call GetTargetAddrInHL__		;47aa	cd d8 33 	. . 3 
	ex de,hl			;47ad	eb 	. 
	ld (hl),e			;47ae	73 	s 
	inc hl			;47af	23 	# 
	ld (hl),d			;47b0	72 	r 
	inc hl			;47b1	23 	# 
	ld a,(BlockLevel__)		;47b2	3a 72 2b 	: r + 
	ld (hl),a			;47b5	77 	w 
	inc hl			;47b6	23 	# 
	ld (TopOfHeapAddr__),hl		;47b7	22 6e 2b 	" n + 
	call WrJump		;47ba	cd c9 33 	. . 3 
	call GetLexem		;47bd	cd c3 2f 	. . / 
	cp 0ach		;47c0	fe ac 	. . 
	jr z,ChkLabelNum__		;47c2	28 c5 	( . 
	call GetTargetAddrInHL__		;47c4	cd d8 33 	. . 3 
	ex de,hl			;47c7	eb 	. 
	pop hl			;47c8	e1 	. 
	call WrDE_ByTargAddr_pl2		;47c9	cd 17 34 	. . 4 
	call ChkSemi_GetLex		;47cc	cd d9 32 	. . 2 
ChkConst:
	cp 003h		;47cf	fe 03 	. . 
	jr nz,ChkType		;47d1	20 45 	  E 
	call GetLexem		;47d3	cd c3 2f 	. . / 
ParseConst:
	call IdentToSymtab		;47d6	cd 0f 33 	. . 3 
	push hl			;47d9	e5 	. 
	call GetLexem		;47da	cd c3 2f 	. . / 
	cp 07dh		;47dd	fe 7d 	. } 
	jr nz,PConChkEq		;47df	20 07 	  . 
	ld e,005h		;47e1	1e 05 	. . 
	call CompileErr		;47e3	cd 3a 2f 	. : / 
	jr PConChkVal		;47e6	18 07 	. . 
PConChkEq:
	cp 078h		;47e8	fe 78 	. x 
	ld e,006h		;47ea	1e 06 	. . 
	call nz,CompileErr		;47ec	c4 3a 2f 	. : / 
PConChkVal:
	call GetLexem		;47ef	cd c3 2f 	. . / 
	call ParseConstVal		;47f2	cd 79 34 	. y 4 
	ex de,hl			;47f5	eb 	. 
	ex (sp),hl			;47f6	e3 	. 
	ld (hl),001h		;47f7	36 01 	6 . 
	inc hl			;47f9	23 	# 
	ld (hl),c			;47fa	71 	q 
	inc hl			;47fb	23 	# 
	ld (hl),b			;47fc	70 	p 
	inc hl			;47fd	23 	# 
	dec b			;47fe	05 	. 
	inc b			;47ff	04 	. 
	jr nz,l4804h		;4800	20 02 	  . 
	dec c			;4802	0d 	. 
	dec c			;4803	0d 	. 
l4804h:
	pop bc			;4804	c1 	. 
	jr nz,l480bh		;4805	20 04 	  . 
	ld (hl),c			;4807	71 	q 
	inc hl			;4808	23 	# 
	ld (hl),b			;4809	70 	p 
	inc hl			;480a	23 	# 
l480bh:
	ld (hl),e			;480b	73 	s 
	inc hl			;480c	23 	# 
	ld (hl),d			;480d	72 	r 
	inc hl			;480e	23 	# 
	ld (TopOfHeapAddr__),hl		;480f	22 6e 2b 	" n + 
	call ChkSemi_GetLex		;4812	cd d9 32 	. . 2 
	or a			;4815	b7 	. 
	jr z,ParseConst		;4816	28 be 	( . 
ChkType:
	cp 01fh		;4818	fe 1f 	. . 
	jr nz,l483ah		;481a	20 1e 	  . 
	call GetLexem		;481c	cd c3 2f 	. . / 
l481fh:
	ld de,00009h		;481f	11 09 00 	. . . 
	call IdentToSymtab		;4822	cd 0f 33 	. . 3 
	ld (hl),003h		;4825	36 03 	6 . 
	inc hl			;4827	23 	# 
	call GetLexem		;4828	cd c3 2f 	. . / 
	ld de,07806h		;482b	11 06 78 	. . x 
	call ChkLexem_GetLex		;482e	cd 08 33 	. . 3 
	call sub_4af1h		;4831	cd f1 4a 	. . J 
	call ChkSemi_GetLex		;4834	cd d9 32 	. . 2 
	or a			;4837	b7 	. 
	jr z,l481fh		;4838	28 e5 	( . 
l483ah:
	ld hl,sub_4af1h		;483a	21 f1 4a 	! . J 
	ld (04da2h),hl		;483d	22 a2 4d 	" . M 
	ld d,a			;4840	57 	W 
	ld a,(BlockLevel__)		;4841	3a 72 2b 	: r + 
	or a			;4844	b7 	. 
	ld hl,0fffch		;4845	21 fc ff 	! . . 
	jr nz,l4865h		;4848	20 1b 	  . 
	ld hl,(binMoveDistance__)		;484a	2a 8f 2b 	* . + 
	ld a,h			;484d	7c 	| 
	or l			;484e	b5 	. 
	ld hl,CSq_Init		;484f	21 60 2e 	! ` . 
	call nz,WCode		;4852	c4 cc 33 	. . 3 
	ld hl,CSq_InitJRTErr		;4855	21 67 2e 	! g . 
	call WCode		;4858	cd cc 33 	. . 3 
	call WrJump		;485b	cd c9 33 	. . 3 
	dec hl			;485e	2b 	+ 
	ld (l2b8dh),hl		;485f	22 8d 2b 	" . + 
	ld hl,(memEnd)		;4862	2a 65 2b 	* e + 
l4865h:
	ld a,d			;4865	7a 	z 
	ld (l2b61h),hl		;4866	22 61 2b 	" a + 
	cp 00ah		;4869	fe 0a 	. . 
	jr nz,l4879h		;486b	20 0c 	  . 
	call GetLexem		;486d	cd c3 2f 	. . / 
FoundIdent:
	call ParseVar		;4870	cd bd 4d 	. . M 
	call ChkSemi_GetLex		;4873	cd d9 32 	. . 2 
	or a			;4876	b7 	. 
	jr z,FoundIdent		;4877	28 f7 	( . 
l4879h:
	ld hl,(l2b61h)		;4879	2a 61 2b 	* a + 
	push hl			;487c	e5 	. 
	ld hl,BlockLevel__		;487d	21 72 2b 	! r + 
	inc (hl)			;4880	34 	4 
ParseBlock__:
	cp 004h		;4881	fe 04 	. . 
	jr z,ParsePrc		;4883	28 05 	( . 
	cp 005h		;4885	fe 05 	. . 
	jp nz,ParseFnc		;4887	c2 41 4a 	. A J 
ParsePrc:
	push af			;488a	f5 	. 
	call GetLexem		;488b	cd c3 2f 	. . / 
	or a			;488e	b7 	. 
	ld e,004h		;488f	1e 04 	. . 
	call nz,CompileErr		;4891	c4 3a 2f 	. : / 
	ld hl,(SymTabAddr__)		;4894	2a 6c 2b 	* l + 
	call SearchInSymTab__		;4897	cd 69 33 	. i 3 
	jp c,l49ddh		;489a	da dd 49 	. . I 
l489dh:
	xor a			;489d	af 	. 
	ld de,0000ah		;489e	11 0a 00 	. . . 
	call IdentToSymtab		;48a1	cd 0f 33 	. . 3 
	pop af			;48a4	f1 	. 
	ld (hl),a			;48a5	77 	w 
	inc hl			;48a6	23 	# 
	inc hl			;48a7	23 	# 
	inc hl			;48a8	23 	# 
	ex de,hl			;48a9	eb 	. 
	call GetTargetAddrInHL__		;48aa	cd d8 33 	. . 3 
	ex de,hl			;48ad	eb 	. 
	ld (hl),e			;48ae	73 	s 
	inc hl			;48af	23 	# 
	ld (hl),d			;48b0	72 	r 
	inc hl			;48b1	23 	# 
	ld a,(BlockLevel__)		;48b2	3a 72 2b 	: r + 
	dec a			;48b5	3d 	= 
	ld (hl),a			;48b6	77 	w 
	ex de,hl			;48b7	eb 	. 
	call WrJump		;48b8	cd c9 33 	. . 3 
	ld hl,(TopOfHeapAddr__)		;48bb	2a 6e 2b 	* n + 
	push hl			;48be	e5 	. 
	call GetLexem		;48bf	cd c3 2f 	. . / 
	cp 0a8h		;48c2	fe a8 	. . 
	jp nz,l4a1eh		;48c4	c2 1e 4a 	. . J 
	ld hl,00000h		;48c7	21 00 00 	! . . 
	ld (l2b61h),hl		;48ca	22 61 2b 	" a + 
	ld hl,l4d5fh		;48cd	21 5f 4d 	! _ M 
	ld (04da2h),hl		;48d0	22 a2 4d 	" . M 
l48d3h:
	call GetLexem		;48d3	cd c3 2f 	. . / 
	cp 00ah		;48d6	fe 0a 	. . 
	jr z,l48dfh		;48d8	28 05 	( . 
	call ParseVar		;48da	cd bd 4d 	. . M 
	jr l48eeh		;48dd	18 0f 	. . 
l48dfh:
	ld d,00ah		;48df	16 0a 	. . 
	call GetLexem		;48e1	cd c3 2f 	. . / 
	call sub_4d77h		;48e4	cd 77 4d 	. w M 
	ld bc,00002h		;48e7	01 02 00 	. . . 
	dec hl			;48ea	2b 	+ 
	call sub_4dc5h		;48eb	cd c5 4d 	. . M 
l48eeh:
	cp 0bbh		;48ee	fe bb 	. . 
	jr z,l48d3h		;48f0	28 e1 	( . 
	call ChkCloBra_GetLex		;48f2	cd 05 33 	. . 3 
	pop bc			;48f5	c1 	. 
	push af			;48f6	f5 	. 
	push bc			;48f7	c5 	. 
	ld hl,(SymTabAddr__)		;48f8	2a 6c 2b 	* l + 
	push hl			;48fb	e5 	. 
	ld hl,(TopOfHeapAddr__)		;48fc	2a 6e 2b 	* n + 
	dec hl			;48ff	2b 	+ 
	dec hl			;4900	2b 	+ 
	ld b,(hl)			;4901	46 	F 
	dec hl			;4902	2b 	+ 
	ld c,(hl)			;4903	4e 	N 
	ex de,hl			;4904	eb 	. 
	ld hl,00002h		;4905	21 02 00 	! . . 
	xor a			;4908	af 	. 
	sbc hl,bc		;4909	ed 42 	. B 
	ld (l2b67h),hl		;490b	22 67 2b 	" g + 
l490eh:
	add hl,bc			;490e	09 	. 
	ex de,hl			;490f	eb 	. 
	ld (hl),e			;4910	73 	s 
	inc hl			;4911	23 	# 
	ld (hl),d			;4912	72 	r 
	pop hl			;4913	e1 	. 
	pop bc			;4914	c1 	. 
	inc a			;4915	3c 	< 
	or a			;4916	b7 	. 
	sbc hl,bc		;4917	ed 42 	. B 
	add hl,bc			;4919	09 	. 
l491ah:
	push bc			;491a	c5 	. 
	jr z,l492dh		;491b	28 10 	( . 
	ld e,(hl)			;491d	5e 	^ 
	inc hl			;491e	23 	# 
	ld d,(hl)			;491f	56 	V 
	push de			;4920	d5 	. 
	dec hl			;4921	2b 	+ 
	dec hl			;4922	2b 	+ 
	dec hl			;4923	2b 	+ 
	ld b,(hl)			;4924	46 	F 
	dec hl			;4925	2b 	+ 
	ld c,(hl)			;4926	4e 	N 
	ex de,hl			;4927	eb 	. 
	ld hl,(l2b67h)		;4928	2a 67 2b 	* g + 
	jr l490eh		;492b	18 e1 	. . 
l492dh:
	ld l,c			;492d	69 	i 
	ld h,b			;492e	60 	` 
	dec hl			;492f	2b 	+ 
	ld de,(l2b67h)		;4930	ed 5b 67 2b 	. [ g + 
	ld (hl),d			;4934	72 	r 
	dec hl			;4935	2b 	+ 
	ld (hl),e			;4936	73 	s 
	dec hl			;4937	2b 	+ 
	ld (hl),a			;4938	77 	w 
	ld bc,0fff9h		;4939	01 f9 ff 	. . . 
	add hl,bc			;493c	09 	. 
	ld a,(hl)			;493d	7e 	~ 
	cp 004h		;493e	fe 04 	. . 
	pop bc			;4940	c1 	. 
	jp z,l49d8h		;4941	ca d8 49 	. . I 
l4944h:
	pop af			;4944	f1 	. 
	push bc			;4945	c5 	. 
	push hl			;4946	e5 	. 
	ld de,0ba16h		;4947	11 16 ba 	. . . 
	call ChkLexem_GetLex		;494a	cd 08 33 	. . 3 
	or a			;494d	b7 	. 
l494eh:
	ld e,029h		;494e	1e 29 	. ) 
	call nz,CompileErr		;4950	c4 3a 2f 	. : / 
	call GetIdentInfoInABC		;4953	cd 50 33 	. P 3 
	cp 003h		;4956	fe 03 	. . 
	ld e,01eh		;4958	1e 1e 	. . 
	call nz,CompileErr		;495a	c4 3a 2f 	. : / 
	ld a,b			;495d	78 	x 
	or a			;495e	b7 	. 
	ld e,02eh		;495f	1e 2e 	. . 
	call nz,CompileErr		;4961	c4 3a 2f 	. : / 
	ex de,hl			;4964	eb 	. 
	dec de			;4965	1b 	. 
	dec de			;4966	1b 	. 
	pop hl			;4967	e1 	. 
	inc hl			;4968	23 	# 
	ld (hl),e			;4969	73 	s 
	inc hl			;496a	23 	# 
	ld (hl),d			;496b	72 	r 
	call GetLexem		;496c	cd c3 2f 	. . / 
l496fh:
	call ChkSemi_GetLex		;496f	cd d9 32 	. . 2 
	cp 01dh		;4972	fe 1d 	. . 
	jr nz,l4988h		;4974	20 12 	  . 
	pop hl			;4976	e1 	. 
	dec hl			;4977	2b 	+ 
	dec hl			;4978	2b 	+ 
	dec hl			;4979	2b 	+ 
	call sub_4a2bh		;497a	cd 2b 4a 	. + J 
	ld (hl),001h		;497d	36 01 	6 . 
	call GetLexem		;497f	cd c3 2f 	. . / 
l4982h:
	call ChkSemi_GetLex		;4982	cd d9 32 	. . 2 
	jp ParseBlock__		;4985	c3 81 48 	. . H 
l4988h:
	ld hl,(labelListAddr)		;4988	2a 6a 2b 	* j + 
	push hl			;498b	e5 	. 
	ld hl,(SymTabAddr__)		;498c	2a 6c 2b 	* l + 
	push hl			;498f	e5 	. 
	ld hl,(TopOfHeapAddr__)		;4990	2a 6e 2b 	* n + 
	push hl			;4993	e5 	. 
	call sub_4781h		;4994	cd 81 47 	. . G 
	pop hl			;4997	e1 	. 
	ld (TopOfHeapAddr__),hl		;4998	22 6e 2b 	" n + 
	pop hl			;499b	e1 	. 
	ld (SymTabAddr__),hl		;499c	22 6c 2b 	" l + 
	pop hl			;499f	e1 	. 
	ld (labelListAddr),hl		;49a0	22 6a 2b 	" j + 
	ld c,a			;49a3	4f 	O 
	ld de,(l2b61h)		;49a4	ed 5b 61 2b 	. [ a + 
	xor a			;49a8	af 	. 
	ld l,a			;49a9	6f 	o 
	ld h,a			;49aa	67 	g 
	sbc hl,de		;49ab	ed 52 	. R 
	call sub_4037h		;49ad	cd 37 40 	. 7 @ 
	call JCodeNextByte		;49b0	cd d1 06 	. . . 
	defb 0ddh		;49b3	dd 	. 
	call JCodeNextByte		;49b4	cd d1 06 	. . . 
	defb 0e1h		;49b7	e1 	. 
	call JCodeNextByte		;49b8	cd d1 06 	. . . 
	defb 0d1h		;49bb	d1 	. 
	pop hl			;49bc	e1 	. 
	dec hl			;49bd	2b 	+ 
	ld d,(hl)			;49be	56 	V 
	dec hl			;49bf	2b 	+ 
	ld e,(hl)			;49c0	5e 	^ 
	dec hl			;49c1	2b 	+ 
	push hl			;49c2	e5 	. 
	ex de,hl			;49c3	eb 	. 
	call sub_4037h		;49c4	cd 37 40 	. 7 @ 
	ld a,c			;49c7	79 	y 
	call JCodeNextByte		;49c8	cd d1 06 	. . . 
	defb 0ebh		;49cb	eb 	. 
	call JCodeNextByte		;49cc	cd d1 06 	. . . 
	defb 0e9h		;49cf	e9 	. 
	pop hl			;49d0	e1 	. 
	call sub_4a2bh		;49d1	cd 2b 4a 	. + J 
	ld (hl),000h		;49d4	36 00 	6 . 
	jr l4982h		;49d6	18 aa 	. . 
l49d8h:
	pop af			;49d8	f1 	. 
	push bc			;49d9	c5 	. 
	jp l496fh		;49da	c3 6f 49 	. o I 
l49ddh:
	ld d,(hl)			;49dd	56 	V 
	pop af			;49de	f1 	. 
	push af			;49df	f5 	. 
	cp d			;49e0	ba 	. 
	jp nz,l489dh		;49e1	c2 9d 48 	. . H 
	pop af			;49e4	f1 	. 
	inc hl			;49e5	23 	# 
l49e6h:
	inc hl			;49e6	23 	# 
	inc hl			;49e7	23 	# 
	ld e,(hl)			;49e8	5e 	^ 
	inc hl			;49e9	23 	# 
	ld d,(hl)			;49ea	56 	V 
	push hl			;49eb	e5 	. 
	call GetTargetAddrInHL__		;49ec	cd d8 33 	. . 3 
	ex de,hl			;49ef	eb 	. 
	inc hl			;49f0	23 	# 
	call WrDE_ByTargAddr		;49f1	cd 23 34 	. # 4 
	pop hl			;49f4	e1 	. 
	ld (hl),d			;49f5	72 	r 
	dec hl			;49f6	2b 	+ 
	ld (hl),e			;49f7	73 	s 
	ex de,hl			;49f8	eb 	. 
	call WrJump		;49f9	cd c9 33 	. . 3 
	ex de,hl			;49fc	eb 	. 
	ld de,00004h		;49fd	11 04 00 	. . . 
	add hl,de			;4a00	19 	. 
	ld a,(hl)			;4a01	7e 	~ 
	add hl,de			;4a02	19 	. 
	dec hl			;4a03	2b 	+ 
	push hl			;4a04	e5 	. 
	or a			;4a05	b7 	. 
	jr z,l4a15h		;4a06	28 0d 	( . 
	inc hl			;4a08	23 	# 
	inc hl			;4a09	23 	# 
	ld b,a			;4a0a	47 	G 
	ld e,00bh		;4a0b	1e 0b 	. . 
l4a0dh:
	set 6,(hl)		;4a0d	cb f6 	. . 
	call sub_4d6dh		;4a0f	cd 6d 4d 	. m M 
	add hl,de			;4a12	19 	. 
	djnz l4a0dh		;4a13	10 f8 	. . 
l4a15h:
	call GetLexem		;4a15	cd c3 2f 	. . / 
	call ChkSemi_GetLex		;4a18	cd d9 32 	. . 2 
	jp l4988h		;4a1b	c3 88 49 	. . I 
l4a1eh:
	ld hl,00002h		;4a1e	21 02 00 	! . . 
	ld (l2b67h),hl		;4a21	22 67 2b 	" g + 
	pop bc			;4a24	c1 	. 
	push af			;4a25	f5 	. 
	push bc			;4a26	c5 	. 
	xor a			;4a27	af 	. 
	jp l492dh		;4a28	c3 2d 49 	. - I 
sub_4a2bh:
	ld b,(hl)			;4a2b	46 	F 
	dec hl			;4a2c	2b 	+ 
	inc b			;4a2d	04 	. 
	dec b			;4a2e	05 	. 
	ret z			;4a2f	c8 	. 
	push hl			;4a30	e5 	. 
	ld de,00006h		;4a31	11 06 00 	. . . 
	add hl,de			;4a34	19 	. 
	ld e,00bh		;4a35	1e 0b 	. . 
l4a37h:
	res 6,(hl)		;4a37	cb b6 	. . 
	call sub_4d6dh		;4a39	cd 6d 4d 	. m M 
	add hl,de			;4a3c	19 	. 
	djnz l4a37h		;4a3d	10 f8 	. . 
	pop hl			;4a3f	e1 	. 
	ret			;4a40	c9 	. 
ParseFnc:
	ld hl,BlockLevel__		;4a41	21 72 2b 	! r + 
	dec (hl)			;4a44	35 	5 
	jr z,WCorrAddr		;4a45	28 72 	( r 
	ld hl,0000ah		;4a47	21 0a 00 	! . . 
	add hl,sp			;4a4a	39 	9 
	ld e,(hl)			;4a4b	5e 	^ 
	inc hl			;4a4c	23 	# 
	ld d,(hl)			;4a4d	56 	V 
	ld hl,0fff9h		;4a4e	21 f9 ff 	! . . 
	add hl,de			;4a51	19 	. 
	ld c,(hl)			;4a52	4e 	N 
	inc hl			;4a53	23 	# 
	ld b,(hl)			;4a54	46 	F 
	ex de,hl			;4a55	eb 	. 
	call GetTargetAddrInHL__		;4a56	cd d8 33 	. . 3 
	ex de,hl			;4a59	eb 	. 
	ld (hl),d			;4a5a	72 	r 
	dec hl			;4a5b	2b 	+ 
	ld (hl),e			;4a5c	73 	s 
	ld h,b			;4a5d	60 	` 
	ld l,c			;4a5e	69 	i 
	inc hl			;4a5f	23 	# 
	call WrDE_ByTargAddr		;4a60	cd 23 34 	. # 4 
	call WCaBreak_IfCoCo_C		;4a63	cd 3c 35 	. < 5 
	ld hl,CSq_IXisSPpl4		;4a66	21 df 4a 	! . J 
	call WCode		;4a69	cd cc 33 	. . 3 
	pop bc			;4a6c	c1 	. 
	ld hl,00004h		;4a6d	21 04 00 	! . . 
	add hl,bc			;4a70	09 	. 
	ld (l2b61h),hl		;4a71	22 61 2b 	" a + 
	ld c,a			;4a74	4f 	O 
	bit 3,(ix+000h)		;4a75	dd cb 00 5e 	. . . ^ 
	jr nz,l4a98h		;4a79	20 1d 	  . 
	ld a,h			;4a7b	7c 	| 
	inc a			;4a7c	3c 	< 
	jr nz,l4a98h		;4a7d	20 19 	  . 
	ld a,l			;4a7f	7d 	} 
	neg		;4a80	ed 44 	. D 
	cp 006h		;4a82	fe 06 	. . 
	jr nc,l4a98h		;4a84	30 12 	0 . 
	srl a		;4a86	cb 3f 	. ? 
	jr nc,l4a8fh		;4a88	30 05 	0 . 
	call JCodeNextByte		;4a8a	cd d1 06 	. . . 
	defb 03bh		;4a8d	3b 	; 
	or a			;4a8e	b7 	. 
l4a8fh:
	jr z,l4aafh		;4a8f	28 1e 	( . 
	call JCodeNextByte		;4a91	cd d1 06 	. . . 
	defb 0e5h		;4a94	e5 	. 
	dec a			;4a95	3d 	= 
	jr l4a8fh		;4a96	18 f7 	. . 
l4a98h:
	call sub_3407h		;4a98	cd 07 34 	. . 4 
	call JCodeNextByte		;4a9b	cd d1 06 	. . . 
	defb 039h		;4a9e	39 	9 
	call JCodeNextByte		;4a9f	cd d1 06 	. . . 
	defb 0f9h		;4aa2	f9 	. 
	bit 3,(ix+000h)		;4aa3	dd cb 00 5e 	. . . ^ 
	jr z,l4aafh		;4aa7	28 06 	( . 
	ld hl,l4ae8h		;4aa9	21 e8 4a 	! . J 
	call WCode		;4aac	cd cc 33 	. . 3 
l4aafh:
	ld a,c			;4aaf	79 	y 
ChkBegin:
	ld de,l1819h		;4ab0	11 19 18 	. . . 
	call ChkLexem_GetLex		;4ab3	cd 08 33 	. . 3 
	jp l3cd4h		;4ab6	c3 d4 3c 	. . < 
WCorrAddr:
	pop bc			;4ab9	c1 	. 
	call GetTargetAddrInHL__		;4aba	cd d8 33 	. . 3 
	ex de,hl			;4abd	eb 	. 
	ld hl,(l2b8dh)		;4abe	2a 8d 2b 	* . + 
	call WrDE_ByTargAddr_pl1		;4ac1	cd 18 34 	. . 4 
	ld hl,CSq_LdMemHL_LdIX		;4ac4	21 d9 4a 	! . J 
	call WCode		;4ac7	cd cc 33 	. . 3 
	ld d,b			;4aca	50 	P 
	ld e,c			;4acb	59 	Y 
	call StoreDE		;4acc	cd 0c 34 	. . 4 
	call JCodeNextByte		;4acf	cd d1 06 	. . . 
	defb 0ddh		;4ad2	dd 	. 
	call JCodeNextByte		;4ad3	cd d1 06 	. . . 
	defb 0f9h		;4ad6	f9 	. 
	jr ChkBegin		;4ad7	18 d7 	. . 
CSq_LdMemHL_LdIX:
	defb 005h		;4ad9	05 	. 
	ld (l178bh),hl		;4ada	22 8b 17 	" . . 
	defb 0ddh,021h		;4add	dd 21 	. ! 
CSq_IXisSPpl4:
	defb 008h		;4adf	08 	. 
	push ix		;4ae0	dd e5 	. . 
	ld ix,00004h		;4ae2	dd 21 04 00 	. ! . . 
	add ix,sp		;4ae6	dd 39 	. 9 
l4ae8h:
	ex af,af'			;4ae8	08 	. 
	ld de,(l178bh)		;4ae9	ed 5b 8b 17 	. [ . . 
	add hl,de			;4aed	19 	. 
	call nc,PrRAM		;4aee	d4 df 08 	. . . 
sub_4af1h:
	cp 023h		;4af1	fe 23 	. # 
	call z,GetLexem		;4af3	cc c3 2f 	. . / 
	cp 01ch		;4af6	fe 1c 	. . 
	jr z,l4b4eh		;4af8	28 54 	( T 
	cp 01eh		;4afa	fe 1e 	. . 
	jp z,l4bf8h		;4afc	ca f8 4b 	. . K 
	cp 0deh		;4aff	fe de 	. . 
	jr z,l4b3ah		;4b01	28 37 	( 7 
	cp 01bh		;4b03	fe 1b 	. . 
	jp nz,l4ca7h		;4b05	c2 a7 4c 	. . L 
	call NextChkOF_GetLex		;4b08	cd e6 32 	. . 2 
	call l4ca7h		;4b0b	cd a7 4c 	. . L 
	ld c,(hl)			;4b0e	4e 	N 
	inc hl			;4b0f	23 	# 
	ld b,(hl)			;4b10	46 	F 
	call ChkScalar		;4b11	cd 4b 35 	. K 5 
	inc (hl)			;4b14	34 	4 
	inc hl			;4b15	23 	# 
	inc hl			;4b16	23 	# 
	ld b,(hl)			;4b17	46 	F 
	inc hl			;4b18	23 	# 
	inc hl			;4b19	23 	# 
	dec c			;4b1a	0d 	. 
	jr z,l4b2ah		;4b1b	28 0d 	( . 
	srl b		;4b1d	cb 38 	. 8 
	srl b		;4b1f	cb 38 	. 8 
	srl b		;4b21	cb 38 	. 8 
	inc b			;4b23	04 	. 
l4b24h:
	inc hl			;4b24	23 	# 
	ld (hl),b			;4b25	70 	p 
	inc hl			;4b26	23 	# 
	ld (hl),000h		;4b27	36 00 	6 . 
	ret			;4b29	c9 	. 
l4b2ah:
	dec b			;4b2a	05 	. 
	inc b			;4b2b	04 	. 
	ld e,028h		;4b2c	1e 28 	. ( 
	call nz,CompileErr		;4b2e	c4 3a 2f 	. : / 
	dec (hl)			;4b31	35 	5 
	inc (hl)			;4b32	34 	4 
	call nz,CompileErr		;4b33	c4 3a 2f 	. : / 
	ld b,020h		;4b36	06 20 	.   
	jr l4b24h		;4b38	18 ea 	. . 
l4b3ah:
	call GetLexem		;4b3a	cd c3 2f 	. . / 
	call l4d5fh		;4b3d	cd 5f 4d 	. _ M 
	inc hl			;4b40	23 	# 
	set 7,(hl)		;4b41	cb fe 	. . 
	ld c,002h		;4b43	0e 02 	. . 
	ld de,00005h		;4b45	11 05 00 	. . . 
	add hl,de			;4b48	19 	. 
	ld (hl),c			;4b49	71 	q 
	inc hl			;4b4a	23 	# 
	ld (hl),000h		;4b4b	36 00 	6 . 
	ret			;4b4d	c9 	. 
l4b4eh:
	call GetLexem		;4b4e	cd c3 2f 	. . / 
	ld de,0db22h		;4b51	11 22 db 	. " . 
	call ChkLexem_GetLex		;4b54	cd 08 33 	. . 3 
sub_4b57h:
	ld de,(TopOfHeapAddr__)		;4b57	ed 5b 6e 2b 	. [ n + 
	ld (hl),e			;4b5b	73 	s 
	inc hl			;4b5c	23 	# 
	ld (hl),d			;4b5d	72 	r 
	push de			;4b5e	d5 	. 
	push hl			;4b5f	e5 	. 
	ex de,hl			;4b60	eb 	. 
	call l4ca7h		;4b61	cd a7 4c 	. . L 
	inc hl			;4b64	23 	# 
	ld c,a			;4b65	4f 	O 
	ld a,(hl)			;4b66	7e 	~ 
	or a			;4b67	b7 	. 
	ld a,c			;4b68	79 	y 
	ld e,024h		;4b69	1e 24 	. $ 
	call nz,CompileErr		;4b6b	c4 3a 2f 	. : / 
	inc hl			;4b6e	23 	# 
	ld c,(hl)			;4b6f	4e 	N 
	inc hl			;4b70	23 	# 
	ld b,(hl)			;4b71	46 	F 
	inc hl			;4b72	23 	# 
	ld e,(hl)			;4b73	5e 	^ 
	inc hl			;4b74	23 	# 
	ld d,(hl)			;4b75	56 	V 
	inc hl			;4b76	23 	# 
	push hl			;4b77	e5 	. 
	push de			;4b78	d5 	. 
	ld de,00008h		;4b79	11 08 00 	. . . 
	add hl,de			;4b7c	19 	. 
	ld (TopOfHeapAddr__),hl		;4b7d	22 6e 2b 	" n + 
	pop hl			;4b80	e1 	. 
	sbc hl,bc		;4b81	ed 42 	. B 
	inc hl			;4b83	23 	# 
	ex (sp),hl			;4b84	e3 	. 
	push hl			;4b85	e5 	. 
	cp 0ddh		;4b86	fe dd 	. . 
	jr z,l4be9h		;4b88	28 5f 	( _ 
	cp 0ach		;4b8a	fe ac 	. . 
	jr nz,l4bf1h		;4b8c	20 63 	  c 
	call GetLexem		;4b8e	cd c3 2f 	. . / 
	call sub_4b57h		;4b91	cd 57 4b 	. W K 
l4b94h:
	pop hl			;4b94	e1 	. 
	ld de,00006h		;4b95	11 06 00 	. . . 
	add hl,de			;4b98	19 	. 
	ld e,(hl)			;4b99	5e 	^ 
	inc hl			;4b9a	23 	# 
	ld d,(hl)			;4b9b	56 	V 
	pop hl			;4b9c	e1 	. 
	push af			;4b9d	f5 	. 
	call Mul8x8		;4b9e	cd bc 09 	. . . 
	pop af			;4ba1	f1 	. 
	ld e,035h		;4ba2	1e 35 	. 5 
	call c,CompileErr		;4ba4	dc 3a 2f 	. : / 
	ex de,hl			;4ba7	eb 	. 
	pop hl			;4ba8	e1 	. 
	inc hl			;4ba9	23 	# 
	ld (hl),e			;4baa	73 	s 
	inc hl			;4bab	23 	# 
	ld (hl),d			;4bac	72 	r 
	inc hl			;4bad	23 	# 
	inc hl			;4bae	23 	# 
	inc hl			;4baf	23 	# 
	ld (hl),e			;4bb0	73 	s 
	inc hl			;4bb1	23 	# 
	ld (hl),d			;4bb2	72 	r 
	ex (sp),hl			;4bb3	e3 	. 
	push hl			;4bb4	e5 	. 
	ld de,l4c9ch		;4bb5	11 9c 4c 	. . L 
	ld bc,00004h		;4bb8	01 04 00 	. . . 
	push af			;4bbb	f5 	. 
l4bbch:
	ld a,(de)			;4bbc	1a 	. 
	inc de			;4bbd	13 	. 
	cpi		;4bbe	ed a1 	. . 
	jr nz,l4be5h		;4bc0	20 23 	  # 
	jp pe,l4bbch		;4bc2	ea bc 4b 	. . K 
	ld a,(hl)			;4bc5	7e 	~ 
	ex af,af'			;4bc6	08 	. 
	inc hl			;4bc7	23 	# 
	ld bc,00007h		;4bc8	01 07 00 	. . . 
l4bcbh:
	ld a,(de)			;4bcb	1a 	. 
	inc de			;4bcc	13 	. 
	cpi		;4bcd	ed a1 	. . 
	jr nz,l4be5h		;4bcf	20 14 	  . 
	jp pe,l4bcbh		;4bd1	ea cb 4b 	. . K 
	ex af,af'			;4bd4	08 	. 
	ld c,a			;4bd5	4f 	O 
	pop af			;4bd6	f1 	. 
	pop hl			;4bd7	e1 	. 
	ld (TopOfHeapAddr__),hl		;4bd8	22 6e 2b 	" n + 
	pop hl			;4bdb	e1 	. 
	ld de,0fffah		;4bdc	11 fa ff 	. . . 
	add hl,de			;4bdf	19 	. 
	ld (hl),002h		;4be0	36 02 	6 . 
	dec hl			;4be2	2b 	+ 
	ld (hl),c			;4be3	71 	q 
	ret			;4be4	c9 	. 
l4be5h:
	pop af			;4be5	f1 	. 
	pop hl			;4be6	e1 	. 
	pop hl			;4be7	e1 	. 
	ret			;4be8	c9 	. 
l4be9h:
	call NextChkOF_GetLex		;4be9	cd e6 32 	. . 2 
l4bech:
	call sub_4af1h		;4bec	cd f1 4a 	. . J 
	jr l4b94h		;4bef	18 a3 	. . 
l4bf1h:
	ld e,026h		;4bf1	1e 26 	. & 
	call CompileErr		;4bf3	cd 3a 2f 	. : / 
	jr l4bech		;4bf6	18 f4 	. . 
l4bf8h:
	ld de,(TopOfHeapAddr__)		;4bf8	ed 5b 6e 2b 	. [ n + 
	inc de			;4bfc	13 	. 
	inc de			;4bfd	13 	. 
	ld (hl),e			;4bfe	73 	s 
	inc hl			;4bff	23 	# 
	ld (hl),d			;4c00	72 	r 
	inc hl			;4c01	23 	# 
	push hl			;4c02	e5 	. 
	ld hl,sub_4af1h		;4c03	21 f1 4a 	! . J 
	ld (04da2h),hl		;4c06	22 a2 4d 	" . M 
	ld hl,00000h		;4c09	21 00 00 	! . . 
	ld (l2b63h),hl		;4c0c	22 63 2b 	" c + 
	call sub_4c27h		;4c0f	cd 27 4c 	. ' L 
	ld de,01036h		;4c12	11 36 10 	. 6 . 
	call ChkLexem_GetLex		;4c15	cd 08 33 	. . 3 
	ld de,(l2b63h)		;4c18	ed 5b 63 2b 	. [ c + 
	pop hl			;4c1c	e1 	. 
	ld (hl),e			;4c1d	73 	s 
	inc hl			;4c1e	23 	# 
	ld (hl),d			;4c1f	72 	r 
	inc hl			;4c20	23 	# 
	inc hl			;4c21	23 	# 
	inc hl			;4c22	23 	# 
	ld (hl),e			;4c23	73 	s 
	inc hl			;4c24	23 	# 
	ld (hl),d			;4c25	72 	r 
	ret			;4c26	c9 	. 
sub_4c27h:
	call GetLexem		;4c27	cd c3 2f 	. . / 
l4c2ah:
	call sub_4c4ah		;4c2a	cd 4a 4c 	. J L 
	ld de,0000ah		;4c2d	11 0a 00 	. . . 
	add hl,de			;4c30	19 	. 
	ld (hl),000h		;4c31	36 00 	6 . 
	inc hl			;4c33	23 	# 
	ld (hl),000h		;4c34	36 00 	6 . 
l4c36h:
	cp 0bbh		;4c36	fe bb 	. . 
	ret nz			;4c38	c0 	. 
	call GetLexem		;4c39	cd c3 2f 	. . / 
	or a			;4c3c	b7 	. 
	jr nz,l4c36h		;4c3d	20 f7 	  . 
	ld de,(TopOfHeapAddr__)		;4c3f	ed 5b 6e 2b 	. [ n + 
	inc de			;4c43	13 	. 
	inc de			;4c44	13 	. 
l4c45h:
	ld (hl),d			;4c45	72 	r 
	dec hl			;4c46	2b 	+ 
	ld (hl),e			;4c47	73 	s 
	jr l4c2ah		;4c48	18 e0 	. . 
sub_4c4ah:
	ld hl,(l2b63h)		;4c4a	2a 63 2b 	* c + 
	push hl			;4c4d	e5 	. 
	ld d,00fh		;4c4e	16 0f 	. . 
	ld hl,0000dh		;4c50	21 0d 00 	! . . 
	call sub_4d7ah		;4c53	cd 7a 4d 	. z M 
	ex (sp),hl			;4c56	e3 	. 
	ld (l2b63h),hl		;4c57	22 63 2b 	" c + 
	pop hl			;4c5a	e1 	. 
	ld b,(hl)			;4c5b	46 	F 
	dec hl			;4c5c	2b 	+ 
	ld c,(hl)			;4c5d	4e 	N 
	push de			;4c5e	d5 	. 
l4c5fh:
	ld de,(l2b63h)		;4c5f	ed 5b 63 2b 	. [ c + 
	ld (hl),e			;4c63	73 	s 
	inc hl			;4c64	23 	# 
	ld (hl),d			;4c65	72 	r 
	inc hl			;4c66	23 	# 
	ex de,hl			;4c67	eb 	. 
	add hl,bc			;4c68	09 	. 
	ld (l2b63h),hl		;4c69	22 63 2b 	" c + 
	ex de,hl			;4c6c	eb 	. 
	ld (hl),000h		;4c6d	36 00 	6 . 
	inc hl			;4c6f	23 	# 
	ld (hl),000h		;4c70	36 00 	6 . 
	inc hl			;4c72	23 	# 
	ld e,l			;4c73	5d 	] 
	ld d,h			;4c74	54 	T 
	inc de			;4c75	13 	. 
	inc de			;4c76	13 	. 
	inc de			;4c77	13 	. 
	inc de			;4c78	13 	. 
	ld (hl),e			;4c79	73 	s 
	inc hl			;4c7a	23 	# 
	ld (hl),d			;4c7b	72 	r 
	ld de,0fff5h		;4c7c	11 f5 ff 	. . . 
	add hl,de			;4c7f	19 	. 
	pop de			;4c80	d1 	. 
	or a			;4c81	b7 	. 
	sbc hl,de		;4c82	ed 52 	. R 
	add hl,de			;4c84	19 	. 
	ret z			;4c85	c8 	. 
	push de			;4c86	d5 	. 
	ld de,0000eh		;4c87	11 0e 00 	. . . 
	add hl,de			;4c8a	19 	. 
	push bc			;4c8b	c5 	. 
	call sub_4d6dh		;4c8c	cd 6d 4d 	. m M 
	ex de,hl			;4c8f	eb 	. 
	ld hl,(l2b7eh)		;4c90	2a 7e 2b 	* ~ + 
	ld bc,00006h		;4c93	01 06 00 	. . . 
	ldir		;4c96	ed b0 	. . 
	pop bc			;4c98	c1 	. 
	ex de,hl			;4c99	eb 	. 
	jr l4c5fh		;4c9a	18 c3 	. . 
l4c9ch:
	ld bc,00100h		;4c9c	01 00 01 	. . . 
	nop			;4c9f	00 	. 
	nop			;4ca0	00 	. 
	inc bc			;4ca1	03 	. 
	nop			;4ca2	00 	. 
	nop			;4ca3	00 	. 
	rst 38h			;4ca4	ff 	. 
	rst 38h			;4ca5	ff 	. 
	rst 38h			;4ca6	ff 	. 
l4ca7h:
	push hl			;4ca7	e5 	. 
	or a			;4ca8	b7 	. 
	jr z,l4cefh		;4ca9	28 44 	( D 
	cp 0a8h		;4cab	fe a8 	. . 
	jr z,l4d13h		;4cad	28 64 	( d 
	push hl			;4caf	e5 	. 
	call ParseConstVal		;4cb0	cd 79 34 	. y 4 
	pop de			;4cb3	d1 	. 
	ex de,hl			;4cb4	eb 	. 
l4cb5h:
	call ChkScalar		;4cb5	cd 4b 35 	. K 5 
	ld (hl),c			;4cb8	71 	q 
	inc hl			;4cb9	23 	# 
	ld (hl),b			;4cba	70 	p 
	inc hl			;4cbb	23 	# 
	ld (hl),e			;4cbc	73 	s 
	inc hl			;4cbd	23 	# 
	ld (hl),d			;4cbe	72 	r 
	inc hl			;4cbf	23 	# 
	push hl			;4cc0	e5 	. 
	push de			;4cc1	d5 	. 
	ld de,0ae25h		;4cc2	11 25 ae 	. % . 
	call ChkLexem_GetLex		;4cc5	cd 08 33 	. . 3 
	call ChkLexem_GetLex		;4cc8	cd 08 33 	. . 3 
	push bc			;4ccb	c5 	. 
	call ParseConstVal		;4ccc	cd 79 34 	. y 4 
	pop de			;4ccf	d1 	. 
	call ChkType__		;4cd0	cd ba 32 	. . 2 
	pop de			;4cd3	d1 	. 
	or a			;4cd4	b7 	. 
	sbc hl,de		;4cd5	ed 52 	. R 
	add hl,de			;4cd7	19 	. 
	ld e,027h		;4cd8	1e 27 	. ' 
	call m,CompileErr		;4cda	fc 3a 2f 	. : / 
	ex de,hl			;4cdd	eb 	. 
	pop hl			;4cde	e1 	. 
	ld (hl),e			;4cdf	73 	s 
	inc hl			;4ce0	23 	# 
	ld (hl),d			;4ce1	72 	r 
l4ce2h:
	inc hl			;4ce2	23 	# 
	dec c			;4ce3	0d 	. 
	ld bc,00002h		;4ce4	01 02 00 	. . . 
	jr z,l4ceah		;4ce7	28 01 	( . 
	dec c			;4ce9	0d 	. 
l4ceah:
	ld (hl),c			;4cea	71 	q 
	inc hl			;4ceb	23 	# 
	ld (hl),b			;4cec	70 	p 
	pop hl			;4ced	e1 	. 
	ret			;4cee	c9 	. 
l4cefh:
	call GetIdentInfoInABC		;4cef	cd 50 33 	. P 3 
	dec a			;4cf2	3d 	= 
	jr z,l4d09h		;4cf3	28 14 	( . 
l4cf5h:
	cp 002h		;4cf5	fe 02 	. . 
	ld e,01eh		;4cf7	1e 1e 	. . 
	call nz,CompileErr		;4cf9	c4 3a 2f 	. : / 
	dec hl			;4cfc	2b 	+ 
	dec hl			;4cfd	2b 	+ 
	pop de			;4cfe	d1 	. 
	push de			;4cff	d5 	. 
	ld bc,00008h		;4d00	01 08 00 	. . . 
	ldir		;4d03	ed b0 	. . 
	pop hl			;4d05	e1 	. 
	jp GetLexem		;4d06	c3 c3 2f 	. . / 
l4d09h:
	call GetLexem		;4d09	cd c3 2f 	. . / 
	ld e,(hl)			;4d0c	5e 	^ 
	inc hl			;4d0d	23 	# 
	ld d,(hl)			;4d0e	56 	V 
	pop hl			;4d0f	e1 	. 
	push hl			;4d10	e5 	. 
	jr l4cb5h		;4d11	18 a2 	. . 
l4d13h:
	xor a			;4d13	af 	. 
	ld (l2b80h),a		;4d14	32 80 2b 	2 . + 
	ld hl,l2b74h		;4d17	21 74 2b 	! t + 
	ld c,(hl)			;4d1a	4e 	N 
	inc (hl)			;4d1b	34 	4 
	ld b,000h		;4d1c	06 00 	. . 
l4d1eh:
	call GetLexem		;4d1e	cd c3 2f 	. . / 
	push bc			;4d21	c5 	. 
	ld de,00005h		;4d22	11 05 00 	. . . 
	call IdentToSymtab		;4d25	cd 0f 33 	. . 3 
	pop bc			;4d28	c1 	. 
	ld (hl),001h		;4d29	36 01 	6 . 
	inc hl			;4d2b	23 	# 
	ld (hl),c			;4d2c	71 	q 
	inc hl			;4d2d	23 	# 
	ld (hl),b			;4d2e	70 	p 
	inc hl			;4d2f	23 	# 
	ld a,(l2b80h)		;4d30	3a 80 2b 	: . + 
	ld (hl),a			;4d33	77 	w 
	inc a			;4d34	3c 	< 
	ld (l2b80h),a		;4d35	32 80 2b 	2 . + 
	inc hl			;4d38	23 	# 
	push hl			;4d39	e5 	. 
	call GetLexem		;4d3a	cd c3 2f 	. . / 
	cp 0ach		;4d3d	fe ac 	. . 
	jr z,l4d1eh		;4d3f	28 dd 	( . 
	call ChkCloBra_GetLex		;4d41	cd 05 33 	. . 3 
	ld d,a			;4d44	57 	W 
	ld a,(l2b80h)		;4d45	3a 80 2b 	: . + 
	ld b,a			;4d48	47 	G 
	dec a			;4d49	3d 	= 
l4d4ah:
	pop hl			;4d4a	e1 	. 
	ld (hl),a			;4d4b	77 	w 
	djnz l4d4ah		;4d4c	10 fc 	. . 
	pop hl			;4d4e	e1 	. 
	push hl			;4d4f	e5 	. 
	ld (hl),c			;4d50	71 	q 
	inc hl			;4d51	23 	# 
	ld (hl),b			;4d52	70 	p 
	inc hl			;4d53	23 	# 
	ld (hl),000h		;4d54	36 00 	6 . 
	inc hl			;4d56	23 	# 
	ld (hl),a			;4d57	77 	w 
	inc hl			;4d58	23 	# 
	ld (hl),a			;4d59	77 	w 
	inc hl			;4d5a	23 	# 
	ld (hl),a			;4d5b	77 	w 
	ld a,d			;4d5c	7a 	z 
	jr l4ce2h		;4d5d	18 83 	. . 
l4d5fh:
	push hl			;4d5f	e5 	. 
	or a			;4d60	b7 	. 
	ld e,02ch		;4d61	1e 2c 	. , 
	call nz,CompileErr		;4d63	c4 3a 2f 	. : / 
	call GetIdentInfoInABC		;4d66	cd 50 33 	. P 3 
	dec a			;4d69	3d 	= 
	jp l4cf5h		;4d6a	c3 f5 4c 	. . L 
sub_4d6dh:
	ld c,a			;4d6d	4f 	O 
l4d6eh:
	ld a,(hl)			;4d6e	7e 	~ 
	inc hl			;4d6f	23 	# 
	or a			;4d70	b7 	. 
	jp p,l4d6eh		;4d71	f2 6e 4d 	. n M 
	ld a,c			;4d74	79 	y 
	inc hl			;4d75	23 	# 
	ret			;4d76	c9 	. 
sub_4d77h:
	ld hl,0000ah		;4d77	21 0a 00 	! . . 
sub_4d7ah:
	push de			;4d7a	d5 	. 
	ex de,hl			;4d7b	eb 	. 
	ld hl,(TopOfHeapAddr__)		;4d7c	2a 6e 2b 	* n + 
	inc hl			;4d7f	23 	# 
	inc hl			;4d80	23 	# 
	ex (sp),hl			;4d81	e3 	. 
	push hl			;4d82	e5 	. 
l4d83h:
	push de			;4d83	d5 	. 
	call IdentToSymtab		;4d84	cd 0f 33 	. . 3 
	pop de			;4d87	d1 	. 
	pop af			;4d88	f1 	. 
	push af			;4d89	f5 	. 
	ld (hl),a			;4d8a	77 	w 
	call GetLexem		;4d8b	cd c3 2f 	. . / 
	cp 0bah		;4d8e	fe ba 	. . 
	jr z,l4d99h		;4d90	28 07 	( . 
	push de			;4d92	d5 	. 
	call ChkComma_GetLex		;4d93	cd f8 32 	. . 2 
	pop de			;4d96	d1 	. 
	jr l4d83h		;4d97	18 ea 	. . 
l4d99h:
	pop af			;4d99	f1 	. 
	call GetLexem		;4d9a	cd c3 2f 	. . / 
	inc hl			;4d9d	23 	# 
	pop de			;4d9e	d1 	. 
	push hl			;4d9f	e5 	. 
	push de			;4da0	d5 	. 
	call sub_4af1h		;4da1	cd f1 4a 	. . J 
	pop hl			;4da4	e1 	. 
	call sub_4d6dh		;4da5	cd 6d 4d 	. m M 
	ld (l2b7eh),hl		;4da8	22 7e 2b 	" ~ + 
	ex de,hl			;4dab	eb 	. 
	pop hl			;4dac	e1 	. 
	push hl			;4dad	e5 	. 
	ld bc,00008h		;4dae	01 08 00 	. . . 
	ldir		;4db1	ed b0 	. . 
	ex de,hl			;4db3	eb 	. 
	ld c,a			;4db4	4f 	O 
	ld a,(BlockLevel__)		;4db5	3a 72 2b 	: r + 
	ld (hl),a			;4db8	77 	w 
	ld a,c			;4db9	79 	y 
	dec hl			;4dba	2b 	+ 
	pop de			;4dbb	d1 	. 
	ret			;4dbc	c9 	. 
ParseVar:
	ld d,002h		;4dbd	16 02 	. . 
	call sub_4d77h		;4dbf	cd 77 4d 	. w M 
	ld b,(hl)			;4dc2	46 	F 
	dec hl			;4dc3	2b 	+ 
	ld c,(hl)			;4dc4	4e 	N 
sub_4dc5h:
	push de			;4dc5	d5 	. 
	ex de,hl			;4dc6	eb 	. 
l4dc7h:
	ld hl,(l2b61h)		;4dc7	2a 61 2b 	* a + 
	or a			;4dca	b7 	. 
	sbc hl,bc		;4dcb	ed 42 	. B 
	ld (l2b61h),hl		;4dcd	22 61 2b 	" a + 
	ex de,hl			;4dd0	eb 	. 
	ld (hl),e			;4dd1	73 	s 
	inc hl			;4dd2	23 	# 
	ld (hl),d			;4dd3	72 	r 
	ld de,0fff9h		;4dd4	11 f9 ff 	. . . 
	add hl,de			;4dd7	19 	. 
	pop de			;4dd8	d1 	. 
	or a			;4dd9	b7 	. 
	sbc hl,de		;4dda	ed 52 	. R 
	add hl,de			;4ddc	19 	. 
	ret z			;4ddd	c8 	. 
	push de			;4dde	d5 	. 
	ld de,0000bh		;4ddf	11 0b 00 	. . . 
	add hl,de			;4de2	19 	. 
	push bc			;4de3	c5 	. 
	call sub_4d6dh		;4de4	cd 6d 4d 	. m M 
	ex de,hl			;4de7	eb 	. 
	ld hl,(l2b7eh)		;4de8	2a 7e 2b 	* ~ + 
	ld bc,00009h		;4deb	01 09 00 	. . . 
	ldir		;4dee	ed b0 	. . 
	dec de			;4df0	1b 	. 
	dec de			;4df1	1b 	. 
	dec de			;4df2	1b 	. 
	pop bc			;4df3	c1 	. 
	jr l4dc7h		;4df4	18 d1 	. . 
sub_4df6h:
	ld e,03ah		;4df6	1e 3a 	. : 
	jp CompileErr		;4df8	c3 3a 2f 	. : / 
l4dfbh:
	ld de,00007h		;4dfb	11 07 00 	. . . 
	add hl,de			;4dfe	19 	. 
	ld d,(hl)			;4dff	56 	V 
	dec hl			;4e00	2b 	+ 
	ld e,(hl)			;4e01	5e 	^ 
	ld a,d			;4e02	7a 	z 
	or e			;4e03	b3 	. 
	call z,sub_4df6h		;4e04	cc f6 4d 	. . M 
	push hl			;4e07	e5 	. 
	call sub_3401h		;4e08	cd 01 34 	. . 4 
	call JCodeNextByte		;4e0b	cd d1 06 	. . . 
	defb 0e5h		;4e0e	e5 	. 
	pop hl			;4e0f	e1 	. 
	dec hl			;4e10	2b 	+ 
	dec hl			;4e11	2b 	+ 
	jr l4e31h		;4e12	18 1d 	. . 
l4e14h:
	cp 0aeh		;4e14	fe ae 	. . 
	jp nz,l4f70h		;4e16	c2 70 4f 	. p O 
	pop hl			;4e19	e1 	. 
	call GetLexem		;4e1a	cd c3 2f 	. . / 
	or a			;4e1d	b7 	. 
	ld e,037h		;4e1e	1e 37 	. 7 
	call nz,CompileErr		;4e20	c4 3a 2f 	. : / 
	call GetIdentInfoInABC		;4e23	cd 50 33 	. P 3 
	ld e,037h		;4e26	1e 37 	. 7 
	cp 00fh		;4e28	fe 0f 	. . 
	call nz,CompileErr		;4e2a	c4 3a 2f 	. : / 
	ld de,00004h		;4e2d	11 04 00 	. . . 
	add hl,de			;4e30	19 	. 
l4e31h:
	ld e,(hl)			;4e31	5e 	^ 
	inc hl			;4e32	23 	# 
	ld d,(hl)			;4e33	56 	V 
	ld bc,0fff9h		;4e34	01 f9 ff 	. . . 
	add hl,bc			;4e37	09 	. 
	push hl			;4e38	e5 	. 
	bit 1,(ix+001h)		;4e39	dd cb 01 4e 	. . . N 
	jr z,l4e4bh		;4e3d	28 0c 	( . 
	call sub_41bfh		;4e3f	cd bf 41 	. . A 
	exx			;4e42	d9 	. 
	inc hl			;4e43	23 	# 
	exx			;4e44	d9 	. 
l4e45h:
	add hl,de			;4e45	19 	. 
	call sub_3407h		;4e46	cd 07 34 	. . 4 
	jr l4e52h		;4e49	18 07 	. . 
l4e4bh:
	exx			;4e4b	d9 	. 
	dec hl			;4e4c	2b 	+ 
	exx			;4e4d	d9 	. 
	ex de,hl			;4e4e	eb 	. 
	call sub_418eh		;4e4f	cd 8e 41 	. . A 
l4e52h:
	call JCodeNextByte		;4e52	cd d1 06 	. . . 
l4e55h:
	defb 0e5h		;4e55	e5 	. 
	pop hl			;4e56	e1 	. 
	call GetLexem		;4e57	cd c3 2f 	. . / 
	ld c,(hl)			;4e5a	4e 	N 
	inc hl			;4e5b	23 	# 
	ld b,(hl)			;4e5c	46 	F 
	inc hl			;4e5d	23 	# 
l4e5eh:
	call sub_5045h		;4e5e	cd 45 50 	. E P 
l4e61h:
	bit 7,b		;4e61	cb 78 	. x 
	jr nz,l4e70h		;4e63	20 0b 	  . 
	ld e,a			;4e65	5f 	_ 
	ld d,000h		;4e66	16 00 	. . 
	ld a,b			;4e68	78 	x 
	cp 002h		;4e69	fe 02 	. . 
	ld a,e			;4e6b	7b 	{ 
	ret c			;4e6c	d8 	. 
	push bc			;4e6d	c5 	. 
	jr l4ec4h		;4e6e	18 54 	. T 
l4e70h:
	push bc			;4e70	c5 	. 
	push hl			;4e71	e5 	. 
	ld d,(ix+001h)		;4e72	dd 56 01 	. V . 
	push de			;4e75	d5 	. 
	ld d,000h		;4e76	16 00 	. . 
	ld c,001h		;4e78	0e 01 	. . 
	jp l500dh		;4e7a	c3 0d 50 	. . P 
sub_4e7dh:
	res 1,(ix+001h)		;4e7d	dd cb 01 8e 	. . . . 
	cp 002h		;4e81	fe 02 	. . 
	jr z,l4e92h		;4e83	28 0d 	( . 
	cp 00ah		;4e85	fe 0a 	. . 
	jp z,l4fe1h		;4e87	ca e1 4f 	. . O 
	cp 00fh		;4e8a	fe 0f 	. . 
	jp z,l4dfbh		;4e8c	ca fb 4d 	. . M 
	jp CompileErr		;4e8f	c3 3a 2f 	. : / 
l4e92h:
	call sub_5045h		;4e92	cd 45 50 	. E P 
	ld a,b			;4e95	78 	x 
	or a			;4e96	b7 	. 
	jp z,l4fa5h		;4e97	ca a5 4f 	. . O 
	dec a			;4e9a	3d 	= 
	push bc			;4e9b	c5 	. 
	jp z,l4fd0h		;4e9c	ca d0 4f 	. . O 
	bit 7,b		;4e9f	cb 78 	. x 
	jp nz,l4fffh		;4ea1	c2 ff 4f 	. . O 
	call sub_34fah		;4ea4	cd fa 34 	. . 4 
	jr z,l4eb6h		;4ea7	28 0d 	( . 
	sub b			;4ea9	90 	. 
	jr z,l4eb1h		;4eaa	28 05 	( . 
	call sub_3509h		;4eac	cd 09 35 	. . 5 
	jr l4ebdh		;4eaf	18 0c 	. . 
l4eb1h:
	call sub_3518h		;4eb1	cd 18 35 	. . 5 
	jr l4ebdh		;4eb4	18 07 	. . 
l4eb6h:
	call WLdHLnnIsDE		;4eb6	cd 08 34 	. . 4 
	set 1,(ix+001h)		;4eb9	dd cb 01 ce 	. . . . 
l4ebdh:
	call JCodeNextByte		;4ebd	cd d1 06 	. . . 
	defb 0e5h		;4ec0	e5 	. 
	call GetLexem		;4ec1	cd c3 2f 	. . / 
l4ec4h:
	pop hl			;4ec4	e1 	. 
	push hl			;4ec5	e5 	. 
	ld d,a			;4ec6	57 	W 
	ld a,h			;4ec7	7c 	| 
	cp 002h		;4ec8	fe 02 	. . 
	jr z,l4ecfh		;4eca	28 03 	( . 
	inc hl			;4ecc	23 	# 
	ld a,(hl)			;4ecd	7e 	~ 
	or a			;4ece	b7 	. 
l4ecfh:
	ld a,d			;4ecf	7a 	z 
	jp nz,l4e14h		;4ed0	c2 14 4e 	. . N 
	cp 0dbh		;4ed3	fe db 	. . 
	jp nz,l4f70h		;4ed5	c2 70 4f 	. p O 
l4ed8h:
	pop hl			;4ed8	e1 	. 
	ld a,h			;4ed9	7c 	| 
	cp 002h		;4eda	fe 02 	. . 
	jp z,l4f74h		;4edc	ca 74 4f 	. t O 
	call GetLexem		;4edf	cd c3 2f 	. . / 
l4ee2h:
	ld c,(hl)			;4ee2	4e 	N 
	inc hl			;4ee3	23 	# 
	ld b,(hl)			;4ee4	46 	F 
	inc hl			;4ee5	23 	# 
	push hl			;4ee6	e5 	. 
	ld d,(ix+001h)		;4ee7	dd 56 01 	. V . 
	push de			;4eea	d5 	. 
	call sub_3f13h		;4eeb	cd 13 3f 	. . ? 
	res 3,(ix+002h)		;4eee	dd cb 02 9e 	. . . . 
	pop de			;4ef2	d1 	. 
	res 1,d		;4ef3	cb 8a 	. . 
	ld (ix+001h),d		;4ef5	dd 72 01 	. r . 
	dec c			;4ef8	0d 	. 
	jr z,l4f01h		;4ef9	28 06 	( . 
	ld hl,l4379h		;4efb	21 79 43 	! y C 
	call sub_33c4h		;4efe	cd c4 33 	. . 3 
l4f01h:
	exx			;4f01	d9 	. 
	dec hl			;4f02	2b 	+ 
	exx			;4f03	d9 	. 
	pop hl			;4f04	e1 	. 
	push af			;4f05	f5 	. 
	ld e,(hl)			;4f06	5e 	^ 
	inc hl			;4f07	23 	# 
	ld d,(hl)			;4f08	56 	V 
	inc hl			;4f09	23 	# 
	push hl			;4f0a	e5 	. 
	xor a			;4f0b	af 	. 
	cp c			;4f0c	b9 	. 
	push af			;4f0d	f5 	. 
	jr z,l4f11h		;4f0e	28 01 	( . 
	ld d,a			;4f10	57 	W 
l4f11h:
	xor a			;4f11	af 	. 
	push de			;4f12	d5 	. 
	ld h,a			;4f13	67 	g 
	ld l,a			;4f14	6f 	o 
	sbc hl,de		;4f15	ed 52 	. R 
	call sub_418eh		;4f17	cd 8e 41 	. . A 
	pop de			;4f1a	d1 	. 
	pop af			;4f1b	f1 	. 
	pop hl			;4f1c	e1 	. 
	ld c,(hl)			;4f1d	4e 	N 
	inc hl			;4f1e	23 	# 
	ld b,(hl)			;4f1f	46 	F 
	inc hl			;4f20	23 	# 
	jr z,l4f24h		;4f21	28 01 	( . 
	ld b,a			;4f23	47 	G 
l4f24h:
	bit 5,(ix+000h)		;4f24	dd cb 00 6e 	. . . n 
	jr z,l4f44h		;4f28	28 1a 	( . 
	push hl			;4f2a	e5 	. 
	ld hl,l524eh		;4f2b	21 4e 52 	! N R 
	push de			;4f2e	d5 	. 
	call WCode		;4f2f	cd cc 33 	. . 3 
	ld h,b			;4f32	60 	` 
	ld l,c			;4f33	69 	i 
	pop bc			;4f34	c1 	. 
	or a			;4f35	b7 	. 
	sbc hl,bc		;4f36	ed 42 	. B 
	ex de,hl			;4f38	eb 	. 
	inc de			;4f39	13 	. 
	call sub_33fbh		;4f3a	cd fb 33 	. . 3 
	ld hl,l5254h		;4f3d	21 54 52 	! T R 
	call WCode		;4f40	cd cc 33 	. . 3 
l4f43h:
	pop hl			;4f43	e1 	. 
l4f44h:
	ld bc,00006h		;4f44	01 06 00 	. . . 
l4f47h:
	add hl,bc			;4f47	09 	. 
	ld e,(hl)			;4f48	5e 	^ 
	inc hl			;4f49	23 	# 
	ld d,(hl)			;4f4a	56 	V 
	ld bc,0fff9h		;4f4b	01 f9 ff 	. . . 
l4f4eh:
	add hl,bc			;4f4e	09 	. 
	push hl			;4f4f	e5 	. 
	ld hl,l5246h		;4f50	21 46 52 	! F R 
	call sub_4295h		;4f53	cd 95 42 	. . B 
	ld hl,l524ah		;4f56	21 4a 52 	! J R 
	call WCode		;4f59	cd cc 33 	. . 3 
	pop hl			;4f5c	e1 	. 
	ld c,(hl)			;4f5d	4e 	N 
	inc hl			;4f5e	23 	# 
	ld b,(hl)			;4f5f	46 	F 
	inc hl			;4f60	23 	# 
	pop af			;4f61	f1 	. 
	cp 0ach		;4f62	fe ac 	. . 
	jr z,l4f6ch		;4f64	28 06 	( . 
	call ChkCloSqBra_GetLex		;4f66	cd f3 32 	. . 2 
	jp l4e5eh		;4f69	c3 5e 4e 	. ^ N 
l4f6ch:
	push bc			;4f6c	c5 	. 
	jp l4ed8h		;4f6d	c3 d8 4e 	. . N 
l4f70h:
	pop bc			;4f70	c1 	. 
	ld d,000h		;4f71	16 00 	. . 
	ret			;4f73	c9 	. 
l4f74h:
	push hl			;4f74	e5 	. 
	call sub_3f0dh		;4f75	cd 0d 3f 	. . ? 
	exx			;4f78	d9 	. 
	dec hl			;4f79	2b 	+ 
	exx			;4f7a	d9 	. 
	call JCodeNextByte		;4f7b	cd d1 06 	. . . 
	defb 02bh		;4f7e	2b 	+ 
	pop bc			;4f7f	c1 	. 
	bit 5,(ix+000h)		;4f80	dd cb 00 6e 	. . . n 
	jr z,l4f96h		;4f84	28 10 	( . 
	ld hl,l525ch		;4f86	21 5c 52 	! \ R 
	call WCode		;4f89	cd cc 33 	. . 3 
	ld e,c			;4f8c	59 	Y 
	call l381ah		;4f8d	cd 1a 38 	. . 8 
	ld hl,05267h		;4f90	21 67 52 	! g R 
	call WCode		;4f93	cd cc 33 	. . 3 
l4f96h:
	ld hl,l524ah		;4f96	21 4a 52 	! J R 
	call WCode		;4f99	cd cc 33 	. . 3 
	call ChkCloSqBra_GetLex		;4f9c	cd f3 32 	. . 2 
	ld d,000h		;4f9f	16 00 	. . 
	ld bc,00003h		;4fa1	01 03 00 	. . . 
	ret			;4fa4	c9 	. 
l4fa5h:
	call sub_34fah		;4fa5	cd fa 34 	. . 4 
	jr z,l4fcah		;4fa8	28 20 	(   
sub_4faah:
	sub b			;4faa	90 	. 
	ld b,000h		;4fab	06 00 	. . 
	jr z,l4fbah		;4fad	28 0b 	( . 
l4fafh:
	call sub_3509h		;4faf	cd 09 35 	. . 5 
l4fb2h:
	ld d,000h		;4fb2	16 00 	. . 
	call JCodeNextByte		;4fb4	cd d1 06 	. . . 
	defb 0e5h		;4fb7	e5 	. 
	jr l4fc2h		;4fb8	18 08 	. . 
l4fbah:
	call sub_3526h		;4fba	cd 26 35 	. & 5 
	jr nc,l4fc5h		;4fbd	30 06 	0 . 
	ld h,002h		;4fbf	26 02 	& . 
l4fc1h:
	ex de,hl			;4fc1	eb 	. 
l4fc2h:
	jp GetLexem		;4fc2	c3 c3 2f 	. . / 
l4fc5h:
	call sub_3518h		;4fc5	cd 18 35 	. . 5 
	jr l4fb2h		;4fc8	18 e8 	. . 
l4fcah:
	ld b,000h		;4fca	06 00 	. . 
	ld h,001h		;4fcc	26 01 	& . 
	jr l4fc1h		;4fce	18 f1 	. . 
l4fd0h:
	call sub_34fah		;4fd0	cd fa 34 	. . 4 
	jr z,l4fdbh		;4fd3	28 06 	( . 
	sub b			;4fd5	90 	. 
	pop bc			;4fd6	c1 	. 
	jr z,l4fc5h		;4fd7	28 ec 	( . 
	jr l4fafh		;4fd9	18 d4 	. . 
l4fdbh:
	call WLdHLnnIsDE		;4fdb	cd 08 34 	. . 4 
	pop bc			;4fde	c1 	. 
	jr l4fb2h		;4fdf	18 d1 	. . 
l4fe1h:
	push bc			;4fe1	c5 	. 
	call sub_5045h		;4fe2	cd 45 50 	. E P 
	push hl			;4fe5	e5 	. 
	ld d,(ix+001h)		;4fe6	dd 56 01 	. V . 
	push de			;4fe9	d5 	. 
	ld c,001h		;4fea	0e 01 	. . 
	res 0,(ix+001h)		;4fec	dd cb 01 86 	. . . . 
	call l4fa5h		;4ff0	cd a5 4f 	. . O 
	call sub_457dh		;4ff3	cd 7d 45 	. } E 
	pop de			;4ff6	d1 	. 
	ld (ix+001h),d		;4ff7	dd 72 01 	. r . 
	pop hl			;4ffa	e1 	. 
	pop bc			;4ffb	c1 	. 
l4ffch:
	jp l4e61h		;4ffc	c3 61 4e 	. a N 
l4fffh:
	push hl			;4fff	e5 	. 
l5000h:
	ld d,(ix+001h)		;5000	dd 56 01 	. V . 
	push de			;5003	d5 	. 
	ld c,001h		;5004	0e 01 	. . 
	res 0,(ix+001h)		;5006	dd cb 01 86 	. . . . 
	call l4fa5h		;500a	cd a5 4f 	. . O 
l500dh:
	cp 0deh		;500d	fe de 	. . 
	jr nz,l5021h		;500f	20 10 	  . 
	call sub_457dh		;5011	cd 7d 45 	. } E 
	pop de			;5014	d1 	. 
	ld (ix+001h),d		;5015	dd 72 01 	. r . 
	pop hl			;5018	e1 	. 
	pop bc			;5019	c1 	. 
	call GetLexem		;501a	cd c3 2f 	. . / 
	res 7,b		;501d	cb b8 	. . 
	jr l4ffch		;501f	18 db 	. . 
l5021h:
	pop bc			;5021	c1 	. 
	pop bc			;5022	c1 	. 
	pop bc			;5023	c1 	. 
	ret			;5024	c9 	. 
	ld e,041h		;5025	1e 41 	. A 
sub_5027h:
	or a			;5027	b7 	. 
	jp nz,CompileErr		;5028	c2 3a 2f 	. : / 
	push de			;502b	d5 	. 
	call GetIdentInfoInABC		;502c	cd 50 33 	. P 3 
	pop de			;502f	d1 	. 
	call sub_4e7dh		;5030	cd 7d 4e 	. } N 
	dec d			;5033	15 	. 
	ret m			;5034	f8 	. 
	ex de,hl			;5035	eb 	. 
	jr z,l5040h		;5036	28 08 	( . 
	call sub_3518h		;5038	cd 18 35 	. . 5 
l503bh:
	call JCodeNextByte		;503b	cd d1 06 	. . . 
	defb 0e5h		;503e	e5 	. 
	ret			;503f	c9 	. 
l5040h:
	call WLdHLnnIsDE		;5040	cd 08 34 	. . 4 
	jr l503bh		;5043	18 f6 	. . 
sub_5045h:
	push bc			;5045	c5 	. 
	res 7,b		;5046	cb b8 	. . 
	ld e,(hl)			;5048	5e 	^ 
	inc hl			;5049	23 	# 
	ld d,(hl)			;504a	56 	V 
	dec hl			;504b	2b 	+ 
	dec b			;504c	05 	. 
	jr z,l505dh		;504d	28 0e 	( . 
	ld (Merker1),de		;504f	ed 53 87 2b 	. S . + 
	inc b			;5053	04 	. 
	pop bc			;5054	c1 	. 
	ret nz			;5055	c0 	. 
	ld e,a			;5056	5f 	_ 
	ld a,d			;5057	7a 	z 
	ld (l2b8bh+1),a		;5058	32 8c 2b 	2 . + 
	ld a,e			;505b	7b 	{ 
	ret			;505c	c9 	. 
l505dh:
	inc b			;505d	04 	. 
	ld (l2b89h),bc		;505e	ed 43 89 2b 	. C . + 
	pop bc			;5062	c1 	. 
	ld e,a			;5063	5f 	_ 
	ld a,d			;5064	7a 	z 
	dec c			;5065	0d 	. 
	jr nz,l506ah		;5066	20 02 	  . 
	ld a,0ffh		;5068	3e ff 	> . 
l506ah:
	inc c			;506a	0c 	. 
	srl a		;506b	cb 3f 	. ? 
	srl a		;506d	cb 3f 	. ? 
	srl a		;506f	cb 3f 	. ? 
	ld (l2b8bh),a		;5071	32 8b 2b 	2 . + 
	ld a,e			;5074	7b 	{ 
	ret			;5075	c9 	. 
	ld hl,l508eh		;5076	21 8e 50 	! . P 
	jr l507eh		;5079	18 03 	. . 
	ld hl,l5096h		;507b	21 96 50 	! . P 
l507eh:
	push hl			;507e	e5 	. 
	call NextChkOpBra_GetLex		;507f	cd fd 32 	. . 2 
	ld e,045h		;5082	1e 45 	. E 
	call sub_5027h		;5084	cd 27 50 	. ' P 
	call ChkCloBra_GetLex		;5087	cd 05 33 	. . 3 
	pop hl			;508a	e1 	. 
	jp sub_33c4h		;508b	c3 c4 33 	. . 3 
l508eh:
	rlca			;508e	07 	. 
	ld de,(l178bh)		;508f	ed 5b 8b 17 	. [ . . 
	ld (hl),e			;5093	73 	s 
	inc hl			;5094	23 	# 
	ld (hl),d			;5095	72 	r 
l5096h:
	rlca			;5096	07 	. 
	ld e,(hl)			;5097	5e 	^ 
	inc hl			;5098	23 	# 
	ld d,(hl)			;5099	56 	V 
	ld (l178bh),de		;509a	ed 53 8b 17 	. S . . 
	call NextChkOpBra_GetLex		;509e	cd fd 32 	. . 2 
	ld e,045h		;50a1	1e 45 	. E 
	call sub_5027h		;50a3	cd 27 50 	. ' P 
	bit 7,b		;50a6	cb 78 	. x 
	ld e,045h		;50a8	1e 45 	. E 
	jp z,CompileErr		;50aa	ca 3a 2f 	. : / 
	res 7,b		;50ad	cb b8 	. . 
	call sub_50c9h		;50af	cd c9 50 	. . P 
	call JCodeNextByte		;50b2	cd d1 06 	. . . 
	defb 001h		;50b5	01 	. 
	or a			;50b6	b7 	. 
	ld hl,00000h		;50b7	21 00 00 	! . . 
	sbc hl,de		;50ba	ed 52 	. R 
	ex de,hl			;50bc	eb 	. 
	call StoreDE		;50bd	cd 0c 34 	. . 4 
	ld hl,l5242h		;50c0	21 42 52 	! B R 
	call WCode		;50c3	cd cc 33 	. . 3 
	jp ChkCloBra_GetLex		;50c6	c3 05 33 	. . 3 
sub_50c9h:
	exx			;50c9	d9 	. 
	dec hl			;50ca	2b 	+ 
	exx			;50cb	d9 	. 
	ld d,a			;50cc	57 	W 
	ld a,b			;50cd	78 	x 
	dec b			;50ce	05 	. 
	jr z,l50dah		;50cf	28 09 	( . 
	inc b			;50d1	04 	. 
	ld a,d			;50d2	7a 	z 
	jr z,l50e3h		;50d3	28 0e 	( . 
	ld de,(Merker1)		;50d5	ed 5b 87 2b 	. [ . + 
	ret			;50d9	c9 	. 
l50dah:
	ld a,d			;50da	7a 	z 
	ld de,(l2b8bh)		;50db	ed 5b 8b 2b 	. [ . + 
	ld d,000h		;50df	16 00 	. . 
	inc e			;50e1	1c 	. 
	ret			;50e2	c9 	. 
l50e3h:
	ld de,00002h		;50e3	11 02 00 	. . . 
	dec c			;50e6	0d 	. 
	ret z			;50e7	c8 	. 
	dec e			;50e8	1d 	. 
	dec c			;50e9	0d 	. 
	ret nz			;50ea	c0 	. 
	ld e,004h		;50eb	1e 04 	. . 
	ret			;50ed	c9 	. 
	call sub_5105h		;50ee	cd 05 51 	. . Q 
	ld hl,l5235h		;50f1	21 35 52 	! 5 R 
l50f4h:
	call sub_33c4h		;50f4	cd c4 33 	. . 3 
	jp ChkCloBra_GetLex		;50f7	c3 05 33 	. . 3 
	call sub_5105h		;50fa	cd 05 51 	. . Q 
	call sub_510eh		;50fd	cd 0e 51 	. . Q 
	ld hl,l523ah		;5100	21 3a 52 	! : R 
	jr l50f4h		;5103	18 ef 	. . 
sub_5105h:
	call NextChkOpBra_GetLex		;5105	cd fd 32 	. . 2 
	ld bc,l0208h		;5108	01 08 02 	. . . 
	call sub_3f29h		;510b	cd 29 3f 	. ) ? 
sub_510eh:
	call ChkComma_GetLex		;510e	cd f8 32 	. . 2 
	jp sub_3f10h		;5111	c3 10 3f 	. . ? 
sub_5114h:
	call NextChkOpBra_GetLex		;5114	cd fd 32 	. . 2 
	call sub_3f10h		;5117	cd 10 3f 	. . ? 
	jr l5130h		;511a	18 14 	. . 
sub_511ch:
	call NextChkOpBra_GetLex		;511c	cd fd 32 	. . 2 
	call sub_3f10h		;511f	cd 10 3f 	. . ? 
	jr l512dh		;5122	18 09 	. . 
sub_5124h:
	call NextChkOpBra_GetLex		;5124	cd fd 32 	. . 2 
	call sub_3f10h		;5127	cd 10 3f 	. . ? 
	call sub_510eh		;512a	cd 0e 51 	. . Q 
l512dh:
	call sub_510eh		;512d	cd 0e 51 	. . Q 
l5130h:
	call sub_510eh		;5130	cd 0e 51 	. . Q 
	jp ChkCloBra_GetLex		;5133	c3 05 33 	. . 3 
	call sub_5114h		;5136	cd 14 51 	. . Q 
	ld hl,l513fh		;5139	21 3f 51 	! ? Q 
	jp sub_33c4h		;513c	c3 c4 33 	. . 3 
l513fh:
	ld a,(bc)			;513f	0a 	. 
	ld (l178fh),hl		;5140	22 8f 17 	" . . 
	pop hl			;5143	e1 	. 
	ld (l178dh),hl		;5144	22 8d 17 	" . . 
	call sub_04e6h		;5147	cd e6 04 	. . . 
	call sub_5114h		;514a	cd 14 51 	. . Q 
	ld hl,l5153h		;514d	21 53 51 	! S Q 
	jp sub_33c4h		;5150	c3 c4 33 	. . 3 
l5153h:
	rlca			;5153	07 	. 
	ld (l178dh),hl		;5154	22 8d 17 	" . . 
	pop hl			;5157	e1 	. 
	call sub_0655h		;5158	cd 55 06 	. U . 
	inc b			;515b	04 	. 
	call sub_066ah		;515c	cd 6a 06 	. j . 
	push hl			;515f	e5 	. 
	call sub_5114h		;5160	cd 14 51 	. . Q 
	ld hl,l5169h		;5163	21 69 51 	! i Q 
	jp sub_33c4h		;5166	c3 c4 33 	. . 3 
l5169h:
	ld a,(bc)			;5169	0a 	. 
	ld (l178fh),hl		;516a	22 8f 17 	" . . 
	pop hl			;516d	e1 	. 
	ld (l178dh),hl		;516e	22 8d 17 	" . . 
	call sub_0502h		;5171	cd 02 05 	. . . 
	call sub_5114h		;5174	cd 14 51 	. . Q 
	ld hl,l517dh		;5177	21 7d 51 	! } Q 
	jp sub_33c4h		;517a	c3 c4 33 	. . 3 
l517dh:
	ld a,(bc)			;517d	0a 	. 
	ld (l178fh),hl		;517e	22 8f 17 	" . . 
	pop hl			;5181	e1 	. 
	ld (l178dh),hl		;5182	22 8d 17 	" . . 
	call sub_0527h		;5185	cd 27 05 	. ' . 
	dec bc			;5188	0b 	. 
	ld (l178fh),hl		;5189	22 8f 17 	" . . 
	pop hl			;518c	e1 	. 
	ld (l178dh),hl		;518d	22 8d 17 	" . . 
	call sub_0590h		;5190	cd 90 05 	. . . 
	push af			;5193	f5 	. 
	dec bc			;5194	0b 	. 
	ld (l178fh),hl		;5195	22 8f 17 	" . . 
	pop hl			;5198	e1 	. 
	ld (l178dh),hl		;5199	22 8d 17 	" . . 
	call sub_0553h		;519c	cd 53 05 	. S . 
	push hl			;519f	e5 	. 
	call sub_5114h		;51a0	cd 14 51 	. . Q 
	ld hl,l51a9h		;51a3	21 a9 51 	! . Q 
	jp sub_33c4h		;51a6	c3 c4 33 	. . 3 
l51a9h:
	ld a,(bc)			;51a9	0a 	. 
	ld (l178fh),hl		;51aa	22 8f 17 	" . . 
	pop hl			;51ad	e1 	. 
	ld (l178dh),hl		;51ae	22 8d 17 	" . . 
	call sub_05c7h		;51b1	cd c7 05 	. . . 
	call sub_5124h		;51b4	cd 24 51 	. $ Q 
	ld hl,l51bdh		;51b7	21 bd 51 	! . Q 
	jp sub_33c4h		;51ba	c3 c4 33 	. . 3 
l51bdh:
	ld (de),a			;51bd	12 	. 
	ld (l1793h),hl		;51be	22 93 17 	" . . 
	pop hl			;51c1	e1 	. 
	ld (l1791h),hl		;51c2	22 91 17 	" . . 
	pop hl			;51c5	e1 	. 
	ld (l178fh),hl		;51c6	22 8f 17 	" . . 
	pop hl			;51c9	e1 	. 
	ld (l178dh),hl		;51ca	22 8d 17 	" . . 
	call sub_05ebh		;51cd	cd eb 05 	. . . 
	call sub_511ch		;51d0	cd 1c 51 	. . Q 
	ld hl,l51d9h		;51d3	21 d9 51 	! . Q 
	jp sub_33c4h		;51d6	c3 c4 33 	. . 3 
l51d9h:
	ld c,022h		;51d9	0e 22 	. " 
	sub c			;51db	91 	. 
	rla			;51dc	17 	. 
	pop hl			;51dd	e1 	. 
	ld (l178fh),hl		;51de	22 8f 17 	" . . 
	pop hl			;51e1	e1 	. 
	ld (l178dh),hl		;51e2	22 8d 17 	" . . 
	call sub_0623h		;51e5	cd 23 06 	. # . 
	inc b			;51e8	04 	. 
	call GetKey		;51e9	cd 81 02 	. . . 
	push af			;51ec	f5 	. 
	add hl,bc			;51ed	09 	. 
	ex de,hl			;51ee	eb 	. 
	pop hl			;51ef	e1 	. 
	ld a,l			;51f0	7d 	} 
	and e			;51f1	a3 	. 
	ld l,a			;51f2	6f 	o 
	ld a,h			;51f3	7c 	| 
	and d			;51f4	a2 	. 
	ld h,a			;51f5	67 	g 
	push hl			;51f6	e5 	. 
	add hl,bc			;51f7	09 	. 
	ex de,hl			;51f8	eb 	. 
	pop hl			;51f9	e1 	. 
	ld a,l			;51fa	7d 	} 
	or e			;51fb	b3 	. 
	ld l,a			;51fc	6f 	o 
	ld a,h			;51fd	7c 	| 
	or d			;51fe	b2 	. 
	ld h,a			;51ff	67 	g 
	push hl			;5200	e5 	. 
	add hl,bc			;5201	09 	. 
	ex de,hl			;5202	eb 	. 
	pop hl			;5203	e1 	. 
	ld a,l			;5204	7d 	} 
	xor e			;5205	ab 	. 
	ld l,a			;5206	6f 	o 
	ld a,h			;5207	7c 	| 
	xor d			;5208	aa 	. 
	ld h,a			;5209	67 	g 
	push hl			;520a	e5 	. 
	inc b			;520b	04 	. 
	ld l,h			;520c	6c 	l 
	ld h,000h		;520d	26 00 	& . 
	push hl			;520f	e5 	. 
	inc bc			;5210	03 	. 
	ld h,000h		;5211	26 00 	& . 
	push hl			;5213	e5 	. 
	inc b			;5214	04 	. 
	ld a,h			;5215	7c 	| 
	ld h,l			;5216	65 	e 
	ld l,a			;5217	6f 	o 
	push hl			;5218	e5 	. 
	dec c			;5219	0d 	. 
	ld a,l			;521a	7d 	} 
	pop hl			;521b	e1 	. 
	or a			;521c	b7 	. 
	jr z,l5226h		;521d	28 07 	( . 
	ld b,a			;521f	47 	G 
l5220h:
	srl h		;5220	cb 3c 	. < 
	rr l		;5222	cb 1d 	. . 
	djnz l5220h		;5224	10 fa 	. . 
l5226h:
	push hl			;5226	e5 	. 
	dec c			;5227	0d 	. 
	ld a,l			;5228	7d 	} 
	pop hl			;5229	e1 	. 
	or a			;522a	b7 	. 
	jr z,l5234h		;522b	28 07 	( . 
	ld b,a			;522d	47 	G 
l522eh:
	sla l		;522e	cb 25 	. % 
	rl h		;5230	cb 14 	. . 
	djnz l522eh		;5232	10 fa 	. . 
l5234h:
	push hl			;5234	e5 	. 
l5235h:
	inc b			;5235	04 	. 
	pop de			;5236	d1 	. 
	call LoadSrcFile		;5237	cd b8 07 	. . . 
l523ah:
	rlca			;523a	07 	. 
	ld c,l			;523b	4d 	M 
	ld b,h			;523c	44 	D 
	pop hl			;523d	e1 	. 
	pop de			;523e	d1 	. 
	call SaveSrcFile		;523f	cd a5 07 	. . . 
l5242h:
	inc bc			;5242	03 	. 
	call sub_0c87h		;5243	cd 87 0c 	. . . 
l5246h:
	inc bc			;5246	03 	. 
	call Mul8x8		;5247	cd bc 09 	. . . 
l524ah:
	inc bc			;524a	03 	. 
	pop de			;524b	d1 	. 
	add hl,de			;524c	19 	. 
	push hl			;524d	e5 	. 
l524eh:
	dec b			;524e	05 	. 
	bit 7,h		;524f	cb 7c 	. | 
	call nz,ErrIdxLow		;5251	c4 06 09 	. . . 
l5254h:
	rlca			;5254	07 	. 
	or a			;5255	b7 	. 
	sbc hl,de		;5256	ed 52 	. R 
	add hl,de			;5258	19 	. 
	call p,ErrIdxHigh		;5259	f4 0b 09 	. . . 
l525ch:
	ld a,(bc)			;525c	0a 	. 
	ld a,h			;525d	7c 	| 
	or a			;525e	b7 	. 
	call m,ErrIdxLow		;525f	fc 06 09 	. . . 
	call nz,ErrIdxHigh		;5262	c4 0b 09 	. . . 
	ld a,l			;5265	7d 	} 
	cp 003h		;5266	fe 03 	. . 
	call nc,ErrIdxHigh		;5268	d4 0b 09 	. . . 
	call NextChkOpBra_GetLex		;526b	cd fd 32 	. . 2 
	ld e,03fh		;526e	1e 3f 	. ? 
	call sub_5027h		;5270	cd 27 50 	. ' P 
	call sub_50c9h		;5273	cd c9 50 	. . P 
	call WLdHLnnIsDE		;5276	cd 08 34 	. . 4 
	call JCodeNextByte		;5279	cd d1 06 	. . . 
	defb 0e5h		;527c	e5 	. 
	jr l5287h		;527d	18 08 	. . 
	call NextChkOpBra_GetLex		;527f	cd fd 32 	. . 2 
	ld e,046h		;5282	1e 46 	. F 
	call sub_5027h		;5284	cd 27 50 	. ' P 
l5287h:
	ld bc,00001h		;5287	01 01 00 	. . . 
	call ChkCloBra_GetLex		;528a	cd 05 33 	. . 3 
	jp l45a0h		;528d	c3 a0 45 	. . E 
	call NextChkOpBra_GetLex		;5290	cd fd 32 	. . 2 
	call sub_3f10h		;5293	cd 10 3f 	. . ? 
	call ChkComma_GetLex		;5296	cd f8 32 	. . 2 
	ld bc,00003h		;5299	01 03 00 	. . . 
	call sub_3f13h		;529c	cd 13 3f 	. . ? 
	call ChkCloBra_GetLex		;529f	cd 05 33 	. . 3 
	ld hl,l52a8h		;52a2	21 a8 52 	! . R 
	jp sub_33c4h		;52a5	c3 c4 33 	. . 3 
l52a8h:
	inc bc			;52a8	03 	. 
	pop bc			;52a9	c1 	. 
	out (c),a		;52aa	ed 79 	. y 
	dec b			;52ac	05 	. 
	ld c,l			;52ad	4d 	M 
l52aeh:
	ld b,h			;52ae	44 	D 
	in a,(c)		;52af	ed 78 	. x 
	push af			;52b1	f5 	. 
	add hl,bc			;52b2	09 	. 
	call KbdStat		;52b3	cd 57 07 	. W . 
	or a			;52b6	b7 	. 
	jr z,l52bbh		;52b7	28 02 	( . 
	ld a,001h		;52b9	3e 01 	> . 
l52bbh:
	push af			;52bb	f5 	. 
	inc bc			;52bc	03 	. 
	call sub_0c25h		;52bd	cd 25 0c 	. % . 
	inc b			;52c0	04 	. 
	ld a,l			;52c1	7d 	} 
	and 001h		;52c2	e6 01 	. . 
	push af			;52c4	f5 	. 
	inc b			;52c5	04 	. 
	call sub_0e8fh		;52c6	cd 8f 0e 	. . . 
	push hl			;52c9	e5 	. 
	inc bc			;52ca	03 	. 
	call PrHalt		;52cb	cd 27 09 	. ' . 
l52ceh:
	ld (bc),a			;52ce	02 	. 
	ld a,l			;52cf	7d 	} 
	push af			;52d0	f5 	. 
	inc b			;52d1	04 	. 
	call IsEOL		;52d2	cd 5e 0a 	. ^ . 
	push af			;52d5	f5 	. 
	dec b			;52d6	05 	. 
	ld a,00ch		;52d7	3e 0c 	> . 
	call OutChr		;52d9	cd 29 07 	. ) . 
	ld b,05dh		;52dc	06 5d 	. ] 
	ld d,h			;52de	54 	T 
	call Mul16x8sgn		;52df	cd dc 09 	. . . 
	push hl			;52e2	e5 	. 
	inc b			;52e3	04 	. 
	call AbsHL		;52e4	cd 0e 0a 	. . . 
	push hl			;52e7	e5 	. 
	dec b			;52e8	05 	. 
	call RealSqrt__		;52e9	cd 53 0d 	. S . 
	push hl			;52ec	e5 	. 
	push de			;52ed	d5 	. 
	inc b			;52ee	04 	. 
	res 7,h		;52ef	cb bc 	. . 
	push hl			;52f1	e5 	. 
	push de			;52f2	d5 	. 
StartPASSrc:
	nop			;52f3	00 	. 
	nop			;52f4	00 	. 
	nop			;52f5	00 	. 
	nop			;52f6	00 	. 
	nop			;52f7	00 	. 
	nop			;52f8	00 	. 
	nop			;52f9	00 	. 
	nop			;52fa	00 	. 
	nop			;52fb	00 	. 
	nop			;52fc	00 	. 
	nop			;52fd	00 	. 
	nop			;52fe	00 	. 
	nop			;52ff	00 	. 
PasEx:
	ld hl,00000h		;5300	21 00 00 	! . . 
	ld b,080h		;5303	06 80 	. . 
PXSrchProlog:
	ld a,(hl)			;5305	7e 	~ 
	cp 07fh		;5306	fe 7f 	.  
	inc hl			;5308	23 	# 
l5309h:
	jr z,PXKillProlog		;5309	28 04 	( . 
	djnz PXSrchProlog		;530b	10 f8 	. . 
	jr PXCpChrMap		;530d	18 02 	. . 
PXKillProlog:
	ld (hl),000h		;530f	36 00 	6 . 
PXCpChrMap:
	ld hl,(CCTL0)		;5311	2a a6 b7 	* . . 
	ld de,0ba00h		;5314	11 00 ba 	. . . 
	ld bc,l0200h		;5317	01 00 02 	. . . 
l531ah:
	ldir		;531a	ed b0 	. . 
	ld hl,PXUSASC		;531c	21 8a 53 	! . S 
	ld de,0bbd8h		;531f	11 d8 bb 	. . . 
	ld bc,00018h		;5322	01 18 00 	. . . 
	ldir		;5325	ed b0 	. . 
	ld hl,PXBASCI		;5327	21 a2 53 	! . S 
	ld de,PXSASCI		;532a	11 00 bc 	. . . 
	ld bc,0000fh		;532d	01 0f 00 	. . . 
	ldir		;5330	ed b0 	. . 
	ld a,07fh		;5332	3e 7f 	>  
	ld (PXSASCI),a		;5334	32 00 bc 	2 . . 
	ld (PXSASCI+1),a		;5337	32 01 bc 	2 . . 
	ld bc,0fc80h		;533a	01 80 fc 	. . . 
	in a,(c)		;533d	ed 78 	. x 
	cp 0a7h		;533f	fe a7 	. . 
	jp nz,PXASCI		;5341	c2 08 bc 	. . . 
	ld bc,000dfh		;5344	01 df 00 	. . . 
	ldir		;5347	ed b0 	. . 
	ld a,07fh		;5349	3e 7f 	>  
	ld (PXTAPE),a		;534b	32 0f bc 	2 . . 
	ld (PXTAPE+1),a		;534e	32 10 bc 	2 . . 
	ld (PXDISK),a		;5351	32 20 bc 	2   . 
	ld (PXDISK+1),a		;5354	32 21 bc 	2 ! . 
	ld hl,(SUTAB)		;5357	2a b0 b7 	* . . 
	ld (SUBALT),hl		;535a	22 fe b7 	" . . 
	ld de,SUBNEU		;535d	11 ee bc 	. . . 
	ld (SUTAB),de		;5360	ed 53 b0 b7 	. S . . 
	ld bc,00092h		;5364	01 92 00 	. . . 
	ldir		;5367	ed b0 	. . 
	ld hl,MBO		;5369	21 80 bc 	! . . 
	ld (SUBNEU+2),hl		;536c	22 f0 bc 	" . . 
	ld hl,MBI		;536f	21 d0 bc 	! . . 
	ld (SUBNEU+10),hl		;5372	22 f8 bc 	" . . 
	ld hl,PXSTAB		;5375	21 82 53 	! . S 
	ld de,SUBNEU+16		;5378	11 fe bc 	. . . 
	ld c,008h		;537b	0e 08 	. . 
	ldir		;537d	ed b0 	. . 
	jp PXASCI		;537f	c3 08 bc 	. . . 
PXSTAB:

; BLOCK 'PXSTAB' (start 0x5382 end 0x538a)
PXSTAB_first:
	defw ISRO		;5382	2f bc 	/ . 
	defw CSRO		;5384	96 bc 	. . 
	defw ISRI		;5386	9e bc 	. . 
	defw CSRI		;5388	e9 bc 	. . 
PXUSASC:
	defb 07ch		;538a	7c 	| 
	defb 060h		;538b	60 	` 
	defb 060h		;538c	60 	` 
	defb 060h		;538d	60 	` 
	defb 060h		;538e	60 	` 
	defb 060h		;538f	60 	` 
	defb 07ch		;5390	7c 	| 
	defb 000h		;5391	00 	. 
	defb 0c0h		;5392	c0 	. 
	defb 060h		;5393	60 	` 
	defb 030h		;5394	30 	0 
	defb 018h		;5395	18 	. 
	defb 00ch		;5396	0c 	. 
	defb 006h		;5397	06 	. 
	defb 002h		;5398	02 	. 
	defb 000h		;5399	00 	. 
	defb 07ch		;539a	7c 	| 
	defb 00ch		;539b	0c 	. 
	defb 00ch		;539c	0c 	. 
	defb 00ch		;539d	0c 	. 
	defb 00ch		;539e	0c 	. 
	defb 00ch		;539f	0c 	. 
	defb 07ch		;53a0	7c 	| 
	defb 000h		;53a1	00 	. 
PXBASCI:

; BLOCK 'PXSASCI_PR' (start 0x53a2 end 0x53a4)
PXSASCI_PR_first:
	defw 00000h		;53a2	00 00 	. . 
	defb 041h		;53a4	41 	A 
	defb 053h		;53a5	53 	S 
	defb 043h		;53a6	43 	C 
	defb 049h		;53a7	49 	I 
	defb 049h		;53a8	49 	I 
	defb 001h		;53a9	01 	. 
	ld hl,0ba00h		;53aa	21 00 ba 	! . . 
	ld (CCTL0),hl		;53ad	22 a6 b7 	" . . 
	ret			;53b0	c9 	. 

; BLOCK 'PXTAPE_PR' (start 0x53b1 end 0x53b3)
PXTAPE_PR_first:
	defw 00000h		;53b1	00 00 	. . 
	defb 050h		;53b3	50 	P 
	defb 041h		;53b4	41 	A 
	defb 053h		;53b5	53 	S 
	defb 054h		;53b6	54 	T 
	defb 041h		;53b7	41 	A 
	defb 050h		;53b8	50 	P 
	defb 045h		;53b9	45 	E 
	defb 001h		;53ba	01 	. 
	ld hl,(SUBALT)		;53bb	2a fe b7 	* . . 
PXSetSUTAB:
	ld (SUTAB),hl		;53be	22 b0 b7 	" . . 
	ret			;53c1	c9 	. 

; BLOCK 'PXDISK_PR' (start 0x53c2 end 0x53c4)
PXDISK_PR_first:
	defw 00000h		;53c2	00 00 	. . 
	defb 050h		;53c4	50 	P 
	defb 041h		;53c5	41 	A 
	defb 053h		;53c6	53 	S 
	defb 044h		;53c7	44 	D 
	defb 049h		;53c8	49 	I 
	defb 053h		;53c9	53 	S 
	defb 04bh		;53ca	4b 	K 
	defb 001h		;53cb	01 	. 
	ld hl,SUBNEU		;53cc	21 ee bc 	! . . 
	jr PXSetSUTAB		;53cf	18 ed 	. . 
ISRO_s:
	ld (ix+002h),000h		;53d1	dd 36 02 00 	. 6 . . 
	ld l,(ix+005h)		;53d5	dd 6e 05 	. n . 
	ld h,(ix+006h)		;53d8	dd 66 06 	. f . 
	ld bc,083f3h		;53db	01 f3 83 	. . . 
	ld e,00bh		;53de	1e 0b 	. . 
PXSendName:
	outi		;53e0	ed a3 	. . 
	inc b			;53e2	04 	. 
	inc b			;53e3	04 	. 
	dec e			;53e4	1d 	. 
	jr nz,PXSendName		;53e5	20 f9 	  . 
	ld d,00bh		;53e7	16 0b 	. . 
PXNxtBlock_s:
	inc (ix+002h)		;53e9	dd 34 02 	. 4 . 
	ld h,(ix+006h)		;53ec	dd 66 06 	. f . 
	ld l,(ix+005h)		;53ef	dd 6e 05 	. n . 
	ld bc,081f2h		;53f2	01 f2 81 	. . . 
	ld e,080h		;53f5	1e 80 	. . 
PXSendBlock:
	outi		;53f7	ed a3 	. . 
	inc b			;53f9	04 	. 
	inc b			;53fa	04 	. 
	dec e			;53fb	1d 	. 
	jr nz,PXSendBlock		;53fc	20 f9 	  . 
PXSendCtl_s:
	ld bc,080f3h		;53fe	01 f3 80 	. . . 
	out (c),d		;5401	ed 51 	. Q 
PXWaitForReady:
	push bc			;5403	c5 	. 
	ld a,001h		;5404	3e 01 	> . 
	call PV1		;5406	cd 03 f0 	. . . 
	defb 014h		;5409	14 	. 
	pop bc			;540a	c1 	. 
	in a,(c)		;540b	ed 78 	. x 
	bit 0,a		;540d	cb 47 	. G 
	jr nz,PXWaitForReady		;540f	20 f2 	  . 
	and a			;5411	a7 	. 
	bit 7,a		;5412	cb 7f 	.  
	ret z			;5414	c8 	. 
	inc b			;5415	04 	. 
	in a,(c)		;5416	ed 78 	. x 
	call PV1		;5418	cd 03 f0 	. . . 
	defb 01ch		;541b	1c 	. 
	call PV1		;541c	cd 03 f0 	. . . 
	defb 019h		;541f	19 	. 
	scf			;5420	37 	7 
	ret			;5421	c9 	. 
MBO_s:
	ld d,003h		;5422	16 03 	. . 
	call PXNxtBlock		;5424	cd 47 bc 	. G . 
	ret c			;5427	d8 	. 
	ld a,002h		;5428	3e 02 	> . 
	cp (ix+002h)		;542a	dd be 02 	. . . 
	ret nc			;542d	d0 	. 
	call PV1		;542e	cd 03 f0 	. . . 
	defb 023h		;5431	23 	# 
	defb 008h		;5432	08 	. 
	defb 008h		;5433	08 	. 
	defb 008h		;5434	08 	. 
	defb 000h		;5435	00 	. 
	and a			;5436	a7 	. 
	ret			;5437	c9 	. 
CSRO_s:
	call MBO		;5438	cd 80 bc 	. . . 
	ret c			;543b	d8 	. 
	ld d,043h		;543c	16 43 	. C 
	jr PXSendCtl_s		;543e	18 be 	. . 
ISRI_s:
	ld (ix+002h),000h		;5440	dd 36 02 00 	. 6 . . 
	ld hl,fileName		;5444	21 f8 06 	! . . 
	ld bc,083f3h		;5447	01 f3 83 	. . . 
	ld de,ErrIdxHigh		;544a	11 0b 09 	. . . 
PXSendName2:
	outi		;544d	ed a3 	. . 
	inc b			;544f	04 	. 
	inc b			;5450	04 	. 
	dec e			;5451	1d 	. 
	jr nz,PXSendName2		;5452	20 f9 	  . 
PXRecvBlock:
	call PXSendCtl		;5454	cd 5c bc 	. \ . 
	ret c			;5457	d8 	. 
	push hl			;5458	e5 	. 
	push af			;5459	f5 	. 
	ld l,(ix+005h)		;545a	dd 6e 05 	. n . 
	ld h,(ix+006h)		;545d	dd 66 06 	. f . 
	ld bc,080f2h		;5460	01 f2 80 	. . . 
	ld e,080h		;5463	1e 80 	. . 
PXRecvByte:
	ini		;5465	ed a2 	. . 
	inc b			;5467	04 	. 
	inc b			;5468	04 	. 
	dec e			;5469	1d 	. 
	jr nz,PXRecvByte		;546a	20 f9 	  . 
	inc (ix+002h)		;546c	dd 34 02 	. 4 . 
	pop af			;546f	f1 	. 
	pop hl			;5470	e1 	. 
	ret			;5471	c9 	. 
MBI_s:
	push de			;5472	d5 	. 
	ld d,001h		;5473	16 01 	. . 
	call PXRecvBlock_s		;5475	cd b2 bc 	. . . 
	pop de			;5478	d1 	. 
	ret c			;5479	d8 	. 
	ld a,002h		;547a	3e 02 	> . 
	cp (ix+002h)		;547c	dd be 02 	. . . 
	ret nc			;547f	d0 	. 
	call PV1		;5480	cd 03 f0 	. . . 
	defb 023h		;5483	23 	# 
	defb 008h		;5484	08 	. 
	defb 008h		;5485	08 	. 
	defb 008h		;5486	08 	. 
	defb 008h		;5487	08 	. 
	defb 000h		;5488	00 	. 
	and a			;5489	a7 	. 
	ret			;548a	c9 	. 
CSRI_s:
	call PV1		;548b	cd 03 f0 	. . . 
	defb 02ch		;548e	2c 	, 
	ret			;548f	c9 	. 
SUBNEU_s:

; BLOCK 'Rest' (start 0x5490 end 0x5500)
Rest_first:
	defb 00dh		;5490	0d 	. 
l5491h:
	defb 00ah		;5491	0a 	. 
	defb 009h		;5492	09 	. 
	defb 043h		;5493	43 	C 
	defb 050h		;5494	50 	P 
	defb 009h		;5495	09 	. 
	defb 037h		;5496	37 	7 
	defb 046h		;5497	46 	F 
	defb 048h		;5498	48 	H 
	defb 009h		;5499	09 	. 
	defb 03bh		;549a	3b 	; 
	defb 054h		;549b	54 	T 
	defb 065h		;549c	65 	e 
	defb 073h		;549d	73 	s 
	defb 074h		;549e	74 	t 
	defb 020h		;549f	20 	  
	defb 050h		;54a0	50 	P 
	defb 072h		;54a1	72 	r 
	defb 06fh		;54a2	6f 	o 
	defb 06ch		;54a3	6c 	l 
	defb 06fh		;54a4	6f 	o 
	defb 067h		;54a5	67 	g 
	defb 03fh		;54a6	3f 	? 
	defb 00dh		;54a7	0d 	. 
	defb 00ah		;54a8	0a 	. 
	defb 009h		;54a9	09 	. 
	defb 049h		;54aa	49 	I 
	defb 04eh		;54ab	4e 	N 
	defb 043h		;54ac	43 	C 
	defb 009h		;54ad	09 	. 
	defb 048h		;54ae	48 	H 
	defb 04ch		;54af	4c 	L 
	defb 00dh		;54b0	0d 	. 
	defb 00ah		;54b1	0a 	. 
	defb 009h		;54b2	09 	. 
	defb 04ah		;54b3	4a 	J 
	defb 052h		;54b4	52 	R 
	defb 009h		;54b5	09 	. 
	defb 05ah		;54b6	5a 	Z 
	defb 02ch		;54b7	2c 	, 
	defb 050h		;54b8	50 	P 
	defb 041h		;54b9	41 	A 
	defb 053h		;54ba	53 	S 
	defb 030h		;54bb	30 	0 
	defb 031h		;54bc	31 	1 
	defb 00dh		;54bd	0d 	. 
	defb 00ah		;54be	0a 	. 
	defb 009h		;54bf	09 	. 
	defb 044h		;54c0	44 	D 
	defb 04ah		;54c1	4a 	J 
	defb 04eh		;54c2	4e 	N 
	defb 05ah		;54c3	5a 	Z 
	defb 009h		;54c4	09 	. 
	defb 050h		;54c5	50 	P 
	defb 041h		;54c6	41 	A 
	defb 053h		;54c7	53 	S 
	defb 030h		;54c8	30 	0 
	defb 032h		;54c9	32 	2 
	defb 00dh		;54ca	0d 	. 
	defb 00ah		;54cb	0a 	. 
	defb 009h		;54cc	09 	. 
	defb 04ah		;54cd	4a 	J 
	defb 052h		;54ce	52 	R 
	defb 009h		;54cf	09 	. 
	defb 050h		;54d0	50 	P 
	defb 041h		;54d1	41 	A 
	defb 053h		;54d2	53 	S 
	defb 030h		;54d3	30 	0 
	defb 033h		;54d4	33 	3 
	defb 00dh		;54d5	0d 	. 
	defb 00ah		;54d6	0a 	. 
	defb 050h		;54d7	50 	P 
	defb 041h		;54d8	41 	A 
	defb 053h		;54d9	53 	S 
	defb 030h		;54da	30 	0 
	defb 031h		;54db	31 	1 
	defb 009h		;54dc	09 	. 
	defb 04ch		;54dd	4c 	L 
	defb 044h		;54de	44 	D 
	defb 009h		;54df	09 	. 
	defb 04dh		;54e0	4d 	M 
	defb 02ch		;54e1	2c 	, 
	defb 030h		;54e2	30 	0 
	defb 009h		;54e3	09 	. 
	defb 03bh		;54e4	3b 	; 
	defb 06ch		;54e5	6c 	l 
	defb 07ch		;54e6	7c 	| 
	defb 073h		;54e7	73 	s 
	defb 063h		;54e8	63 	c 
	defb 068h		;54e9	68 	h 
	defb 065h		;54ea	65 	e 
	defb 06eh		;54eb	6e 	n 
	defb 00dh		;54ec	0d 	. 
	defb 00ah		;54ed	0a 	. 
	defb 050h		;54ee	50 	P 
	defb 041h		;54ef	41 	A 
	defb 053h		;54f0	53 	S 
	defb 030h		;54f1	30 	0 
	defb 033h		;54f2	33 	3 
	defb 009h		;54f3	09 	. 
	defb 04ch		;54f4	4c 	L 
	defb 044h		;54f5	44 	D 
	defb 009h		;54f6	09 	. 
	defb 048h		;54f7	48 	H 
	defb 04ch		;54f8	4c 	L 
	defb 02ch		;54f9	2c 	, 
	defb 028h		;54fa	28 	( 
	defb 043h		;54fb	43 	C 
	defb 043h		;54fc	43 	C 
	defb 054h		;54fd	54 	T 
	defb 04ch		;54fe	4c 	L 
	defb 030h		;54ff	30 	0 
