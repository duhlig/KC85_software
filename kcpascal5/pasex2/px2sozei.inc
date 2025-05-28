;;; ======================================================
;;; Zeichensatz selektiv
;;; kein Platz für kompletten Zeichensatz
;;; --> die 3 veraenderten Zeichen separat behandeln
	
	;; org 0c000h - (OCHRPE - OCHRP)

OCHRP:	
	cp 05bh			; erstes ersetztes Zeichen
ochrp1:	jp c,0			; nein, Orig.-Routine benutzen
	cp 05eh			; erstes nach den ersetzten Zeichen
ochrp2:	jp nc,0			; ja, keine Sonderbehandlung, Orig.-Rou. benutzen
	push hl
	ld hl,(CCTL0)
	push hl
	ld hl,0c000h - 8*03eh	; scheinbarer Anfang von CCTL0/PAS
	ld (CCTL0),hl
ochrp3:	call 0
	pop hl
	ld (CCTL0),hl
	pop hl
	ret
CCTL0P:	
	defb 07ch,060h,060h,060h,060h,060h,07ch,000h
	defb 0c0h,060h,030h,018h,00ch,006h,002h,000h
	defb 07ch,00ch,00ch,00ch,00ch,00ch,07ch,000h
OCHRPE:			      ; Ende
