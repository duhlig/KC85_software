;;; ======================================================
;;; Autostart
PasExL:	equ HochE - HochA	; Laenge, die hochzuladen ist
include px2init.inc		; enthaelt px2sozei.inc

;;; ----------------- hochladen --------------------------
PasExB:				; Basisadr. im Pascal-Binary
;PasExL:	equ HochE - HochA	; Laenge, die hochzuladen ist
;PasExR:	equ ochrpa - PasExL	; resultierende Adresse
;	phase PasExR

include px2org.inc
HochA:
PasExR:	
include px2kern.inc
include px2var.inc
HochE:
