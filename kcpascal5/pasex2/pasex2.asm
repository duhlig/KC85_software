	org 06000h
include pas_gdef.inc

	defb "PASEX   KCC"
	defs 5
	defb 3
	defw PasExA
	defw PasExB + HochE - HochA
	defw pre_init
	defs 0x69

PasExA:
include pasex2.inc
