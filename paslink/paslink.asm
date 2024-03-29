PASLINK ASM                                                                                                                     ;KC-Pascal-Linker
VER     EQU     '2'
;
PV1     EQU     0F003H
CRT	EQU	0
INLIN	EQU	17H
RHEX	EQU	18H
HLHX	EQU	1AH
AHEX	EQU	1CH
OSTR    EQU     23H
SPACE	EQU	2BH
CRLF	EQU	2CH
ZKOUT	EQU	45H
;
NUMNX	EQU	0B796H
NUMVX	EQU	0B797H
;
MAXA    EQU     10      ;max.Anz.Adre.
LAEMK	EQU	7	;Markenlaenge
			;Bsp.: <A:1.1>
;
; Prolog
	ORG     7B80H
	DEFW    7F7FH
	DEFM    'PASLINK'
	DEFB    1
	NOP             ;Einsprung TEMO
;
; Begruessung
	CALL    PV1
	DEFB    OSTR
	DEFM    'KC-Pascal-5.1-Linker '
	DEFM    'Version '
	DEFB    VER
	DEFW    0D0AH
	DEFM    'Doku lesen!'
	DEFW    0D0AH
	DEFM	'Abbruch mit E'
	DEFW	0D0AH
	DEFB	0
;
; Eingabe und Pruefung
	; Daten initialisieren
	LD	HL,DANF
	LD	(HL),0
	LD	D,H
	LD	E,L
	INC	DE
	LD	BC,DEND-DANF-1
	LDIR
	LD	HL,ADR
	LD	(NXTAD),HL
	;
	CALL	PV1
	DEFB	OSTR
	DEFM	'Anfangsadresse = 1800'
	DEFW	0D0AH
	DEFB	0
FRGEND:	CALL	PV1
	DEFB	OSTR
	DEFM	'Endadresse:'
	DEFW	0D0AH
	DEFB	0
	CALL	PV1
	DEFB	INLIN
	CALL	PV1
	DEFB	RHEX
	JR	NC,CHKADR
	LD	BC,EHEX
	CALL	FEHM
	JR	FRGEND
CHKADR:	LD	HL,(NUMVX)
	LD	DE,000EH ; =Ende, s.o.
	OR	A	; Carry=0
	SBC	HL,DE
	ADD	HL,DE
	JR	NZ,CHKAD1
	CALL	PV1
	DEFB	OSTR
	DEFM	'Abbruch'
	DEFW	0D0AH
	DEFB	0
	RET
CHKAD1:	LD	DE,1800H ; =Prg.Anfang
	OR	A
	SBC	HL,DE
	ADD	HL,DE
	JR	NC,CHKAD2
	LD	BC,EAKL
	CALL	FEHM
	JR	FRGEND
CHKAD2:	LD	DE,7B80H ; =PASLINK
	OR	A
	SBC	HL,DE
	ADD	HL,DE
	LD	(PEND),HL
	JR	C,SAMLA
	LD	BC,EAGR
	CALL	FEHM
	JR	FRGEND
;
FEHM:	PUSH	BC  ; Adr.Fehlertext
	LD	HL,ERRM
	CALL	PV1
	DEFB	ZKOUT
	POP	HL
	CALL	PV1
	DEFB	ZKOUT
	CALL	PV1
	DEFB	CRLF
	RET
ERRM:	DEFM	'ERROR: '
	DEFB	0
EHEX:	DEFM	'keine Hex-Zahl'
	DEFB	0
EAKL:	DEFM	'Adr. zu klein'
	DEFB	0
EAGR:	DEFM	'Adr. zu gross'
	DEFB	0
;
; Suche nach Bytefolgen
; Sammle A-Marken
SAMLA:  CALL	PV1
	DEFB	OSTR
	DEFM	'A:'
	DEFB	0
	CALL	PRGLAE
	LD	DE,ABSPR
SAMLA1:	CALL	BFS_SU
	JP	PO,SAMLAE
	PUSH	DE
	CALL	LIESMK
	JP	PO,SAMLA9
	PUSH	HL
	CALL	LIESJA
	JR	NZ,SAMLA2 ;JP ni.gefun.
	; DE=Mk.-Inhalt, HL=JP-Adr.
	CALL	A_TAB
	JR	Z,SAMLA8 ;Ende bei
	                 ;Tab-Ueberlauf
	LD	A,'+'
	CALL	PV1
	DEFB	CRT
	JR	SAMLA3
SAMLA2: ;JP vor der Marke nicht gefunden
	CALL	PV1
	DEFB	AHEX
	LD	A,'?'
	CALL	PV1
	DEFB	CRT
SAMLA3:	POP	HL
	POP	DE
	JR	SAMLA1
SAMLA8:	POP	HL
SAMLA9:	POP	DE
SAMLAE:	CALL	PV1
	DEFB	CRLF
;
; Sammle E-Marken
SAMLE:	CALL	PV1
	DEFB	OSTR
	DEFM	'E:'
	DEFB	0
	CALL	PRGLAE
	LD	DE,EINSPR
SAMLE1:	CALL	BFS_SU
	JP	PO,SAMLEE
	PUSH	DE
	CALL	LIESMK
	JP	PO,SAMLE9
	PUSH	HL
	CALL	LIESJA
	JR	NZ,SAMLE3 ;JP ni.gefun.
	PUSH	BC
	CALL	E_TAB
	POP	BC
	JR	C,SAMLEX
	LD	A,'-'
	JR	Z,SAMLE2 ;keine Abspr-
		         ;marke gefun.
	LD	A,'+'
SAMLE2: CALL	PV1
	DEFB	CRT
	JR	SAMLE4
SAMLE3:	;JP vor der Marke nicht gefun.
	CALL	PV1
	DEFB	AHEX
	LD	A,'?'
	CALL	PV1
	DEFB	CRT
SAMLE4:	POP	HL
	POP	DE
	JR	SAMLE1
SAMLEX:	POP	DE ; Fehler -> Abbruch
	POP	HL
	RET
SAMLE9:	POP	DE
SAMLEE:	CALL	PV1
	DEFB	CRLF
;
; Pruefe auf Vollstaendigkeit
	CALL	TSTAE
;
; Adressersetzungen
AERS:	CALL	PV1
	DEFB	OSTR
	DEFM	'T:'
	DEFB	0
	CALL	PRGLAE
	LD	DE,ACODE
AERS1:	CALL	BFS_SU
	JP	PO,AERS_E
	PUSH	HL
	PUSH	DE
	PUSH	BC
	CALL	ERS
	;... ohne Fehlerbehandlung
	POP	BC
	POP	DE
	POP	HL
	JR	AERS1
AERS_E:	CALL	PV1
	DEFB	CRLF
;
	CALL	ZEIADR
ENDE:	CALL	PV1
	DEFB	OSTR
	DEFM	'wenn Tabelle plausibel'
	DEFM	', dann weiter mit'
	DEFW	0D0AH
	DEFM	'%FSAVE 0200 '
	DEFB	0
	LD	HL,(PEND)
	CALL	PV1
	DEFB	HLHX
	CALL	PV1
	DEFB	CRLF
	RET
;
ABSPR:	DEFM	'<A:'
	DEFB	0
EINSPR:	DEFM	'<E:'
	DEFB	0
ACODE:	DB	0CDH,0B1H,09H,0D5H,0CDH
	DEFB	0
;
; Laenge d.Suchbereichs berech.
; Parameter (OUT)
; HL=Programmanfang
; BC=Programmlaenge
; DE wird ueberschrieben
PRGLAE:	LD	HL,(PEND)
	LD	DE,(PANF)
	OR	A
	SBC	HL,DE
	INC	HL
	LD	B,H
	LD	C,L	; Laenge in BC
	EX	DE,HL	; Start in HL
	RET
	;
;
; Bytefolge suchen
; Parameter (IN/OUT!)
; HL=Start zu durchsuchender Bereich
; DE=zu suchende Bytefolge, 0-termini.
; BC=Laenge des zu durchsu. Bereichs
BFS_SU:	PUSH	DE
	LD	A,(DE)
	CPIR
	JP	PO,BFS_EN
                ;;; >>>> HL merken
BFS_ZV:	INC	DE
	LD	A,(DE)
	OR	A
	JR	Z,BFS_EN ; gefunden!  >>>>>> gemerktes HL verwerfen
	CPI
	JP	PO,BFS_EN ;End.Suchber.  >>>>>> gemerktes HL verwerfen
	JR	Z,BFS_ZV ; passt,weiter
	POP	DE ; neu anfangen
	;; >>>>>>>>>>>> gemerktes HL wiederherstellen
	JR	BFS_SU
BFS_EN:	POP	DE
	RET
;
; Marke einlesen
; Parameter (IN/OUT!)
; HL=zu durchsuchender Speicher
; BC=Laenge des zu durchsu. Speichers
; DE(out)=gelesene Marke (=2 Zeichen)
LIESMK: LD	D,(HL)
	CPI
	RET	PO
	LD	A,'.'
	CPI
	RET	PO
	RET	NZ
	LD	E,(HL)
	CPI
	RET	PO
	LD	A,'>'
	CPI
	RET
;
; Nachdem eine Marke gefunden wurde:
; Vor der Marke steht ein JP. Pruefe
; (->Z=1) und lies die Zieladr.d.JP.
; HL(in)=Adr.am Ende der Marke
; HL(out)=JP-Ziel
LIESJA:	PUSH	DE
	LD	DE,LAEMK+3
	OR	A
	SBC	HL,DE
	LD	A,(HL)
	CP	0C3H ;Ist es ein JP?
	JR	NZ,LIESJE
	INC	HL
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	EX	DE,HL
LIESJE:	POP	DE
	RET
;
; Absprungmarke u. -adresse in Tabelle
; Parameter:
; DE=Marke, HL=JP-Adresse
A_TAB:	LD	A,(ANZA)
	CP	MAXA
	JR	Z,A_TAB9
	PUSH	HL
	LD	HL,(NXTAD)
	LD	(HL),D
	INC	HL
	LD	(HL),E
	POP	DE
	INC	HL
	LD	(HL),E
	INC	HL
	LD	(HL),D
	INC	HL
	INC	HL
	INC	HL
	INC	HL
	LD	(NXTAD),HL
	LD	HL,ANZA
	INC	(HL)
	RET
A_TAB9:	LD	BC,EADRTV
	CALL	FEHM
	RET
EADRTV: DEFM	'Adresstabelle voll'
	DEFB	0
;
; Einsprungadressen in die Adr-Tabelle
; eintragen an alle gleichen Marken
; Parameter
; DE=Marke, HL=JP-Adresse
E_TAB:	LD	(ETJADR),HL
	LD	A,D
	LD	(ETMRK),A
	LD	A,E
	LD	(ETMRK+1),A
	LD	HL,ADR
	LD	A,(ANZA)
	CP	0
	RET	Z
	LD	B,A
E_TAB1:	LD	A,(HL)
	INC	HL
	CP	D
	JR	NZ,E_TAB2
	LD	A,(HL)
	INC	HL
	CP	E
	JR	NZ,E_TAB3
	INC	HL ; Absprungadresse..
	INC	HL ;    uebergehen
	LD	A,(HL) ; zur Kontrolle
	INC	HL ; bei OK wieder DEC!
	ADD	A,(HL)
	JR	NZ,E_TABF
	JR	C,E_TABF
	DEC	HL
	LD	A,(ETJADR)
	LD	(HL),A
	INC	HL
	LD	A,(ETJADR+1)
	LD	(HL),A
	JR	E_TAB4
E_TAB2:	INC	HL
E_TAB3:	INC	HL
	INC	HL
	INC	HL
E_TAB4:	INC	HL
	INC	HL ; Zaehlfeld
	DJNZ	E_TAB1
	OR	A ; Cy=0 -> kein Fehler
	RET
E_TABF:	LD	HL,ETMRK
	CALL	ZEIMRK
	LD	BC,ETFDOP
	CALL	FEHM
	SCF       ; Fehler anzeigen
	RET
ETJADR	DEFW	0 ; Hilfsvariablen
ETMRK	DEFW	0
ETFDOP	DEFM	'Einsprungmarke doppelt'
	DEFB	0
;
; Ersetzung einer Adresse, falls in
; ADR gefunden
; Parameter:
; HL=Stelle im Programm
ERS:	LD	(ERS_AD),HL
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	LD	HL,ADR
	LD	A,(ANZA)
	CP	0
	RET	Z
	LD	B,A
