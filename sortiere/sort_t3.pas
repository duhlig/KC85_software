SORT_T3 PAS     X[g0);Auswertung;T>*)" .  " .  Ă[g        Íá!p2ĂśgĂqgĂqg<A:1.4>ÝĺÝ! Ý9!  9ůí[ÔßÝáŃ3áëéĂg  (*2023-04-23,v0.11,Teil 3*) &  WrAStaT(st:tStart);(*Dummy*)0  L='<A:1.4>';: D(*<TN st XAUF:    WRITE('aufstg.');bAB:     WRITE('abstei.');lZUFALL: WRITE('unsort.')v     WRITE('(andrs)');T>*) ;   WrAlgoT(al:tAlgo);(*Dummy*)¨  L='<A:1.5>';˛ ź(*<TĆ al ĐSEL: WRITE('Select.');ÚINS: WRITE('Insert.');äBUB: WRITE('Bubble ');îSHE: WRITE('Shell  ');řQUI: WRITE('Quick  ');QUM: WRITE('Qu/Med ');QMI: WRITE('Q/M+Ins');HEA: WRITE('Hash   ') ;*T>*)4 ;> H  WrDezU6(z:INTEGER);(*Dummy*)R  L='<A:2.3>';\ f(*<TpWRITE(z:6);zT>*) ;   Ergebnis(˘al:tAlgo; st:tStart;Źg,d,v,z:INTEGER);ś  L='<E:3.1>';Ŕ Ę ausw[uein] ÔŢalg:=al; sta:=st; gr:=g;čdp:=d; vg:=v; zw:=z;ň;ü uein=UGR  uein:=1 uein:=uein+1; ugr<UGR $ugr:=ugr+1;.ui[ugr]:=ugr;8;B ;L V  KopfZl;`  s:INTEGER;jr:CHAR;t ~ KoFa; s=usp  SETC(7,4);Ś ur °-1: r:=CHR(138);ş0:  r:=' ';Ä1:  r:=CHR(139)Î;Řâ ěSETC(7,5); r:=' '; ;ös:=s+1; ;
  GOTOXY(0,0); s:=-1;(KoFa; WRITE('  ',r);2KoFa; WRITE('Algorit',r);<KoFa; WRITE('F-gr',r);FKoFa; WRITE('Start m',r);PKoFa; WRITE('Dop',r);ZKoFa; WRITE('Vergl',r);dKoFa; WRITE('Zuwei',r);n ;x   StatusZl; GOTOXY(0,31); SETC(7,4); WRITE(' Auswertung ');ŞWRITE('            ');´WRITE('Tasten: ');žGOTOXY(32,31);SETC(7,0);ČWRITE('Q',CHR(138),CHR(139),CHR(136),CHR(137),'W');Ň ;Ü ć  Trenner;đ  o,u:INTEGER;ú o:=247; u:=8;LINEPLOT( 22,o, 22,u);LINEPLOT( 86,o, 86,u);"LINEPLOT(126,o,126,u);,LINEPLOT(190,o,190,u);6LINEPLOT(222,o,222,u);@LINEPLOT(270,o,270,u);J ;T ^  ZeigeAusw;h  n:INTEGER;r |GOTOXY(0,1); n:=1  ugr  ODD(n)  SETC(7,7)¤ SETC(7,6);ŽWRITE(ui[n]:2,' ');¸ ausw[ui[n]] ÂĚWrAlgoT(alg);WRITE(gr:5,' ');ÖWrAStaT(sta);ŕ dp ę0: WRITE('   -');ô1: WRITE('  2x');ţ2: WRITE('  4x');WrDezU6(vg);WrDezU6(zw);WRITE(' ');&;0;: ;D N  AuswVergl(m,n:INTEGER):BOOLEAN;X (*m,n:Indexe in ui;RET:true->tauschen*)b  o,p:INTEGER;le:BOOLEAN;v  ur>0  o:=m; p:=n;  o:=n; p:=m; ;¨ usp ˛0: e:=ausw[ui[o]].alg>ausw[ui[p]].alg;ź1: e:=ausw[ui[o]].gr>ausw[ui[p]].gr;Ć2: e:=ausw[ui[o]].sta>ausw[ui[p]].sta;Đ3: e:=ausw[ui[o]].dp>ausw[ui[p]].dp;Ú4: e:=ausw[ui[o]].vg>ausw[ui[p]].vg;ä5: e:=ausw[ui[o]].zw>ausw[ui[p]].zwî;řAuswVergl:=e; ;   AuswSort;   h,m:INTEGER;* 4(*1.Elem. per Selection sort*)>m:=1;H i:=2  ugr R AuswVergl(m,i)  m:=i;\ m<>i  fh:=ui[m];ui[m]:=ui[1];ui[1]:=h;p;z ugr>2  (*weiter m. Insertion sort*) i:=3  ugr ˘ui[0]:=ui[i]; j:=i;Ź AuswVergl(j-1,0) śŔui[j]:=ui[j-1]; j:=j-1;Ę;Ôui[j]:=ui[0];Ţ;č;ň ;ü 	  Auswertung;	  L='<E:3.2>';	  n:INTEGER;$	 .	SETC(7,4); PAGE;8	 ugr=0 B	L	GOTOXY(2,10);V	WRITELN('Bitte erst einen Sortiervorgang');`	WRITE('  durchlaufen lassen.');j	tast:=READKBD;t	 tast='Q'  zu1:='0';~				ur:=0; KopfZl; StatusZl;Ś	ZeigeAusw; Trenner;°	ş	GOTOXY(38,31);Ä	tast:=READKBD;Î	 tast Ř	'Q': zu1:='0';â	CHR(8): ě	 usp<=0  usp:=5ö	 usp:=usp-1; 
ur:=0; KopfZl;

;
CHR(9): 
 usp>=5  usp:=0(
 usp:=usp+1;2
ur:=0; KopfZl;<
;F
CHR(10): P
ur:=-1; KopfZl;Z
AuswSort;d
ZeigeAusw; Trenner;n
;x
CHR(11): 
ur:=1; KopfZl;
AuswSort;
ZeigeAusw; Trenner; 
Ş
´
 (tast='Q')  (tast='W');ž
;Č
 ;Ň
 Ü
 ć
(*<Tđ
uein:=1;ugr:=0;usp:=0;ur:=1;ui[0]:=0;ú
Ergebnis(INS,ZUFALL,50,0,317,523);Ergebnis(SEL,AUF,35,2,1000,2000);Ergebnis(BUB,AB,200,1,22345,32100);Auswertung;"T>*), .  ung;T>*)" .                                   0);Ergebnis(BUB,AB,200,1,22345,32100);Auswertung;"T>*), .  ung;T>*)" .                                   