
;;; ============================================================
;;; Adressen der Routinen fuer die Geraete 0 (Tape), 1 (Floppy) und 2 (USB)
Dev0Adr:	defs 12
Dev1Adr:	defw PXMBO
		defw PXMBI
		defw PXISRO
		defw PXCSRO
		defw PXISRI
		defw PXCSRI
Dev2Adr:	defs 12

;; SUTAB-Adr. im RAM, Merkzelle zur Wiederherstellung nach Reset
SutabR:		defw 0
