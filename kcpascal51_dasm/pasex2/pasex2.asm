;;; ======================================================
;;; Autostart
PasExL:	equ HochE - HochA	; Laenge, die hochzuladen ist
include pasex2/px2init.inc		; enthaelt px2sozei.inc

;;; ----------------- hochladen --------------------------
PasExB:				; Basisadr. im Pascal-Binary
;PasExL:	equ HochE - HochA	; Laenge, die hochzuladen ist
;PasExR:	equ ochrpa - PasExL	; resultierende Adresse
;	phase PasExR

include pasex2/px2org.inc
HochA:
PasExR:	
include pasex2/px2kern.inc
include pasex2/px2var.inc
HochE:
