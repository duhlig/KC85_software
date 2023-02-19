Konvertierung von KC-Pascal-Datei mit CAOS-Vorblock in ASCII-Text
(vielleicht auch irgendwann mal in Gegenrichtung)

Verwendung z.B.:

* Vergleich zweier Pascal-Dateien am besten ohne Zeilennummern:

  ```diff <(pas2txt.pl DATEI1.pas | cut -b 6-) <(pas2txt.pl DATEI2.pas | cut -b 6-)```
