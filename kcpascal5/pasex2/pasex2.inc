;;; ======================================================
;;; Autostart
PasExL:	equ HochE - HochA	; Laenge, die hochzuladen ist
include px2init.inc

;;; ----------------- hochladen --------------------------
PasExB:				; Basisadr. im Pascal-Binary

include px2org.inc
HochA:
PasExR:				; resultierende Adresse
include px2kern.inc
include px2var.inc
HochE:
