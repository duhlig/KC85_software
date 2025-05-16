;;; ======================================================
;;; Autostart

	;; SUTAB-Kopie wenn es bei CAOS <= 4.6 kein (passendes) M052 gibt
SutNDx:	equ 0ba00h
	
pre_init:
	;; CAOS-Versionskontrolle
	call PxCVer
	cp 046h			; Ab CAOS 4.6 werden...
	jr nc,pri_46		; UDevEx und PasEx nicht mehr gebraucht.

	ld hl,PasExB		; PasEx usw. hochladen
	ld de,PasExR
	ld bc,PasExL
	ldir
	ld a,07fh
	ld (PasDev),a		; Menueeintrag aktivieren

	ld de,Dev0Adr
	call FuellA
	xor a
	ld (Dev2Adr),a		; Init.: 0 = Geraet nicht vorhanden
	call DevEx

	;; SUTAB kopieren, wenn es kein M052 gibt
	;; sutab-adr < e000?
	ld a,(SUTAB+1)		; high-Byte reicht zum Test auf ROM
	cp 0dfh			; CAOS-ROM ab e000h
	jr c,pri_su
	;; dann kopieren
	ld hl,(SUTAB)
	ld de,SutNDx
	ld (SUTAB),de
	ld bc,00092h		; passt so, zieht nur fuer CAOS <= 4.6
	ldir
pri_su:	
	ld hl,(SUTAB)
	ld (SutabR),hl		; Merkzelle zur Wiederherstellung nach Reset

	call tstD4
	jr pri_ch
pri_46:	call PV1
	defb OSTR
	defb "Bitte CAOS-Devices statt PasEx benutzen.",0dh,0ah,0
pri_ch:	call PASCHR
	ret
	
PxCVer:
	ld a,(0e011h) ; ab KC 85/4 steht hier Menüwort „BASIC“ 
	cp 7fh	      ; KC 85/4 ?				 
	ld a,0	      ; KC 85/2 und KC 85/3 = Version 0.0	 
	ret nz	      					 
	ld a,(0edffh) ; CAOS-Versionsnummer                    
	ret

PxJpHl:	jp (hl)

;;; ======================================================
;;; DevEx

ED_Adr equ 0200h		; Adresse des "leeren" EDAS im RAM

DevEx:
	;; M052 mit aktuellem ROM wird vorausgesetzt
	;; Menuewort edas suchen
	ld hl,0c000h
	ld bc,02000h
	ld de,medas		; "edas" ruft DevEx-Init auf
	ld a,07fh		; CAOS-Menue-Prolog
	call PV1
	defb ZSUCH		; bei Erfolg: HL+1 = Startadr.
	jr c,rufEdas		; CY=1: gefunden
	call PV1
	defb OSTR
	defb 0dh,0ah,"kein M052 oder ROM zu alt",0dh,0ah,0
	ret

medas:	defb "edas",0
mEDASx:	defb 07fh,"EDAS",0,0c9h	; um DEVEX zu ueberreden

rufEdas:
	push hl
	;; Menuewort EDAS auf 0200h schreiben, um edas (UDEVEX) benutzen zu koennen
	ld hl,ED_Adr
	ld (hl),07fh
	inc hl
	ex de,hl
	ld hl,mEDASx
	ld bc,7
	ldir
	pop hl
	;; edas aufrufen
	inc hl
	call PxJpHl		; DevEx-Init aufrufen
	ld hl,ED_Adr	 	; ausnullen, EDAS-Menue-Eintrag wird nicht mehr gebraucht
	ld b,8
	xor a
loeEda:
	ld (hl),a
	inc hl
	djnz loeEda

	;; Menuewort USB suchen /*und sichtbar machen*/
	ld hl,0ba00h
	ld bc,00500h
	ld de,mUSB
	ld a,0ddh		; CAOS-Menue-Prolog
	call PV1
	defb ZSUCH		; bei Erfolg: HL+1 = Startadr.
	ret nc			; Fehlerbehandlung?

	inc hl			; Prozedurbeginn
;	push hl
;	ld de,4			; 4 = laenge(0ddh,'USB',1) - Carry
;	sbc hl,de
;	ld (hl),07fh
;	dec hl
;	ld (hl),07fh

	;; USB einschalten, dann steht SUDEV in SUTAB
	ld a,1
	ld (CAOS_ARGN),a
	ld (CAOS_ARG1),a 	; "USB 1" = USB ein
	call PxJpHl
	ld a,(ix+8)
	and 0e3h		; Device-Bits auf 0 setzen
	or 08h			; Device 2 eintragen
	ld (ix+8),a

	ld de,Dev2Adr		; Adr. der USB-Routinen merken
	call FuellA
	ret
	
mUSB:	defb "USB",0

;;; Adressen Dev0Adr, Dev1Adr oder Dev2Adr befüllen
;;; Parameter: DE = Zieladresse
FuellA:
	push hl
	push bc
	ld hl,(SUTAB)
	inc hl
	inc hl			; MBO = UP-Nr. 1
	ldi
	ldi
	ld bc,6
	add hl,bc		; MBI = UP-Nr. 5
	ldi
	ldi
;	ld bc,4			; BC ist durch ldi schon 4
	add hl,bc		; ISRO-CSRI = UP-Nr. 8-0bh
	ld bc,8
	ldir
	pop bc
	pop hl
	ret

;;; ======================================================
;;; Test auf D004

tstD4:
	;; Test auf D004
	ld bc,0fc80h
	in a,(c)
	cp 0a7h
	ret z			; D004 gefunden
	xor a			; kein D004 gefunden -->
	ld (Dev1Adr),a		; 1. Byte der Adr. auf 0
	ret

;;; ======================================================
;;; Sonderzeichen fuer Pascal, Routine an Ort und Stelle kopieren
ochrpl  equ OCHRPE - OCHRP
ochrpa  equ 0c000h - ochrpl
PASCHR:
	;; Voraussetzung: SUTAB ist bereits im RAM, enthaelt aber
	;; noch die Adr. der orig. Routine
	ld hl,(SUTAB)
	ld e,(hl)
	inc hl
	ld d,(hl)
	dec hl
	ex de,hl		; hl = orig. OCHR-Adr.
	ld (ochrp1+1),hl	; 3 Code-Stellen patchen
	ld (ochrp2+1),hl
	ld (ochrp3+1),hl
	ex de,hl		; hl = (SUTAB)
	ld de,ochrpa
	ld (hl),e
	inc hl
	ld (hl),d
	ld hl,OCHRP
	ld bc,ochrpl
	ldir
	ret

;;; muss vor "org PasExR" stehen weil isso (um die 3 Codestellen zu patchen)
include pasex2/px2sozei.inc
