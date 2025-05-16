;;; PasEx Kernfunktionen
;;; werden ans Ende des freien Speichers zwischen DevEx und
;;; Sonderzeichen geladen

;;; ======================================================
;;; Adressen der Dateiroutinen setzen
;;; Parameter: HL = Dev[012]Adr
SetXAd:
	push de
	push bc
	ld de,(SUTAB)
	inc de
	inc de			; MBO = UP-Nr. 1
	ldi
	ldi
	ld bc,6
	ex de,hl
	add hl,bc		; MBI = UP-Nr. 5
	ex de,hl
	ldi
	ldi
	inc de
	inc de
	inc de
	inc de			; ISRO-CSRI = UP-Nr. 8-0bh
	ld bc,8
	ldir
	pop bc
	pop de
	ret

;;; ======================================================
;;; Device einschalten (weitestgehend von UDEVEX.INC abgeschrieben)
PasDev:
	db 0,07fh		; initial ausgeblendet
	defb "PASDEV",1
	;; einfach und unelegant SUTAB nach Reset wiederherstellen
	ld hl,(SutabR)		; Merkzelle zur Wiederherstellung nach Reset
	ld (SUTAB),hl
	;; jetzt das machen, was man erwarten wuerde
	ld a,(CAOS_ARGN)
	and a
;	jr nz,PDTstA		; min. 1 Argument
;	call PDStat
	jr z,PDStat		; kein Argument --> nur Info

PDTstA:
	ld a,(CAOS_ARG1)
	cp 3			; hart kodiert: nur 0, 1 und 2 zulaessig
	jr c,PDSet		; Wert ok -> weiter
	call PV1
	db OSTR
	defb "ERR: falsches Argument",0dh,0ah,0
	ret
PDSet:
	push hl
	push bc
	push af
	ld hl,Dev0Adr
	and a
	jr z,PDSetA
	ld bc,12		; 6 Adressen
	add hl,bc
	dec a
	jr z,PDSetA
	add hl,bc
PDSetA:
	call SetXAd
	pop af
	rlca
	rlca			; Arg. in Dev-Bit umwandeln
	ld c,a
	ld a,(ix+8)
	and 0e3h		; Device-Bits zuruecksetzen
	or c
	ld (ix+8),a
	pop bc
	pop hl
;	ret			; zum Schluss PDStat aurufen

PDStat:
	call PV1
	db OSTR
	defb "Dev ",0
	ld a,(ix+8)		; Device-Status ermitteln
	rrca
	rrca
	and 07h			; Device-Bits uebrig lassen
	call PV1
	db AHEX

	call PV1
	db OSTR
	defb " (0=Tape",0
	ld a,(Dev1Adr)		; wenn (Dev1Adr)=0 dann kein D004
	and a
	jr z,PDInfU
	call PV1
	db OSTR
	defb ", 1=Floppy",0
PDInfU:	ld a,(Dev2Adr)		; wenn (Dev2Adr)=0 dann kein M052
	and a
	jr z,PDInfE
	call PV1
	db OSTR
	defb ", 2=USB",0
PDInfE:	call PV1
	db OSTR
	defb ")",0dh,0ah,0

	ret
	
;;; ============================================================
;;; PasEx: IO-Routinen
PXISRO:
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
PXMBO:
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
PXCSRO:
	call PXMBO
	ret c	
	ld d,043h
	jr PXSendCtl
PXISRI:
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
PXMBI:
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
PXCSRI:
	call PV1
	defb 02ch
	ret	
