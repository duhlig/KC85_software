;;; ======================================================
;;; Sonderzeichen fuer Pascal, Routine an Ort und Stelle kopieren
ochrpl  equ OCHRPE - OCHRP
;ochrpa  equ PasExR - ochrpl	; ausgelagert nach pas_gdef.inc
				; Berechnung funktioniert mit pasmo nicht.
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
include sozei.inc
