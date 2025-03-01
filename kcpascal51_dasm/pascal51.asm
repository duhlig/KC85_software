; z80dasm 1.1.6
; command line: z80dasm -b p51.block -g 0x200 -l -S p51.sym -s p51.symout -u -o pascal51.asm pascal51_kcc.bin

	org	00200h
iobuf:	equ 0x0080
;iobuf+11:	equ 0x008b
;iobuf+16:	equ 0x0090
;iobuf+17:	equ 0x0091
;iobuf+19:	equ 0x0093
;iobuf+20:	equ 0x0094
CAOS_ARG1:	equ 0xb782
CAOS_ARG2:	equ 0xb784
CAOS_ARG3:	equ 0xb786
CAOS_ARG4_9:	equ 0xb788
CAOS_CURSO:	equ 0xb7a0
CAOS_COLOR:	equ 0xb7a3
CCTL0:	equ 0xb7a6
SUTAB:	equ 0xb7b0
CAOS_HOR:	equ 0xb7d3
CAOS_VERT:	equ 0xb7d5
CAOS_FARB:	equ 0xb7d6
SUBALT:	equ 0xb7fe
;;PXSASCI:	equ 0xbc00
;PXSASCI+1:	equ 0xbc01
;;PXASCI:	equ 0xbc08
;;PXTAPE:	equ 0xbc0f
;PXTAPE+1:	equ 0xbc10
;;PXDISK:	equ 0xbc20
;PXDISK+1:	equ 0xbc21
;;ISRO:	equ 0xbc2f
;;PXNxtBlock:	equ 0xbc47
;;PXSendCtl:	equ 0xbc5c
;;MBO:	equ 0xbc80
;;CSRO:	equ 0xbc96
;;ISRI:	equ 0xbc9e
;;PXRecvBlock:	equ 0xbcb2
;;MBI:	equ 0xbcd0
;;CSRI:	equ 0xbce9
;;SUBNEU:	equ 0xbcee
;SUBNEU+2:	equ 0xbcf0
;SUBNEU+10:	equ 0xbcf8
;SUBNEU+16:	equ 0xbcfe
PV1:	equ 0xf003

IRM_ON	MACRO
	in a,(088h)
	set 5,a
	set 2,a
	out (088h),a
	ENDM
	
IRM_OFF	MACRO
	in a,(088h)
	res 5,a
	res 2,a
	out (088h),a
	ENDM
	
PasPrgMenuHdr:
	defw 00000h
PasPrgMenuName:
	defs 8
	defb 000h
	jp PasPrgStart
MenuPRec:
	defw 07f7fh
	defb 'PASREC',000h
	jp Recall
MenuPEnt:
	defw 07f7fh
	defb 'PASENTRY',000h
	jp Entry
DoNopRET:
	nop	
	nop	
	ret	
DoRET:
	ret	
CCaos:
	push iy
	push ix
	push bc	
	push de	
	push hl	
	ld ix,(caos_ix)
	ld (pascal_sp),sp
	ld (tmp_reg_a),a
	IRM_ON
	ld a,e	
	ld (OSPrc),a
	ld a,(tmp_reg_a)
	ld sp,(caos_sp)
	ei	
	call PV1
OSPrc:
	defb 000h
	di	
	ld (caos_sp),sp
	ld (tmp_reg_a),a
	IRM_OFF
	ld a,(tmp_reg_a)
	ld sp,(pascal_sp)
	pop hl	
	pop de	
	pop bc	
	pop ix
	pop iy
	ret	
CAOS_KBDS:
	push de	
	ld e,00ch
	call CCaos
	pop de	
	ld a,0ffh
	ret c	
	xor a	
	ret	
GetKey:
	push de	
	push ix
	ld ix,(caos_ix)
	IRM_ON
	res 0,(ix+008h)
	IRM_OFF
	ei	
	ld a,002h
	ld e,014h
l02a1h:
	call CCaos
GetKeyTest:
	ld e,00ch
	call CCaos
	cp 080h
	jr c,CAOS_KBD
	IRM_ON
	xor a	
	ld (ix+00dh),a
	res 0,(ix+008h)
	IRM_OFF
	jr GetKeyTest
CAOS_KBD:
	ld e,004h
	call CCaos
	cp 080h
	jr nc,CAOS_KBD
	ld e,a
	IRM_ON
	res 0,(ix+008h)
	IRM_OFF
	ld a,e	
	pop ix
	pop de	
	ret	
CAOS_CRT:
	push af	
	ld a,c	
	push de	
	ld e,000h
	call CCaos
	pop de	
	pop af	
	ret	
Save:
	ld ix,(caos_ix)
	ld (SaveBlockAdr),hl
	ld (iobuf+17),hl
	ld hl,iobuf+11
	ld b,005h
KillMem:
	ld (hl),000h
	inc hl	
	djnz KillMem
	inc de	
	ld (bin_end),de
	ld (iobuf+19),de
	ld a,002h
	ld (iobuf+16),a
	ld a,(fileExt)
	cp 043h
	jr nz,C_ISRO
	ld a,d	
	ld (iobuf+19),a
	ld hl,l04d5h
	ld (iobuf+20),hl
	ld hl,07f7fh
	ld (PasPrgMenuHdr),hl
	ld hl,00000h
	ld (MenuPEnt),hl
	ld (MenuPRec),hl
	ld hl,fileName
	ld de,PasPrgMenuName
	ld b,008h
FName2Menu:
	ld a,(hl)	
	cp 020h
	jr z,C_ISRO
	or a	
	jr z,C_ISRO
	ld (de),a	
	inc hl	
	inc de	
	djnz FName2Menu
C_ISRO:
	ld hl,fileName
	ld bc,0000bh
	ld de,iobuf
	ldir
	ld hl,iobuf
	IRM_ON
	ld (ix+005h),l
	ld (ix+006h),h
	IRM_OFF
	ld bc,01f40h
	ld e,008h
	call CCaos
SaveBlock:
	ld hl,(SaveBlockAdr)
	ld de,iobuf
	ld bc,00080h
	ldir
	ld (SaveBlockAdr),hl
	ld bc,000a0h
	ld e,001h
	call CCaos
	IRM_ON
	ld e,(ix+002h)
	IRM_OFF
	ld a,e	
	call PrByteHex
	call PrSpace
	ld hl,(SaveBlockAdr)
	ld de,(bin_end)
	or a	
	sbc hl,de
	jr c,SaveBlock
C_CSRO:
	ld e,009h
	call CCaos
	ld a,012h
	call OutChr
	jp PrNL
TestBreak:
	ld e,02ah
	call CCaos
	ret nc	
	ld a,012h
	call OutChr
	jp Reset
Load:
	ld (srcAddr_LoadSave),hl
RetryISRI:
	ld ix,(caos_ix)
C_ISRI:
	call TestBreak
	ld hl,iobuf
	IRM_ON
	set 0,(ix+007h)
	ld (ix+005h),l
	ld (ix+006h),h
	IRM_OFF
	ld e,00ah
	call CCaos
	jr c,RetryISRI
	IRM_ON
	ld e,(ix+002h)
	IRM_OFF
	ld a,e	
ChkForBlock1:
	cp 001h
	jp nz,RetryISRI
	inc a	
	ld (nextBlkNum),a
	ld de,iobuf
	ld bc,00b00h
	ld hl,fileName
CmpFNamChr:
	ld a,(de)	
	or a	
	jr z,CmpFNamNxtChr
	cp 020h
	jr z,CmpFNamNxtChr
	cp (hl)	
	jr z,CmpFNamEchoChr
	ld a,03fh
	cp (hl)	
	jr z,CmpFNamEchoChr
	ld c,001h
CmpFNamEchoChr:
	ld a,(de)	
	call OutChr
CmpFNamNxtChr:
	inc de	
	inc hl	
	djnz CmpFNamChr
	call PrNL
	ld a,c	
	or a	
	jp nz,RetryISRI
	ld de,(iobuf+17)
	ld hl,(iobuf+19)
	or a	
	sbc hl,de
	ld (SaveBlockAdr),hl
	ld de,(srcAddr_LoadSave)
	add hl,de	
	ld (l06b6h),hl
C_MBI:
	call TestBreak
	ld e,005h
	call CCaos
	jr c,C_MBI
	IRM_ON
	ld e,(ix+002h)
	IRM_OFF
	ld a,e	
	ld hl,nextBlkNum
	cp 0ffh
	jr z,C_CSRI
	cp (hl)	
	jr z,BlockRead
	call PrByteHex
	ld a,02ah
	call OutChr
	call PrSpace
	jr C_MBI
BlockRead:
	inc (hl)	
	call PrByteHex
	ld a,03eh
	call OutChr
	call PrSpace
	ld hl,(SaveBlockAdr)
	ld de,00080h
	or a	
	sbc hl,de
	jr c,C_CSRI
	ld (SaveBlockAdr),hl
	ld bc,00080h
	ld hl,iobuf
	ld de,(srcAddr_LoadSave)
	ldir
	ld (srcAddr_LoadSave),de
	jr C_MBI
C_CSRI:
	ld bc,(SaveBlockAdr)
	ld hl,iobuf
	ld de,(srcAddr_LoadSave)
	ldir
	ld e,00bh
	call CCaos
	ld a,012h
	call OutChr
	ld hl,(l06b6h)
l04d5h:
	ret	
RET_to_CAOS:
	ld e,012h
	jp CCaos
CAOS_UOT1:
	push af	
	ld a,c	
	push de	
	ld e,002h
	call CCaos
	pop de	
	pop af	
	ret	
sub_04e6h:
	ld a,(l178fh)
	ld h,a	
	ld a,(l178dh)
	ld l,a
	IRM_ON
	ld (CAOS_CURSO),hl
	IRM_OFF
	ret	
sub_0502h:
	ld a,(l178fh)
	and 007h
	ld l,a	
	ld a,(l178dh)
	and 01fh
	rlca	
	rlca	
	rlca	
	or l	
	ld l,a
	IRM_ON
	ld a,l	
	ld (CAOS_COLOR),a
	IRM_OFF
	ret	
sub_0527h:
	IRM_ON
	ld hl,(l178dh)
	ld (CAOS_HOR),hl
	ld a,(l178fh)
	ld (CAOS_VERT),a
	ld a,(CAOS_COLOR)
	and 0f8h
	ld (CAOS_FARB),a
	IRM_OFF
sub_054bh:
	push de	
	ld e,030h
	call CCaos
	pop de	
	ret	
sub_0553h:
	call sub_05c7h
	ld l,a	
	ld h,000h
	jr z,l0588h
	ld (l1791h),hl
	IRM_ON
	ld hl,(l178dh)
	ld (CAOS_HOR),hl
	ld a,(l178fh)
	ld (CAOS_VERT),a
	ld a,(l1791h)
	and 0f8h
	ld (CAOS_FARB),a
	IRM_OFF
	call sub_054bh
	ld hl,(l1791h)
l0588h:
	ld a,l	
	and 0f8h
	rrca	
	rrca	
	rrca	
	ld l,a	
	ret	
sub_0590h:
	call sub_05c7h
	ld l,a	
	ld h,000h
	jr z,l05c5h
	ld (l1791h),hl
	IRM_ON
	ld hl,(l178dh)
	ld (CAOS_HOR),hl
	ld a,(l178fh)
	ld (CAOS_VERT),a
	ld a,(l1791h)
	and 0f8h
	ld (CAOS_FARB),a
	IRM_OFF
	call sub_054bh
	ld a,001h
	ret	
l05c5h:
	xor a	
	ret	
sub_05c7h:
	IRM_ON
	ld hl,(l178dh)
	ld (CAOS_HOR),hl
	ld a,(l178fh)
	ld (CAOS_VERT),a
	IRM_OFF
	push de	
	ld e,02fh
	call CCaos
	pop de	
	ret	
sub_05ebh:
	IRM_ON
	ld hl,(l178dh)
	ld (CAOS_ARG1),hl
	ld hl,(l178fh)
	ld (CAOS_ARG2),hl
	ld hl,(l1791h)
	ld (CAOS_ARG3),hl
	ld hl,(l1793h)
	ld (CAOS_ARG4_9),hl
	ld a,(CAOS_COLOR)
	and 0f8h
	ld (CAOS_FARB),a
	IRM_OFF
	push de	
	ld e,03eh
	call CCaos
	pop de	
	ret	
sub_0623h:
	IRM_ON
	ld hl,(l178dh)
	ld (CAOS_ARG1),hl
	ld hl,(l178fh)
	ld (CAOS_ARG2),hl
	ld hl,(l1791h)
	ld (CAOS_ARG3),hl
	ld a,(CAOS_COLOR)
	and 0f8h
	ld (CAOS_FARB),a
	IRM_OFF
	push de	
	ld e,03fh
	call CCaos
	pop de	
	ret	
sub_0655h:
	IRM_ON
	ld a,(l178dh)
	ld (hl),a
	IRM_OFF
	ret	
sub_066ah:
	IRM_ON
	ld l,(hl)	
	ld h,000h
	IRM_OFF
	ret	
GetRAMEnd:
	IRM_OFF
	ld hl,06000h
l0689h:
	ld e,(hl)	
	ld a,055h
	ld (hl),a	
	cp (hl)	
	jr nz,l069ch
	ld a,0aah
	ld (hl),a	
	cp (hl)	
	jr nz,l069ch
	ld (hl),e	
	inc hl	
	ld a,h	
	or l	
	jr nz,l0689h
l069ch:
	dec hl	
	push hl	
	pop de	
	ret	
Entry:
	ld (caos_ix),ix
	di	
	jp Init1
Recall:
	ld (caos_ix),ix
	di	
	jp l06c3h
caos_ix:
	defw 00000h
pascal_sp:
	defw 00000h
srcAddr_LoadSave:
	defw 00000h
l06b6h:
	defw 00000h
SaveBlockAdr:
	defw 00000h
bin_end:
	defw 00000h
nextBlkNum:
	defb 000h
tmp_reg_a:
	nop	
Init1:
	call SaveCAOS_SP
	jr Init2
l06c3h:
	call SaveCAOS_SP
	jr Reset
PasPrgStart:
	jp 07cd5h
JEndPascal:
	jp END_PASCAL
JReadEditIBuf__:
	jp ReadEditIBuf__
JCodeNextByte:
	jp CodeNextByte
JPrError:
	jp CoErNumTooBig
JResetPrintFlag:
	jp ResetPrintFlag
Init2:
	jp START_PASCAL
Reset:
	jp ResetPasStack
StartEditLine:
	jp PrevLineFound
JSrcToLineBuf:
	jp SrcToLineBuf
JLdHLSrcEnd:
	jp LdHLSrcEnd
JGetPar3:
	jp GetPar3
	jp ExpandLine
	jp ExpandLineSrc
JCompile:
	jp Compile
JCompileToRuntimeEnd:
	jp SetBinStartToRuntimeEnd
fileName:
	defb 000h,000h,000h,000h,000h,000h,000h,000h
fileExt:
	defb 000h,000h,000h
	defb 000h
l0704h:
	defw 00000h
caos_sp:
	defw 00000h
	defw 00000h
	defw RL_SETSYS
curSrcLineNum:
	defw 00028h
l070eh:
	defw 00000h
l0710h:
	defw 00000h
printFlag:
	defb 000h
SaveCAOS_SP:
	ld (caos_sp),sp
	jp DoRET
	ret	
END_PASCAL:
	ld sp,(caos_sp)
	jp RET_to_CAOS
ResetPrintFlag:
	xor a	
	ld (printFlag),a
	jp DoNopRET
OutChr:
	push bc	
	push af	
	ld c,a	
	cp 010h
	jr nz,OCChkNL
	ld a,(printFlag)
	xor 001h
	ld (printFlag),a
	jr OCEnd
OCChkNL:
	cp 00dh
	jr nz,OCOther
	call OutCh1
	ld c,00ah
OCOther:
	call OutCh1
OCEnd:
	pop af	
	pop bc	
	ret	
OutCh1:
	push bc	
	call CAOS_CRT
	ld a,(printFlag)
	bit 0,a
	pop bc	
	ret z	
	jp CAOS_UOT1
KbdStat:
	jp CAOS_KBDS
Upper:
	cp 07eh
	ret nc	
	cp 061h
	ret c	
	res 5,a
	ret	
SetFileName:
	push hl	
	push bc	
	ld b,008h
	ld hl,fileName
	push hl	
SetFNClear:
	ld (hl),000h
	inc hl	
	djnz SetFNClear
	pop hl	
	ld b,008h
SetFNChr:
	ld a,(de)	
	cp 00dh
	jr z,SetFNEnd
	call Upper
	ld (hl),a	
	inc de	
	inc hl	
	djnz SetFNChr
SetFNEnd:
	pop bc	
	pop hl	
	push hl	
	add hl,bc	
	ex de,hl	
	pop hl	
	ret	
SetExtPAS:
	push hl	
	ld hl,fileExtPAS
SetFileExt:
	push bc	
	push de	
	ld bc,00003h
	ld de,fileExt
	ldir
	pop de	
	pop bc	
	pop hl	
	ret	
SetExtCOM:
	push hl	
	ld hl,fileExtCOM
	jr SetFileExt
fileExtCOM:
	defb 'COM'
fileExtPAS:
	defb 'PAS'
SaveSrcFile:
	push ix
	push iy
	push hl	
	push bc	
	push de	
	call SetExtPAS
	call SetFileName
	call Save
	pop de	
	jr SaveLoadEnd
LoadSrcFile:
	push ix
	push iy
	push hl	
	push bc	
	push hl	
	call SetExtPAS
	call SetFileName
	pop hl	
	call Load
	ex de,hl	
	dec de	
SaveLoadEnd:
	pop bc	
	pop hl	
	pop iy
	pop ix
	ret	
SaveCom:
	ld hl,PasPrgMenuHdr
	call SetExtCOM
	call SetFileName
	call Save
	jp JEndPascal
InitRuntimeErr__:
	ld a,0c3h
	ld (JReadEditIBuf__),a
	ld hl,ReadEditIBuf__
	ld (JReadEditIBuf__+1),hl
	ld hl,PrRuntimeErr
	ld (JPrError+1),hl
	ld hl,inputBuf
	ld (iBufCurChrAddr),hl
	ld hl,0000dh
	ld (inputBuf),hl
	ret	
PrGetKey:
	call GetKey
	jp OutChr
PrCuL:
	ld a,008h
	jp OutChr
PrDez:
	push hl	
	ld b,005h
	bit 7,h
	jr z,PrDezPos1
	ex de,hl	
	ld hl,00000h
	or a	
	sbc hl,de
	inc b	
PrDezPos1:
	ld iy,hexDezTab
PrDezNumLen:
	ld e,(iy+000h)
	ld d,(iy+001h)
	or a	
	sbc hl,de
	jr nc,PrDezFillSpc
	add hl,de	
	inc iy
	inc iy
	djnz PrDezNumLen
	inc b	
PrDezFillSpc:
	ld l,a	
	ld a,b	
	call PrFillSpc
	pop hl	
	bit 7,h
	jr z,PrDezPos2
	ld a,02dh
	call OutChr
	or a	
	ex de,hl	
	ld hl,00000h
	sbc hl,de
PrDezPos2:
	ld iy,hexDezTab
	ld bc,00530h
PrDezConv:
	ld a,030h
	ld e,(iy+000h)
	ld d,(iy+001h)
PrDezCount:
	or a	
	sbc hl,de
	jr c,PrDezOutChr
	inc a	
	jr PrDezCount
PrDezOutChr:
	add hl,de	
	cp c	
	jr z,PrDezSkip0
	call OutChr
	dec c	
PrDezSkip0:
	inc iy
	inc iy
	djnz PrDezConv
	cp c	
	ret nz	
	jp OutChr
hexDezTab:
	defb 010h
	defb 027h
	defb 0e8h
	defb 003h
	defb 064h
	defb 000h
	defb 00ah
	defb 000h
	defb 001h
	defb 000h
PrFillSpc:
	sub l	
	ret nc	
	neg
PrNSpaceA:
	ld b,a	
PrNSpaceB:
	call PrSpace
	djnz PrNSpaceB
	ret	
PrNL:
	ld a,00dh
	jr JOutChr
PrSpace:
	ld a,020h
JOutChr:
	jp OutChr
OutNStr:
	ld a,(hl)	
	inc hl	
	call OutChr
	djnz OutNStr
	ret	
PrBool:
	or a	
	jr nz,PrTrue
PrFalse:
	ld hl,tFalse
	jr OutZStr
PrTrue:
	ld hl,tTrue
OutZStr:
	ld a,(hl)	
	inc hl	
	or a	
	ret z	
	call OutChr
	jr OutZStr
PrHex:
	dec l	
	ld a,e	
	jr z,Pr1Hex
	dec l	
	jr z,PrByteHex
	dec l	
	jr z,PrWordHex
	dec l	
	jr z,PrWordHex
	ld b,l	
	call PrNSpaceB
PrWordHex:
	ld a,d	
	call PrByteHex
	ld a,e	
PrByteHex:
	push af	
	rrca	
	rrca	
	rrca	
	rrca	
	call Pr1Hex
	pop af	
Pr1Hex:
	and 00fh
	add a,090h
	daa	
	adc a,040h
	daa	
	jp OutChr
tFalse:

; BLOCK 'TFalse' (start 0x08d4 end 0x08da)
TFalse_start:
	defb 'FALSE',000h
tTrue:

; BLOCK 'TTrue' (start 0x08da end 0x08df)
TTrue_start:
	defb 'TRUE',000h
PrRAM:
	ld de,T_RAM
	jr PrErr2
l08e4h:
	pop bc	
ErrNumExpected:
	pop bc	
	ld de,TNumExpected
	jr PrErr2
l08ebh:
	pop bc	
	pop bc	
l08edh:
	ld de,TNumTooBig
	jr PrErr2
ErrOverflow:
	ld de,TUeber
PrErr2:
	jp JPrError
PrRuntimeErr:
	ex de,hl	
	call OutZStr
	ld hl,T_beiPC
	jr OutZStrOutAddr
ErrDivBy0:
	ld de,TDiv0
	jr PrErr2
ErrIdxLow:
	ld de,TIdxLow
	jr PrErr2
ErrIdxHigh:
	ld de,TIdxHigh
	jr PrErr2
ErrMath:
	ld de,TMathErr
	jr PrErr2
Break:
	call CAOS_KBDS
	inc a	
	ret nz	
	call GetKey
	cp 003h
	jr z,PrHalt
	call GetKey
	cp 003h
	ret nz	
PrHalt:
	ld hl,THalt
OutZStrOutAddr:
	call OutZStr
	pop de	
	call PrWordHex
	jp Reset
THalt:

; BLOCK 'TErrMsg' (start 0x0934 end 0x09b1)
TErrMsg_start:
	defb 00dh
	defb 'Halt'
T_beiPC:
	defb ' bei PC=',000h
TUeber:
	defb 'Ueberlauf',000h
T_RAM:
	defb '>> RAM',000h
TDiv0:
	defb '/ durch Null',000h
TIdxLow:
	defb 'Index zu niedrig',000h
TIdxHigh:
	defb 'Index zu hoch',000h
TMathErr:
	defb 'mathematischer Fehler',000h
TNumTooBig:
	defb 'Zahl zu gro',07eh,000h,000h
TNumExpected:
	defb 'Zahl erwartet',000h
SelListElem__:
	ld d,ixh
	ld e,ixl
NxtListElem:
	ex de,hl	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	djnz NxtListElem
	ret	
Mul8x8:
	xor a	
	sbc hl,de
	add hl,de	
	jr nc,l09c3h
	ex de,hl	
l09c3h:
	or d	
	scf	
	ret nz	
	or e	
	ld e,d	
	jr nz,l09d1h
	ex de,hl	
	ret	
l09cch:
	ex de,hl	
	add hl,de	
	ex de,hl	
l09cfh:
	add hl,hl	
	ret c	
l09d1h:
	rra	
	jr nc,l09cfh
	or a	
	jr nz,l09cch
	add hl,de	
	ret	
JErrOverflow:
	jp ErrOverflow
Mul16x8sgn:
	ld a,d	
	xor h	
	ld b,a	
	call AbsHL
	ex de,hl	
	call AbsHL
	xor a	
	sbc hl,de
	add hl,de	
	jr nc,l09edh
	ex de,hl	
l09edh:
	or d	
	jr nz,JErrOverflow
	or e	
	ld e,d	
	jp nz,l09fdh
	ex de,hl	
	ret	
l09f7h:
	ex de,hl	
	add hl,de	
	ex de,hl	
l09fah:
	add hl,hl	
	jr c,JErrOverflow
l09fdh:
	rra	
	jr nc,l09fah
	or a	
	jr nz,l09f7h
	adc hl,de
	jr c,JErrOverflow
	jp m,JErrOverflow
	or b	
	ret p	
	jr NegHL
AbsHL:
	ld a,h	
	or a	
	ret p	
NegHL:
	xor a	
	sub l	
	ld l,a	
	ld a,000h
	sbc a,h	
	ld h,a	
	ret	
Div:
	ld a,h	
	or l	
	jp z,ErrDivBy0
	ld a,h	
	push de	
	xor d	
	push af	
	xor a	
	or h	
	call p,NegHL
	ld b,h	
	ld c,l	
	ld hl,00000h
	ex de,hl	
	call AbsHL
	or l	
	jp z,l0a49h
	ld a,011h
l0a36h:
	add hl,hl	
	dec a	
	jr nc,l0a36h
	ex de,hl	
l0a3bh:
	adc hl,hl
	add hl,bc	
	jr c,l0a42h
	sbc hl,bc
l0a42h:
	rl e
	rl d
	dec a	
	jr nz,l0a3bh
l0a49h:
	pop af	
	ex de,hl	
	call m,NegHL
	ex de,hl	
	pop af	
	or a	
	ret p	
	jr NegHL
CurrCharIsNum:
	call GetCurIBufChr
IsNum:
	cp 030h
	ccf	
	ret nc	
	cp 03ah
	ret	
IsEOL:
	call GetCurIBufChr
	cp 00dh
	ld a,000h
	ret nz	
	inc a	
	ret	
GetCurIBufChr:
	push hl	
	ld hl,(iBufCurChrAddr)
	ld a,(hl)	
	pop hl	
	ret	
ReadEditIBuf__:
	call GetCurIBufChr
EditIBuf__:
	push hl	
	push de	
	push bc	
	push af	
	call ReadIBufOrEdit
	pop af	
	pop bc	
	pop de	
	pop hl	
	ret	
ReadIBufOrEdit:
	ld hl,(iBufCurChrAddr)
	inc hl	
	ld a,(hl)	
	ld (iBufCurChrAddr),hl
	or a	
	ret nz	
	ld d,000h
	exx	
	ld hl,inputBuf
	ld d,000h
	push hl	
	call EditLine
	pop hl	
	jp nc,Reset
	ld (iBufCurChrAddr),hl
	ld c,000h
	cpir
	ld (hl),000h
	ret	
l0aa2h:
	call JReadEditIBuf__
	cp 00dh
	jr nz,l0aa2h
	ret	
EditSrcLine__:
	ld d,006h
l0aach:
	ld hl,lineBuf
EditLine:
	ld c,051h
	ld e,000h
l0ab3h:
	ld a,028h
	sub d	
	ld b,a	
LineEdLoop__:
	exx	
	bit 1,d
	exx	
	ret nz	
LineEdNextLine__:
	ld a,b	
	and 003h
	jr nz,l0ac5h
	exx	
	res 4,d
	exx	
l0ac5h:
	ld a,020h
	exx	
	bit 4,d
	jr nz,ChkCuUp
	bit 0,d
	exx	
	ld a,(hl)	
	exx	
	call z,GetKey
ChkCuUp:
	exx	
	cp 00bh
	jr nz,l0adfh
	exx	
	set 4,d
	exx	
	jr l0ac5h
l0adfh:
	cp 002h
	jr nz,TestBreakLEdi
	inc e	
	dec e	
	jr z,LineEdLoop__
LinEdDelLine__:
	call LineEdCuL__
	jr nz,LinEdDelLine__
l0aech:
	jr l0ab3h
TestBreakLEdi:
	cp 003h
	jp z,Reset
	cp 008h
	jr nz,TestCuD
ItsCuL:
	inc e	
	dec e	
	call nz,LineEdCuL__
	jr LineEdLoop__
TestCuD:
	cp 010h
	jr nz,TestEnter
	call OutChr
	jr LineEdNextLine__
TestEnter:
	cp 00dh
	jr z,l0b1ah
	cp 00ch
	jr nz,TestPrintableChr
	call OutChr
	jp l0aach
TestPrintableChr:
	cp 020h
	jr c,LineEdLoop__
	ccf	
l0b1ah:
	ld (hl),a	
	inc hl	
	push af	
	call OutChr
	pop af	
	ccf	
	ret c	
	inc e	
	dec b	
	dec c	
	jr z,ItsCuL
	inc b	
	dec b	
	jr nz,LineEdLoop__
	exx	
	dec e	
	exx	
	ld b,d	
	inc b	
	dec b	
	jp z,l0ab3h
	push hl	
	ld hl,printFlag
	bit 0,(hl)
	pop hl	
	call z,PrNSpaceB
	jr l0aech
LineEdCuL__:
	ld a,028h
	sub d	
	cp b	
	jr nz,l0b51h
	ld b,d	
	inc b	
	dec b	
	jr z,l0b51h
DelLineNum__:
	call PrCuL
	djnz DelLineNum__
l0b51h:
	inc b	
	call PrCuL
	exx	
	res 4,d
	exx	
	dec hl	
	inc c	
	dec e	
	ret	
MulBy10_HL_DE:
	add hl,hl	
	rl e
	rl d
	push de	
	push hl	
	add hl,hl	
	rl e
	rl d
	add hl,hl	
	rl e
	rl d
	pop bc	
	add hl,bc	
	ex de,hl	
	pop bc	
	adc hl,bc
	ex de,hl	
	ret	
sub_0b76h:
	call IsNum
	jp nc,l08e4h
	ld hl,00000h
	ld d,h	
	ld e,l	
	ld b,007h
	push bc	
	jr l0b8ah
l0b86h:
	push bc	
	call MulBy10_HL_DE
l0b8ah:
	sub 030h
	ld c,a	
	ld b,d	
	add hl,bc	
	jr nc,l0b92h
	inc de	
l0b92h:
	call CurrCharIsNum
	pop bc	
	dec b	
	ret nc	
	call EditIBuf__
	jr nz,l0b86h
l0b9dh:
	inc d	
	call CurrCharIsNum
	ret nc	
	call EditIBuf__
	jr l0b9dh
l0ba7h:
	call JReadEditIBuf__
	cp 020h
	jr z,l0ba7h
	cp 00dh
	ret nz	
	jr l0ba7h
sub_0bb3h:
	call l0ba7h
	cp 02dh
	jr z,l0bcch
	cp 02bh
sub_0bbch:
	call z,JReadEditIBuf__
	call sub_0b76h
	ld a,d	
	or e	
	jr nz,l0bc9h
	bit 7,h
	ret z	
l0bc9h:
	jp l08edh
l0bcch:
	call sub_0bbch
	ex de,hl	
	or a	
	sbc hl,de
	ret	
l0bd4h:
	call GetCurIBufChr
	cp 00dh
	jr z,l0be3h
	ld (hl),a	
	inc hl	
	call EditIBuf__
	djnz l0bd4h
	ret	
l0be3h:
	xor a	
l0be4h:
	ld (hl),a	
	inc hl	
	djnz l0be4h
	ret	
sub_0be9h:
	ld hl,00002h
	add hl,sp	
	ld c,a	
	xor a	
	srl c
	rra	
	srl c
	rra	
	srl c
	rla	
	rla	
	rla	
	ld b,a	
	inc b	
	xor a	
	scf	
l0bfeh:
	adc a,a	
	djnz l0bfeh
	add hl,bc	
	ret	
sub_0c03h:
	inc a	
	ld b,a	
l0c05h:
	ld a,(hl)	
	or d	
	ld (hl),a	
	rlc d
	jr nc,l0c0dh
	inc hl	
l0c0dh:
	djnz l0c05h
	ret	
InitLocVar_CaPrc__:
	pop hl	
	ld (retAddr__),hl
	xor a	
	ld b,a	
	ld l,a	
	ld h,a	
	sbc hl,bc
	add hl,sp	
	ld d,h	
	ld e,l	
	dec hl	
	ld sp,hl	
	ld (hl),a	
	ldir
	ld hl,(retAddr__)
sub_0c25h:
	jp (hl)	
MaskBytes__:
	pop hl	
	ld (retAddr__),hl
	ld hl,00000h
	add hl,sp	
	ld d,h	
	ld e,l	
	add hl,bc	
	ld b,c	
l0c32h:
	ld a,(de)	
opCodes:
	defb 002h
	defb 000h
	ld (hl),a	
	inc hl	
	inc de	
	djnz l0c32h
	ex de,hl	
	ld sp,hl	
	ld hl,(retAddr__)
	jp (hl)	
MultiCall__:
	pop hl	
	ld (retAddr__),hl
	ld hl,00000h
	add hl,sp	
	ld d,h	
	ld e,l	
	add hl,bc	
	ld b,c	
VarCall:
	call 00000h
	inc hl	
	inc de	
	djnz VarCall
	ld a,001h
MultiCallEnd:
	ld sp,hl	
	ld hl,(retAddr__)
	jp (hl)	
EquOrIncHLbyB:
	ld a,(de)	
	cp (hl)	
TestOrIncHLbyB:
	ret z	
IncHLbyB:
	inc hl	
	djnz IncHLbyB
	xor a	
	jr MultiCallEnd
NeqOrIncHLbyB:
	ld a,(de)	
	cpl	
	and (hl)	
	jr TestOrIncHLbyB
Neq2OrIncHLbyB:
	ex de,hl	
	ld a,(de)	
	cpl	
	and (hl)	
	ex de,hl	
	jr TestOrIncHLbyB
sub_0c6fh:
	or a	
	sbc hl,de
	ld a,080h
	jp pe,l0c82h
l0c77h:
	and h	
	rlca	
	ret	
sub_0c7ah:
	or a	
	sbc hl,de
	ld a,080h
	jp pe,l0c77h
l0c82h:
	and h	
	rlca	
	xor 001h
	ret	
sub_0c87h:
	push hl	
	ld hl,0ffcfh
	ld de,(l178bh)
	sbc hl,de
	ex de,hl	
	add hl,bc	
	ld (l178bh),hl
	pop hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	ret	
l0c9bh:
	pop af	
l0c9ch:
	pop bc	
	pop de	
	pop hl	
	push bc	
	ret	
sub_0ca1h:
	bit 6,h
	jr z,l0c9ch
	ld iy,00000h
	add iy,sp
	ld a,h	
	ld b,(iy+005h)
	bit 6,b
	jr z,l0cf7h
	xor b	
	push af	
	push de	
	ld a,d	
	ld d,b	
	ld b,e	
	ld e,(iy+004h)
	sub (iy+003h)
	jp pe,l0cfch
	jp m,l0d1ah
	ld c,(iy+002h)
	jr z,l0d29h
l0ccah:
	push hl	
	res 7,d
	res 7,h
l0ccfh:
	srl d
	rr e
	rr c
	dec a	
	jr nz,l0ccfh
	ld a,b	
	bit 7,(iy-001h)
	jr nz,l0d01h
l0cdfh:
	add a,c	
	adc hl,de
	pop bc	
	pop de	
	jp po,l0cf0h
	srl h
	rr l
	rra	
	inc d	
	jp pe,l0d11h
l0cf0h:
	ld e,a	
	ld a,b	
	and 080h
	or h	
	ld h,a	
l0cf6h:
	pop af	
l0cf7h:
	pop bc	
	pop af	
	pop af	
	push bc	
	ret	
l0cfch:
	pop de	
	jr nc,l0c9bh
	jr l0cf6h
l0d01h:
	sub c	
	sbc hl,de
l0d04h:
	pop bc	
l0d05h:
	pop de	
l0d06h:
	bit 6,h
	jr nz,l0cf0h
	add a,a	
	adc hl,hl
	dec d	
	jp po,l0d06h
l0d11h:
	ld sp,iy
	pop bc	
	pop hl	
	pop hl	
	push bc	
	jp ErrOverflow
l0d1ah:
	ld c,b	
	ld b,(iy+003h)
	ld (iy-003h),b
	ld b,(iy+002h)
	ex de,hl	
	neg
	jr l0ccah
l0d29h:
	ld a,b	
	push hl	
	res 7,h
	res 7,d
	bit 7,(iy-001h)
	jr z,l0cdfh
	sub c	
	sbc hl,de
	jr nz,l0d3dh
	or a	
	jr z,l0d4dh
l0d3dh:
	jr nc,l0d04h
	ld de,00000h
	ex de,hl	
	ld c,a	
	pop af	
	cpl	
	ld b,a	
	xor a	
	sub c	
	sbc hl,de
	jr l0d05h
l0d4dh:
	ld d,h	
	ld e,h	
	pop af	
	pop af	
	jr l0cf6h
RealSqrt__:
	pop bc	
	push hl	
	push de	
	push bc	
RealMul__:
	ld iy,00000h
	add iy,sp
	ld a,040h
	and h	
	ld b,(iy+005h)
	and b	
	jr z,RealRes0__
	ld a,h	
	xor b	
	and 080h
	ld b,a	
	ld a,(iy+003h)
	add a,d	
	ld c,a	
	jp pe,l0d11h
	push bc	
	res 7,h
	ld c,e	
	xor a	
	ex de,hl	
	ld l,(iy+002h)
	ld b,008h
l0d7eh:
	rr l
	jr nc,l0d83h
	add a,d	
l0d83h:
	rra	
	djnz l0d7eh
	rr l
	ld h,a	
	ld a,(iy+004h)
	ld b,008h
l0d8eh:
	rra	
	jr nc,l0d92h
	add hl,de	
l0d92h:
	rr h
	rr l
	djnz l0d8eh
	rra	
	ld b,007h
l0d9bh:
	rr (iy+005h)
	jr nc,l0da4h
	add a,c	
	adc hl,de
l0da4h:
	rr h
	rr l
	rra	
	djnz l0d9bh
	pop bc	
	ld e,a	
	ld d,c	
	bit 6,h
	jr nz,l0db8h
	rl e
	adc hl,hl
	jr l0dbch
l0db8h:
	inc d	
	jp pe,l0d11h
l0dbch:
	ld a,b	
	or h	
	ld h,a	
	pop bc	
	pop af	
	pop af	
	push bc	
	ret	
RealRes0__:
	pop hl	
	pop de	
	ex (sp),hl	
	ld hl,00000h
	ld e,h	
	ld d,l	
	ret	
RealDiv__:
	bit 6,h
	jp z,ErrDivBy0
	ld iy,00000h
	add iy,sp
	ld b,(iy+005h)
	bit 6,b
	jp z,RealRes0__
	ld a,(iy+003h)
	sub d	
	jp pe,l0d11h
	push af	
	ld d,b	
	ld c,e	
	ld e,(iy+004h)
	ld a,d	
	xor h	
	and 080h
	res 7,d
	res 7,h
	push af	
	ex de,hl	
	ld a,(iy+002h)
	ld b,008h
l0dfch:
	sub c	
	sbc hl,de
	jr nc,l0e04h
	add a,c	
	adc hl,de
l0e04h:
	rl (iy-004h)
	add a,a	
	adc hl,hl
	djnz l0dfch
	ld b,008h
l0e0fh:
	sbc hl,de
	jr nc,l0e14h
	add hl,de	
l0e14h:
	rla	
	add hl,hl	
	djnz l0e0fh
	cpl	
	ld l,a	
	ld a,h	
	ld b,008h
l0e1dh:
	sub d	
	jr nc,l0e21h
	add a,d	
l0e21h:
	rl e
	add a,a	
	djnz l0e1dh
	pop bc	
	ld a,c	
	cpl	
	ld h,a	
	ld a,e	
	pop de	
	cpl	
	bit 7,h
	jr nz,l0e3eh
	dec d	
	jp pe,l0d11h
l0e35h:
	ld e,a	
	ld a,h	
	or b	
	ld h,a	
	pop bc	
	pop af	
	pop af	
	push bc	
	ret	
l0e3eh:
	srl h
	rr l
	rra	
	jr l0e35h
sub_0e45h:
	ld a,080h
	and h	
	jp z,l0e52h
	ex de,hl	
	ld hl,00000h
	sbc hl,de
	or a	
l0e52h:
	ld de,00000h
	adc hl,de
	ret z	
	ld d,00eh
l0e5ah:
	bit 6,h
	jp nz,l0e64h
	add hl,hl	
	dec d	
	jp l0e5ah
l0e64h:
	ld e,000h
	or h	
	ld h,a	
	ret	
Trunc__:
	bit 6,h
	ret z	
	ld a,080h
	and h	
	ld c,a	
	res 7,h
	ld a,00eh
	sub d	
	jr z,l0e81h
	jp m,l0e8bh
	ld b,a	
l0e7bh:
	srl h
	rr l
	djnz l0e7bh
l0e81h:
	inc c	
	ret p	
	ex de,hl	
	ld hl,00000h
	or a	
	sbc hl,de
	ret	
l0e8bh:
	ld hl,00000h
	ret	
sub_0e8fh:
	ld hl,(l1795h)
	ld a,048h
	and h	
	jp po,l0e99h
	scf	
l0e99h:
	rl h
	res 7,h
	ld a,l	
	rr l
	and 011h
	jp po,l0ea7h
	set 7,h
l0ea7h:
	ld a,h	
	xor l	
	ld (l1795h),hl
	ld l,a	
	ld h,000h
	ret	
Round__:
	push hl	
	push de	
	ld de,0ff00h
	ld hl,04000h
	call sub_0ca1h
Entier__:
	bit 6,h
	ret z	
	ld a,080h
	and h	
	ld c,a	
	res 7,h
	ld a,d	
	or a	
	jp m,l0ef1h
	ld a,00eh
	sub d	
	jp c,ErrOverflow
	ld b,a	
	xor a	
	cp e	
	jp z,l0ed6h
	inc a	
l0ed6h:
	dec b	
	inc b	
	jp z,l0ee3h
l0edbh:
	srl h
	rr l
	adc a,000h
	djnz l0edbh
l0ee3h:
	inc c	
	ret p	
	or a	
	jp z,l0eeah
	inc hl	
l0eeah:
	ex de,hl	
	ld hl,00000h
	sbc hl,de
	ret	
l0ef1h:
	inc c	
	ld hl,00000h
	ret p	
	dec hl	
	ret	
sub_0ef8h:
	ld hl,04000h
	ld d,l	
	ld e,l	
	ld iy,realTab1__
l0f01h:
	srl a
	jr nc,l0f1ch
	push af	
	push iy
	push hl	
	push de	
	ld h,(iy+000h)
	ld l,(iy+001h)
	ld e,(iy+002h)
	ld d,(iy+003h)
	call RealMul__
	pop iy
	pop af	
l0f1ch:
	ret z	
	ld bc,00004h
	add iy,bc
	jr l0f01h
realTab1__:
	defw 00050h
	defw 00300h
	defw 00064h
	defw 00600h
	defw 0204eh
	defw 00d00h
	defw 05e5fh
	defw 01a10h
	defw 00d47h
	defw 035e4h
	defw 0e24eh
	defw 06ad4h
sub_0f3ch:
	ld a,d	
	cp 003h
	ret c	
	push hl	
	push de	
	ld bc,05000h
	jr nz,l0f4ch
	or a	
	sbc hl,bc
	jr c,l0f5ch
l0f4ch:
	ld h,b	
	ld l,c	
l0f4eh:
	ld de,00300h
	call RealDiv__
	ld a,(l1797h)
	inc a	
	ld (l1797h),a
	ret	
l0f5ch:
	pop de	
	pop hl	
	ret	
l0f5fh:
	pop af	
l0f60h:
	pop af	
	ld a,(l17a5h)
	ld hl,(l1799h)
	ld de,(l179bh)
	jp l106fh
sub_0f6eh:
	ld a,e	
	ld (l17a5h),a
	ld a,l	
	ld (l1798h),a
	or a	
	ld a,0ffh
	jr z,l0f80h
	jp m,l0f80h
	sub l	
	dec a	
l0f80h:
	add a,e	
	pop hl	
	pop de	
	ex (sp),hl	
	ld (l1799h),hl
	ld (l179bh),de
	rlc h
	push af	
	rrc h
	jp p,l0f96h
	res 7,h
	dec a	
l0f96h:
	or a	
	jp m,l0f60h
	ld (l1797h),a
	push hl	
	push de	
	ld hl,04000h
	push hl	
	ld h,0ffh
	push hl	
	ld a,(l1798h)
	call sub_0ef8h
	call RealDiv__
	call sub_0ca1h
	ld (l070eh),hl
	ld (l179fh),de
	pop af	
	ld a,0ffh
	push af	
	ld a,(l1797h)
	ld c,a	
	ld a,(l1798h)
	add a,c	
	dec a	
	ld (l1798h),a
	ld a,c	
l0fcah:
	push hl	
	push de	
	call sub_0ef8h
	call RealDiv__
	call sub_1045h
	ld a,d	
	push af	
	cp 00ah
	jr nc,l0f5fh
	pop af	
	jp m,l1038h
	or a	
	jr nz,l0ff7h
	ld a,(l1797h)
	sub b	
	jr z,l0ff7h
	ld d,a	
	call PrSpace
	ld a,d	
	dec a	
	ld hl,(l070eh)
	ld de,(l179fh)
	jr l0fcah
l0ff7h:
	call sub_103dh
l0ffah:
	ld a,030h
	add a,d	
	call OutChr
	ld a,(l1797h)
	cp b	
	jr nz,l100bh
	ld a,02eh
	call OutChr
l100bh:
	ld a,d	
	ld hl,(l17a1h)
	ld de,(l17a3h)
	neg
	jr z,l1022h
	push hl	
	push de	
	ld l,a	
	ld h,0ffh
	call sub_0e45h
	call sub_0ca1h
l1022h:
	ld bc,05000h
	push bc	
	ld b,003h
	push bc	
	call RealMul__
	call sub_1045h
	jr nc,l0ffah
l1031h:
	ld a,030h
	add a,d	
	pop bc	
	jp OutChr
l1038h:
	call sub_103dh
	jr l1031h
sub_103dh:
	bit 0,c
	ret z	
	ld a,02dh
	jp OutChr
sub_1045h:
	ld (l17a1h),hl
	ld (l17a3h),de
	call Trunc__
	ld d,l	
	pop hl	
	pop bc	
	inc b	
	push bc	
	ld a,(l1798h)
	cp b	
	push hl	
	ret	
l105ah:
	ld hl,realStrPart
	call OutZStr
	ld a,(l1798h)
	inc a	
	ld b,a	
	ld a,030h
l1067h:
	call OutChr
	djnz l1067h
	jp OutZStr
l106fh:
	sub 008h
	jp p,l1076h
l1074h:
	ld a,004h
l1076h:
	ld (l1798h),a
	sub 005h
	jr c,l1083h
	inc a	
	call PrNSpaceA
	jr l1074h
l1083h:
	bit 6,h
	jr z,l105ah
	bit 7,h
	jr z,l1091h
	res 7,h
	ld a,02dh
	jr l1093h
l1091h:
	ld a,020h
l1093h:
	call OutChr
	ld a,d	
	or a	
	push hl	
	push de	
	ld de,0004dh
	ld h,d	
	ld l,d	
	jp m,l1138h
l10a2h:
	srl a
	jr nc,l10ach
	add hl,de	
l10a7h:
	ex de,hl	
	add hl,hl	
	ex de,hl	
	jr l10a2h
l10ach:
	jr nz,l10a7h
	ld a,h	
	ld (l1797h),a
	call sub_0ef8h
	call RealDiv__
	call sub_0f3ch
	push hl	
	push de	
l10bdh:
	ld a,(l1798h)
	add a,a	
	add a,a	
	ld e,a	
	ld d,000h
	ld hl,xxTab1__
	add hl,de	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
	ld c,(hl)	
	inc hl	
	ld h,(hl)	
	ld l,c	
	call sub_0ca1h
	call sub_0f3ch
	ld b,d	
	inc b	
	inc b	
	ld d,e	
	ld e,h	
	ld h,l	
	ld l,d	
	ld d,000h
l10e0h:
	add hl,hl	
	rl e
	rl d
	djnz l10e0h
	ld a,030h
	add a,d	
	call OutChr
	ld d,000h
	ld a,02eh
	call OutChr
	ld a,(l1798h)
	inc a	
	ld b,a	
l10f9h:
	push bc	
	call MulBy10_HL_DE
	ld a,030h
	add a,d	
	call OutChr
	ld d,000h
	pop bc	
	djnz l10f9h
	ld a,045h
	call OutChr
	ld a,(l1797h)
	or a	
	jp p,l111bh
	neg
	ld c,a	
	ld a,02dh
	jr l111eh
l111bh:
	ld c,a	
	ld a,02bh
l111eh:
	call OutChr
	ld a,c	
	ld b,00ah
	ld c,030h
l1126h:
	sub b	
	jr c,l112ch
	inc c	
	jr l1126h
l112ch:
	add a,b	
	add a,030h
	ld b,a	
	ld a,c	
	call OutChr
	ld a,b	
	jp OutChr
l1138h:
	cpl	
l1139h:
	srl a
	jr nc,l1143h
	add hl,de	
l113eh:
	ex de,hl	
	add hl,hl	
	ex de,hl	
	jr l1139h
l1143h:
	jr nz,l113eh
	ld a,h	
	cpl	
	ld (l1797h),a
	neg
	call sub_0ef8h
	call RealMul__
	push hl	
	push de	
	ld a,d	
	or a	
	jp p,l10bdh
	ld hl,05000h
	ld de,00300h
	call RealMul__
	push hl	
	push de	
	ld hl,l1797h
	dec (hl)	
	jp l10bdh
xxTab1__:

; BLOCK 'xxTab1__' (start 0x116b end 0x1188)
xxTab1___start:
	defb 066h
	defb 0fbh
	defb 066h
	defb 066h
	defb 085h
	defb 0f8h
	defb 0ebh
	defb 051h
	defb 036h
	defb 0f5h
	defb 085h
	defb 041h
	defb 08bh
	defb 0f1h
	defb 0dbh
	defb 068h
	defb 0d6h
	defb 0eeh
	defb 0e2h
	defb 053h
realStrPart:
	defb ' 0.',000h
        defb 'E+00',000h
Sqrt__:
	ld a,h	
	or a	
	jp m,ErrMath
	ret z	
	ld (l179bh),de
	ld (l1799h),hl
	sra d
	ld b,004h
l1199h:
	push bc	
	push hl	
	push de	
	ld bc,(l1799h)
	push bc	
	ld bc,(l179bh)
	push bc	
	call RealDiv__
	call sub_0ca1h
	dec d	
	pop bc	
	djnz l1199h
	ret	
sub_11b1h:
	call l0ba7h
	cp 02dh
	jr z,l11c1h
	cp 02bh
	call z,JReadEditIBuf__
	call sub_11cch
	ret	
l11c1h:
	call JReadEditIBuf__
	call sub_11cch
	ld a,080h
	xor h	
	ld h,a	
	ret	
sub_11cch:
	call sub_0b76h
	cp 02eh
	jp nz,l1221h
	call EditIBuf__
	call JReadEditIBuf__
	call IsNum
	jp nc,ErrNumExpected
	dec b	
	inc b	
	ld c,d	
	jr z,l11fdh
l11e5h:
	push bc	
	call MulBy10_HL_DE
	sub 030h
	ld c,a	
	ld b,d	
	add hl,bc	
	jr nc,l11f1h
	inc e	
l11f1h:
	pop bc	
	dec c	
	call CurrCharIsNum
	jr nc,l1207h
	call EditIBuf__
	djnz l11e5h
l11fdh:
	call CurrCharIsNum
	jr nc,l1207h
	call EditIBuf__
	jr l11fdh
l1207h:
	ld d,c	
	cp 045h
	jr nz,l1225h
l120ch:
	push de	
	call EditIBuf__
	call JReadEditIBuf__
	cp 02dh
	jr nz,l1228h
	call JReadEditIBuf__
	call sub_1290h
	pop af	
	sub b	
	jr NumToFloat__
l1221h:
	cp 045h
	jr z,l120ch
l1225h:
	ld a,d	
	jr NumToFloat__
l1228h:
	cp 02bh
	call z,JReadEditIBuf__
	call sub_1290h
	pop af	
	add a,b	
NumToFloat__:
	ld d,016h
	ld c,a	
	bit 7,e
	jp nz,l1283h
	xor a	
	cp e	
	jr nz,NToF_CorrExp
	cp l	
	jr nz,NToF_CorrNum
	cp h	
	jr nz,NToF_CorrNum
	ld d,000h
	ret	
NToF_CorrExp:
	bit 6,e
	jr nz,NToF_Convert__
NToF_CorrNum:
	add hl,hl	
	rl e
	dec d	
	jr NToF_CorrExp
NToF_Convert__:
	ld b,e	
	ld e,l	
	ld l,h	
	ld h,b	
	ld a,c	
	or a	
	ret z	
	push hl	
	push de	
	jp m,l1264h
	call sub_0ef8h
	call RealMul__
	ret	
l1264h:
	neg
	cp 020h
	jr nc,l1271h
	call sub_0ef8h
l126dh:
	call RealDiv__
	ret	
l1271h:
	sub 020h
	call sub_0ef8h
	call RealDiv__
	push hl	
	push de	
	ld hl,l4ee2h
	ld de,06ad4h
	jr l126dh
l1283h:
	inc hl	
	jr nz,l1287h
	inc e	
l1287h:
	srl e
	rr h
	rr l
	inc d	
	jr NToF_Convert__
sub_1290h:
	call IsNum
	jr nc,l12b1h
	sub 030h
	ld b,a	
	call CurrCharIsNum
	ret nc	
	call EditIBuf__
	sub 030h
	ld c,a	
	ld a,b	
	add a,a	
	ld b,a	
	add a,a	
	add a,a	
	add a,b	
	add a,c	
	ld b,a	
	call CurrCharIsNum
	jp c,l08ebh
	ret	
l12b1h:
	pop bc	
	pop bc	
	pop bc	
	ld de,tExpErw
	jp PrErr2
tExpErw:
	defb 'Exponent erwartet',000h
Frac__:
	ld a,h	
	or a	
	ret z	
	jp m,l12f2h
sub_12d2h:
	bit 7,d
	ret nz	
	ld b,d	
	inc b	
	ld a,e	
l12d8h:
	add a,a	
	adc hl,hl
	djnz l12d8h
	ld d,0ffh
	res 7,h
	ld e,a	
l12e2h:
	bit 6,h
	ret nz	
	dec d	
	sla e
	adc hl,hl
	jr nz,l12e2h
	inc e	
	dec e	
	jr nz,l12e2h
	ld d,e	
	ret	
l12f2h:
	res 7,h
	call sub_12d2h
	bit 6,h
	ret z	
	set 7,h
	push hl	
	push de	
	ld hl,04000h
	ld d,l	
	ld e,l	
	call sub_0ca1h
	ret	
Exp__:
	push hl	
	push de	
	ld hl,05c55h
	ld de,0001eh
	call RealMul__
	push hl	
	push de	
	call Entier__
	ld (l1797h),hl
	pop de	
	pop hl	
	call Frac__
	bit 6,h
	jr z,l1394h
	call sub_1720h
	exx	
	or a	
	jp m,l138fh
	jp z,l1398h
	ld hl,l139fh
l1331h:
	ld b,(hl)	
	inc hl	
	ld c,000h
	push bc	
	ld b,0feh
	push bc	
	exx	
	call sub_0ca1h
	exx	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
	push bc	
	ld c,(hl)	
	inc hl	
	ld b,000h
	push bc	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
	push bc	
	ld c,(hl)	
	ld b,004h
	push bc	
	exx	
	push hl	
	push de	
	ld bc,0c53fh
	push bc	
	ld bc,003d6h
	push bc	
	ld bc,063e7h
	push bc	
	ld bc,004dch
	push bc	
	call RealDiv__
	call sub_0ca1h
	call sub_0ca1h
	call RealDiv__
	call sub_0ca1h
l1373h:
	ld a,(l1798h)
	or a	
	jr z,l1386h
	inc a	
	jp nz,ErrOverflow
	ld a,(l1797h)
	or a	
	jp p,ErrOverflow
	ld d,a	
	ret	
l1386h:
	ld a,(l1797h)
	or a	
	jp m,ErrOverflow
	ld d,a	
	ret	
l138fh:
	ld hl,l13a6h
	jr l1331h
l1394h:
	ld h,040h
	jr l1373h
l1398h:
	ld hl,05a82h
	ld e,04fh
	jr l1373h
l139fh:
	ret nz	
	and d	
	ld l,e	
	ld a,a	
	halt	
	ld (hl),h	
	adc a,h	
l13a6h:
	ld b,b	
	dec de	
	ld c,h	
	rst 30h	
	ld e,d	
	ld d,d	
	ld (de),a	
Ln__:
	ld a,h	
	dec a	
	jp m,ErrMath
	ld a,d	
	ld (l1797h),a
	ld d,000h
	ld bc,04073h
	push bc	
	ld bc,002a1h
	push bc	
	ld bc,0c4d2h
	push bc	
	ld bc,00545h
	push bc	
	push hl	
	push de	
	ld bc,05309h
	push bc	
	ld bc,00390h
	push bc	
	ld bc,0c103h
	push bc	
	ld bc,00314h
	push bc	
	push hl	
	push de	
	ld bc,041a3h
	push bc	
	ld bc,00189h
	push bc	
	ld bc,0c43ah
	push bc	
	ld bc,0fea0h
	push bc	
	ld bc,06ccch
	push bc	
	ld bc,0fe7ch
	push bc	
	call sub_0ca1h
	call RealDiv__
	call sub_0ca1h
	call sub_0ca1h
	call RealDiv__
	call sub_0ca1h
	call sub_0ca1h
	call RealDiv__
	call sub_0ca1h
	push hl	
	push de	
	ld a,(l1797h)
	ld l,a	
	ld h,000h
	or a	
	jp p,l141ch
	dec h	
l141ch:
	call sub_0e45h
	ld bc,058b9h
	push bc	
	ld bc,0ff0ch
	push bc	
	call RealMul__
	call sub_0ca1h
	ret	
l142eh:
	ld hl,04000h
	ld d,l	
	ld e,l	
	ret	
Cos__:
	bit 6,h
	jr z,l142eh
	ld a,d	
	cp 0f3h
	jp m,l142eh
	call sub_1581h
	ld b,000h
	jr nz,l144ah
	ld b,080h
	call sub_156ah
l144ah:
	ld a,d	
	add a,002h
	ex af,af'	
	ld a,002h
	jr l1466h
Sin__:
	bit 6,h
	ret z	
	ld a,d	
	cp 0f3h
	ret m	
	push hl	
	call sub_1581h
	jr nz,l1463h
	call sub_156ah
	xor a	
l1463h:
	ex af,af'	
	xor a	
	pop bc	
l1466h:
	ex af,af'	
	xor b	
	cpl	
	and 080h
	ld (l1797h),a
	ld a,d	
	cp 0feh
	call z,sub_156ah
	ex af,af'	
	add a,a	
	ex af,af'	
	cp 0fdh
	jr nz,l147eh
	call sub_156ah
l147eh:
	cp 0fch
	ex af,af'	
	add a,a	
	ex af,af'	
	jr nz,l1494h
	ex af,af'	
	inc a	
	ex af,af'	
	ld bc,04000h
	push bc	
	ld b,0fdh
	push bc	
	set 7,h
	call sub_0ca1h
l1494h:
	ex af,af'	
	exx	
	ld l,a	
	ld h,000h
	ld de,xxTab__
	add hl,de	
	ld a,(hl)	
	ld (l1798h),a
	exx	
	ld (l1799h),de
	ld (l179bh),hl
	call RealSqrt__
	push hl	
	push de	
	ld bc,07a3bh
	push bc	
	ld bc,00021h
	push bc	
	ld bc,04d67h
	push bc	
	ld bc,00157h
	push bc	
	ld bc,0e144h
	push bc	
	ld bc,000b2h
	push bc	
	call sub_0ca1h
	call RealDiv__
	call sub_0ca1h
	ld (l17a1h),de
	ld (l17a3h),hl
	call RealDiv__
	ld c,h	
	ld a,h	
	xor 080h
	ld h,a	
	ld (l070eh),de
	ld (l179fh),hl
	ld h,c	
	push hl	
	push de	
	ld de,(l17a1h)
	ld hl,(l17a3h)
	call sub_0ca1h
	ld (l17a5h),de
	ld (l17a7h),hl
	ld a,(l1798h)
	srl a
	jr c,l1529h
	or a	
	jr nz,l1514h
	ld de,(l1799h)
	ld hl,(l179bh)
	inc d	
l150bh:
	call sub_155dh
l150eh:
	ld a,(l1797h)
	or h	
	ld h,a	
	ret	
l1514h:
	ld de,(l17a1h)
	ld hl,(l17a3h)
	push hl	
	push de	
	ld de,(l070eh)
	ld hl,(l179fh)
	call sub_0ca1h
	jr l150bh
l1529h:
	ld hl,05a82h
	ld de,0ff79h
	push hl	
	push de	
	inc d	
	or a	
	jr nz,l1537h
	set 7,h
l1537h:
	push hl	
	push de	
	ld de,(l070eh)
	ld hl,(l179fh)
	jr nz,l1546h
	ld a,h	
	xor 080h
	ld h,a	
l1546h:
	push hl	
	push de	
	ld hl,(l179bh)
	ld de,(l1799h)
	call sub_0ca1h
	call RealMul__
	call sub_155dh
l1558h:
	call sub_0ca1h
	jr l150eh
sub_155dh:
	push hl	
	push de	
	ld hl,(l17a7h)
	ld de,(l17a5h)
	call RealDiv__
	ret	
sub_156ah:
	ld a,e	
l156bh:
	dec d	
	add a,a	
	adc hl,hl
	jr z,l157bh
	bit 6,h
	jr z,l156bh
l1575h:
	ld e,a	
	ex af,af'	
	inc a	
	ex af,af'	
	ld a,d	
	ret	
l157bh:
	or a	
	jr nz,l156bh
	ld d,a	
	jr l1575h
sub_1581h:
	push af	
	res 7,h
	ld bc,0517ch
	push bc	
	ld bc,0fdc0h
	push bc	
	call RealMul__
	call Frac__
	pop af	
	ex af,af'	
	ld a,d	
	inc a	
	ret	
xxTab__:

; BLOCK 'xxTab2__' (start 0x1597 end 0x15a7)
xxTab2___start:
	defb 000h
	defb 001h
	defb 003h
	defb 002h
	defb 002h
	defb 003h
	defb 001h
	defb 000h
	defb 002h
	defb 003h
	defb 001h
	defb 000h
	defb 000h
	defb 001h
	defb 003h
	defb 002h
Arctan__:
	bit 6,h
	ret z	
	ld a,h	
	and 080h
	ld (l1797h),a
	res 7,h
	ld a,d	
	or a	
	jp m,l15cdh
	ld a,002h
	ld (l1799h),a
	exx	
	ld hl,l49e6h
	ld de,0ff9dh
	push hl	
	push de	
	ld bc,0d555h
	push bc	
	ld b,000h
	jr l15f0h
l15cdh:
	cp 0feh
	jr nc,l15dch
	cp 0f3h
	jp c,l150eh
	xor a	
	ld (l1799h),a
	jr l15fdh
l15dch:
	ld a,001h
	ld (l1799h),a
	exx	
	ld hl,06ed9h
	ld de,000ebh
	push hl	
	push de	
	ld bc,0c000h
	push bc	
	ld b,002h
l15f0h:
	push bc	
	push hl	
	push de	
	exx	
	call sub_0ca1h
	call RealDiv__
	call sub_0ca1h
l15fdh:
	push hl	
	push de	
	ld bc,04000h
	push bc	
	ld b,c	
	push bc	
	call RealSqrt__
	push hl	
	push de	
	ld bc,06000h
	push bc	
	ld b,001h
	push bc	
	inc d	
	inc d	
	push hl	
	push de	
	dec d	
	dec d	
	ld b,050h
	push bc	
	ld b,002h
	push bc	
	push hl	
	push de	
	ld bc,0638eh
	push bc	
	ld bc,0ff39h
	push bc	
	ld bc,06b15h
	push bc	
	ld bc,0fc00h
	push bc	
	call RealMul__
	call sub_0ca1h
	call RealDiv__
	call sub_0ca1h
	call RealDiv__
	call sub_0ca1h
	call RealDiv__
	call sub_0ca1h
	call RealDiv__
	ld a,(l1799h)
	or a	
	jr z,l1666h
	push hl	
	push de	
	add a,a	
	add a,a	
	ld hl,xxTab3__-4
	ld e,a	
	ld d,000h
	add hl,de	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
	ld c,(hl)	
	inc hl	
	ld h,(hl)	
	ld l,c	
	call sub_0ca1h
l1666h:
	jp l150eh
xxTab3__:
	defw 0ff48h
	defw 04305h
	defw 00048h
	defw 04305h
	defw 000ech
	defw 06487h
l1675h:
	xor a	
	jr l16b7h
Tan__:
	bit 6,h
	ret z	
	ld a,d	
	cp 0f8h
	ret m	
	ld a,h	
	ld (l1797h),a
	res 7,h
	ld bc,0517ch
	push bc	
	ld bc,0fec1h
	push bc	
	call RealMul__
	call Frac__
	call sub_1720h
	ld a,(l1797h)
	xor h	
	xor 080h
	and 080h
	ld (l1797h),a
	res 7,h
	ld a,d	
	add a,003h
	jr nc,l1675h
	jr z,l16b6h
	ld a,h	
	cp 070h
	jp nc,l172bh
	cp 060h
	ld a,002h
	jr c,l16b7h
l16b6h:
	inc a	
l16b7h:
	add a,a	
	exx	
	ld d,000h
	ld e,a	
	ld hl,l1761h
	add hl,de	
	ld c,000h
	ld b,(hl)	
	inc hl	
	push bc	
	ld b,(hl)	
	push bc	
	exx	
	call sub_0ca1h
	push hl	
	push de	
	ld bc,04305h
	push bc	
	ld bc,0ff49h
	push bc	
	ld bc,0d4e1h
	push bc	
	ld bc,0fff4h
	push bc	
	ld bc,0c0d8h
	push bc	
	ld bc,0fe77h
	push bc	
	call RealSqrt__
	call sub_0ca1h
	call RealDiv__
	call sub_0ca1h
	call RealMul__
	exx	
	sla e
	sla e
	ld hl,l1769h
	add hl,de	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	push bc	
	inc hl	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	push bc	
	inc hl	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	push bc	
	push de	
	exx	
	call sub_0ca1h
	call RealDiv__
	exx	
	set 7,b
	push bc	
	push de	
	exx	
	jp l1558h
sub_1720h:
	ld bc,0c000h
	push bc	
	ld b,0ffh
	push bc	
	call sub_0ca1h
	ret	
l172bh:
	call sub_1720h
	res 7,h
	push hl	
	push de	
	call RealSqrt__
	ld bc,06487h
	push bc	
	ld bc,001eeh
	push bc	
	push hl	
	push de	
	ld bc,052aeh
	push bc	
	ld bc,003f5h
	push bc	
	ld bc,0519ah
	push bc	
	ld bc,005f2h
	push bc	
	call RealMul__
	call sub_0ca1h
	call RealMul__
	call sub_0ca1h
	call RealMul__
	jp l150eh
l1761h:
	defs 8
l1769h:
	defs 32
retAddr__:
	defw 00000h
l178bh:
	defw 00000h
l178dh:
	defw 00000h
l178fh:
	defw 00000h
l1791h:
	defw 00000h
l1793h:
	defw 00000h
l1795h:
	defw 00000h
l1797h:
	defb 000h
l1798h:
	defb 000h
l1799h:
	defw 00000h
l179bh:
	defw 00000h
	defw 00000h
l179fh:
	defw 00000h
l17a1h:
	defw 00000h
l17a3h:
	defw 00000h
l17a5h:
	defw 00000h
l17a7h:
	defw 00000h
iBufCurChrAddr:
	defw 00000h
inputBuf:
	defs 85
RuntimeEnd:
	nop	
lineBuf:
	defs 80
lineBufEnd:
	defb 00dh
stack_adr:
	defw 00000h
ram_end:
	defw 00000h
heapEndAddr:
PasIDEStartAddr:
	defw START_PASCAL
RL_SETSYS:
	defw 00000h
	defb 'SETSY','S'+0x80
	defb 006h
	defw PaSetsys
RL_GETSYS:
	defw RL_SETSYS
	defb 'GETSY','S'+0x80
	defb 009h
	defb 001h
	defb 000h
	defw l515bh
	defb 002h
RL_PLOT:
	defw RL_GETSYS
	defb 'PLO','T'+0x80
	defb 006h
	defw l5174h
RL_CLRPLOT:
	defw RL_PLOT
	defb 'CLRPLO','T'+0x80
	defb 006h
	defw l51a0h
RL_PTEST:
	defw RL_CLRPLOT
	defb 'PTES','T'+0x80
	defb 009h
	defb 004h
	defb 000h
	defw l5188h
	defb 003h
RL_GETC:
	defw RL_PTEST
	defb 'GET','C'+0x80
	defb 009h
	defb 001h
	defb 000h
	defw l5194h
	defb 003h
RL_SETC:
	defw RL_GETC
	defb 'SET','C'+0x80
	defb 006h
	defw l5160h
RL_LINEPLOT:
	defw RL_SETC
	defb 'LINEPLO','T'+0x80
	defb 006h
	defw l51b4h
RL_CIRCLE:
	defw RL_LINEPLOT
	defb 'CIRCL','E'+0x80
	defb 006h
	defw l51d0h
RL_GOTOXY:
	defw RL_CIRCLE
	defb 'GOTOX','Y'+0x80
	defb 006h
	defw l5136h
RL_PI:
	defw RL_GOTOXY
	defb 'P','I'+0x80
	defb 001h
	defb 002h
	defb 000h
	defb 0ech
	defb 001h
	defb 087h
	defb 064h
RL_FRAC:
	defw RL_PI
	defb 'FRA','C'+0x80
	defb 00bh
	defw Frac__
RL_READKBD:
	defw RL_FRAC
	defb 'READKB','D'+0x80
	defb 009h
	defb 003h
	defb 000h
	defw l51e8h
	defb 001h
RL_SHR:
	defw RL_READKBD
	defb 'SH','R'+0x80
	defb 009h
	defb 001h
	defb 000h
	defw l5219h
	defb 003h
RL_SHL:
	defw RL_SHR
	defb 'SH','L'+0x80
	defb 009h
	defb 001h
	defb 000h
	defw l5227h
	defb 003h
RL_LO:
	defw RL_SHL
	defb 'L','O'+0x80
	defb 009h
	defb 001h
	defb 000h
	defw l5210h
	defb 002h
RL_HI:
	defw RL_LO
	defb 'H','I'+0x80
	defb 009h
	defb 001h
	defb 000h
	defw l520bh
	defb 002h
RL_SWAP:
	defw RL_HI
	defb 'SWA','P'+0x80
	defb 009h
	defb 001h
	defb 000h
	defw l5214h
	defb 002h
RL_BXOR:
	defw RL_SWAP
	defb 'BXO','R'+0x80
	defb 009h
	defb 001h
	defb 000h
	defw l5201h
	defb 003h
RL_BOR:
	defw RL_BXOR
	defb 'BO','R'+0x80
	defb 009h
	defb 001h
	defb 000h
	defw l51f7h
	defb 003h
RL_BAND:
	defw RL_BOR
	defb 'BAN','D'+0x80
	defb 009h
	defb 001h
	defb 000h
	defw l51edh
	defb 003h
RL_EXP:
	defw RL_BAND
	defb 'EX','P'+0x80
	defb 00bh
	defw Exp__
RL_LN:
	defw RL_EXP
	defb 'L','N'+0x80
	defb 00bh
	defw Ln__
RL_ARCTAN:
	defw RL_LN
	defb 'ARCTA','N'+0x80
	defb 00bh
	defw Arctan__
RL_TAN:
	defw RL_ARCTAN
	defb 'TA','N'+0x80
	defb 00bh
	defw Tan__
RL_COS:
	defw RL_TAN
	defb 'CO','S'+0x80
	defb 00bh
	defw Cos__
RL_SIN:
	defw RL_COS
	defb 'SI','N'+0x80
	defb 00bh
	defw Sin__
RL_INP:
	defw RL_SIN
	defb 'IN','P'+0x80
	defb 009h
	defb 003h
	defb 000h
	defw l52ach
	defb 002h
RL_OUT:
	defw RL_INP
	defb 'OU','T'+0x80
	defb 006h
	defw l5290h
RL_SIZE:
	defw RL_OUT
	defb 'SIZ','E'+0x80
	defb 007h
	defw l526bh
RL_ADDR:
	defw RL_SIZE
	defb 'ADD','R'+0x80
	defb 007h
	defw l527fh
RL_INLINE:
	defw RL_ADDR
	defb 'INLIN','E'+0x80
	defb 006h
	defw l438ah
RL_ENTIER:
	defw RL_INLINE
	defb 'ENTIE','R'+0x80
	defb 00ch
	defw Entier__
RL_USER:
	defw RL_ENTIER
	defb 'USE','R'+0x80
	defb 008h
	defb 000h
	defb 000h
	defw l52bch
	defb 002h
RL_RANDOM:
	defw RL_USER
	defb 'RANDO','M'+0x80
	defb 009h
	defb 001h
	defb 000h
	defw l52c5h
	defb 001h
RL_KEYPRESSED:
	defw RL_RANDOM
	defb 'KEYPRESSE','D'+0x80
	defb 009h
	defb 004h
	defb 000h
	defw l52b2h
	defb 001h
RL_HALT:
	defw RL_KEYPRESSED
	defb 'HAL','T'+0x80
	defb 008h
	defb 000h
	defb 000h
	defw l52cah
	defb 001h
RL_EOLN:
	defw RL_HALT
	defb 'EOL','N'+0x80
	defb 009h
	defb 004h
	defb 000h
	defw l52d1h
	defb 001h
RL_PAGE:
	defw RL_EOLN
	defb 'PAG','E'+0x80
	defb 008h
	defb 000h
	defb 000h
	defw l52d6h
	defb 001h
RL_SQRT:
	defw RL_PAGE
	defb 'SQR','T'+0x80
	defb 00bh
	defw Sqrt__
RL_ROUND:
	defw RL_SQRT
	defb 'ROUN','D'+0x80
	defb 00ch
	defw Round__
RL_TRUNC:
	defw RL_ROUND
	defb 'TRUN','C'+0x80
	defb 00ch
	defw Trunc__
RL_MAXINT:
	defw RL_TRUNC
	defb 'MAXIN','T'+0x80
	defb 001h
	defb 001h
	defb 000h
	defw 07fffh
RL_SUCC:
	defw RL_MAXINT
	defb 'SUC','C'+0x80
	defb 007h
	defw l436ch
RL_PRED:
	defw RL_SUCC
	defb 'PRE','D'+0x80
	defb 007h
	defw l435bh
RL_ORD:
	defw RL_PRED
	defb 'OR','D'+0x80
	defb 007h
	defw l434ch
RL_PEEK:
	defw RL_ORD
	defb 'PEE','K'+0x80
	defb 007h
	defw l4536h
RL_POKE:
	defw RL_PEEK
	defb 'POK','E'+0x80
	defb 006h
	defw l3844h
RL_RELEASE:
	defw RL_POKE
	defb 'RELEAS','E'+0x80
	defb 006h
	defw l507bh
RL_MARK:
	defw RL_RELEASE
	defb 'MAR','K'+0x80
	defb 006h
	defw l5076h
RL_NEW:
	defw RL_MARK
	defb 'NE','W'+0x80
	defb 006h
	defw l509eh
RL_TOUT:
	defw RL_NEW
	defb 'TOU','T'+0x80
	defb 006h
	defw l50fah
RL_TIN:
	defw RL_TOUT
	defb 'TI','N'+0x80
	defb 006h
	defw l50eeh
RL_CHR:
	defw RL_TIN
	defb 'CH','R'+0x80
	defb 009h
	defb 003h
	defb 000h
	defw l52ceh
	defb 002h
RL_ODD:
	defw RL_CHR
	defb 'OD','D'+0x80
	defb 009h
	defb 004h
	defb 000h
	defw l52c0h
	defb 002h
RL_ABS:
	defw RL_ODD
	defb 'AB','S'+0x80
	defb 00dh
	defw l52e3h
	defw l52eeh
RL_SQR:
	defw RL_ABS
	defb 'SQ','R'+0x80
	defb 00dh
	defw l52dch
	defw l52e8h
RL_FALSE:
	defw RL_SQR
	defb 'FALS','E'+0x80
	defb 001h
	defb 004h
	defb 000h
	defb 000h
	defb 001h
RL_TRUE:
	defw RL_FALSE
	defb 'TRU','E'+0x80
	defb 001h
	defb 004h
	defb 000h
	defb 001h
	defb 001h
RL_BOOLEAN:
	defw RL_TRUE
	defb 'BOOLEA','N'+0x80
	defb 003h
	defb 004h
	defb 000h
	defb 000h
	defb 001h
	defb 001h
	defb 001h
	defb 001h
	defb 000h
RL_CHAR:
	defw RL_BOOLEAN
	defb 'CHA','R'+0x80
	defb 003h
	defb 003h
	defb 000h
	defb 000h
	defb 0ffh
	defb 0ffh
	defb 0ffh
	defb 001h
	defb 000h
RL_REAL:
	defw RL_CHAR
	defb 'REA','L'+0x80
	defb 003h
	defb 002h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 004h
	defb 000h
RL_INTEGER:
	defw RL_REAL
	defb 'INTEGE','R'+0x80
	defb 003h
	defb 001h
	defb 000h
	defb 001h
	defb 080h
	defb 0ffh
	defb 07fh
	defb 002h
	defb 000h
RL_READLN:
	defw RL_INTEGER
	defb 'READL','N'+0x80
	defb 006h
	defw l3ee5h
RL_READ:
	defw RL_READLN
	defb 'REA','D'+0x80
	defb 006h
	defw l3e95h
RL_WRITELN:
	defw RL_READ
	defb 'WRITEL','N'+0x80
	defb 006h
	defw l3d6eh
RL_WRITE:
	defw RL_WRITELN
	defb 'WRIT','E'+0x80
	defb 006h
	defw l3d81h

; BLOCK 'Symtab_open' (start 0x1b35 end 0x2355)
Symtab_open_start:
	defs 2080

START_PASCAL:
	call GetRAMEnd
l2358h:
	ld (ram_end),de
	ld (stack_adr),hl
	ld sp,(stack_adr)
	call InitEditor__
	ld a,02ch
	ld (separator__),a
	ld a,00ah
	ld (listPageSize),a
	ld hl,0000ah
	ld (lineNumStart__),hl
	ld (lineNumInc__),hl
	ld hl,StartPASSrc
	ld (endPASSrc_adr),hl
	ld (startPASSrc_adr__),hl
	ld (compiBinStart__),hl
	ld hl,banner
	call OutZStr
ResetPasStack:
	ld sp,(stack_adr)
	call PrNL
	call JResetPrintFlag
l2395h:
	ld sp,(stack_adr)
	call sub_2ba3h
	ld h,a	
	ld l,a	
	ld (param1),hl
	ld (param2),hl
	ld hl,(endPASSrc_adr)
	inc hl	
	ld de,(compiBinStart__)
	sbc hl,de
	jr c,ExecCmdLine
	ld hl,l29cbh
	ld (cmdTabRunAddr),hl
ExecCmdLine:
	call sub_23edh
	jr nz,l23e5h
	ld hl,l2395h
	push hl	
	ld a,(l2b33h)
	ld hl,cmdTab
	ld b,013h
TestCmd:
	cp (hl)	
	jr z,RunCmd
	sub 020h
	cp (hl)	
	jr z,RunCmd
	add a,020h
	inc hl	
	inc hl	
	inc hl	
	djnz TestCmd
	ret	
RunCmd:
	inc hl	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ex de,hl	
	jp (hl)	
LdHLSrcEnd:
	ld hl,(endPASSrc_adr)
	ret	
GetPar3:
	ld hl,param3
	ret	
l23e5h:
	ld hl,tPardon
	call OutZStr
	jr l2395h
sub_23edh:
	ld a,02bh
	call OutChr
	ld d,001h
	call l0aach
	ld hl,lineBuf
	call sub_249dh
	ld (l2b33h),a
	ret z	
	cp 05ah
	jr z,l2409h
	cp 07ah
	jr nz,l2411h
l2409h:
	push hl	
	ld hl,000afh
	ld (l24c4h),hl
	pop hl	
l2411h:
	call IsNum
	jr nc,l2434h
	call sub_24abh
	ret nz	
	ld (curLineNum_safe__),hl
	inc de	
	ld a,(de)	
	inc de	
	cp 00dh
	jr nz,l242fh
	ld (param1),hl
	ld (param2),hl
	call DoCmdD
	xor a	
	ret	
l242fh:
	call sub_28f5h
	xor a	
	ret	
l2434h:
	call sub_249ch
	ret z	
	cp b	
	jr z,l244ah
	call sub_24abh
	ret nz	
	ld (lineNumStart__),hl
	ld (param1),hl
	ex de,hl	
l2446h:
	call sub_249ch
	ret z	
l244ah:
	cp b	
	jr nz,l2446h
	call sub_249ch
	ret z	
	cp b	
	jr z,l2463h
	call sub_24abh
	ret nz	
	ld (lineNumInc__),hl
	ld (param2),hl
	ex de,hl	
l245fh:
	call sub_249ch
	ret z	
l2463h:
	cp b	
	jr nz,l245fh
	ld c,b	
	inc hl	
	ld a,(hl)	
	cp c	
	jr z,l247dh
	ld de,param3
	call sub_2481h
	jr c,l247eh
	ret z	
	dec hl	
l2476h:
	call sub_249ch
	ret z	
	cp b	
	jr nz,l2476h
l247dh:
	inc hl	
l247eh:
	ld de,param4
sub_2481h:
	ld b,014h
	ld a,00dh
	push de	
	push bc	
l2487h:
	ld (de),a	
	inc de	
	djnz l2487h
	pop bc	
	pop de	
l248dh:
	ld a,(hl)	
	inc hl	
	cp c	
	jr nz,l2494h
	scf	
	ret	
l2494h:
	cp 00dh
	ret z	
	ld (de),a	
	inc de	
	djnz l248dh
	ret	
sub_249ch:
	inc hl	
sub_249dh:
	ld a,(separator__)
	ld b,a	
l24a1h:
	ld a,(hl)	
	inc hl	
	cp 020h
	jr z,l24a1h
	dec hl	
	cp 00dh
	ret	
sub_24abh:
	ld a,(hl)	
	inc hl	
	ld (iBufCurChrAddr),hl
	call IsNum
	jr nc,l24c7h
	call sub_0b76h
l24b8h:
	ld a,d	
	or e	
	ld de,(iBufCurChrAddr)
	dec de	
	ret nz	
	ld a,h	
	or l	
	jr z,l24b8h
l24c4h:
	bit 7,h
	ret	
l24c7h:
	or a	
	ret	
DoCmdI:
	ld hl,(lineNumStart__)
InsNextLine:
	ld (curLineNum_safe__),hl
	push hl	
	call PrSrcLiNum
	call EditSrcLine__
	pop hl	
	ret nc	
	push hl	
	call CompriLineBuf__
	pop de	
	ld hl,(lineNumInc__)
	add hl,de	
	ld a,h	
	rlca	
	ret c	
	jr InsNextLine
GetParams:
	ld bc,(param1)
	ld a,c	
	or b	
	ret z	
	ld hl,(param2)
	ld a,l	
	or h	
	ret	
DoCmdD:
	call GetParams
	ret z	
	push hl	
	call GotoSrcLineBC
	pop bc	
	ret c	
	push hl	
	call GotoSrcLineBC
	pop de	
	call z,INC_HL_toEOL
	or a	
	sbc hl,de
	add hl,de	
	ret z	
	ret c	
	ld bc,(endPASSrc_adr)
	call MoveSrcLines
	ld (endPASSrc_adr),de
	ret	
MoveSrcLines:
	push de	
	ex de,hl	
	ld h,b	
	ld l,c	
	or a	
	sbc hl,de
	ld b,h	
	ld c,l	
	pop hl	
	sbc hl,de
	add hl,de	
	ex de,hl	
	jr c,MoveSrcLinesUp
	add hl,bc	
	ex de,hl	
	add hl,bc	
	ex de,hl	
	inc bc	
	push de	
	lddr
	pop de	
	ret	
MoveSrcLinesUp:
	inc bc	
	ldir
	dec de	
	ret	
DoCmdS:
	ld a,(param3)
	cp 020h
	ret z	
	ld (separator__),a
	ret	
StartEditPrevLine:
	push bc	
TryPrevLineNum:
	dec bc	
	ld a,b	
	or c	
	jr z,NoPrevLine
	call GotoSrcLineBC
	jr c,NoPrevLine
	jr nz,TryPrevLineNum
	pop hl	
	jr PrevLineFound
NoPrevLine:
	pop bc	
PrevLineFound:
	ld sp,(stack_adr)
	ld (param1),bc
	ld hl,l2395h
	push hl	
	push hl	
	call InitEditor__
l2561h:
	pop hl	
	call PrNL
DoCmdE:
	ld bc,(param1)
	call GotoSrcLineBC
	ret nz	
	inc hl	
	inc hl	
	call ExpSrcToLineBuf
	call sub_29d7h
	call sub_29d4h
l2578h:
	exx	
	res 0,d
	exx	
	ld a,05fh
	ld c,(ix+000h)
	bit 3,c
	jr z,l2587h
	ld a,02ah
l2587h:
	bit 2,c
	jr z,l258dh
	ld a,02bh
l258dh:
	call GetKey
	ld de,l2578h
	push de	
	bit 2,c
	jr nz,l2601h
	bit 3,c
	jr nz,l25a4h
	ld hl,EdCmdTab
	ld b,00eh
	jp TestCmd
l25a4h:
	cp 00dh
	jr nz,l25ach
	res 3,(ix+000h)
l25ach:
	cp 00bh
	jr nz,l25b7h
	set 4,(ix+000h)
	or a	
	jr l25cbh
l25b7h:
	cp 008h
	jr nz,l25c0h
	call sub_2668h
	jr l2636h
l25c0h:
	bit 4,(ix+000h)
	jr z,l25d4h
l25c6h:
	ld a,(l2b3fh)
	and 003h
l25cbh:
	ld a,020h
	jr nz,l25d4h
	res 4,(ix+000h)
	ret	
l25d4h:
	cp 020h
	ret c	
	ld e,a	
	ld a,(l2b40h)
	or a	
	ret z	
	ld hl,lineBuf
	call FindEOL_SetDistInA
	cp 051h
	ret z	
	ld b,h	
	ld c,l	
	dec bc	
	ld hl,(l2b42h)
	push de	
	push hl	
	ld d,h	
	ld e,l	
	inc de	
	call MoveSrcLines
	pop hl	
	pop de	
	ld (hl),e	
	call sub_2619h
	bit 4,(ix+000h)
	ret z	
	jr l25c6h
l2601h:
	cp 008h
	jr z,sub_2668h
	cp 00dh
	jr nz,l260dh
	res 2,(ix+000h)
l260dh:
	cp 020h
	ret c	
	ld hl,(l2b42h)
	ld d,a	
	ld a,(hl)	
	cp 00dh
	ret z	
	ld (hl),d	
sub_2619h:
	call sub_2653h
	cp 00dh
	ret z	
	call LineEdNextLine__
l2622h:
	ld a,e	
	ex de,hl	
	ld hl,l2b3fh
	ld (hl),b	
	inc hl	
	ld (hl),c	
	inc hl	
	ld (hl),a	
	inc hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	exx	
	res 1,d
	exx	
	or a	
	ret	
l2636h:
	ld hl,(l2b42h)
	ld a,(hl)	
	cp 00dh
	ret z	
	ld bc,lineBufEnd
	ld d,h	
	ld e,l	
	inc hl	
	call MoveSrcLines
	ret	
l2647h:
	ld a,(l2b3fh)
	and 007h
	ret z	
l264dh:
	call sub_2619h
	ret z	
	jr l2647h
sub_2653h:
	exx	
	ld d,003h
	exx	
	ld hl,l2b3fh
	ld b,(hl)	
	inc hl	
	ld c,(hl)	
	inc hl	
	ld e,(hl)	
	inc hl	
	ld a,(hl)	
	inc hl	
	ld h,(hl)	
	ld l,a	
	ld d,006h
	ld a,(hl)	
	ret	
sub_2668h:
	call sub_2653h
	ld a,008h
	call ItsCuL
	jr l2622h
l2672h:
	set 2,(ix+000h)
	ret	
l2677h:
	call sub_2619h
	jr nz,l2677h
l267ch:
	set 3,(ix+000h)
	ret	
l2681h:
	ld hl,(l2b42h)
	ld a,(hl)	
	cp 00dh
	ret z	
	call l2636h
	jr l2681h
l268dh:
	pop hl	
	pop hl	
	pop hl	
	jr l26e8h
l2692h:
	ld de,(l2b48h)
	call sub_2749h
	jr nc,l269dh
	pop hl	
	ret	
l269dh:
	ld hl,param3
	call FindEOL_SetDistInA
	dec a	
	ld e,a	
	ld hl,param4
	push hl	
	call FindEOL_SetDistInA
	dec a	
	push af	
	sub e	
	ld b,000h
	ld d,b	
	ld c,a	
	jp p,l26b7h
	dec b	
l26b7h:
	ld hl,lineBuf
	call FindEOL_SetDistInA
	dec hl	
	push hl	
	sub 051h
	add a,c	
	jp p,l268dh
	ld hl,(l2b48h)
	add hl,de	
	push hl	
	add hl,bc	
	ex de,hl	
	pop hl	
	pop bc	
	call MoveSrcLines
	pop bc	
	pop hl	
	ld c,b	
	ld b,000h
	inc c	
	dec c	
	ld de,(l2b48h)
	jr z,l26e0h
	ldir
l26e0h:
	call sub_2746h
	pop hl	
	jp nc,l275eh
	ret	
l26e8h:
	ld de,(l2b48h)
	inc de	
	jr l26e0h
DoCmdL:
	ld bc,(param1)
	ld a,b	
	or c	
	jr nz,l26f8h
	inc c	
l26f8h:
	call GotoSrcLineBC
	ret c	
ListPage:
	exx	
	set 0,d
	ld a,(listPageSize)
	ld e,a	
	exx	
ListLine:
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	ex de,hl	
	ld hl,(param2)
	ld a,h	
	or l	
	jr nz,l2712h
	ld hl,07fffh
l2712h:
	sbc hl,bc
	ret c	
	ld h,b	
	ld l,c	
	push de	
	call PrSrcLiNum
	pop hl	
	push hl	
	inc hl	
	call ExpSrcToLineBuf
	call EditSrcLine__
	pop hl	
	dec hl	
	call INC_HL_toEOL
	ret z	
	exx	
	dec e	
	ld a,e	
	dec a	
	exx	
	jp p,ListLine
	call GetKey
	cp 003h
	ret z	
	jr ListPage
DoCmdK:
	ld a,(param1)
	or a	
	jr nz,l2742h
	ld a,00ah
l2742h:
	ld (listPageSize),a
	ret	
sub_2746h:
	call PrNL
sub_2749h:
	push de	
	ld hl,(param1)
	call CompriLineBuf__
	push hl	
	call ExpSrcToLineBuf
	pop bc	
	dec bc	
	dec bc	
	pop de	
	jr l279bh
DoCmdF:
	call sub_277ah
	ret c	
l275eh:
	ld de,(l2b48h)
	push de	
	call sub_29d7h
	call sub_2653h
l2769h:
	pop de	
	or a	
	sbc hl,de
	add hl,de	
	jp z,l2578h
	inc hl	
	push de	
	push hl	
	call sub_2619h
	pop hl	
	jr l2769h
sub_277ah:
	ld bc,(lineNumStart__)
	call GotoSrcLineBC
	ret c	
l2782h:
	push hl	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
	push de	
	call ExpSrcToLineBuf
	pop de	
	pop bc	
	ld hl,(lineNumInc__)
	or a	
	sbc hl,de
	ret c	
	ld (param1),de
	ld de,lineBuf
l279bh:
	ld (l2b48h),de
	ld hl,param3
	ld a,(hl)	
	cp 00dh
	scf	
	ret z	
l27a7h:
	ld a,(hl)	
	cp 00dh
	ret z	
	ld a,(de)	
	cp 00dh
	jr z,l27b7h
	cp (hl)	
	inc hl	
	inc de	
	jr z,l27a7h
	jr l279bh
l27b7h:
	ld h,b	
	ld l,c	
	call INC_HL_toEOL
	jr nz,l2782h
	scf	
	ret	
DoCmdP:
	ld bc,(lineNumStart__)
	call GotoSrcLineBC
	ret c	
	push hl	
	ld bc,(lineNumInc__)
	call GotoSrcLineBC
	pop de	
	jr z,CmdPGotoEOL
	jr nc,CmdPGotoEOL
	ld hl,(endPASSrc_adr)
	ld (hl),000h
	inc hl	
	ld (hl),000h
	inc hl	
CmdPGotoEOL:
	call z,INC_HL_toEOL
	or a	
	sbc hl,de
	ret z	
	ret c	
	ld b,h	
	ld c,l	
	ex de,hl	
	ld de,param3
	jp SaveSrcFile
DoCmdG:
	ld hl,(endPASSrc_adr)
	push hl	
	ld de,param3
	call LoadSrcFile
l27f9h:
	dec de	
	ld a,(de)	
	or a	
	jr z,l27f9h
	inc de	
	ld (endPASSrc_adr),de
	pop de	
	ld hl,(startPASSrc_adr__)
	or a	
	sbc hl,de
	ret z	
	ld hl,00001h
	ld (param1),hl
	ld (param2),hl
DoCmdN:
	call GetParams
	ret z	
	call sub_2820h
	ret m	
	set 5,(ix+000h)
sub_2820h:
	ld hl,(param1)
	push hl	
	ld hl,(startPASSrc_adr__)
	call CMP_HL_srcEnd
l282ah:
	pop de	
	ret z	
	bit 5,(ix+000h)
	jr z,l2836h
	ld (hl),e	
	inc hl	
	ld (hl),d	
	dec hl	
l2836h:
	ex de,hl	
	ld bc,(param2)
	or a	
	adc hl,bc
	ret m	
	push hl	
	ex de,hl	
	call INC_HL_toEOL
	jr l282ah
DoCmdO:
	ld hl,(endPASSrc_adr)
	push hl	
	ld de,param3
	call LoadSrcFile
	ld (endPASSrc_adr),de
	ld hl,(lineNumStart__)
	ld a,l	
	or h	
	jr z,l285ch
	dec hl	
l285ch:
	ld (l2b4ah),hl
	pop hl	
l2860h:
	ld de,lineBuf
	ld a,(lineNumInc__)
	ld c,a	
l2867h:
	ld a,(hl)	
	bit 0,c
	call nz,Upper
	ld (de),a	
	cp 00dh
	jr z,l2876h
	inc hl	
	inc de	
	jr l2867h
l2876h:
	ld hl,(l2b4ah)
	inc hl	
	ld (l2b4ah),hl
	call CompriLineBuf__
	ex de,hl	
	push hl	
	push hl	
	ld a,00dh
	ld bc,00000h
	cpir
	ld a,(hl)	
	cp 00ah
	jr nz,l2890h
	inc hl	
l2890h:
	ex de,hl	
	ld hl,(endPASSrc_adr)
	or a	
	sbc hl,de
	ld b,h	
	ld c,l	
	pop hl	
	ex de,hl	
	ldir
	pop hl	
	ld a,(hl)	
	cp 01ah
	jr nz,l2860h
	ld (hl),000h
	ld (endPASSrc_adr),hl
	ret	
SrcToLineBuf:
	or a	
	sbc hl,de
	ret z	
	push bc	
	ld b,h	
	ld c,l	
	ld a,00dh
	ld hl,0fffch
	add hl,bc	
	jr nc,NotFound
	inc hl	
	ld b,h	
	ld c,l	
	ld h,d	
	ld l,e	
	inc hl	
	inc hl	
	inc hl	
	cpir
	jr z,l28c8h
NotFound:
	scf	
	pop bc	
	ex de,hl	
	ret	
l28c8h:
	ex de,hl	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
	pop de	
	push bc	
	call ExpandLine
	inc hl	
	pop de	
	or a	
	ret	
DoCmdM:
	ld bc,(lineNumStart__)
	call GotoSrcLineBC
	ret nz	
	inc hl	
	inc hl	
	call ExpSrcToLineBuf
	ld hl,(lineNumInc__)
	jr CompriLineBuf__
l28e8h:
	call sub_29cch
	ld hl,(param1)
	ld de,lineBuf
	pop bc	
CompriLineBuf__:
	ld de,lineBuf
sub_28f5h:
	ex de,hl	
	ld b,000h
SkipSpace:
	ld a,(hl)	
	cp 020h
	jr nz,WrNumLeadSp
	inc b	
	inc hl	
	jr SkipSpace
WrNumLeadSp:
	dec hl	
	ld (hl),b	
	inc hl	
	push hl	
	push de	
	ld (SP_safe),sp
	ex de,hl	
CompriLine:
	call GetSrcChr
	call IsAlpha
	jr nc,CompriLine
	push de	
	call LxIdentifier
	inc c	
	dec c	
	pop hl	
	jr z,CompriLine
	dec hl	
	set 7,c
	ld (hl),c	
	inc hl	
	push hl	
	dec de	
	ld bc,lineBufEnd
	ex de,hl	
	call MoveSrcLines
	pop de	
	jr CompriLine
GetChr_LinBToSrc:
	bit 6,(ix+000h)
	jr nz,GetChr_LinBToSrc1
	ld a,(de)	
	inc de	
	jp SetAToSpaceIfEOL
GetChr_LinBToSrc1:
	res 6,(ix+000h)
	ld sp,(SP_safe)
	pop de	
	pop hl	
	push hl	
	push de	
	call FindEOL_SetDistInA
	inc a	
	ld d,000h
	ld e,a	
	pop hl	
	push hl	
	push de	
	ld b,h	
	ld c,l	
	call GotoSrcLineBC
	pop de	
	jr z,OvwrtSrcLine
	ex de,hl	
	push hl	
	add hl,de	
	inc hl	
	inc hl	
	ex de,hl	
	push hl	
MakeRoomAndInsert:
	ld bc,(endPASSrc_adr)
	call MoveSrcLines
	ld (endPASSrc_adr),de
	pop hl	
	pop bc	
	pop de	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	ex de,hl	
	pop hl	
	dec hl	
	push de	
	ldir
	pop hl	
	ret	
OvwrtSrcLine:
	push de	
	push hl	
	inc hl	
	inc hl	
	inc hl	
	call FindEOL_SetDistInA
	inc a	
	push hl	
	ex de,hl	
	ld e,a	
	ld d,000h
	or a	
	sbc hl,de
	ex de,hl	
	pop hl	
	ex de,hl	
	add hl,de	
	ex de,hl	
	jr MakeRoomAndInsert
FindEOL_SetDistInA:
	ld a,00dh
	push bc	
	ld bc,00000h
	cpir
	ld a,c	
	neg
	pop bc	
	ret	
GotoSrcLineBC:
	ld hl,(startPASSrc_adr__)
	call CMP_HL_srcEnd
TestSrcEnd:
	jr nz,CompLineNumBC
	sub 001h
	ret	
CompLineNumBC:
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	or a	
	ex de,hl	
	sbc hl,bc
	ex de,hl	
	dec hl	
	ret nc	
	call INC_HL_toEOL
	jr TestSrcEnd
INC_HL_toEOL:
	inc hl	
	inc hl	
	inc hl	
	ld a,00dh
	push bc	
	ld c,000h
	cpir
	pop bc	
CMP_HL_srcEnd:
	push de	
	ld de,(endPASSrc_adr)
	xor a	
	sbc hl,de
	add hl,de	
	pop de	
l29cbh:
	ret	
sub_29cch:
	call sub_2619h
	jr nz,sub_29cch
	jp PrNL
sub_29d4h:
	call sub_29cch
sub_29d7h:
	ld de,lineBuf
	ld hl,l2b3fh
	ld a,022h
	ld (hl),a	
	inc hl	
	ld (hl),051h
	inc hl	
	ld (hl),000h
	inc hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	ld hl,(param1)
PrSrcLiNum:
	ld a,005h
	call PrDez
	jp PrSpace
l29f5h:
	pop hl	
	jp PrNL
DoCmdX:
	ld de,StartPASSrc
	call PrWordHex
	call PrSpace
	ld de,(endPASSrc_adr)
	call PrWordHex
	call PrSpace
	ld de,(stack_adr)
	call PrWordHex
	call PrSpace
	ld de,(ram_end)
	call PrWordHex
	jp PrNL
DoCmdV:
	ld a,005h
	ld hl,(lineNumStart__)
	call PrDez
	call sub_2a6eh
	ld a,005h
	ld hl,(lineNumInc__)
	call PrDez
	call sub_2a6eh
	ld hl,param3
	call sub_2a64h
	call sub_2a6eh
	ld hl,param4
	call sub_2a64h
	jp PrNL
DoCmdZ:
	ld hl,(lineNumStart__)
	ld de,(lineNumInc__)
	ld bc,07ccbh
	ld (l24c4h),bc
	ld a,h	
	cp 054h
	jr c,l2a5eh
	ld a,d	
	cp 014h
l2a5eh:
	jp c,l23e5h
	jp l2358h
sub_2a64h:
	ld a,(hl)	
	cp 00dh
	ret z	
	call OutChr
	inc hl	
	jr sub_2a64h
sub_2a6eh:
	ld a,(separator__)
	jp OutChr
DoCmdT:
	call GotoSrcLinePar1
	jp JCompileToRuntimeEnd
DoCmdC:
	ld hl,PasPrgStart
	ld (cmdTabRunAddr),hl
	call GotoSrcLinePar1
	ld de,(endPASSrc_adr)
	inc de	
	inc de	
	jp JCompile
GotoSrcLinePar1:
	ld bc,(param1)
	ld a,b	
	or c	
SetHLFirstSrcLine:
	ld hl,(startPASSrc_adr__)
	ret z	
	call GotoSrcLineBC
	ret nc	
	xor a	
	jr SetHLFirstSrcLine
cmdTab:
	defb 'B'
	defw JEndPascal
	defb 'C'
	defw DoCmdC
	defb 'D'
	defw DoCmdD
	defb 'E'
	defw DoCmdE
	defb 'F'
	defw DoCmdF
	defb 'G'
	defw DoCmdG
	defb 'I'
	defw DoCmdI
	defb 'L'
	defw DoCmdL
	defb 'K'
	defw DoCmdK
	defb 'M'
	defw DoCmdM
	defb 'N'
	defw DoCmdN
	defb 'O'
	defw DoCmdO
	defb 'P'
	defw DoCmdP
	defb 'R'
cmdTabRunAddr:
	defw PasPrgStart
	defb 'S'
	defw DoCmdS
	defb 'T'
	defw DoCmdT
	defb 'V'
	defw DoCmdV
	defb 'X'
	defw DoCmdX
	defb 'Z'
	defw DoCmdZ
EdCmdTab:
	defb 00bh
	defw l264dh
	defb 009h
	defw sub_2619h
	defb 008h
	defw sub_2668h
	defb 'C'
	defw l2672h
	defb 00dh
	defw l28e8h
	defb 'F'
	defw l26e8h
	defb 'I'
	defw l267ch
	defb 'K'
	defw l2636h
	defb 'L'
	defw sub_29d4h
	defb 'Q'
	defw l29f5h
	defb 'S'
	defw l2692h
	defb 'R'
	defw l2561h
	defb 'X'
	defw l2677h
	defb 'Z'
	defw l2681h
tPardon:
	defb 'Pardon?',00dh,000h
param3:
	defb 00dh
	defs 20
param4:
	defb 00dh
	defs 20
l2b33h:
	nop	
lineNumStart__:
	nop	
	nop	
lineNumInc__:
	nop	
	nop	
param1:
	nop	
	nop	
param2:
	nop	
	nop	
curLineNum_safe__:
	jr z,separator__
separator__:
	nop	
l2b3fh:
	dec c	
l2b40h:
	nop	
	nop	
l2b42h:
	nop	
	nop	
endPASSrc_adr:
	nop	
	nop	
startPASSrc_adr__:
	nop	
	nop	
l2b48h:
	nop	
	nop	
l2b4ah:
	nop	
	nop	
listPageSize:
	nop	
GetSrcChr:
	jp 05491h
curIdentifier:
	defs 10
SP_safe:
	defb 0f0h
	defb 07fh
	defb 060h
curNum:
	defw 00000h
curRealHWord:
	defw 00000h
l2b61h:
	defw 00000h
l2b63h:
	defw 00000h
memEnd:
	defw 00000h
l2b67h:
	defw 00000h
lastChrRead__:
	defb 020h
labelListAddr:
	defw 00000h
SymTabAddr__:
	defw 00000h
TopOfHeapAddr__:
	defw 00000h
	defw 00000h
BlockLevel__:
	defb 000h
lastError__:
	defb 000h
l2b74h:
	defb 006h
l2b75h:
	defb 000h
l2b76h:
	defw 00000h
lineBufPtr:
	defw 00000h
	defw 00000h
compiBinStart__:
	defw 00000h
l2b7eh:
	defw 00000h
l2b80h:
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
	defb 000h
Merker1:
	defb 000h
	defb 000h
l2b89h:
	nop	
	nop	
l2b8bh:
	add a,080h
l2b8dh:
	nop	
	nop	
binMoveDistance__:
	nop	
	nop	
binMoveDistanceNeg__:
	nop	
	nop	
l2b93h:
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
nextLineAddr:
	nop	
	nop	
l2b9eh:
	ret	
	inc hl	
InitEditor__:
	call JResetPrintFlag
sub_2ba3h:
	ld a,0c3h
	ld (GetSrcChr),a
	ld hl,GetChr_LinBToSrc
	ld (GetSrcChr+1),hl
	ld ix,l2b75h
	xor a	
	ld (ix+000h),a
	ld d,a	
	exx	
	ret	
ExpSrcToLineBuf:
	ld de,lineBuf
ExpandLine:
	ld b,(hl)	
	inc b	
	dec b	
	jr z,ExpandNextChar
	ld a,020h
ExpandSp:
	ld (de),a	
	inc de	
	djnz ExpandSp
ExpandNextChar:
	inc hl	
ExpandLineSrc:
	ld a,(hl)	
	or a	
	jp p,Expand_CopyChr
	sub 080h
	push hl	
	push de	
	ld hl,ResWordsEntry
FindResWord:
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	dec hl	
	dec hl	
	cp (hl)	
	ex de,hl	
	jr nz,FindResWord
	inc hl	
	inc hl	
	pop de	
ExpandResWord:
	ld a,(hl)	
	or a	
	res 7,a
	ld (de),a	
	inc de	
	inc hl	
	jp p,ExpandResWord
	pop hl	
	jr ExpandNextChar
Expand_CopyChr:
	ld (de),a	
	inc de	
	cp 00dh
	jr nz,ExpandNextChar
	ret	
SetBinStartToRuntimeEnd:
	ld de,RuntimeEnd
Compile:
	ld sp,(stack_adr)
	call CoInit
l2bfeh:
	call sub_4781h
	cp 0aeh
	jp z,CloseCompi
	ld e,00bh
	call CompileErr
	jr l2bfeh
CoInit:
	push de	
	ld (nextLineAddr),hl
	call InitEditor__
	ld hl,00000h
	ld (curSrcLineNum),hl
	ld hl,CoVarInitData
	ld de,lastChrRead__
	ld bc,0000fh
	ldir
	ld hl,CoErNumTooBig
	ld (JPrError+1),hl
	ld a,0c3h
	ld (JCodeNextByte),a
	ld hl,CodeNextByte
	ld (JCodeNextByte+1),hl
	ld hl,GetChr_SrcToLinB
	ld (GetSrcChr+1),hl
	ld hl,banner_nl
	call OutZStr
	call JLdHLSrcEnd
	inc hl	
	inc hl	
	ld (compiBinStart__),hl
	pop hl	
	call PrNL
	ld (PasPrgStart+1),hl
	ld de,(compiBinStart__)
	or a	
	sbc hl,de
	ld (binMoveDistance__),hl
	ex de,hl	
	xor a	
	ld l,a	
	ld h,a	
	sbc hl,de
	ld (binMoveDistanceNeg__),hl
	ld hl,(stack_adr)
	jr z,StackAtRamEnd
	ld hl,(ram_end)
StackAtRamEnd:
	ld (memEnd),hl
	exx	
	ld hl,(compiBinStart__)
	exx	
	call GetLexem
	ld de,00117h
	call ChkLexem_GetLex
	ld de,00004h
	call ChkLexem_GetLex
	jp ChkSemi_GetLex
banner_nl:
	defb 00dh
banner:
 	defb 00ch,012h
 	defb '**** KC-PASCAL V5.1 ****',00dh,00dh
 	defb 'BEARB. VON  +++ AM90 +++',00dh,00dh
 	defb '   (VERSION KC85/4)',00dh,000h
CoVarInitData:
	defb 020h
	defw RL_PACKED
	defw RL_WRITE
	defw Symtab_open_start
	defw StartPASSrc
	defb 000h
	defb 000h
	defb 006h
	defb 0efh
	defw 00000h
CoErNumTooBigA:
	ld (lastChrRead__),a
CoErNumTooBig:
	ld e,001h
l2ce6h:
	call CompileErr
	jp l30a8h
l2cech:
	set 1,(ix+002h)
ChkExponent:
	ld c,d	
	cp 045h
	jr z,GetExp
	ld (lastChrRead__),a
	xor a	
	cp e	
	jr nz,l2d08h
	bit 7,h
	jr nz,l2d08h
	ld (curRealHWord),hl
	ld a,07fh
	jp PrcEnd__
l2d08h:
	ld a,d	
	jp GetFloatEnds
GetFloat:
	ld hl,00000h
	ld d,h	
	ld e,l	
	ld b,007h
	push bc	
	jr AddNumToResult
NextNumPos:
	push bc	
	call MulBy10_HL_DE
AddNumToResult:
	sub 030h
	ld c,a	
	ld b,d	
	add hl,bc	
	jr nc,NoNumOverflow
	inc de	
NoNumOverflow:
	call GetCIsNum
	pop bc	
	dec b	
	jr nc,ChkDecPt
	jr nz,NextNumPos
TooManyDigits:
	inc d	
	call GetCIsNum
	jr c,TooManyDigits
ChkDecPt:
	cp 02eh
	jr nz,ChkExponent
	call GetCIsNum
	jr nc,l2cech
	dec b	
	inc b	
	ld c,d	
	jr z,TooManyFractDigits
NextFractPos:
	push bc	
	call MulBy10_HL_DE
	sub 030h
AddFractToResult:
	ld c,a	
	ld b,d	
	add hl,bc	
	jr nc,NoFractOverflow
	inc e	
NoFractOverflow:
	pop bc	
	dec c	
	call GetCIsNum
	jr nc,ChkExpF
	djnz NextFractPos
TooManyFractDigits:
	call GetCIsNum
	jr c,TooManyFractDigits
ChkExpF:
	ld d,c	
	cp 045h
	jr nz,FractEnds
GetExp:
	push de	
	call GetSrcChr
	cp 02dh
	jr nz,PosExp
	call GetSrcChr
	call Get2C_Dec
	pop af	
	sub b	
	jr GetFloatEnds
FractEnds:
	ld (lastChrRead__),a
	ld a,d	
	jr GetFloatEnds
PosExp:
	cp 02bh
	call z,GetSrcChr
	call Get2C_Dec
	pop af	
	add a,b	
GetFloatEnds:
	jp NumToFloat__
l2d83h:
	ld e,01fh
	jp l2ce6h
Get2C_Dec:
	call IsNum
	jr nc,l2d83h
	sub 030h
	ld b,a	
	call GetCIsNum
	jr nc,OneDigit
	sub 030h
	ld c,a	
	ld a,b	
	add a,a	
	ld b,a	
	add a,a	
	add a,a	
	add a,b	
	add a,c	
	ld b,a	
	call GetCIsNum
	jp c,CoErNumTooBigA
OneDigit:
	ld (lastChrRead__),a
	ret	
PrSrcLine:
	push de	
	call Break
	ld hl,(curSrcLineNum)
	ld a,005h
	call PrDez
	call PrSpace
	ld hl,lineBuf
PrSrcChr:
	ld a,(hl)	
	call OutChr
	cp 00dh
	inc hl	
	jr nz,PrSrcChr
	pop de	
	ret	
GetChr_SrcToLinB:
	push hl	
	bit 6,(ix+000h)
	jr z,l2e02h
	push de	
	push bc	
l2dd0h:
	call JLdHLSrcEnd
	ld bc,lineBuf
	ld (lineBufPtr),bc
	ld de,(nextLineAddr)
	call JSrcToLineBuf
	jr z,ErrKeinTxt
	jr c,l2e15h
	ld (nextLineAddr),hl
	ld (curSrcLineNum),de
	res 6,(ix+000h)
	bit 0,(ix+000h)
	jr z,Quiet1
	call GetTargetAddrInHL__
	ex de,hl	
	call PrWordHex
	call PrSrcLine
Quiet1:
	pop bc	
	pop de	
l2e02h:
	ld hl,(lineBufPtr)
	ld a,(hl)	
	inc hl	
	ld (lineBufPtr),hl
	pop hl	
SetAToSpaceIfEOL:
	cp 00dh
	ret nz	
	set 6,(ix+000h)
	ld a,020h
	ret	
l2e15h:
	ld hl,(l2b9eh)
	ld (nextLineAddr),hl
	jp l2dd0h
ErrKeinTxt:
	ld hl,tKeTx
OutErrAndReset:
	call OutZStr
	jp Reset
ReadCompOpt:
	ld a,(de)	
	inc de	
	ld hl,compOptTab
	ld b,006h
RCO_CheckChr:
	cp (hl)	
	inc hl	
	jr z,RCO_ChkPluMin
	inc hl	
	djnz RCO_CheckChr
	cp 050h
	scf	
	ret nz	
	ld a,010h
	call OutChr
	jr RCO_ChkNextOpt
RCO_ChkPluMin:
	ld a,(de)	
	inc de	
	cp 02bh
	jr z,RCO_SetOn
	cp 02dh
	jr nz,RCO_End
	ld a,(hl)	
	cpl	
	and (ix+000h)
RCO_SetOpts:
	ld (ix+000h),a
RCO_ChkNextOpt:
	ld a,(de)	
	inc de	
	cp 02ch
	jr z,ReadCompOpt
RCO_End:
	or a	
	ret	
RCO_SetOn:
	ld a,(hl)	
	or (ix+000h)
	jr RCO_SetOpts
CSq_Init:
	defb 006h
	call SaveCAOS_SP
	call JResetPrintFlag
CSq_InitJRTErr:
	defb 006h
	call InitRuntimeErr__
CloseCompi:
	ld hl,tEadr
	call OutZStr
	ld hl,CSq_JReset
	call WCode
	ex de,hl	
	dec de	
	call PrWordHex
	call PrNL
	ld hl,0ffcdh
	or a	
	sbc hl,de
	ex de,hl	
	ld hl,(l2b8dh)
	dec hl	
	dec hl	
	call WrDE_ByTargAddr_pl2
	ld a,(lastError__)
	or a	
	jr z,l2ea7h
	push af	
	ld hl,tFeh1
	call OutZStr
	pop af	
	ld l,a	
	ld h,000h
	ld a,003h
	call PrDez
	jp Reset
l2ea7h:
	ld hl,(binMoveDistance__)
	ld a,h	
	or l	
	jr z,RunOrReset
	ld hl,TOk
	call OutZStr
	call GetKey
	cp 04ah
	jp nz,Reset
	ld hl,PasPrgStart
	ld (l0710h),hl
	ld hl,(JEndPascal+1)
	ld (Reset+1),hl
	exx	
	push hl	
	ex de,hl	
	call JGetPar3
	ld bc,00008h
	ldir
	ex de,hl	
	push hl	
	exx	
	call JCodeNextByte
	defb 0edh
	call JCodeNextByte
	defb 0b0h
	call JCodeNextByte
	defb 001h
	pop de	
	pop hl	
	push hl	
	push de	
	ld de,(compiBinStart__)
	or a	
	sbc hl,de
	push hl	
	push hl	
	ld hl,RuntimeEnd
	ld de,PasPrgMenuHdr
	or a	
	sbc hl,de
	ex de,hl	
	pop hl	
	add hl,de	
	ld (l0704h),hl
	ex de,hl	
	call StoreDE
	ld hl,CSq_SaveCom
	call WCode
	pop bc	
	ld de,RuntimeEnd
	ld hl,(compiBinStart__)
	ret	
RunOrReset:
	ld hl,TLauf
	call OutZStr
	call PrGetKey
	cp 04ah
	jp nz,Reset
	call PrNL
	jp PasPrgStart
TOk:
	defb 'Ok?',000h
TLauf:
	defb 'Lauf?',000h
CSq_JReset:
	defb 003h
	jp Reset
CSq_SaveCom:
	defb 00ah
	pop de	
	call SaveCom
	jp JEndPascal
CompileErr:
	push af	
	push bc	
	push hl	
	bit 0,(ix+000h)
	jr nz,CoEPrFehler
	ld b,004h
CoEPr4Spc:
	call PrSpace
	djnz CoEPr4Spc
	call PrSrcLine
CoEPrFehler:
	ld hl,tFeh2
	call OutZStr
	ld hl,(lineBufPtr)
	ld bc,lineBuf
	sbc hl,bc
	ld b,l	
CoEToErrCol:
	call PrSpace
	djnz CoEToErrCol
	ld a,05eh
	call OutChr
	ld l,e	
	ld h,000h
	ld a,002h
	call PrDez
	ld hl,lastError__
	inc (hl)	
	call PrGetKey
	cp 045h
	ld bc,(curSrcLineNum)
	jp z,StartEditLine
	cp 050h
	jp z,StartEditPrevLine
	call PrNL
	pop hl	
	pop bc	
	pop af	
	ret	
GetCIsAlNum:
	call GetSrcChr
	cp 030h
	ccf	
	ret nc	
	cp 03ah
	ret c	
IsAlpha:
	cp 041h
	ccf	
	ret nc	
	cp 05bh
	ret c	
	cp 061h
	ccf	
	ret nc	
	cp 07bh
	ret	
GetCIsHex_ToNum:
	call GetSrcChr
	cp 041h
	jr c,IsNum_ToNum
	cp 047h
	ccf	
	ret c	
	sub 037h
	ret	
IsNum_ToNum:
	call IsNum
	ccf	
	ret c	
	sub 030h
	ret	
GetCIsNum:
	call GetSrcChr
	jp IsNum
LxSrcEnd__:
	ld a,0aeh
	jp GetLexEnd
GetLexem:
	push hl	
	push de	
	push bc	
	bit 1,(ix+002h)
	jr nz,LxSrcEnd__
	ld a,(lastChrRead__)
LxSkipSpace:
	cp 020h
	jr nz,SignificantChr
	call GetSrcChr
	jr LxSkipSpace
SignificantChr:
	cp 041h
	jr c,LxNumOrPkt
	cp 05bh
	jr nc,LxLowCOrPkt
l2fe0h:
	call LxIdentifier
	jp l303ah
LxLowCOrPkt:
	cp 07bh
	jr z,l2ff4h
	jp nc,l305fh
	cp 061h
	jr nc,l2fe0h
	jp l305fh
l2ff4h:
	call GetSrcChr
	cp 024h
	jr nz,l300eh
	ld de,(lineBufPtr)
	call ReadCompOpt
	ld (lineBufPtr),de
	call SetAToSpaceIfEOL
	jr l300eh
l300bh:
	call GetSrcChr
l300eh:
	cp 07dh
	jr z,l301dh
	cp 02ah
	jr nz,l300bh
	call GetSrcChr
	cp 029h
	jr nz,l300eh
l301dh:
	call GetSrcChr
	jp LxSkipSpace
LxNumOrPkt:
	call IsNum
	jr c,GetUnsigNum
	cp 03ah
	jr nz,l306ah
	call GetSrcChr
	ld c,0bah
	cp 03dh
	jr nz,l303ah
	ld c,07dh
l3037h:
	call GetSrcChr
l303ah:
	ld (lastChrRead__),a
	ld a,c	
GetLexEnd:
	res 1,(ix+002h)
	pop bc	
	pop de	
	pop hl	
	ret	
l3046h:
	cp 027h
	jp z,l30d9h
	cp 023h
	jr z,l30b2h
	cp 028h
	jr nz,l305fh
	call GetSrcChr
	cp 02ah
	jp z,l2ff4h
	ld c,0a8h
	jr l303ah
l305fh:
	add a,080h
	ld c,a	
	cp 0aeh
	jr nz,l3037h
	ld a,020h
	jr l303ah
l306ah:
	jr c,l3046h
	ld c,078h
	cp 03dh
	jr z,l3037h
	cp 03ch
	jr nz,l3089h
	call GetSrcChr
	ld c,077h
	cp 03eh
	jr z,l3037h
	ld c,07ah
	cp 03dh
	jr nz,l303ah
	ld c,07ch
	jr l3037h
l3089h:
	cp 03eh
	jr nz,l305fh
	call GetSrcChr
	cp 03dh
	ld c,079h
	jr nz,l303ah
	ld c,07bh
	jr l3037h
GetUnsigNum:
	ld (SP_safe),sp
	call GetFloat
	ld (curRealHWord),hl
	ld (curNum),de
l30a8h:
	ld a,07eh
PrcEnd__:
	ld sp,(SP_safe)
	pop bc	
	pop de	
	pop hl	
	ret	
l30b2h:
	call GetCIsHex_ToNum
	jr c,CoErrHexExpected
	ld l,a	
	ld h,000h
	ld b,004h
l30bch:
	call GetCIsHex_ToNum
	jr c,l30d1h
	add hl,hl	
	add hl,hl	
	add hl,hl	
	add hl,hl	
	or l	
	ld l,a	
	djnz l30bch
	call GetSrcChr
CoErrHexExpected:
	ld e,033h
	call CompileErr
l30d1h:
	ld c,07fh
	ld (curRealHWord),hl
	jp l303ah
l30d9h:
	call WrJump
	ld (curRealHWord),hl
	ld c,000h
ChkEOLInStr:
	call GetSrcChr
	bit 6,(ix+000h)
	jr nz,CErrStrLiEnd
	cp 027h
	jr z,ChkDblApos
WStrChrToTarget:
	call StoreAToHL2
	inc c	
	jr ChkEOLInStr
ChkDblApos:
	call GetSrcChr
	cp 027h
	jr z,WStrChrToTarget
OnEndOfStr__:
	ld (lastChrRead__),a
	dec c	
	jr nz,ChkEmptyStr
	exx	
	dec hl	
	ld a,(hl)	
l3104h:
	dec hl	
	dec hl	
	dec hl	
	exx	
	ld l,a	
	ld h,0ffh
	ld (curRealHWord),hl
	ld a,076h
	jr JGetLexEnd
ChkEmptyStr:
	inc c	
	jr nz,WStrLit__
	ld e,021h
	call CompileErr
	xor a	
	exx	
	jr l3104h
WStrLit__:
	ld a,c	
	ld (curNum),a
	call GetTargetAddrInHL__
	ex de,hl	
	ld hl,(curRealHWord)
	call WrDE_ByTargAddr_pl2
	ld a,075h
JGetLexEnd:
	jp GetLexEnd
CErrStrLiEnd:
	ld e,044h
	call CompileErr
	jr OnEndOfStr__
LxIdentifier:
	ld hl,curIdentifier
	ld b,00ah
LxIdNextChr:
	ld (hl),a	
	call GetCIsAlNum
	jr nc,LxIdAllChrsRead
	inc hl	
	djnz LxIdNextChr
	dec hl	
LxIdSkipTrailingChr:
	call GetCIsAlNum
	jr c,LxIdSkipTrailingChr
LxIdAllChrsRead:
	push af	
	set 7,(hl)
	ld a,(curIdentifier)
	cp 061h
	jr nc,LxIdSetLxCode
	ld hl,ResWordsEntry2
	push de	
	call SearchInSymTab__
	pop de	
LxIdSetLxCode:
	ld c,000h
	jr nc,LxIdEnd
	ld c,(hl)	
LxIdEnd:
	pop af	
	ret	
compOptTab:

; BLOCK 'compOptTab' (start 0x3165 end 0x3171)
compOptTab_start:
	defb 'L'
	defb 001h
	defb 'O'
	defb 002h
	defb 'C'
	defb 004h
	defb 'S'
	defb 008h
	defb 'I'
	defb 010h
	defb 'A'
	defb 020h
RL_PACKED:
	defw 00000h
	defb 'PACKE','D'+080h
	defb 023h
RL_NIL:
	defw RL_PACKED
	defb 'NI','L'+080h
	defb 022h
RL_FORWARD:
	defw RL_NIL
	defb 'FORWAR','D'+080h
	defb 01dh
RL_PROGRAM:
	defw RL_FORWARD
	defb 'PROGRA','M'+080h
	defb 001h
RL_IN:
	defw RL_PROGRAM
	defb 'I','N'+080h
	defb 020h
RL_OR:
	defw RL_IN
	defb 'O','R'+080h
	defb 007h
RL_OF:
	defw RL_OR
	defb 'O','F'+080h
	defb 00bh
RL_TO:
	defw RL_OF
	defb 'T','O'+080h
	defb 00ch
RL_DO:
	defw RL_TO
	defb 'D','O'+080h
	defb 011h
RL_IF:
	defw RL_DO
	defb 'I','F'+080h
	defb 017h
RL_SET:
	defw RL_IF
	defb 'SE','T'+080h
	defb 01bh
RL_NOT:
	defw RL_SET
	defb 'NO','T'+080h
	defb 006h
RL_MOD:
	defw RL_NOT
	defb 'MO','D'+080h
	defb 009h
RL_DIV:
	defw RL_MOD
	defb 'DI','V'+080h
	defb 002h
RL_VAR:
	defw RL_DIV
	defb 'VA','R'+080h
	defb 00ah
RL_AND:
	defw RL_VAR
	defb 'AN','D'+080h
	defb 008h
RL_FOR:
	defw RL_AND
	defb 'FO','R'+080h
	defb 016h
RL_END:
	defw RL_FOR
	defb 'EN','D'+080h
	defb 010h
RL_GOTO:
	defw RL_END
	defb 'GOT','O'+080h
	defb 01ah
RL_WITH:
	defw RL_GOTO
	defb 'WIT','H'+080h
	defb 019h
RL_TYPE:
	defw RL_WITH
	defb 'TYP','E'+080h
	defb 01fh
RL_CASE:
	defw RL_TYPE
	defb 'CAS','E'+080h
	defb 014h
RL_ELSE:
	defw RL_CASE
	defb 'ELS','E'+080h
	defb 012h
RL_THEN:
	defw RL_ELSE
	defb 'THE','N'+080h
	defb 00eh
RL_LABEL:
	defw RL_THEN
	defb 'LABE','L'+080h
	defb 021h
RL_CONST:
	defw RL_LABEL
	defb 'CONS','T'+080h
	defb 003h
RL_ARRAY:
	defw RL_CONST
	defb 'ARRA','Y'+080h
	defb 01ch
RL_UNTIL:
	defw RL_ARRAY
	defb 'UNTI','L'+080h
	defb 00fh
RL_WHILE:
	defw RL_UNTIL
	defb 'WHIL','E'+080h
	defb 015h
RL_BEGIN:
	defw RL_WHILE
	defb 'BEGI','N'+080h
	defb 018h
RL_RECORD:
 	defw RL_BEGIN
	defb 'RECOR','D'+080h
 	defb 01eh
RL_DOWNTO:
	defw RL_RECORD
	defb 'DOWNT','O'+080h
	defb 00dh
RL_REPEAT:
 	defw RL_DOWNTO
	defb 'REPEA','T'+080h
 	defb 013h
RL_FUNCTION:
 	defw RL_REPEAT
	defb 'FUNCTIO','N'+080h
 	defb 005h
ResWordsEntry2:
RL_PROCEDURE:
 	defw RL_FUNCTION
	defb 'PROCEDUR','E'+080h
 	defb 004h
ResWordsEntry:
 	defw ResWordsEntry2
tEadr:
	defb 'Endadresse: ',000h
tFeh1:
	defb 'Fehler:',000h
tFeh2:
	defb '*FEHLER*',000h
tKeTx:
	defb 00dh,'Kein Text mehr!',000h
tTabU:
	defb 'Tabellenueberlauf!',000h
ChkTypeBool__:
	ld de,00004h
	jr ChkType__
ChkType0001:
	ld de,00001h
ChkType__:
	ex de,hl	
	or a	
	sbc hl,bc
	add hl,bc	
	ex de,hl	
	ret z	
	bit 7,b
	jr z,CErrWroType
	bit 7,d
	jr z,CErrWroType
	ld e,a	
	ld a,b	
	cp 080h
	ld a,e	
	ret z	
	ld a,d	
	cp 080h
	ld a,e	
	ret z	
CErrWroType:
	ld e,00ah
	jp CompileErr
ChkSemi_GetLex:
	cp 0bbh
	ld e,002h
	jp z,GetLexem
	call CompileErr
	jp GetLexem
NextChkOF_GetLex:
	call GetLexem
ChkOF_GetLex:
	ld de,00b14h
	jr ChkLexem_GetLex
ChkColEq_GetLex:
	ld de,07d08h
	jr ChkLexem_GetLex
ChkCloSqBra_GetLex:
	ld de,0dd23h
	jr ChkLexem_GetLex
ChkComma_GetLex:
	ld de,0ac15h
	jr ChkLexem_GetLex
NextChkOpBra_GetLex:
	call GetLexem
ChkOpBra_GetLex:
	ld de,0a812h
	jr ChkLexem_GetLex
ChkCloBra_GetLex:
	ld de,0a909h
ChkLexem_GetLex:
	cp d	
	jp z,GetLexem
	jp CompileErr
IdentToSymtab:
	push de	
	ld hl,(TopOfHeapAddr__)
	ld de,(SymTabAddr__)
	ld (SymTabAddr__),hl
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	or a	
	jr nz,ItS_ErrIdExpected
	ex de,hl	
	ld hl,curIdentifier
	ld bc,00000h
ItS_StoreChr:
	ld a,(hl)	
	ldi
	or a	
	jp p,ItS_StoreChr
ItS_ChkHeapEnd:
	pop hl	
	add hl,de	
	ld (TopOfHeapAddr__),hl
	ld hl,(heapEndAddr)
	ld bc,0fff4h
	add hl,bc	
	sbc hl,de
	ex de,hl	
	ret nc	
	ld hl,tTabU
	jp OutErrAndReset
ItS_ErrIdExpected:
	ld e,004h
	call CompileErr
	ld (hl),080h
	inc hl	
	ex de,hl	
	jr ItS_ChkHeapEnd
GetIdentInfoInABC:
	ld hl,(SymTabAddr__)
	call SearchInSymTab__
	jr nc,SiS_NotFound
	ld a,(hl)	
	inc hl	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
	ret	
SiS_NotFound:
	ld e,003h
	xor a	
	jp CompileErr
SiS_GotoNextId:
	ld a,d	
	or e	
	ret z	
	ex de,hl	
SearchInSymTab__:
	ld bc,curIdentifier
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
SiS_CompChr:
	ld a,(bc)	
	cp (hl)	
	jr nz,SiS_GotoNextId
	or a	
	inc bc	
	inc hl	
	jp p,SiS_CompChr
	scf	
	ret	
ChkLabelList__:
	ld hl,(labelListAddr)
NextListEntry:
	ld a,h	
	or l	
	ld e,03eh
	ccf	
	jp z,CompileErr
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	push de	
	inc hl	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	ex de,hl	
	ld hl,(curRealHWord)
	or a	
	sbc hl,bc
	pop hl	
	jr nz,NextListEntry
	ex de,hl	
	inc hl	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
	ld a,(BlockLevel__)
	cp (hl)	
	ret z	
	ld e,03dh
	scf	
	jp CompileErr
CodeLdBC_0n_from_0x2b8b:
	push hl	
	ld e,a	
	call JCodeNextByte
	defb 001h
	ld a,(l2b8bh)
	inc a	
	call StoreAToHL2
	call JCodeNextByte
	defb 000h
	ld a,e	
	jr WCode1
l33beh:
	push hl	
	exx	
	dec hl	
	dec hl	
	jr WCode2
WCodeOverLastByte:
	push hl	
	exx	
	dec hl	
	jr WCode2
WrJump:
	ld hl,CSq_JP
WCode:
	push hl	
WCode1:
	exx	
WCode2:
	ex (sp),hl	
	ld c,(hl)	
	inc hl	
	ld b,000h
	pop de	
	ldir
	ex de,hl	
	exx	
GetTargetAddrInHL__:
	exx	
	push hl	
	ld bc,(binMoveDistance__)
	add hl,bc	
	ex (sp),hl	
	exx	
	pop hl	
	ret	
StoreAToHL2:
	exx	
	ld (hl),a	
	inc hl	
	exx	
	ret	
StoreA_GetTarget:
	call StoreAToHL2
	jp GetTargetAddrInHL__
CodeNextByte:
	pop hl	
	push af	
	ld a,(hl)	
	inc hl	
	call StoreAToHL2
	pop af	
	push hl	
	jp GetTargetAddrInHL__
WLdDEnnIsHL:
	ex de,hl	
WLdDEnnIsDE:
	call JCodeNextByte
	defb 011h
	jr StoreDE
WLdHLfromMemIsDE:
	call JCodeNextByte
	defb 02ah
	jr StoreDE
WLdHLnnIsHL:
	ex de,hl	
WLdHLnnIsDE:
	call JCodeNextByte
	defb 021h
StoreDE:
	push af	
	ld a,e	
	call StoreAToHL2
	ld a,d	
	call StoreA_GetTarget
	pop af	
	ret	
WrDE_ByTargAddr_pl2:
	dec hl	
WrDE_ByTargAddr_pl1:
	push bc	
	push hl	
	call TargAddrToCompAddr
	ld (hl),d	
	dec hl	
	ld (hl),e	
	pop hl	
	pop bc	
	ret	
WrDE_ByTargAddr:
	push bc	
	push hl	
	call TargAddrToCompAddr
	ld (hl),e	
	inc hl	
	ld (hl),d	
	pop hl	
	pop bc	
	ret	
WrA_ByTargAddr:
	push bc	
	push hl	
	call TargAddrToCompAddr
	ld (hl),a	
	pop hl	
	pop bc	
	ret	
TargAddrToCompAddr:
	ld bc,(binMoveDistanceNeg__)
	add hl,bc	
	ret	
sub_343dh:
	exx	
	dec hl	
	exx	
	dec hl	
	call JCodeNextByte
	defb 006h
	ld e,c	
	jp l381ah
CSq_JP:
	defb 003h
	defb 0c3h
l344bh:
	cp 0bbh
	ret z	
	or a	
	jr z,l3454h
	cp 024h
	ret c	
l3454h:
	call GetLexem
	jr l344bh
PCVNegNum:
	call GetLexem
	call ParseConstVal
	call PCVChkNum
	dec c	
	jr z,PCVNegInt
	inc c	
	bit 6,h
	ret z	
	push af	
	ld a,080h
	xor h	
	ld h,a	
	pop af	
	ret	
PCVNegInt:
	inc c	
	ex de,hl	
	ld hl,00000h
	or a	
	sbc hl,de
	ret	
ParseConstVal:
	or a	
	jr z,PCVIdent
	cp 0abh
	jr z,PCVPosNum
	cp 0adh
	jr z,PCVNegNum
	ld hl,(curRealHWord)
	cp 075h
	jr z,l34d8h
	ld bc,00001h
	cp 07fh
	jr z,PCVEnds__
	inc c	
	ld de,(curNum)
	cp 07eh
	jr z,PCVEnds__
	inc c	
	cp 076h
	jr z,PCVEnds__
	ld e,00dh
	jp CompileErr
PCVIdent:
	call GetIdentInfoInABC
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	dec a	
	jr z,l34cfh
	cp 008h
	jr nz,l34c8h
	ld hl,l52ceh
	sbc hl,de
	jr nz,l34c8h
	call NextChkOpBra_GetLex
	call ParseConstVal
	call ChkType0001
	ld bc,00003h
	jp ChkCloBra_GetLex
l34c8h:
	ld e,00eh
	call CompileErr
	jr PCVEnds__
l34cfh:
	inc hl	
	ld a,(hl)	
	inc hl	
	ld l,(hl)	
	ld h,a	
	ex de,hl	
PCVEnds__:
	jp GetLexem
l34d8h:
	ld a,(curNum)
	ld c,a	
	ld b,002h
	jr PCVEnds__
PCVPosNum:
	call GetLexem
	call ParseConstVal
PCVChkNum:
	push af	
	xor a	
	cp b	
	jr nz,CErrIntOrRealExpected
	ld a,c	
	dec a	
	jr z,PCVNumOk
	dec a	
	jr nz,CErrIntOrRealExpected
PCVNumOk:
	pop af	
	ret	
CErrIntOrRealExpected:
	ld e,01ch
	pop af	
	jp CompileErr
sub_34fah:
	ld de,00004h
	add hl,de	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
	ld b,(hl)	
	xor a	
	cp b	
	ld a,(BlockLevel__)
	ret	
WSelListEl_byA:
	call JCodeNextByte
	defb 006h
	call StoreAToHL2
	ld hl,CSq_SelListEl
	call WCode
	jr WAddConstHLDE
WAddConstHLIX:
	ld hl,CSq_CpIXtoDE
	call WCode
WAddConstHLDE:
	call WLdHLnnIsDE
	call JCodeNextByte
	defb 019h
	ret	
sub_3526h:
	ld a,d	
	or a	
	inc a	
	jr nz,l352eh
	ld a,e	
	add a,a	
	ret	
l352eh:
	dec a	
	ret nz	
	ld a,e	
	sub 07dh
	ret	
CSq_SelListEl:
	defb 003h
	call SelListElem__
CSq_CpIXtoDE:
	defb 003h
	push ix
	pop de	
WCaBreak_IfCoCo_C:
	bit 2,(ix+000h)
	ret z	
	ld hl,CSq_CallBreak
	jp WCode
CSq_CallBreak:
	defb 003h
	call Break
ChkScalar:
	push af	
	xor a	
	cp b	
	jr nz,CErrScalarExpected
	ld a,c	
	cp 002h
	jr nz,l355bh
CErrScalarExpected:
	ld e,02fh
	pop af	
	jp CompileErr
l355bh:
	pop af	
	ret	
l355dh:
	defb 008h
	pop bc	
	sub b	
	ld a,001h
	jr z,l3565h
	xor a	
l3565h:
	push af	
l3566h:
	defb 007h
	pop bc	
	sub b	
	jr z,l356dh
	ld a,001h
l356dh:
	push af	
l356eh:
	defb 006h
	pop bc	
	sub b	
	ld a,000h
	rla	
	push af	
l3575h:
	defb 007h
	ld b,a	
	pop af	
	sub b	
	ld a,000h
	rla	
	push af	
l357dh:
	defb 008h
	ld b,a	
	pop af	
	sub b	
	ccf	
	ld a,000h
	rla	
	push af	
l3586h:
	defb 007h
	pop bc	
	sub b	
	ccf	
	ld a,000h
	rla	
	push af	
l358eh:
	defb 008h
	pop de	
	xor a	
	sbc hl,de
	jr nz,l3596h
	inc a	
l3596h:
	push af	
l3597h:
	defb 008h
	pop de	
	xor a	
	sbc hl,de
	jr z,l359fh
	inc a	
l359fh:
	push af	
l35a0h:
	defb 009h
	pop de	
	or a	
	sbc hl,de
	ld a,080h
	and h	
	rlca	
	push af	
l35aah:
	defb 005h
	pop de	
	call sub_0c6fh
	push af	
l35b0h:
	defb 00ah
	ex de,hl	
	pop hl	
	or a	
	sbc hl,de
	ld a,080h
	and h	
	rlca	
	push af	
l35bbh:
	defb 006h
	ex de,hl	
	pop hl	
	call sub_0c6fh
	push af	
l35c2h:
	defb 00ch
	ex de,hl	
	pop hl	
	or a	
	sbc hl,de
	ld a,080h
	and h	
	rlca	
	xor 001h
	push af	
l35cfh:
	defb 006h
	ex de,hl	
	pop hl	
	call sub_0c7ah
	push af	
l35d6h:
	defb 00bh
	pop de	
	or a	
	sbc hl,de
	ld a,080h
	and h	
	rlca	
	xor 001h
	push af	
l35e2h:
	defb 005h
	pop de	
	call sub_0c7ah
	push af	
CSq_l35e8h:
	defb 007h
	pop de	
	ld a,(de)	
	sub (hl)	
l35ech:
	inc hl	
	inc de	
	jr nz,l35f0h
l35f0h:
	defb 008h
	dec b	
	djnz l35ech
	inc a	
l35f5h:
	jr l35f8h
	xor a	
l35f8h:
	push af	
l35f9h:
	defb 008h
	inc b	
	djnz l35f5h
	jr l3601h
	ld a,001h
l3601h:
	push af	
	dec bc	
	inc b	
	djnz $-6
	jr l360dh
	ld a,000h
l360ah:
	jr c,l360dh
	inc a	
l360dh:
	push af	
l360eh:
	defb 00bh
	inc b	
	djnz l360ah
	jr l3619h
	ld a,000h
l3616h:
	jr nc,l3619h
	inc a	
l3619h:
	push af	
l361ah:
	defb 00bh
	inc b	
	djnz l3616h
	jr l3624h
	ld a,000h
l3622h:
	jr c,l3625h
l3624h:
	inc a	
l3625h:
	push af	
l3626h:
	defb 00bh
	inc b	
	djnz l3622h
	jr l3630h
	ld a,000h
	jr nc,l3631h
l3630h:
	inc a	
l3631h:
	push af	
l3632h:
	defb 00fh
	ex de,hl	
	pop bc	
	xor a	
	sbc hl,bc
	pop bc	
	jr nz,l3641h
	ex de,hl	
	sbc hl,bc
	jr nz,l3641h
	inc a	
l3641h:
	push af	
l3642h:
	defb 00fh
	ex de,hl	
	pop bc	
	xor a	
	sbc hl,bc
	pop bc	
	jr nz,l3650h
	ex de,hl	
	sbc hl,bc
	jr z,l3651h
l3650h:
	inc a	
l3651h:
	push af	
l3652h:
	defb 00ch
	ld a,080h
	xor h	
	ld h,a	
	call sub_0ca1h
	ld a,080h
	and h	
	rlca	
	push af	
l365fh:
	defb 014h
	pop bc	
	ex (sp),hl	
	bit 6,h
	jr z,l366ah
	ld a,080h
	xor h	
	ld h,a	
l366ah:
	ex (sp),hl	
	push bc	
	call sub_0ca1h
	ld a,080h
	and h	
	rlca	
	push af	
l3674h:
	defb 016h
	pop bc	
	ex (sp),hl	
	bit 6,h
	jr z,l367fh
	ld a,080h
	xor h	
	ld h,a	
l367fh:
	ex (sp),hl	
l3680h:
	defb 0c5h
	call sub_0ca1h
	ld a,080h
	and h	
	rlca	
	xor 001h
	push af	
l368bh:
	defb 00eh
	ld a,080h
	xor h	
	ld h,a	
	call sub_0ca1h
	ld a,080h
	and h	
	rlca	
	xor 001h
	push af	
l369ah:
	defb 00ah
	ld hl,EquOrIncHLbyB
	ld (VarCall+1),hl
	call MultiCall__
	push af	
l36a5h:
	defb 00ch
	ld hl,EquOrIncHLbyB
	ld (VarCall+1),hl
	call MultiCall__
	xor 001h
	push af	
l36b2h:
	defb 00ah
	ld hl,NeqOrIncHLbyB
	ld (VarCall+1),hl
	call MultiCall__
	push af	
l36bdh:
	defb 00ah
	ld hl,Neq2OrIncHLbyB
	ld (VarCall+1),hl
	call MultiCall__
	push af	
TabCSq:

; BLOCK 'TabCSq' (start 0x36c8 end 0x3710)
TabCSq_first:
	defw l3597h
	defw l358eh
	defw l35a0h
	defw l35b0h
	defw l35c2h
	defw l35d6h
	defw l3597h
	defw l358eh
	defw l35aah
	defw l35bbh
	defw l35cfh
	defw l35e2h
	defw l3566h
	defw l355dh
	defw l356eh
	defw l3575h
	defw l357dh
	defw l3586h
	defw l35f9h
	defw l35f0h
	defw l3680h
	defw l360eh
	defw l361ah
	defw l3626h
	defw l3642h
	defw l3632h
	defw l365fh
	defw l3652h
	defw l368bh
	defw l3674h
	defw l36a5h
	defw l369ah
	defw 00000h
	defw 00000h
	defw l36bdh
	defw l36b2h
sub_3710h:
	call GetLexem
	call sub_3f3fh
	call ChkTypeBool__
	ld hl,CSq_l3722h
	call WCodeOverLastByte
	dec hl	
	dec hl	
	ret	
CSq_l3722h:
	defb 004h
	or a	
	defb 0cah
l3725h:
	call ChkLabelList__
	jp c,GetLexem
	push hl	
	call GetTargetAddrInHL__
	ex de,hl	
	inc hl	
	call WrDE_ByTargAddr
	pop hl	
	dec hl	
	ld (hl),d	
	dec hl	
	ld (hl),e	
	call GetLexem
	ld de,0ba16h
	call ChkLexem_GetLex
	jr l3777h
xxTab4__:
	defw l3cb4h
	defw l399dh
	defw l3c69h
	defw l3ac1h
	defw l3c8ah
	defw l3cd1h
	defw sub_3ce7h
	defw l3d57h
l3754h:
	cp 07fh
	jr z,l3725h
	cp 013h
	ret c	
	cp 01bh
	ret nc	
	add a,a	
	ld l,a	
	ld h,000h
	ld de,xxTab4__-00026h
	add hl,de	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ex de,hl	
	jp (hl)	
l376bh:
	push bc	
	ret	
sub_376dh:
	ex af,af'	
	ld de,01110h
	call ChkLexem_GetLex
	call WCaBreak_IfCoCo_C
l3777h:
	res 0,(ix+001h)
	or a	
	ld hl,l2b89h
	ld (hl),000h
	jp nz,l3754h
	call GetIdentInfoInABC
	cp 004h
	jp z,l38c0h
	cp 006h
	jr z,l376bh
	cp 008h
	jp z,l42fdh
	cp 005h
	jp z,l3887h
	ld e,007h
	call sub_4e7dh
l379fh:
	push hl	
	push de	
	dec b	
	jr nz,l37aah
	ld hl,CSq_SaveHL
	call WCodeOverLastByte
l37aah:
	inc b	
	call ChkColEq_GetLex
	call sub_3f29h
	pop hl	
	pop de	
	dec b	
	jp z,l383eh
	inc b	
	jp nz,l3865h
l37bbh:
	dec h	
	jp m,l3827h
	exx	
	dec hl	
	exx	
	jr nz,l37e2h
	dec c	
	jr z,l37dbh
	dec c	
	jp nz,l3aafh
	exx	
	dec hl	
	exx	
	call JCodeNextByte
	defb 0edh
	call JCodeNextByte
	defb 053h
	call StoreDE
	inc de	
	inc de	
l37dbh:
	call JCodeNextByte
	defb 022h
	jp StoreDE
l37e2h:
	dec c	
	jr z,l3804h
	dec c	
	jr nz,l3804h
	exx	
	dec hl	
	exx	
	call JCodeNextByte
	defb 0ddh
	call JCodeNextByte
	ld (hl),e	
	call l381ah
	inc e	
	call JCodeNextByte
	defb 0ddh
	call JCodeNextByte
	ld (hl),d	
	call l381ah
	inc e	
	cp a	
l3804h:
	call JCodeNextByte
	defb 0ddh
	jr nz,l3821h
	call JCodeNextByte
	defb 075h
	call l381ah
	call JCodeNextByte
	defb 0ddh
	inc e	
	call JCodeNextByte
	ld (hl),h	
l381ah:
	push af	
	ld a,e	
	call StoreA_GetTarget
	pop af	
	ret	
l3821h:
	call JCodeNextByte
	defb 077h
	jr l381ah
l3827h:
	dec c	
	jr z,l3832h
	dec c	
	jr z,l3838h
	ld hl,l389ch
	jr l3835h
l3832h:
	ld hl,CSq_l389fh
l3835h:
	jp WCodeOverLastByte
l3838h:
	ld hl,l38a9h
	jp l33beh
l383eh:
	ld hl,l38b4h
	jp CodeLdBC_0n_from_0x2b8b
l3844h:
	call NextChkOpBra_GetLex
	call sub_3f10h
	call ChkComma_GetLex
	call sub_3f3fh
	call ChkCloBra_GetLex
	dec b	
	jr z,l387dh
	dec b	
	jr nz,l385fh
	ld (Merker1),bc
	jr l3865h
l385fh:
	inc b	
	inc b	
	ld h,000h
	jr z,l3827h
l3865h:
	bit 7,b
	jr nz,l3882h
	exx	
	dec hl	
	exx	
	call JCodeNextByte
	defb 001h
	ld de,(Merker1)
	call StoreDE
	ld hl,CSq_PopDELdir
	jp WCode
l387dh:
	ld e,034h
	jp CompileErr
l3882h:
	ld c,001h
	jp l37bbh
l3887h:
	ld a,(bc)	
	ld c,a	
	inc hl	
	inc hl	
	ld b,(hl)	
	inc b	
	inc hl	
	inc hl	
	inc hl	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ld a,(BlockLevel__)
	call sub_4faah
	jp l379fh
l389ch:
	ld (bc),a	
	pop hl	
	ld (hl),a	
CSq_l389fh:
	defb 005h
	ex de,hl	
	pop hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
CSq_PopDELdir:
	defb 003h
	pop de	
	ldir
l38a9h:
	ld a,(bc)	
	ld b,h	
	ld c,l	
	pop hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	ld (hl),c	
	inc hl	
	ld (hl),b	
l38b4h:
	dec bc	
	ld de,(l1798h)
	ld hl,00000h
	add hl,sp	
	ldir
	ld sp,hl	
l38c0h:
	push hl	
	push bc	
	ld de,00004h
	add hl,de	
	ld b,(hl)	
	call GetLexem
	dec b	
	inc b	
	jp z,l3931h
	call ChkOpBra_GetLex
	ld de,00005h
	add hl,de	
l38d6h:
	call sub_4d6dh
	push bc	
	ld e,a	
	dec hl	
	ld a,(hl)	
	inc hl	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	push hl	
	cp 002h
	ld a,e	
	jr z,l38f3h
	ld e,018h
	push bc	
	call sub_5027h
	pop de	
	call ChkType__
	jr l3914h
l38f3h:
	call sub_3f29h
	bit 7,b
	jr nz,l3914h
	dec b	
	jr z,l3914h
	inc b	
	jr z,l3922h
	exx	
	dec hl	
	exx	
	call JCodeNextByte
	defb 001h
	ld de,(Merker1)
	call StoreDE
	ld hl,CSq_PushValuesToStack
	call WCode
l3914h:
	pop hl	
	pop bc	
	dec b	
	jr z,l392eh
	call ChkComma_GetLex
	ld de,0000ah
	add hl,de	
	jr l38d6h
l3922h:
	dec c	
	jr z,l3914h
	dec c	
	jr z,l3914h
	call JCodeNextByte
	defb 033h
	jr l3914h
l392eh:
	call ChkCloBra_GetLex
l3931h:
	res 3,(ix+002h)
	pop hl	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	pop hl	
	push af	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
	ld a,(hl)	
	ld hl,BlockLevel__
	sub (hl)	
	jp p,l395ah
	neg
	call JCodeNextByte
	defb 006h
	call StoreAToHL2
	ld hl,CSq_PushListEl_CallX
l3953h:
	call WCode
	pop af	
	jp StoreDE
l395ah:
	ld hl,CSq_PushIX_CallX
	jr l3953h
CSq_PushValuesToStack:
	defb 00bh
	ex de,hl	
	xor a	
	ld l,a	
	ld h,a	
	sbc hl,bc
	add hl,sp	
	ld sp,hl	
	ex de,hl	
	ldir
CSq_PushListEl_CallX:
	defb 005h
	call SelListElem__
	push de	
	defb 0cdh
CSq_PushIX_CallX:
	defb 003h
	push ix
	defb 0cdh
l3975h:
	call ParseConstVal
	push hl	
	ld hl,l2b80h
	ld e,(hl)	
	ld d,000h
	call ChkType__
	pop de	
	call JCodeNextByte
	defb 0feh
	call l381ah
	ld hl,CSq_l3a62h
	call WCode
	cp 0bah
	jr z,l3999h
	call ChkComma_GetLex
	jr l3975h
l3999h:
	ld a,0fbh
	jr l39d8h
l399dh:
	ld bc,0ffffh
	push bc	
	call GetLexem
	call sub_3f3fh
	exx	
	dec hl	
	exx	
	call GetTargetAddrInHL__
	dec hl	
	push hl	
	ld de,00b14h
	call ChkLexem_GetLex
	ld b,a	
	ld a,c	
	ld (l2b80h),a
l39bah:
	dec a	
	ld a,b	
	jr nz,l3975h
l39beh:
	call ParseConstVal
	call ChkType0001
	call WLdDEnnIsHL
	ld hl,CSq_l3a5ch
	call WCode
	cp 0bah
	jr z,l39d6h
	call ChkComma_GetLex
	jr l39beh
l39d6h:
	ld a,0f6h
l39d8h:
	ld d,h	
	ld e,l	
	dec hl	
l39dbh:
	ld b,0ffh
	ld c,a	
	add hl,bc	
	pop bc	
	push bc	
	or a	
	sbc hl,bc
	add hl,bc	
	jr z,l39ech
	call WrDE_ByTargAddr_pl1
	jr l39dbh
l39ech:
	pop bc	
	dec de	
	push de	
	ld hl,l2b80h
	ld b,(hl)	
	push bc	
	call GetLexem
	call l3777h
	pop bc	
	ld hl,l2b80h
	ld (hl),b	
	call WrJump
	dec hl	
	pop de	
	pop bc	
	push hl	
	inc b	
	push bc	
	push hl	
	ex de,hl	
	inc de	
	call WrDE_ByTargAddr_pl1
	dec hl	
	dec hl	
	push af	
	ld a,0c2h
	call WrA_ByTargAddr
	pop af	
	cp 012h
	jr z,l3a49h
	cp 010h
	jr z,l3a29h
	call ChkSemi_GetLex
	ld b,a	
	ld a,(l2b80h)
	jp l39bah
l3a29h:
	inc hl	
	dec de	
	dec de	
	dec de	
	call WrDE_ByTargAddr
	pop de	
	pop bc	
	pop hl	
	exx	
	dec hl	
	dec hl	
	dec hl	
	exx	
	call GetLexem
l3a3bh:
	call GetTargetAddrInHL__
	ex de,hl	
	dec b	
	inc b	
	ret z	
l3a42h:
	pop hl	
	call WrDE_ByTargAddr_pl1
	djnz l3a42h
	ret	
l3a49h:
	pop de	
	pop bc	
	inc b	
	pop hl	
	call GetTargetAddrInHL__
	dec hl	
	push hl	
	push bc	
	call GetLexem
	call l3777h
	pop bc	
	jr l3a3bh
CSq_l3a5ch:
	defb 007h
	or a	
	sbc hl,de
	add hl,de	
	defb 0cah
CSq_l3a62h:
	defb 003h
	defb 0cah
sub_3a64h:
	call StoreAToHL2
	inc c	
sub_3a68h:
	push af	
	call sub_3a6eh
	pop af	
	ret	
sub_3a6eh:
	ld hl,(l2b7eh)
	call sub_34fah
	jr z,l3aabh
	sub b	
	jr z,l3a91h
	dec c	
	jr z,l3a84h
	call WSelListEl_byA
WLdM_A:
	call JCodeNextByte
	defb 077h
	ret	
l3a84h:
	call JCodeNextByte
	defb 0e5h
	call WSelListEl_byA
l3a8bh:
	ld hl,CSq_NxtListEl
	jp WCode
l3a91h:
	call sub_3526h
	jr nc,l3a9ah
	dec c	
	jp l3804h
l3a9ah:
	dec c	
	jr z,l3aa2h
	call WAddConstHLIX
	jr WLdM_A
l3aa2h:
	call JCodeNextByte
	defb 0e5h
	call WAddConstHLIX
	jr l3a8bh
l3aabh:
	dec c	
	jp z,l37dbh
l3aafh:
	call JCodeNextByte
	defb 032h
	jp StoreDE
CSq_NxtListEl:
	defb 005h
	pop de	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	ex de,hl	
CSq_l3abch:
	defb 004h
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ex de,hl	
l3ac1h:
	call GetLexem
	or a	
	ld e,004h
	call nz,CompileErr
	call GetIdentInfoInABC
	cp 002h
	ld e,007h
	call nz,CompileErr
	ld a,c	
	ld (l2b80h),a
	ld (l2b7eh),hl
	call GetLexem
	call ChkColEq_GetLex
	call sub_3f13h
	exx	
	ld (Merker1),hl
	exx	
	call sub_3a68h
	cp 00dh
	jr z,l3af7h
	cp 00ch
	ld e,011h
	call nz,CompileErr
l3af7h:
	push af	
	call GetLexem
	ld hl,(l2b80h)
	ld h,000h
	exx	
	push hl	
	exx	
	call sub_3f23h
	ex af,af'	
	ld a,c	
	dec a	
	exx	
	pop bc	
	exx	
	jr nz,l3b4eh
	add a,021h
	call sub_41bfh
	exx	
	inc hl	
	cp (hl)	
	jr nz,l3b37h
	sbc hl,bc
	add hl,bc	
	jr nz,l3b37h
	ld de,(Merker1)
	sbc hl,de
	ld b,h	
	ld c,l	
	ld h,d	
	ld l,e	
	dec de	
	ldir
	dec hl	
	exx	
	pop af	
	push hl	
	set 2,(ix+001h)
	call WrJump
	jr l3b46h
l3b37h:
	inc hl	
	inc hl	
	inc hl	
	exx	
	res 2,(ix+001h)
	ld hl,CSq_l3c50h
	call WCode
	pop af	
l3b46h:
	dec hl	
	push hl	
	push af	
	ld hl,(l2b7eh)
	jr l3b81h
l3b4eh:
	pop af	
	cp 00ch
	jr nz,l3b5bh
	ld hl,l3c53h
	ld de,l3c57h
	jr l3b61h
l3b5bh:
	ld hl,CSq_l3c5ch
	ld de,CSq_l3c61h
l3b61h:
	call WCodeOverLastByte
	push hl	
	ex de,hl	
	call WCode
	push hl	
	call JCodeNextByte
	defb 0c5h
	push af	
	ld hl,(l2b7eh)
	push hl	
	ld a,(l2b80h)
	push af	
	call sub_376dh
	ex af,af'	
	pop af	
	ld c,a	
	pop hl	
	ld (l2b7eh),hl
l3b81h:
	call sub_34fah
	jr z,l3bd9h
	sub b	
	jr z,l3baah
	call WSelListEl_byA
l3b8ch:
	dec c	
	jr z,l3beah
	call JCodeNextByte
	defb 077h
l3b93h:
	pop af	
	add a,030h
	call sub_3a64h
	ld hl,CSq_l3c65h
	call WCode
	pop de	
	call WrDE_ByTargAddr_pl2
	inc hl	
	ex de,hl	
	pop hl	
	ex af,af'	
	jp WrDE_ByTargAddr
l3baah:
	call sub_3526h
	jr nc,l3bd4h
	call JCodeNextByte
	defb 0ddh
	dec c	
	jr nz,l3bcbh
	call JCodeNextByte
	defb 06eh
	call l381ah
	inc e	
	call JCodeNextByte
	defb 0ddh
	call JCodeNextByte
	ld h,(hl)	
	call l381ah
	jr l3bf0h
l3bcbh:
	call JCodeNextByte
	defb 07eh
	call l381ah
	jr l3b93h
l3bd4h:
	call WAddConstHLIX
	jr l3b8ch
l3bd9h:
	dec c	
	jr z,l3be5h
	call JCodeNextByte
	defb 03ah
	call StoreDE
	jr l3b93h
l3be5h:
	call WLdHLfromMemIsDE
	jr l3bf0h
l3beah:
	ld hl,CSq_l3abch
	call WCode
l3bf0h:
	pop af	
	rlca	
	rlca	
	rlca	
	sub 03dh
	call sub_3a64h
	call GetTargetAddrInHL__
	ex de,hl	
	pop hl	
	push hl	
	call WrDE_ByTargAddr_pl1
	bit 2,(ix+001h)
	jr nz,l3c43h
	call JCodeNextByte
	defb 0d1h
	call JCodeNextByte
	defb 0d5h
l3c10h:
	cp 02bh
	jr z,l3c18h
	call JCodeNextByte
	defb 0ebh
l3c18h:
	ld hl,CSq_l3c4bh
	call WCode
	dec hl	
	push hl	
	ld h,(ix+001h)
	push hl	
	call sub_376dh
	pop hl	
	ld (ix+001h),h
	call WrJump
	ex de,hl	
	pop hl	
	call WrDE_ByTargAddr_pl1
	ex de,hl	
	pop de	
	inc de	
	call WrDE_ByTargAddr_pl2
	bit 2,(ix+001h)
	ret nz	
	call JCodeNextByte
	defb 0d1h
	ret	
l3c43h:
	pop bc	
	pop de	
	call WLdDEnnIsDE
	push bc	
	jr l3c10h
CSq_l3c4bh:
	defb 006h
	or a	
	sbc hl,de
	defb 0fah
CSq_l3c50h:
	defb 004h
	ex (sp),hl	
	defb 0c3h
l3c53h:
	defb 003h
	pop bc	
	cp b	
	defb 0dah
l3c57h:
	defb 004h
	nop	
	nop	
	inc a	
	ld b,a	
CSq_l3c5ch:
	defb 004h
	ld b,a	
	pop af	
	cp b	
	defb 0dah
CSq_l3c61h:
	defb 003h
	nop	
	nop	
	dec b	
CSq_l3c65h:
	defb 005h
	pop bc	
	cp b	
	defb 0c2h
l3c69h:
	call GetTargetAddrInHL__
	push hl	
	call WCaBreak_IfCoCo_C
	call sub_3710h
	push hl	
	ld de,01110h
	call ChkLexem_GetLex
	call l3777h
	call WrJump
	pop de	
	ex de,hl	
	call WrDE_ByTargAddr
	ex de,hl	
	pop de	
	jp WrDE_ByTargAddr_pl2
l3c8ah:
	call sub_3710h
	push hl	
	ld de,00e0fh
	call ChkLexem_GetLex
	call l3777h
	cp 012h
	jr nz,l3cach
	call WrJump
	ex de,hl	
	pop hl	
	call WrDE_ByTargAddr
	dec de	
	dec de	
	push de	
	call GetLexem
	call l3777h
l3cach:
	call GetTargetAddrInHL__
	ex de,hl	
	pop hl	
	jp WrDE_ByTargAddr
l3cb4h:
	call GetTargetAddrInHL__
	push hl	
	call GetLexem
	call WCaBreak_IfCoCo_C
l3cbeh:
	call l3777h
	cp 00fh
	jr z,l3ccah
	call ChkSemi_GetLex
	jr l3cbeh
l3ccah:
	call sub_3710h
	pop de	
	jp WrDE_ByTargAddr
l3cd1h:
	call GetLexem
l3cd4h:
	call l3777h
	cp 010h
	jp z,GetLexem
	call ChkSemi_GetLex
	jr l3cd4h
l3ce1h:
	pop af	
	ld e,039h
	jp CompileErr
sub_3ce7h:
	call GetLexem
	ld e,038h
	call sub_5027h
	exx	
	dec hl	
	exx	
	call JCodeNextByte
	defb 022h
	ld de,00005h
	add hl,de	
	ex de,hl	
	call StoreDE
	call JCodeNextByte
	defb 0c3h
	ld de,00004h
	add hl,de	
	ex de,hl	
	call StoreDE
	exx	
	inc hl	
	inc hl	
	exx	
	push af	
	ld a,b	
	cp 003h
	jr c,l3ce1h
	inc bc	
	ld a,(bc)	
	dec bc	
	or a	
	jr z,l3ce1h
	push bc	
	ld b,h	
	ld c,l	
	pop hl	
	push hl	
	call sub_3d41h
	pop hl	
	pop af	
	push hl	
	cp 0ach
	jr z,l3d3ch
	ld de,01110h
	call ChkLexem_GetLex
	call l3777h
l3d32h:
	pop hl	
	ld bc,00000h
	push af	
	call sub_3d41h
	pop af	
	ret	
l3d3ch:
	call sub_3ce7h
	jr l3d32h
sub_3d41h:
	ld a,c	
	call sub_4d6dh
	ld c,a	
	ld de,00008h
	add hl,de	
	ld (hl),c	
	inc hl	
	ld (hl),b	
	inc hl	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ld a,d	
	or e	
	ret z	
	ex de,hl	
	jr sub_3d41h
l3d57h:
	call GetLexem
	ld e,03ch
	cp 07fh
	jp nz,CompileErr
	call ChkLabelList__
	call JCodeNextByte
	defb 0c3h
	call StoreDE
	jp GetLexem
l3d6eh:
	call GetLexem
	cp 0a8h
	jr nz,l3d7bh
	call GetLexem
	call sub_3d84h
l3d7bh:
	ld hl,CSq_l3e3dh
	jp WCode
l3d81h:
	call NextChkOpBra_GetLex
sub_3d84h:
	call sub_3f3fh
	dec b	
	inc b	
	jp nz,l3e15h
	dec c	
	jr z,l3da1h
	dec c	
	jp z,l3df7h
	dec c	
	jr z,l3dceh
	dec c	
	jp z,l3dd6h
l3d9ah:
	ld e,013h
	call CompileErr
	jr l3dedh
l3da1h:
	cp 0bah
	ld hl,l3e41h
	jr nz,l3dc9h
	call sub_3f0dh
	ld hl,l3e48h
	cp 0bah
	jr nz,l3dc9h
	call GetLexem
	or a	
	ld e,043h
	call nz,CompileErr
	ld a,(curIdentifier)
	cp 0c8h
	call nz,CompileErr
	call GetLexem
	ld hl,CSq_l3e4eh
l3dc9h:
	call WCodeOverLastByte
	jr l3dedh
l3dceh:
	ld de,CSq_l3e6ch
	ld hl,CSq_l3e73h
	jr l3ddch
l3dd6h:
	ld de,CSq_l3e5eh
	ld hl,CSq_l3e68h
l3ddch:
	cp 0bah
	jr nz,l3dc9h
	push hl	
	push de	
	call sub_3f0dh
	pop hl	
	call WCodeOverLastByte
	pop hl	
l3deah:
	call WCode
l3dedh:
	cp 0ach
	jp nz,ChkCloBra_GetLex
	call GetLexem
	jr sub_3d84h
l3df7h:
	cp 0bah
	jr nz,l3e0dh
	call sub_3f0dh
	cp 0bah
	ld hl,CSq_l3e77h
	jr nz,l3dc9h
	call sub_3f0dh
	ld hl,CSq_l3e82h
	jr l3dc9h
l3e0dh:
	ld hl,CSq_l3e7eh
	call l33beh
	jr l3dedh
l3e15h:
	dec b	
	dec b	
	jp nz,l3d9ah
	cp 0bah
	jr nz,l3e35h
	push bc	
	call sub_3f0dh
	pop de	
	exx	
	dec hl	
	exx	
	call JCodeNextByte
	defb 03eh
	call l381ah
	ld hl,CSq_l3e53h
	call WCode
	jr l3e38h
l3e35h:
	call sub_343dh
l3e38h:
	ld hl,l3e5ah
	jr l3deah
CSq_l3e3dh:
	defb 003h
	call PrNL
l3e41h:
	ld b,0cdh
	ld (hl),008h
	call PrSpace
l3e48h:
	dec b	
	ld a,l	
	pop hl	
	call PrDez
CSq_l3e4eh:
	defb 004h
	pop de	
	call PrHex
CSq_l3e53h:
	defb 006h
	ld c,a	
	call PrFillSpc
	pop hl	
	ld b,c	
l3e5ah:
	inc bc	
	call OutNStr
CSq_l3e5eh:
	defb 009h
	ld a,005h
	pop bc	
	push bc	
	sub b	
	call PrFillSpc
	pop af	
CSq_l3e68h:
	defb 003h
	call PrBool
CSq_l3e6ch:
	defb 006h
	ld a,001h
	call PrFillSpc
	pop af	
CSq_l3e73h:
	defb 003h
	call OutChr
CSq_l3e77h:
	defb 006h
	ld a,l	
	pop de	
	pop hl	
	call l106fh
CSq_l3e7eh:
	defb 003h
	call l1074h
CSq_l3e82h:
	defb 004h
	pop de	
	call sub_0f6eh
sub_3e87h:
	or a	
	ld e,01ah
	jp nz,CompileErr
	call GetIdentInfoInABC
	ld e,01ah
	jp sub_4e7dh
l3e95h:
	call NextChkOpBra_GetLex
l3e98h:
	call sub_3e87h
	push af	
	push hl	
	push de	
	xor a	
	cp b	
	jr nz,l3ed3h
	ld a,c	
	dec a	
	jr z,l3ec1h
	dec a	
	jr z,l3ec9h
	dec a	
	jr z,l3eceh
l3each:
	ld e,01dh
	call CompileErr
l3eb1h:
	pop hl	
	pop de	
	pop af	
	call l37bbh
l3eb7h:
	cp 0ach
	jp nz,ChkCloBra_GetLex
sub_3ebch:
	call GetLexem
	jr l3e98h
l3ec1h:
	ld hl,CSq_l3ef9h
l3ec4h:
	call WCode
	jr l3eb1h
l3ec9h:
	ld hl,l3f07h
	jr l3ec4h
l3eceh:
	ld hl,l3efeh
	jr l3ec4h
l3ed3h:
	dec b	
	dec b	
	jr nz,l3each
	call sub_343dh
	ld hl,CSq_l3f03h
	call WCode
	pop de	
	pop hl	
	pop af	
	jr l3eb7h
l3ee5h:
	call GetLexem
	cp 0a8h
	jr nz,l3eefh
	call sub_3ebch
l3eefh:
	ld hl,CSq_l3ef5h
	jp WCode
CSq_l3ef5h:
	defb 003h
	call l0aa2h
CSq_l3ef9h:
	defb 004h
	call sub_0bb3h
	push hl	
l3efeh:
	inc b	
	call JReadEditIBuf__
	push af	
CSq_l3f03h:
	defb 003h
	call l0bd4h
l3f07h:
	dec b	
	call sub_11b1h
	push hl	
	push de	
sub_3f0dh:
	call GetLexem
sub_3f10h:
	ld bc,00001h
sub_3f13h:
	push bc	
	jr l3f24h
sub_3f16h:
	ld hl,(l2b89h)
	dec h	
	push hl	
	call sub_3f3fh
	exx	
	dec hl	
	exx	
	jr l3f2dh
sub_3f23h:
	push hl	
l3f24h:
	call sub_3f3fh
	jr l3f2dh
sub_3f29h:
	push bc	
	call sub_3f31h
l3f2dh:
	pop de	
	jp ChkType__
sub_3f31h:
	ld hl,00002h
	or a	
	sbc hl,bc
	jr nz,sub_3f3fh
	set 0,(ix+001h)
	jr l3f43h
sub_3f3fh:
	res 0,(ix+001h)
l3f43h:
	call sub_4075h
	cp 020h
	jp z,l3febh
	cp 077h
	ret c	
	cp 07dh
	ret nc	
	add a,a	
	ld l,a	
	ld h,000h
	push hl	
	push bc	
	call sub_4072h
	ld e,a	
	ld a,b	
	or a	
	jr nz,l3f9eh
	ld a,c	
	dec a	
	jr z,l3f8bh
	dec a	
	ld a,e	
	jr nz,l3f82h
	pop bc	
	call PCVChkNum
	exx	
	dec hl	
	exx	
	bit 0,c
	jr z,l3f78h
	ld hl,CSq_l4184h
	call WCodeOverLastByte
l3f78h:
	ld bc,TabCSq-000beh
WCode_VarIdxTOS:
	pop hl	
	call GetCSqAddrByIdx
	jp WCodeOverLastByte
l3f82h:
	pop de	
	call ChkType__
	ld bc,TabCSq-000d6h
	jr WCode_VarIdxTOS
l3f8bh:
	ld a,e	
	pop de	
	call ChkType__
	bit 4,(ix+000h)
	ld bc,TabCSq-000eeh
	jr z,WCode_VarIdxTOS
	ld bc,TabCSq-000e2h
	jr WCode_VarIdxTOS
l3f9eh:
	ld a,e	
	pop de	
	call ChkType__
	bit 7,d
	jr nz,l3fdbh
	dec d	
	jr z,l3fbbh
	dec d	
	jr nz,l3fd0h
	call sub_343dh
	ld hl,CSq_l35e8h
	call WCode
	ld bc,TabCSq-000cah
	jr WCode_VarIdxTOS
l3fbbh:
	pop hl	
	ld e,a	
	ld a,l	
	cp 0f2h
	jr z,l3fd6h
	cp 0f4h
	ld a,e	
	jr z,l3fd7h
	ld bc,TabCSq-000b2h
	call GetCSqAddrByIdx
	jp CodeLdBC_0n_from_0x2b8b
l3fd0h:
	ld e,01bh
l3fd2h:
	pop hl	
l3fd3h:
	jp CompileErr
l3fd6h:
	ld a,e	
l3fd7h:
	ld e,031h
	jr l3fd3h
l3fdbh:
	ld e,a	
	pop hl	
	push hl	
	ld a,l	
	cp 0f2h
	ld bc,TabCSq-000eeh
	ld a,e	
	jr c,WCode_VarIdxTOS
	ld e,040h
	jr l3fd2h
l3febh:
	call sub_46bfh
	exx	
	dec hl	
	exx	
	jr c,l3ff7h
	call JCodeNextByte
	defb 07dh
l3ff7h:
	ld hl,CSq_l4026h
	call WCode
	push bc	
	call sub_4072h
	pop de	
	call ChkType__
	ld hl,CSq_l402ah
	call WCode
	ld c,a	
	ld hl,(l2b8bh)
	ld h,000h
	inc l	
	call sub_4037h
	ld a,c	
	call JCodeNextByte
	defb 0f5h
	jr l4022h
GetCSqAddrByIdx:
	add hl,bc	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
	ex de,hl	
l4022h:
	ld bc,00004h
	ret	
CSq_l4026h:
	defb 003h
	ld (l1798h),a
CSq_l402ah:
	defb 00ch
	ld a,(l1798h)
	call sub_0be9h
	and (hl)	
	neg
	ld a,000h
	rla	
sub_4037h:
	ld a,h	
	or a	
	jr nz,l4051h
	ld a,l	
	cp 006h
	jr nc,l4051h
	srl a
	jr nc,l4049h
	call JCodeNextByte
	defb 033h
	or a	
l4049h:
	ret z	
	call JCodeNextByte
	defb 0e1h
	dec a	
	jr l4049h
l4051h:
	call WLdHLnnIsHL
	call JCodeNextByte
	defb 039h
	call JCodeNextByte
	defb 0f9h
	ret	
FoundMinus__:
	call GetTerm
	call PCVChkNum
	bit 0,c
	ld hl,l414bh
	jr nz,l40a0h
	ld hl,l4150h
	call l33beh
	jr l4089h
sub_4072h:
	call GetLexem
sub_4075h:
	cp 0adh
	jp z,FoundMinus__
	cp 0abh
	jr nz,l4086h
	call GetTerm
	call PCVChkNum
	jr l4089h
l4086h:
	call ChkTerm
l4089h:
	cp 0abh
	jr z,l40a5h
	cp 0adh
	jr z,l40a5h
	cp 007h
	ret nz	
	call ChkTypeBool__
	call GetTerm
	call ChkTypeBool__
	ld hl,CSq_l416fh
l40a0h:
	call WCodeOverLastByte
	jr l4089h
l40a5h:
	dec b	
	jp z,l411ch
	inc b	
	call PCVChkNum
	ld b,a	
	push bc	
	call GetTerm
	call PCVChkNum
	bit 0,c
	pop bc	
	jr nz,l40ddh
	exx	
	dec hl	
	dec hl	
	exx	
	bit 2,b
	jr z,l40c8h
	ld hl,CSq_l4173h
	call WCode
l40c8h:
	bit 0,c
	jr z,l40d2h
	ld hl,CSq_l417eh
	call WCode
l40d2h:
	ld hl,CSq_l4188h
	ld bc,00002h
	call WCode
	jr l4089h
l40ddh:
	push af	
	xor a	
	call sub_41bbh
	jr z,l40feh
	bit 2,b
	jr z,l40edh
	ex de,hl	
	ld l,a	
	ld h,a	
	sbc hl,de
l40edh:
	bit 1,(ix+000h)
	call sub_418eh
l40f4h:
	pop af	
	call JCodeNextByte
	defb 0e5h
	ld bc,00001h
	jr l4089h
l40feh:
	bit 2,b
	jr nz,l410bh
	bit 1,(ix+000h)
	call sub_41b0h
	jr l40f4h
l410bh:
	bit 1,(ix+000h)
	ld hl,l4162h
	jr nz,l4117h
	ld hl,CSq_l416ah
l4117h:
	call WCode
	jr l40f4h
l411ch:
	push af	
	inc b	
	push bc	
	call GetTerm
	pop de	
	call ChkType__
	pop de	
	bit 2,d
	ld hl,CSq_StorNotDEAndM
	jr nz,A_was_0xad_this_is_not_0xab
	ld hl,CSq_StorOrM
A_was_0xad_this_is_not_0xab:
	call CodeLdBC_0n_from_0x2b8b
	jp l4089h
CSq_StorOrM:
	defb 009h
	ld hl,000b6h
	ld (opCodes),hl
	call MaskBytes__
CSq_StorNotDEAndM:
	defb 009h
	ld hl,0a62fh
	ld (opCodes),hl
	call MaskBytes__
l414bh:
	inc b	
	call NegHL
	push hl	
l4150h:
	ld a,(bc)	
	bit 6,h
	jr z,l4159h
	ld a,080h
	xor h	
	ld h,a	
l4159h:
	push hl	
	push de	
CSq_l415bh:
	defb 006h
	or a	
	adc hl,de
	call pe,ErrOverflow
l4162h:
	rlca	
	ex de,hl	
	or a	
	sbc hl,de
	call pe,ErrOverflow
CSq_l416ah:
	defb 004h
	ex de,hl	
	or a	
	sbc hl,de
CSq_l416fh:
	defb 003h
	pop bc	
	or b	
	push af	
CSq_l4173h:
	defb 004h
	ld a,080h
	xor h	
	ld h,a	
CSq_l4178h:
	defb 005h
	call sub_0e45h
	push hl	
	push de	
CSq_l417eh:
	defb 005h
	ex (sp),hl	
	push de	
	call sub_0e45h
CSq_l4184h:
	defb 003h
	call sub_0e45h
CSq_l4188h:
	defb 005h
	call sub_0ca1h
	push hl	
	push de	
sub_418eh:
	push af	
	ld a,h	
	or a	
	jr nz,l41a4h
	ld a,l	
	ld e,023h
l4196h:
	cp 005h
	jr nc,l41ach
	pop bc	
	or a	
	ret z	
	ld b,a	
l419eh:
	call l381ah
	djnz l419eh
	ret	
l41a4h:
	inc a	
	jr nz,l41ach
	sub l	
	ld e,02bh
	jr nz,l4196h
l41ach:
	call WLdDEnnIsHL
	pop af	
sub_41b0h:
	ld hl,CSq_l415bh
	jp nz,WCode
	call JCodeNextByte
	defb 019h
	ret	
sub_41bbh:
	bit 3,(ix+002h)
sub_41bfh:
	exx	
	dec hl	
	jr z,l41cdh
	dec hl	
	ld d,(hl)	
	dec hl	
	ld e,(hl)	
	dec hl	
	dec hl	
	push de	
	exx	
	pop hl	
	ret	
l41cdh:
	ld (hl),0d1h
	inc hl	
	exx	
	ret	
GetTerm:
	call GetLexem
ChkTerm:
	call ChkFactor
ChkTermOp:
	cp 0aah
	jr z,l424ah
	cp 002h
	jr z,l41fch
	cp 009h
	jr z,l41fch
	cp 0afh
	jr z,l422bh
	cp 008h
	ret nz	
	call ChkTypeBool__
	call GetFactor
	call ChkTypeBool__
	ld hl,CSq_l42edh
	call WCodeOverLastByte
	jr ChkTermOp
l41fch:
	call ChkType0001
	push af	
	call GetFactor
	call ChkType0001
	call sub_41bbh
	jr z,l4213h
	ex de,hl	
	call JCodeNextByte
	defb 0ebh
	call WLdHLnnIsDE
l4213h:
	pop de	
	bit 0,d
	ld hl,l42e9h
	jr nz,l421eh
	ld hl,CSq_l42e4h
l421eh:
	call WCode
l4221h:
	call JCodeNextByte
	defb 0e5h
	res 3,(ix+002h)
	jr ChkTermOp
l422bh:
	call PCVChkNum
	bit 0,c
	jr z,l423ch
	ld hl,CSq_l4178h
	call WCodeOverLastByte
	set 0,(ix+001h)
l423ch:
	call GetFactor
	call PCVChkNum
	ld hl,l42f1h
	call l33beh
	jr ChkTermOp
l424ah:
	push bc	
	dec b	
	jr z,l4274h
	inc b	
	call PCVChkNum
	call GetFactor
	call PCVChkNum
	bit 0,c
	pop de	
	jr nz,l4283h
	exx	
	dec hl	
	dec hl	
	exx	
	bit 0,e
	jr z,l426bh
	ld hl,CSq_l417eh
	call WCode
l426bh:
	ld hl,CSq_l42f7h
	call WCode
l4271h:
	jp ChkTermOp
l4274h:
	call GetFactor
	pop de	
	call ChkType__
	ld hl,CSq_StorAndM
	call CodeLdBC_0n_from_0x2b8b
	jr l4271h
l4283h:
	call sub_41bbh
	ex de,hl	
	ld hl,l42e0h
	jr z,l421eh
	push af	
	push bc	
	call sub_4295h
	pop bc	
	pop af	
	jr l4221h
sub_4295h:
	push hl	
	ld a,d	
	or a	
	jr nz,WCodeFromTOS
	ld a,e	
	cp 011h
	jr nc,WCodeFromTOS
	or a	
	jr z,WCodeFromTOS
	cp 001h
	pop hl	
	ret z	
	push hl	
	exx	
	push hl	
	exx	
	ld c,0feh
l42ach:
	srl a
	jr z,l42cdh
	jr nc,l42bdh
	inc c	
	jr z,WCodeFromSOStoTOS
	call JCodeNextByte
	defb 054h
	call JCodeNextByte
	defb 05dh
l42bdh:
	call JCodeNextByte
	defb 029h
	jr l42ach
WCodeFromSOStoTOS:
	exx	
	pop hl	
	exx	
WCodeFromTOS:
	call WLdDEnnIsDE
	pop hl	
	jp WCode
l42cdh:
	pop hl	
	pop hl	
	inc c	
	ret nz	
	call JCodeNextByte
	defb 019h
	ret	
CSq_StorAndM:
	add hl,bc	
	ld hl,000a6h
	ld (opCodes),hl
	call MaskBytes__
l42e0h:
	inc bc	
	call Mul16x8sgn
CSq_l42e4h:
	defb 004h
	call Div
	ex de,hl	
l42e9h:
	inc bc	
	call Div
CSq_l42edh:
	defb 003h
	pop bc	
	and b	
	push af	
l42f1h:
	dec b	
	call RealDiv__
	push hl	
	push de	
CSq_l42f7h:
	defb 005h
	call RealMul__
	push hl	
	push de	
l42fdh:
	ld a,(l2b76h)
	push af	
	push bc	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	push de	
	inc hl	
	ld b,(hl)	
	call GetLexem
	dec b	
	jr z,l4323h
	call ChkOpBra_GetLex
	jr l4316h
l4313h:
	call ChkComma_GetLex
l4316h:
	push bc	
	call sub_3f10h
	pop bc	
	djnz l4313h
	call ChkCloBra_GetLex
	exx	
	dec hl	
	exx	
l4323h:
	pop hl	
	pop bc	
	pop de	
	ld (ix+001h),d
	call WCode
	ld hl,00001h
	or a	
	sbc hl,bc
	ret nz	
	jp l45a0h
sub_4336h:
	ld a,(l2b76h)
	push af	
	call NextChkOpBra_GetLex
	call sub_3f3fh
	call ChkScalar
	call ChkCloBra_GetLex
	dec c	
	pop de	
	ld (ix+001h),d
	ret	
l434ch:
	call sub_4336h
	jr z,l4358h
	ld hl,CSq_l4379h
	ld c,b	
l4355h:
	call WCodeOverLastByte
l4358h:
	jp l459fh
l435bh:
	call sub_4336h
	jr z,l4367h
	ld hl,CSq_l4381h
l4363h:
	inc c	
	jp WCodeOverLastByte
l4367h:
	ld hl,l4387h
	jr l4355h
l436ch:
	call sub_4336h
	ld hl,l437eh
	jr nz,l4363h
	ld hl,l4384h
	jr l4355h
CSq_l4379h:
	defb 004h
	ld l,a	
	ld h,000h
	push hl	
l437eh:
	ld (bc),a	
	inc a	
	push af	
CSq_l4381h:
	defb 002h
	dec a	
	push af	
l4384h:
	ld (bc),a	
	inc hl	
	push hl	
l4387h:
	ld (bc),a	
	dec hl	
	push hl	
l438ah:
	call NextChkOpBra_GetLex
l438dh:
	call ParseConstVal
	ld c,a	
	ld a,l	
	call StoreAToHL2
	ld a,c	
	cp 0ach
	jp nz,ChkCloBra_GetLex
	call GetLexem
	jr l438dh
NOTFactor__:
	call GetFactor
	call ChkTypeBool__
	ld hl,CSqNOT
	jp WCodeOverLastByte
GetExpr__:
	call GetLexem
	call l3f43h
	jp l4511h
GetFactor:
	call GetLexem
ChkFactor:
	res 3,(ix+002h)
	or a	
	jr z,FoundIdent_2__
	cp 076h
	jr z,WLdChr
	cp 075h
	jr z,FoundStrLit__
	cp 0a8h
	jr z,GetExpr__
	cp 0dbh
	jp z,GetRange__
	cp 022h
	jp z,FoundNIL__
	set 3,(ix+002h)
	cp 07fh
	ld hl,(curRealHWord)
	jr z,FoundPosInt__
	ld de,(curNum)
	cp 07eh
	jr z,FoundUnsigNum__
	cp 006h
	jr z,NOTFactor__
	ld e,00ch
	call CompileErr
	jp l344bh
WLdChr:
	ld a,(curRealHWord)
	ld bc,00003h
	jr WLdChrInA
FoundStrLit__:
	ld de,(curRealHWord)
	ld a,(curNum)
	ld c,a	
	ld b,002h
l4406h:
	ld l,c	
	ld h,000h
	ld (Merker1),hl
	jp WLdStrAddr
FoundIdent_2__:
	call GetIdentInfoInABC
	cp 001h
	ret m	
	jp nz,l44c7h
	set 3,(ix+002h)
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ld a,b	
	or a	
	jr nz,l4406h
	ld a,c	
	dec a	
	jr z,l4445h
	dec a	
	jr z,l447bh
	ld a,d	
	ld (l2b8bh+1),a
	ld a,e	
WLdChrInA:
	or a	
	jr z,WLd0
	call JCodeNextByte
	defb 03eh
	call StoreAToHL2
WPushAF:
	call JCodeNextByte
	defb 0f5h
	jr l4464h
WLd0:
	call JCodeNextByte
	defb 0afh
	jr WPushAF
l4445h:
	ex de,hl	
FoundPosInt__:
	bit 0,(ix+001h)
	jr z,l446eh
	call NormalisiereZahl__
FoundUnsigNum__:
	ex de,hl	
	push hl	
l4451h:
	ex de,hl	
	ex (sp),hl	
	call WLdDEnnIsHL
	pop de	
	call WLdHLnnIsDE
	call sub_45c2h
	ld bc,00002h
	set 0,(ix+001h)
l4464h:
	jp GetLexem
FoundNIL__:
	ld bc,08000h
	ld d,c	
	ld e,c	
	jr WLdStrAddr
l446eh:
	ld bc,00001h
	ex de,hl	
WLdStrAddr:
	call WLdHLnnIsDE
	call JCodeNextByte
	defb 0e5h
	jr l4464h
l447bh:
	push de	
	inc hl	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	jr l4451h
l4482h:
	ld a,(l2b76h)
	push af	
	ld a,(bc)	
	ld c,a	
	ld b,000h
	push bc	
	push hl	
	dec a	
	ld hl,l4676h
	jr z,l449bh
	dec a	
	ld hl,l4678h
	jr z,l449bh
	ld hl,CSq_l4660h
l449bh:
	call WCode
	pop hl	
	call l38c0h
	pop bc	
	pop de	
	ld (ix+001h),d
	dec c	
	jr nz,l44b3h
	ld hl,CSq_l4654h
	call WCode
	jp l459fh
l44b3h:
	dec c	
	jr z,l44bbh
	ld hl,l4657h
	jr l44c2h
l44bbh:
	ld hl,CSq_l465bh
	set 0,(ix+001h)
l44c2h:
	inc c	
	inc c	
	jp WCode
l44c7h:
	cp 009h
	jp z,l42fdh
	cp 00ah
	jp z,l456fh
	jr nc,l4518h
	cp 007h
	jp z,l376bh
	cp 005h
	jr z,l4482h
	jp l456fh
sub_44dfh:
	push bc	
	set 0,(ix+001h)
	call sub_4508h
	exx	
	dec hl	
	dec hl	
	exx	
	call JCodeNextByte
	defb 0cdh
	pop de	
	call StoreDE
	jp sub_45c2h
l44f6h:
	ld a,(l2b76h)
	push af	
	call sub_44dfh
	pop de	
	ld (ix+001h),d
	dec c	
	exx	
	dec hl	
	exx	
	jp l45a0h
sub_4508h:
	call NextChkOpBra_GetLex
	call l3f43h
	call PCVChkNum
l4511h:
	res 3,(ix+002h)
	jp ChkCloBra_GetLex
l4518h:
	cp 00ch
	jr c,sub_44dfh
	jr z,l44f6h
	cp 00fh
	jp z,l456fh
	push bc	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	push de	
	call sub_4508h
	bit 0,c
	pop de	
	pop hl	
	jp nz,WCodeOverLastByte
	ex de,hl	
	jp l33beh
l4536h:
	ld a,(l2b76h)
	push af	
	call NextChkOpBra_GetLex
	call sub_3f10h
	pop de	
	ld (ix+001h),d
	call ChkComma_GetLex
	ld hl,l2b93h
	push hl	
	call sub_4af1h
	call ChkCloBra_GetLex
	pop hl	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
	call sub_5045h
	ld d,000h
	jr l4574h
l455dh:
	push bc	
	ld c,001h
	call sub_457dh
	pop bc	
	ret	
l4565h:
	exx	
	dec hl	
	exx	
	ld hl,CSq_PushValuesToStack
	inc b	
	jp CodeLdBC_0n_from_0x2b8b
l456fh:
	ld e,00ch
	call sub_4e7dh
l4574h:
	bit 7,b
	jr nz,l455dh
	dec b	
	jr z,l4565h
	inc b	
	ret nz	
sub_457dh:
	dec d	
	jp m,l4612h
	ex de,hl	
	jr nz,l45cbh
	dec c	
	jr z,l4598h
	dec c	
	jr z,l45ach
	call JCodeNextByte
	defb 03ah
	call StoreDE
l4591h:
	inc c	
	call JCodeNextByte
	defb 0f5h
	inc c	
	ret	
l4598h:
	call WLdHLfromMemIsDE
l459bh:
	call JCodeNextByte
	defb 0e5h
l459fh:
	inc c	
l45a0h:
	bit 0,(ix+001h)
	ret z	
	inc c	
	ld hl,CSq_l4178h
	jp WCodeOverLastByte
l45ach:
	call JCodeNextByte
	defb 0edh
	call JCodeNextByte
	defb 05bh
	call StoreDE
	inc de	
	inc de	
	call WLdHLfromMemIsDE
l45bch:
	set 0,(ix+001h)
	inc c	
	inc c	
sub_45c2h:
	call JCodeNextByte
	defb 0e5h
	call JCodeNextByte
	defb 0d5h
	ret	
l45cbh:
	ld d,0ddh
	call JCodeNextByte
	defb 0ddh
	dec c	
	jr z,l45e0h
	dec c	
	jr z,l45f1h
	call JCodeNextByte
	defb 07eh
	call l381ah
	jr l4591h
l45e0h:
	call JCodeNextByte
	defb 06eh
	call StoreDE
	inc e	
	call JCodeNextByte
	defb 066h
	call l381ah
	jr l459bh
l45f1h:
	call JCodeNextByte
	defb 05eh
	call StoreDE
	inc e	
	call JCodeNextByte
	defb 056h
	call StoreDE
	inc e	
	call JCodeNextByte
	defb 06eh
	call StoreDE
	inc e	
	call JCodeNextByte
	defb 066h
	call l381ah
	jr l45bch
l4612h:
	dec c	
	jr z,l461dh
	dec c	
	jr z,l4623h
	ld hl,l4662h
	jr l462ah
l461dh:
	ld hl,l4665h
	jp l4355h
l4623h:
	ld hl,CSq_l466bh
	set 0,(ix+001h)
l462ah:
	inc c	
	inc c	
	jp WCodeOverLastByte
NormalisiereZahl__:
	ld a,080h
	and h	
	jr z,HL_is_Pos
	ex de,hl	
	ld hl,00000h
	sbc hl,de
	or a	
HL_is_Pos:
	ld de,00000h
	adc hl,de
	ret z	
	ld d,00eh
ShlHL:
	bit 6,h
	jr nz,RestoreSignBit
	add hl,hl	
	dec d	
	jr ShlHL
RestoreSignBit:
	ld e,000h
	or h	
	ld h,a	
	ret	
CSqNOT:
	defb 003h
	xor 001h
	push af	
CSq_l4654h:
	defb 002h
	pop hl	
	push hl	
l4657h:
	inc bc	
	dec sp	
	pop af	
	push af	
CSq_l465bh:
	defb 004h
	pop de	
	pop hl	
	push hl	
	push de	
CSq_l4660h:
	defb 001h
	dec sp	
l4662h:
	defb 002h
	ld a,(hl)	
	push af	
l4665h:
	defb 005h
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ex de,hl	
	push hl	
CSq_l466bh:
	defb 00ah
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
	ld c,(hl)	
	inc hl	
	ld h,(hl)	
	ld l,c	
	push hl	
	push de	
l4676h:
	defb 001h
	push hl	
l4678h:
	defb 002h
	push hl	
	push de	
sub_467bh:
	or a	
	ld hl,CSq_PrepCaPrc_NoLVar__
	jr z,l468bh
	call JCodeNextByte
	defb 00eh
	call StoreAToHL2
	ld hl,CSq_IniLVar_CaPrc
l468bh:
	jp WCode
CSq_IniLVar_CaPrc:
	defb 003h
	call InitLocVar_CaPrc__
	inc bc	
	call sub_0be9h
CSq_l4696h:
	defb 005h
	call sub_0be9h
	or (hl)	
	ld (hl),a	
	inc b	
	ld a,l	
	call sub_0be9h
CSq_l46a1h:
	defb 007h
	ld e,a	
	call sub_0be9h
	ld d,a	
	push hl	
	push de	
l46a9h:
	ex af,af'	
	pop de	
	pop hl	
	sub e	
	jr c,CSq_PrepCaPrc_NoLVar__
	call sub_0c03h
CSq_PrepCaPrc_NoLVar__:
	defb 004h
	ld b,000h
	push bc	
	inc sp	
CSq_SaveHL:
	defb 003h
	ld (l1798h),hl
CSq_RestHL:
	defb 003h
	ld hl,(l1798h)
sub_46bfh:
	call ChkScalar
	inc b	
	ld (l2b89h),bc
	ld a,c	
	dec a	
	jr z,l46dfh
	cp 002h
	ld a,01fh
	jr z,l46dah
	ld a,(l2b8bh+1)
	srl a
	srl a
	srl a
l46dah:
	ld (l2b8bh),a
	scf	
	ret	
l46dfh:
	ld a,01fh
	ld (l2b8bh),a
	or a	
	ret	
l46e6h:
	ld bc,(l2b89h)
	jp GetLexem
GetRange__:
	ld a,(l2b89h)
	or a	
	jp z,l474eh
	ld a,(l2b8bh)
	call sub_467bh
	call GetLexem
	cp 0ddh
	jr z,l46e6h
l4701h:
	call sub_3f16h
l4704h:
	cp 0aeh
	jr z,l4721h
	dec c	
	jr nz,l470fh
	call JCodeNextByte
	defb 07dh
l470fh:
	ld hl,CSq_l4696h
l4712h:
	call WCode
	cp 0ddh
	jr z,l46e6h
	ld de,0ac2ah
	call ChkLexem_GetLex
	jr l4701h
l4721h:
	call GetLexem
	ld de,0ae2bh
	call ChkLexem_GetLex
	dec c	
	jr z,l4738h
	ld hl,CSq_l46a1h
	call WCode
	call sub_3f16h
	jr l4749h
l4738h:
	call JCodeNextByte
	defb 07dh
	ld hl,CSq_l46a1h
	call WCode
	call sub_3f16h
	call JCodeNextByte
	defb 07dh
l4749h:
	ld hl,l46a9h
	jr l4712h
l474eh:
	call GetLexem
	cp 0ddh
	jr z,CoErrEmptySet
	call sub_3f3fh
	push af	
	call sub_46bfh
	jr nc,l4768h
	exx	
	dec hl	
	exx	
	call sub_467bh
l4764h:
	pop af	
	jp l4704h
l4768h:
	ld hl,CSq_SaveHL
	call WCodeOverLastByte
	call sub_467bh
	ld hl,CSq_RestHL
	call WCode
	jr l4764h
CoErrEmptySet:
	ld e,02dh
	call CompileErr
	jp GetLexem
sub_4781h:
	cp 021h
	jr nz,ChkConst
	call WrJump
	push hl	
ChkLabelNum__:
	call GetLexem
	cp 07fh
	ld e,03bh
	jp nz,CompileErr
	ld hl,(TopOfHeapAddr__)
	ld de,(labelListAddr)
	ld (labelListAddr),hl
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	ld de,(curRealHWord)
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	ex de,hl	
	call GetTargetAddrInHL__
	ex de,hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	ld a,(BlockLevel__)
	ld (hl),a	
	inc hl	
	ld (TopOfHeapAddr__),hl
	call WrJump
	call GetLexem
	cp 0ach
	jr z,ChkLabelNum__
	call GetTargetAddrInHL__
	ex de,hl	
	pop hl	
	call WrDE_ByTargAddr_pl2
	call ChkSemi_GetLex
ChkConst:
	cp 003h
	jr nz,ChkType
	call GetLexem
ParseConst:
	call IdentToSymtab
	push hl	
	call GetLexem
	cp 07dh
	jr nz,PConChkEq
	ld e,005h
	call CompileErr
	jr PConChkVal
PConChkEq:
	cp 078h
	ld e,006h
	call nz,CompileErr
PConChkVal:
	call GetLexem
	call ParseConstVal
	ex de,hl	
	ex (sp),hl	
	ld (hl),001h
	inc hl	
	ld (hl),c	
	inc hl	
	ld (hl),b	
	inc hl	
	dec b	
	inc b	
	jr nz,l4804h
	dec c	
	dec c	
l4804h:
	pop bc	
	jr nz,l480bh
	ld (hl),c	
	inc hl	
	ld (hl),b	
	inc hl	
l480bh:
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	ld (TopOfHeapAddr__),hl
	call ChkSemi_GetLex
	or a	
	jr z,ParseConst
ChkType:
	cp 01fh
	jr nz,l483ah
	call GetLexem
l481fh:
	ld de,00009h
	call IdentToSymtab
	ld (hl),003h
	inc hl	
	call GetLexem
	ld de,07806h
	call ChkLexem_GetLex
	call sub_4af1h
	call ChkSemi_GetLex
	or a	
	jr z,l481fh
l483ah:
	ld hl,sub_4af1h
	ld (CallDest_04da2+1),hl
	ld d,a	
	ld a,(BlockLevel__)
	or a	
	ld hl,0fffch
	jr nz,l4865h
	ld hl,(binMoveDistance__)
	ld a,h	
	or l	
	ld hl,CSq_Init
	call nz,WCode
	ld hl,CSq_InitJRTErr
	call WCode
	call WrJump
	dec hl	
	ld (l2b8dh),hl
	ld hl,(memEnd)
l4865h:
	ld a,d	
	ld (l2b61h),hl
	cp 00ah
	jr nz,l4879h
	call GetLexem
FoundIdent:
	call ParseVar
	call ChkSemi_GetLex
	or a	
	jr z,FoundIdent
l4879h:
	ld hl,(l2b61h)
	push hl	
	ld hl,BlockLevel__
	inc (hl)	
ParseBlock__:
	cp 004h
	jr z,ParsePrc
	cp 005h
	jp nz,ParseFnc
ParsePrc:
	push af	
	call GetLexem
	or a	
	ld e,004h
	call nz,CompileErr
	ld hl,(SymTabAddr__)
	call SearchInSymTab__
	jp c,l49ddh
l489dh:
	xor a	
	ld de,0000ah
	call IdentToSymtab
	pop af	
	ld (hl),a	
	inc hl	
	inc hl	
	inc hl	
	ex de,hl	
	call GetTargetAddrInHL__
	ex de,hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	ld a,(BlockLevel__)
	dec a	
	ld (hl),a	
	ex de,hl	
	call WrJump
	ld hl,(TopOfHeapAddr__)
	push hl	
	call GetLexem
	cp 0a8h
	jp nz,l4a1eh
	ld hl,00000h
	ld (l2b61h),hl
	ld hl,l4d5fh
	ld (CallDest_04da2+1),hl
l48d3h:
	call GetLexem
	cp 00ah
	jr z,l48dfh
	call ParseVar
	jr l48eeh
l48dfh:
	ld d,00ah
	call GetLexem
	call sub_4d77h
	ld bc,00002h
	dec hl	
	call sub_4dc5h
l48eeh:
	cp 0bbh
	jr z,l48d3h
	call ChkCloBra_GetLex
	pop bc	
	push af	
	push bc	
	ld hl,(SymTabAddr__)
	push hl	
	ld hl,(TopOfHeapAddr__)
	dec hl	
	dec hl	
	ld b,(hl)	
	dec hl	
	ld c,(hl)	
	ex de,hl	
	ld hl,00002h
	xor a	
	sbc hl,bc
	ld (l2b67h),hl
l490eh:
	add hl,bc	
	ex de,hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	pop hl	
	pop bc	
	inc a	
	or a	
	sbc hl,bc
	add hl,bc	
	push bc	
	jr z,l492dh
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	push de	
	dec hl	
	dec hl	
	dec hl	
	ld b,(hl)	
	dec hl	
	ld c,(hl)	
	ex de,hl	
	ld hl,(l2b67h)
	jr l490eh
l492dh:
	ld l,c	
	ld h,b	
	dec hl	
	ld de,(l2b67h)
	ld (hl),d	
	dec hl	
	ld (hl),e	
	dec hl	
	ld (hl),a	
	ld bc,0fff9h
	add hl,bc	
	ld a,(hl)	
	cp 004h
	pop bc	
	jp z,l49d8h
	pop af	
	push bc	
	push hl	
	ld de,0ba16h
	call ChkLexem_GetLex
	or a	
	ld e,029h
	call nz,CompileErr
	call GetIdentInfoInABC
	cp 003h
	ld e,01eh
	call nz,CompileErr
	ld a,b	
	or a	
	ld e,02eh
	call nz,CompileErr
	ex de,hl	
	dec de	
	dec de	
	pop hl	
	inc hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	call GetLexem
l496fh:
	call ChkSemi_GetLex
	cp 01dh
	jr nz,l4988h
	pop hl	
	dec hl	
	dec hl	
	dec hl	
	call sub_4a2bh
	ld (hl),001h
	call GetLexem
l4982h:
	call ChkSemi_GetLex
	jp ParseBlock__
l4988h:
	ld hl,(labelListAddr)
	push hl	
	ld hl,(SymTabAddr__)
	push hl	
	ld hl,(TopOfHeapAddr__)
	push hl	
	call sub_4781h
	pop hl	
	ld (TopOfHeapAddr__),hl
	pop hl	
	ld (SymTabAddr__),hl
	pop hl	
	ld (labelListAddr),hl
	ld c,a	
	ld de,(l2b61h)
	xor a	
	ld l,a	
	ld h,a	
	sbc hl,de
	call sub_4037h
	call JCodeNextByte
	defb 0ddh
	call JCodeNextByte
	defb 0e1h
	call JCodeNextByte
	defb 0d1h
	pop hl	
	dec hl	
	ld d,(hl)	
	dec hl	
	ld e,(hl)	
	dec hl	
	push hl	
	ex de,hl	
	call sub_4037h
	ld a,c	
	call JCodeNextByte
	defb 0ebh
	call JCodeNextByte
	defb 0e9h
	pop hl	
	call sub_4a2bh
	ld (hl),000h
	jr l4982h
l49d8h:
	pop af	
	push bc	
	jp l496fh
l49ddh:
	ld d,(hl)	
	pop af	
	push af	
	cp d	
	jp nz,l489dh
	pop af	
	inc hl	
l49e6h:
	inc hl	
	inc hl	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	push hl	
	call GetTargetAddrInHL__
	ex de,hl	
	inc hl	
	call WrDE_ByTargAddr
	pop hl	
	ld (hl),d	
	dec hl	
	ld (hl),e	
	ex de,hl	
	call WrJump
	ex de,hl	
	ld de,00004h
	add hl,de	
	ld a,(hl)	
	add hl,de	
	dec hl	
	push hl	
	or a	
	jr z,l4a15h
	inc hl	
	inc hl	
	ld b,a	
	ld e,00bh
l4a0dh:
	set 6,(hl)
	call sub_4d6dh
	add hl,de	
	djnz l4a0dh
l4a15h:
	call GetLexem
	call ChkSemi_GetLex
	jp l4988h
l4a1eh:
	ld hl,00002h
	ld (l2b67h),hl
	pop bc	
	push af	
	push bc	
	xor a	
	jp l492dh
sub_4a2bh:
	ld b,(hl)	
	dec hl	
	inc b	
	dec b	
	ret z	
	push hl	
	ld de,00006h
	add hl,de	
	ld e,00bh
l4a37h:
	res 6,(hl)
	call sub_4d6dh
	add hl,de	
	djnz l4a37h
	pop hl	
	ret	
ParseFnc:
	ld hl,BlockLevel__
	dec (hl)	
	jr z,WCorrAddr
	ld hl,0000ah
	add hl,sp	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ld hl,0fff9h
	add hl,de	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	ex de,hl	
	call GetTargetAddrInHL__
	ex de,hl	
	ld (hl),d	
	dec hl	
	ld (hl),e	
	ld h,b	
	ld l,c	
	inc hl	
	call WrDE_ByTargAddr
	call WCaBreak_IfCoCo_C
	ld hl,CSq_IXisSPpl4
	call WCode
	pop bc	
	ld hl,00004h
	add hl,bc	
	ld (l2b61h),hl
	ld c,a	
	bit 3,(ix+000h)
	jr nz,l4a98h
	ld a,h	
	inc a	
	jr nz,l4a98h
	ld a,l	
	neg
	cp 006h
	jr nc,l4a98h
	srl a
	jr nc,l4a8fh
	call JCodeNextByte
	defb 03bh
	or a	
l4a8fh:
	jr z,l4aafh
	call JCodeNextByte
	defb 0e5h
	dec a	
	jr l4a8fh
l4a98h:
	call WLdHLnnIsHL
	call JCodeNextByte
	defb 039h
	call JCodeNextByte
	defb 0f9h
	bit 3,(ix+000h)
	jr z,l4aafh
	ld hl,CSq_l4ae8h
	call WCode
l4aafh:
	ld a,c	
ChkBegin:
	ld de,01819h
	call ChkLexem_GetLex
	jp l3cd4h
WCorrAddr:
	pop bc	
	call GetTargetAddrInHL__
	ex de,hl	
	ld hl,(l2b8dh)
	call WrDE_ByTargAddr_pl1
	ld hl,CSq_LdMemHL_LdIX
	call WCode
	ld d,b	
	ld e,c	
	call StoreDE
	call JCodeNextByte
	defb 0ddh
	call JCodeNextByte
	defb 0f9h
	jr ChkBegin
CSq_LdMemHL_LdIX:
	defb 005h
	ld (l178bh),hl
	defb 0ddh,021h
CSq_IXisSPpl4:
	defb 008h
	push ix
	ld ix,00004h
	add ix,sp
CSq_l4ae8h:
	defb 008h
	ld de,(l178bh)
	add hl,de	
	call nc,PrRAM
sub_4af1h:
	cp 023h
	call z,GetLexem
	cp 01ch
	jr z,l4b4eh
	cp 01eh
	jp z,l4bf8h
	cp 0deh
	jr z,l4b3ah
	cp 01bh
	jp nz,l4ca7h
	call NextChkOF_GetLex
	call l4ca7h
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	call ChkScalar
	inc (hl)	
	inc hl	
	inc hl	
	ld b,(hl)	
	inc hl	
	inc hl	
	dec c	
	jr z,l4b2ah
	srl b
	srl b
	srl b
	inc b	
l4b24h:
	inc hl	
	ld (hl),b	
	inc hl	
	ld (hl),000h
	ret	
l4b2ah:
	dec b	
	inc b	
	ld e,028h
	call nz,CompileErr
	dec (hl)	
	inc (hl)	
	call nz,CompileErr
	ld b,020h
	jr l4b24h
l4b3ah:
	call GetLexem
	call l4d5fh
	inc hl	
	set 7,(hl)
	ld c,002h
	ld de,00005h
	add hl,de	
	ld (hl),c	
	inc hl	
	ld (hl),000h
	ret	
l4b4eh:
	call GetLexem
	ld de,0db22h
	call ChkLexem_GetLex
sub_4b57h:
	ld de,(TopOfHeapAddr__)
	ld (hl),e	
	inc hl	
	ld (hl),d	
	push de	
	push hl	
	ex de,hl	
	call l4ca7h
	inc hl	
	ld c,a	
	ld a,(hl)	
	or a	
	ld a,c	
	ld e,024h
	call nz,CompileErr
	inc hl	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
	push hl	
	push de	
	ld de,00008h
	add hl,de	
	ld (TopOfHeapAddr__),hl
	pop hl	
	sbc hl,bc
	inc hl	
	ex (sp),hl	
	push hl	
	cp 0ddh
	jr z,l4be9h
	cp 0ach
	jr nz,l4bf1h
	call GetLexem
	call sub_4b57h
l4b94h:
	pop hl	
	ld de,00006h
	add hl,de	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	pop hl	
	push af	
	call Mul8x8
	pop af	
	ld e,035h
	call c,CompileErr
	ex de,hl	
	pop hl	
	inc hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	inc hl	
	inc hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	ex (sp),hl	
	push hl	
	ld de,l4c9ch
	ld bc,00004h
	push af	
l4bbch:
	ld a,(de)	
	inc de	
	cpi
	jr nz,l4be5h
	jp pe,l4bbch
	ld a,(hl)	
	ex af,af'	
	inc hl	
	ld bc,00007h
l4bcbh:
	ld a,(de)	
	inc de	
	cpi
	jr nz,l4be5h
	jp pe,l4bcbh
	ex af,af'	
	ld c,a	
	pop af	
	pop hl	
	ld (TopOfHeapAddr__),hl
	pop hl	
	ld de,0fffah
	add hl,de	
	ld (hl),002h
	dec hl	
	ld (hl),c	
	ret	
l4be5h:
	pop af	
	pop hl	
	pop hl	
	ret	
l4be9h:
	call NextChkOF_GetLex
l4bech:
	call sub_4af1h
	jr l4b94h
l4bf1h:
	ld e,026h
	call CompileErr
	jr l4bech
l4bf8h:
	ld de,(TopOfHeapAddr__)
	inc de	
	inc de	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	push hl	
	ld hl,sub_4af1h
	ld (CallDest_04da2+1),hl
	ld hl,00000h
	ld (l2b63h),hl
	call sub_4c27h
	ld de,01036h
	call ChkLexem_GetLex
	ld de,(l2b63h)
	pop hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	inc hl	
	inc hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	ret	
sub_4c27h:
	call GetLexem
l4c2ah:
	call sub_4c4ah
	ld de,0000ah
	add hl,de	
	ld (hl),000h
	inc hl	
	ld (hl),000h
l4c36h:
	cp 0bbh
	ret nz	
	call GetLexem
	or a	
	jr nz,l4c36h
	ld de,(TopOfHeapAddr__)
	inc de	
	inc de	
	ld (hl),d	
	dec hl	
	ld (hl),e	
	jr l4c2ah
sub_4c4ah:
	ld hl,(l2b63h)
	push hl	
	ld d,00fh
	ld hl,0000dh
	call sub_4d7ah
	ex (sp),hl	
	ld (l2b63h),hl
	pop hl	
	ld b,(hl)	
	dec hl	
	ld c,(hl)	
	push de	
l4c5fh:
	ld de,(l2b63h)
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	ex de,hl	
	add hl,bc	
	ld (l2b63h),hl
	ex de,hl	
	ld (hl),000h
	inc hl	
	ld (hl),000h
	inc hl	
	ld e,l	
	ld d,h	
	inc de	
	inc de	
	inc de	
	inc de	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	ld de,0fff5h
	add hl,de	
	pop de	
	or a	
	sbc hl,de
	add hl,de	
	ret z	
	push de	
	ld de,0000eh
	add hl,de	
	push bc	
	call sub_4d6dh
	ex de,hl	
	ld hl,(l2b7eh)
	ld bc,00006h
	ldir
	pop bc	
	ex de,hl	
	jr l4c5fh
l4c9ch:
	defb 001h
	defb 000h
	defb 001h
	defb 000h
	defb 000h
	defb 003h
	defb 000h
	defb 000h
	defb 0ffh
	defb 0ffh
	defb 0ffh
l4ca7h:
	push hl	
	or a	
	jr z,l4cefh
	cp 0a8h
	jr z,l4d13h
	push hl	
	call ParseConstVal
	pop de	
	ex de,hl	
l4cb5h:
	call ChkScalar
	ld (hl),c	
	inc hl	
	ld (hl),b	
	inc hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	inc hl	
	push hl	
	push de	
	ld de,0ae25h
	call ChkLexem_GetLex
	call ChkLexem_GetLex
	push bc	
	call ParseConstVal
	pop de	
	call ChkType__
	pop de	
	or a	
	sbc hl,de
	add hl,de	
	ld e,027h
	call m,CompileErr
	ex de,hl	
	pop hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
l4ce2h:
	inc hl	
	dec c	
	ld bc,00002h
	jr z,l4ceah
	dec c	
l4ceah:
	ld (hl),c	
	inc hl	
	ld (hl),b	
	pop hl	
	ret	
l4cefh:
	call GetIdentInfoInABC
	dec a	
	jr z,l4d09h
l4cf5h:
	cp 002h
	ld e,01eh
	call nz,CompileErr
	dec hl	
	dec hl	
	pop de	
	push de	
	ld bc,00008h
	ldir
	pop hl	
	jp GetLexem
l4d09h:
	call GetLexem
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	pop hl	
	push hl	
	jr l4cb5h
l4d13h:
	xor a	
	ld (l2b80h),a
	ld hl,l2b74h
	ld c,(hl)	
	inc (hl)	
	ld b,000h
l4d1eh:
	call GetLexem
	push bc	
	ld de,00005h
	call IdentToSymtab
	pop bc	
	ld (hl),001h
	inc hl	
	ld (hl),c	
	inc hl	
	ld (hl),b	
	inc hl	
	ld a,(l2b80h)
	ld (hl),a	
	inc a	
	ld (l2b80h),a
	inc hl	
	push hl	
	call GetLexem
	cp 0ach
	jr z,l4d1eh
	call ChkCloBra_GetLex
	ld d,a	
	ld a,(l2b80h)
	ld b,a	
	dec a	
l4d4ah:
	pop hl	
	ld (hl),a	
	djnz l4d4ah
	pop hl	
	push hl	
	ld (hl),c	
	inc hl	
	ld (hl),b	
	inc hl	
	ld (hl),000h
	inc hl	
	ld (hl),a	
	inc hl	
	ld (hl),a	
	inc hl	
	ld (hl),a	
	ld a,d	
	jr l4ce2h
l4d5fh:
	push hl	
	or a	
	ld e,02ch
	call nz,CompileErr
	call GetIdentInfoInABC
	dec a	
	jp l4cf5h
sub_4d6dh:
	ld c,a	
l4d6eh:
	ld a,(hl)	
	inc hl	
	or a	
	jp p,l4d6eh
	ld a,c	
	inc hl	
	ret	
sub_4d77h:
	ld hl,0000ah
sub_4d7ah:
	push de	
	ex de,hl	
	ld hl,(TopOfHeapAddr__)
	inc hl	
	inc hl	
	ex (sp),hl	
	push hl	
l4d83h:
	push de	
	call IdentToSymtab
	pop de	
	pop af	
	push af	
	ld (hl),a	
	call GetLexem
	cp 0bah
	jr z,l4d99h
	push de	
	call ChkComma_GetLex
	pop de	
	jr l4d83h
l4d99h:
	pop af	
	call GetLexem
	inc hl	
	pop de	
	push hl	
	push de	
CallDest_04da2:
	call sub_4af1h
	pop hl	
	call sub_4d6dh
	ld (l2b7eh),hl
	ex de,hl	
	pop hl	
	push hl	
	ld bc,00008h
	ldir
	ex de,hl	
	ld c,a	
	ld a,(BlockLevel__)
	ld (hl),a	
	ld a,c	
	dec hl	
	pop de	
	ret	
ParseVar:
	ld d,002h
	call sub_4d77h
	ld b,(hl)	
	dec hl	
	ld c,(hl)	
sub_4dc5h:
	push de	
	ex de,hl	
l4dc7h:
	ld hl,(l2b61h)
	or a	
	sbc hl,bc
	ld (l2b61h),hl
	ex de,hl	
	ld (hl),e	
	inc hl	
	ld (hl),d	
	ld de,0fff9h
	add hl,de	
	pop de	
	or a	
	sbc hl,de
	add hl,de	
	ret z	
	push de	
	ld de,0000bh
	add hl,de	
	push bc	
	call sub_4d6dh
	ex de,hl	
	ld hl,(l2b7eh)
	ld bc,00009h
	ldir
	dec de	
	dec de	
	dec de	
	pop bc	
	jr l4dc7h
sub_4df6h:
	ld e,03ah
	jp CompileErr
l4dfbh:
	ld de,00007h
	add hl,de	
	ld d,(hl)	
	dec hl	
	ld e,(hl)	
	ld a,d	
	or e	
	call z,sub_4df6h
	push hl	
	call WLdHLfromMemIsDE
	call JCodeNextByte
	defb 0e5h
	pop hl	
	dec hl	
	dec hl	
	jr l4e31h
l4e14h:
	cp 0aeh
	jp nz,l4f70h
	pop hl	
	call GetLexem
	or a	
	ld e,037h
	call nz,CompileErr
	call GetIdentInfoInABC
	ld e,037h
	cp 00fh
	call nz,CompileErr
	ld de,00004h
	add hl,de	
l4e31h:
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ld bc,0fff9h
	add hl,bc	
	push hl	
	bit 1,(ix+001h)
	jr z,l4e4bh
	call sub_41bfh
	exx	
	inc hl	
	exx	
	add hl,de	
	call WLdHLnnIsHL
	jr l4e52h
l4e4bh:
	exx	
	dec hl	
	exx	
	ex de,hl	
	call sub_418eh
l4e52h:
	call JCodeNextByte
	defb 0e5h
	pop hl	
	call GetLexem
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
l4e5eh:
	call sub_5045h
l4e61h:
	bit 7,b
	jr nz,l4e70h
	ld e,a	
	ld d,000h
	ld a,b	
	cp 002h
	ld a,e	
	ret c	
	push bc	
	jr l4ec4h
l4e70h:
	push bc	
	push hl	
	ld d,(ix+001h)
	push de	
	ld d,000h
	ld c,001h
	jp l500dh
sub_4e7dh:
	res 1,(ix+001h)
	cp 002h
	jr z,l4e92h
	cp 00ah
	jp z,l4fe1h
	cp 00fh
	jp z,l4dfbh
	jp CompileErr
l4e92h:
	call sub_5045h
	ld a,b	
	or a	
	jp z,l4fa5h
	dec a	
	push bc	
	jp z,l4fd0h
	bit 7,b
	jp nz,l4fffh
	call sub_34fah
	jr z,l4eb6h
	sub b	
	jr z,l4eb1h
	call WSelListEl_byA
	jr l4ebdh
l4eb1h:
	call WAddConstHLIX
	jr l4ebdh
l4eb6h:
	call WLdHLnnIsDE
	set 1,(ix+001h)
l4ebdh:
	call JCodeNextByte
	defb 0e5h
	call GetLexem
l4ec4h:
	pop hl	
	push hl	
	ld d,a	
	ld a,h	
	cp 002h
	jr z,l4ecfh
	inc hl	
	ld a,(hl)	
	or a	
l4ecfh:
	ld a,d	
	jp nz,l4e14h
	cp 0dbh
	jp nz,l4f70h
l4ed8h:
	pop hl	
	ld a,h	
	cp 002h
	jp z,l4f74h
	call GetLexem
l4ee2h:
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
	push hl	
	ld d,(ix+001h)
	push de	
	call sub_3f13h
	res 3,(ix+002h)
	pop de	
	res 1,d
	ld (ix+001h),d
	dec c	
	jr z,l4f01h
	ld hl,CSq_l4379h
	call WCodeOverLastByte
l4f01h:
	exx	
	dec hl	
	exx	
	pop hl	
	push af	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
	push hl	
	xor a	
	cp c	
	push af	
	jr z,l4f11h
	ld d,a	
l4f11h:
	xor a	
	push de	
	ld h,a	
	ld l,a	
	sbc hl,de
	call sub_418eh
	pop de	
	pop af	
	pop hl	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
	jr z,l4f24h
	ld b,a	
l4f24h:
	bit 5,(ix+000h)
	jr z,l4f44h
	push hl	
	ld hl,CSq_l524eh
	push de	
	call WCode
	ld h,b	
	ld l,c	
	pop bc	
	or a	
	sbc hl,bc
	ex de,hl	
	inc de	
	call WLdDEnnIsDE
	ld hl,CSq_l5254h
	call WCode
	pop hl	
l4f44h:
	ld bc,00006h
	add hl,bc	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ld bc,0fff9h
	add hl,bc	
	push hl	
	ld hl,l5246h
	call sub_4295h
	ld hl,CSq_l524ah
	call WCode
	pop hl	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
	pop af	
	cp 0ach
	jr z,l4f6ch
	call ChkCloSqBra_GetLex
	jp l4e5eh
l4f6ch:
	push bc	
	jp l4ed8h
l4f70h:
	pop bc	
	ld d,000h
	ret	
l4f74h:
	push hl	
	call sub_3f0dh
	exx	
	dec hl	
	exx	
	call JCodeNextByte
	defb 02bh
	pop bc	
	bit 5,(ix+000h)
	jr z,l4f96h
	ld hl,CSq_l525ch
	call WCode
	ld e,c	
	call l381ah
	ld hl,CSq_l5267h
	call WCode
l4f96h:
	ld hl,CSq_l524ah
	call WCode
	call ChkCloSqBra_GetLex
	ld d,000h
	ld bc,00003h
	ret	
l4fa5h:
	call sub_34fah
	jr z,l4fcah
sub_4faah:
	sub b	
	ld b,000h
	jr z,l4fbah
l4fafh:
	call WSelListEl_byA
l4fb2h:
	ld d,000h
	call JCodeNextByte
	defb 0e5h
	jr l4fc2h
l4fbah:
	call sub_3526h
	jr nc,l4fc5h
	ld h,002h
l4fc1h:
	ex de,hl	
l4fc2h:
	jp GetLexem
l4fc5h:
	call WAddConstHLIX
	jr l4fb2h
l4fcah:
	ld b,000h
	ld h,001h
	jr l4fc1h
l4fd0h:
	call sub_34fah
	jr z,l4fdbh
	sub b	
	pop bc	
	jr z,l4fc5h
	jr l4fafh
l4fdbh:
	call WLdHLnnIsDE
	pop bc	
	jr l4fb2h
l4fe1h:
	push bc	
	call sub_5045h
	push hl	
	ld d,(ix+001h)
	push de	
	ld c,001h
	res 0,(ix+001h)
	call l4fa5h
	call sub_457dh
	pop de	
	ld (ix+001h),d
	pop hl	
	pop bc	
l4ffch:
	jp l4e61h
l4fffh:
	push hl	
	ld d,(ix+001h)
	push de	
	ld c,001h
	res 0,(ix+001h)
	call l4fa5h
l500dh:
	cp 0deh
	jr nz,l5021h
	call sub_457dh
	pop de	
	ld (ix+001h),d
	pop hl	
	pop bc	
	call GetLexem
	res 7,b
	jr l4ffch
l5021h:
	pop bc	
	pop bc	
	pop bc	
	ret	
	ld e,041h
sub_5027h:
	or a	
	jp nz,CompileErr
	push de	
	call GetIdentInfoInABC
	pop de	
	call sub_4e7dh
	dec d	
	ret m	
	ex de,hl	
	jr z,l5040h
	call WAddConstHLIX
l503bh:
	call JCodeNextByte
	defb 0e5h
	ret	
l5040h:
	call WLdHLnnIsDE
	jr l503bh
sub_5045h:
	push bc	
	res 7,b
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	dec hl	
	dec b	
	jr z,l505dh
	ld (Merker1),de
	inc b	
	pop bc	
	ret nz	
	ld e,a	
	ld a,d	
	ld (l2b8bh+1),a
	ld a,e	
	ret	
l505dh:
	inc b	
	ld (l2b89h),bc
	pop bc	
	ld e,a	
	ld a,d	
	dec c	
	jr nz,l506ah
	ld a,0ffh
l506ah:
	inc c	
	srl a
	srl a
	srl a
	ld (l2b8bh),a
	ld a,e	
	ret	
l5076h:
	ld hl,l508eh
	jr l507eh
l507bh:
	ld hl,CSq_l5096h
l507eh:
	push hl	
	call NextChkOpBra_GetLex
	ld e,045h
	call sub_5027h
	call ChkCloBra_GetLex
	pop hl	
	jp WCodeOverLastByte
l508eh:
	rlca	
	ld de,(l178bh)
	ld (hl),e	
	inc hl	
	ld (hl),d	
CSq_l5096h:
	defb 007h
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ld (l178bh),de
l509eh:
	call NextChkOpBra_GetLex
	ld e,045h
	call sub_5027h
	bit 7,b
	ld e,045h
	jp z,CompileErr
	res 7,b
	call sub_50c9h
	call JCodeNextByte
	defb 001h
	or a	
	ld hl,00000h
	sbc hl,de
	ex de,hl	
	call StoreDE
	ld hl,CSq_l5242h
	call WCode
	jp ChkCloBra_GetLex
sub_50c9h:
	exx	
	dec hl	
	exx	
	ld d,a	
	ld a,b	
	dec b	
	jr z,l50dah
	inc b	
	ld a,d	
	jr z,l50e3h
	ld de,(Merker1)
	ret	
l50dah:
	ld a,d	
	ld de,(l2b8bh)
	ld d,000h
	inc e	
	ret	
l50e3h:
	ld de,00002h
	dec c	
	ret z	
	dec e	
	dec c	
	ret nz	
	ld e,004h
	ret	
l50eeh:
	call sub_5105h
	ld hl,CSq_l5235h
l50f4h:
	call WCodeOverLastByte
	jp ChkCloBra_GetLex
l50fah:
	call sub_5105h
	call sub_510eh
	ld hl,l523ah
	jr l50f4h
sub_5105h:
	call NextChkOpBra_GetLex
	ld bc,00208h
	call sub_3f29h
sub_510eh:
	call ChkComma_GetLex
	jp sub_3f10h
sub_5114h:
	call NextChkOpBra_GetLex
	call sub_3f10h
	jr l5130h
sub_511ch:
	call NextChkOpBra_GetLex
	call sub_3f10h
	jr l512dh
sub_5124h:
	call NextChkOpBra_GetLex
	call sub_3f10h
	call sub_510eh
l512dh:
	call sub_510eh
l5130h:
	call sub_510eh
	jp ChkCloBra_GetLex
l5136h:
	call sub_5114h
	ld hl,CSq_l513fh
	jp WCodeOverLastByte
CSq_l513fh:
	defb 00ah
	ld (l178fh),hl
	pop hl	
	ld (l178dh),hl
	call sub_04e6h
PaSetsys:
	call sub_5114h
	ld hl,CSq_l5153h
	jp WCodeOverLastByte
CSq_l5153h:
	defb 007h
	ld (l178dh),hl
	pop hl	
	call sub_0655h
l515bh:
	inc b	
	call sub_066ah
	push hl	
l5160h:
	call sub_5114h
	ld hl,CSq_l5169h
	jp WCodeOverLastByte
CSq_l5169h:
	defb 00ah
	ld (l178fh),hl
	pop hl	
	ld (l178dh),hl
	call sub_0502h
l5174h:
	call sub_5114h
	ld hl,CSq_l517dh
	jp WCodeOverLastByte
CSq_l517dh:
	defb 00ah
	ld (l178fh),hl
	pop hl	
	ld (l178dh),hl
	call sub_0527h
l5188h:
	dec bc	
	ld (l178fh),hl
	pop hl	
	ld (l178dh),hl
	call sub_0590h
	push af	
l5194h:
	dec bc	
	ld (l178fh),hl
	pop hl	
	ld (l178dh),hl
	call sub_0553h
	push hl	
l51a0h:
	call sub_5114h
	ld hl,CSq_l51a9h
	jp WCodeOverLastByte
CSq_l51a9h:
	defb 00ah
	ld (l178fh),hl
	pop hl	
	ld (l178dh),hl
	call sub_05c7h
l51b4h:
	call sub_5124h
	ld hl,CSq_l51bdh
	jp WCodeOverLastByte
CSq_l51bdh:
	defb 012h
	ld (l1793h),hl
	pop hl	
	ld (l1791h),hl
	pop hl	
	ld (l178fh),hl
	pop hl	
	ld (l178dh),hl
	call sub_05ebh
l51d0h:
	call sub_511ch
	ld hl,CSq_l51d9h
	jp WCodeOverLastByte
CSq_l51d9h:
	defb 00eh
	ld (l1791h),hl
	pop hl	
	ld (l178fh),hl
	pop hl	
	ld (l178dh),hl
	call sub_0623h
l51e8h:
	inc b	
	call GetKey
	push af	
l51edh:
	add hl,bc	
	ex de,hl	
	pop hl	
	ld a,l	
	and e	
	ld l,a	
	ld a,h	
	and d	
	ld h,a	
	push hl	
l51f7h:
	add hl,bc	
	ex de,hl	
	pop hl	
	ld a,l	
	or e	
	ld l,a	
	ld a,h	
	or d	
	ld h,a	
	push hl	
l5201h:
	add hl,bc	
	ex de,hl	
	pop hl	
	ld a,l	
	xor e	
	ld l,a	
	ld a,h	
	xor d	
	ld h,a	
	push hl	
l520bh:
	inc b	
	ld l,h	
	ld h,000h
	push hl	
l5210h:
	inc bc	
	ld h,000h
	push hl	
l5214h:
	inc b	
	ld a,h	
	ld h,l	
	ld l,a	
	push hl	
l5219h:
	dec c	
	ld a,l	
	pop hl	
	or a	
	jr z,l5226h
	ld b,a	
l5220h:
	srl h
	rr l
	djnz l5220h
l5226h:
	push hl	
l5227h:
	dec c	
	ld a,l	
	pop hl	
	or a	
	jr z,l5234h
	ld b,a	
l522eh:
	sla l
	rl h
	djnz l522eh
l5234h:
	push hl	
CSq_l5235h:
	defb 004h
	pop de	
	call LoadSrcFile
l523ah:
	rlca	
	ld c,l	
	ld b,h	
	pop hl	
	pop de	
	call SaveSrcFile
CSq_l5242h:
	defb 003h
	call sub_0c87h
l5246h:
	inc bc	
	call Mul8x8
CSq_l524ah:
	defb 003h
	pop de	
	add hl,de	
	push hl	
CSq_l524eh:
	defb 005h
	bit 7,h
	call nz,ErrIdxLow
CSq_l5254h:
	defb 007h
	or a	
	sbc hl,de
	add hl,de	
	call p,ErrIdxHigh
CSq_l525ch:
	defb 00ah
	ld a,h	
	or a	
	call m,ErrIdxLow
	call nz,ErrIdxHigh
	ld a,l	
	defb 0feh
CSq_l5267h:
	defb 003h
	call nc,ErrIdxHigh
l526bh:
	call NextChkOpBra_GetLex
	ld e,03fh
	call sub_5027h
	call sub_50c9h
	call WLdHLnnIsDE
	call JCodeNextByte
	defb 0e5h
	jr l5287h
l527fh:
	call NextChkOpBra_GetLex
	ld e,046h
	call sub_5027h
l5287h:
	ld bc,00001h
	call ChkCloBra_GetLex
	jp l45a0h
l5290h:
	call NextChkOpBra_GetLex
	call sub_3f10h
	call ChkComma_GetLex
	ld bc,00003h
	call sub_3f13h
	call ChkCloBra_GetLex
	ld hl,CSq_l52a8h
	jp WCodeOverLastByte
CSq_l52a8h:
	defb 003h
	pop bc	
	out (c),a
l52ach:
	dec b	
	ld c,l	
l52aeh:
	ld b,h	
	in a,(c)
	push af	
l52b2h:
	add hl,bc	
	call KbdStat
	or a	
	jr z,l52bbh
	ld a,001h
l52bbh:
	push af	
l52bch:
	inc bc	
	call sub_0c25h
l52c0h:
	inc b	
	ld a,l	
	and 001h
	push af	
l52c5h:
	inc b	
	call sub_0e8fh
	push hl	
l52cah:
	inc bc	
	call PrHalt
l52ceh:
	ld (bc),a	
	ld a,l	
	push af	
l52d1h:
	inc b	
	call IsEOL
	push af	
l52d6h:
	dec b	
	ld a,00ch
	call OutChr
l52dch:
	ld b,05dh
	ld d,h	
	call Mul16x8sgn
	push hl	
l52e3h:
	inc b	
	call AbsHL
	push hl	
l52e8h:
	dec b	
	call RealSqrt__
	push hl	
	push de	
l52eeh:
	inc b	
	res 7,h
	push hl	
	push de	
StartPASSrc:
	defs 13

PasEx:
	ld hl,00000h
	ld b,080h
PXSrchProlog:
	ld a,(hl)	
	cp 07fh
	inc hl	
	jr z,PXKillProlog
	djnz PXSrchProlog
	jr PXCpChrMap
PXKillProlog:
	ld (hl),000h
PXCpChrMap:
	ld hl,(CCTL0)
	ld de,0ba00h
	ld bc,00200h
	ldir
	ld hl,PXUSASC
	ld de,0bbd8h
	ld bc,00018h
	ldir
	ld hl,PXBASCI
	ld de,PXSASCI
	ld bc,PXTAPE-PXSASCI
	ldir
	ld a,07fh
	ld (PXSASCI),a
	ld (PXSASCI+1),a
	ld bc,0fc80h
	in a,(c)
	cp 0a7h
	jp nz,PXASCI
	ld bc,SUBNEU-PXTAPE
	ldir
	ld a,07fh
	ld (PXTAPE),a
	ld (PXTAPE+1),a
	ld (PXDISK),a
	ld (PXDISK+1),a
	ld hl,(SUTAB)
	ld (SUBALT),hl
	ld de,SUBNEU
	ld (SUTAB),de
	ld bc,00092h
	ldir
	ld hl,MBO
	ld (SUBNEU+2),hl
	ld hl,MBI
	ld (SUBNEU+10),hl
	ld hl,PXSTAB
	ld de,SUBNEU+16
	ld c,008h
	ldir
	jp PXASCI
PXSTAB:
	defw ISRO
	defw CSRO
	defw ISRI
	defw CSRI
PXUSASC:
	defb 07ch,060h,060h,060h,060h,060h,07ch,000h
	defb 0c0h,060h,030h,018h,00ch,006h,002h,000h
	defb 07ch,00ch,00ch,00ch,00ch,00ch,07ch,000h
PXBASCI:

	org  0bc00h

PXSASCI:
	defw 00000h
	defb 'ASCII'
	defb 001h
PXASCI:
	ld hl,0ba00h
	ld (CCTL0),hl
	ret	
PXTAPE:
	defw 00000h
	defb 'PASTAPE'
	defb 001h
	ld hl,(SUBALT)
PXSetSUTAB:
	ld (SUTAB),hl
	ret	
PXDISK:
	defw 00000h
	defb 'PASDISK'
	defb 001h
	ld hl,SUBNEU
	jr PXSetSUTAB
ISRO:
	ld (ix+002h),000h
	ld l,(ix+005h)
	ld h,(ix+006h)
	ld bc,083f3h
	ld e,00bh
PXSendName:
	outi
	inc b	
	inc b	
	dec e	
	jr nz,PXSendName
	ld d,00bh
PXNxtBlock:
	inc (ix+002h)
	ld h,(ix+006h)
	ld l,(ix+005h)
	ld bc,081f2h
	ld e,080h
PXSendBlock:
	outi
	inc b	
	inc b	
	dec e	
	jr nz,PXSendBlock
PXSendCtl:
	ld bc,080f3h
	out (c),d
PXWaitForReady:
	push bc	
	ld a,001h
	call PV1
	defb 014h
	pop bc	
	in a,(c)
	bit 0,a
	jr nz,PXWaitForReady
	and a	
	bit 7,a
	ret z	
	inc b	
	in a,(c)
	call PV1
	defb 01ch
	call PV1
	defb 019h
	scf	
	ret	
MBO:
	ld d,003h
	call PXNxtBlock
	ret c	
	ld a,002h
	cp (ix+002h)
	ret nc	
	call PV1
	defb 023h
	defb 008h,008h,008h,000h
	and a	
	ret	
CSRO:
	call MBO
	ret c	
	ld d,043h
	jr PXSendCtl
ISRI:
	ld (ix+002h),000h
	ld hl,fileName
	ld bc,083f3h
	ld de,0090bh
PXSendName2:
	outi
	inc b	
	inc b	
	dec e	
	jr nz,PXSendName2
PXRecvBlock:
	call PXSendCtl
	ret c	
	push hl	
	push af	
	ld l,(ix+005h)
	ld h,(ix+006h)
	ld bc,080f2h
	ld e,080h
PXRecvByte:
	ini
	inc b	
	inc b	
	dec e	
	jr nz,PXRecvByte
	inc (ix+002h)
	pop af	
	pop hl	
	ret	
MBI:
	push de	
	ld d,001h
	call PXRecvBlock
	pop de	
	ret c	
	ld a,002h
	cp (ix+002h)
	ret nc	
	call PV1
	defb 023h
	defb 008h,008h,008h,008h,000h
	and a	
	ret	
CSRI:
	call PV1
	defb 02ch
	ret	
SUBNEU:

; BLOCK 'Rest' (start 0x5490 end 0x5500)
Rest_first:
	defb 00dh,00ah,009h,043h,050h,009h,037h,046h ; ...CP.7F 
	defb 048h,009h,03bh,054h,065h,073h,074h,020h ; H.;Test  
	defb 050h,072h,06fh,06ch,06fh,067h,03fh,00dh ; Prolog?. 
	defb 00ah,009h,049h,04eh,043h,009h,048h,04ch ; ..INC.HL 
	defb 00dh,00ah,009h,04ah,052h,009h,05ah,02ch ; ...JR.Z, 
	defb 050h,041h,053h,030h,031h,00dh,00ah,009h ; PAS01... 
	defb 044h,04ah,04eh,05ah,009h,050h,041h,053h ; DJNZ.PAS 
	defb 030h,032h,00dh,00ah,009h,04ah,052h,009h ; 02...JR. 
	defb 050h,041h,053h,030h,033h,00dh,00ah,050h ; PAS03..P 
	defb 041h,053h,030h,031h,009h,04ch,044h,009h ; AS01.LD. 
	defb 04dh,02ch,030h,009h,03bh,06ch,07ch,073h ; M,0.;l|s 
	defb 063h,068h,065h,06eh,00dh,00ah,050h,041h ; chen..PA 
	defb 053h,030h,033h,009h,04ch,044h,009h,048h ; S03.LD.H 
	defb 04ch,02ch,028h,043h,043h,054h,04ch,030h ; L,(CCTL0 