ERS1:	INC	HL ; Marke
	INC	HL
	LD	A,(HL)
	INC	HL
	CP	E
	JR	NZ,ERS2
	LD	A,(HL)
	INC	HL
	CP	D
	JR	NZ,ERS3
	; Adresse gefunden
	LD	DE,(ERS_AD)
	LD	A,(HL)
	INC	HL
	LD	(DE),A
	INC	DE
	LD	A,(HL)
	INC	HL
	LD	(DE),A
	;INC	(HL) ;Ersetzgn. zaehlen
	LD	A,(HL)
	INC	A
	DAA
	LD	(HL),A
	LD	A,'t'
	CALL	PV1
	DEFB	CRT
	RET
ERS2:	INC	HL
ERS3:	INC	HL
	INC	HL
	INC	HL
	DJNZ	ERS1
	LD	A,'.'
	CALL	PV1
	DEFB	CRT
	RET
ERS_AD	DEFW	0 ;Stelle im Prg., wo
		; die Adr. ersetzt wird
;
; Auswertung
ZEIADR:	CALL	PV1
	DEFB	CRLF
	CALL	PV1
	DEFB	OSTR
	DEFM	'Mrk Ab -> Ein Ers'
	DEFW	0D0AH
	DEFM	'--- ---- ---- ---'
	DEFW	0D0AH
	DEFB	0
	LD	HL,ADR
	LD	A,(ANZA)
	CP	0
	RET	Z
	LD	B,A
ZEIAD1:	CALL	ZEIMRK
	CALL	ZEI1AD
	CALL	ZEI1AD
	CALL	ZEIANZ
	CALL	PV1
	DEFB	CRLF
	DJNZ	ZEIAD1
	RET
ZEIMRK:	LD	A,(HL)
	INC	HL
	CALL	PV1
	DEFB	CRT
	LD	A,'.'
	CALL	PV1
	DEFB	CRT
	LD	A,(HL)
	INC	HL
	CALL	PV1
	DEFB	CRT
	CALL	PV1
	DEFB	SPACE
	RET
ZEI1AD:	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	INC	HL
	EX	DE,HL
	CALL	PV1
	DEFB	HLHX
	EX	DE,HL
	RET
ZEIANZ:	LD	A,(HL)
	RRCA
	RRCA
	RRCA
	RRCA
	AND	0FH
	ADD	A,'0'
	CALL	PV1
	DEFB	CRT
	LD	A,(HL)
	INC	HL
	AND	0FH
	ADD	A,'0'
	CALL	PV1
	DEFB	CRT
	RET
; Test, ob zu jedem Absprung ein
; Einsprung gefunden wurde
TSTAE:
	LD	HL,ADR
	LD	A,(ANZA)
	CP	0
	RET	Z
	LD	B,A
TSTAE1:	LD	(TSMKAD),HL
	INC	HL
	INC	HL
	INC	HL
	INC	HL
	LD	A,(HL)
	INC	HL
	ADD	A,(HL)
	JR	NZ,TSTAE2
	JR	C,TSTAE2
	LD	HL,(TSMKAD)
	CALL	ZEIMRK
	LD	BC,TSFADR
	CALL	FEHM
	SCF
	RET
TSTAE2:	INC	HL
	INC	HL
	DJNZ	TSTAE1
	OR	A
	RET
TSMKAD	DEFW	0
TSFADR	DEFM	'Einsprungmarke fehlt'
	DEFB	0
;
; Ende
	RET
; ----------
;	Daten
PANF	DEFW	1800H ;Prog.anfang
DANF:
PEND	DEFW	0 ;Programmendeadr.
ANZA    DEFB    0 ;Anz.gefuellt.Felder
		  ;in ADR
NXTAD	DEFW	0 ;nae.frei.Feld in ADR
		  ;erspart Adr.-rechng.
ADR     DEFS	7*MAXA
	; Struktur:
	; je 2 Byte Marke, Abspr.- u.
	; Einspr.-Adresse
	; 1 Byte Anz. Ersetzungen i.Prg
DEND
�@�t(�p6�nTop of Text:  End of Text:je 2 Byte Marke, Abspr.- u.
	; Einspr.-Adresse
	; 1 Byte Anz. Ersetzungen i.Prg
DEND
�@�t(�p6�nTop of Text:  End of Text:
