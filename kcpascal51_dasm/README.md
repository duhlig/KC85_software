# KC-Pascal 5.1 disassembliert

_Das ist ein Arbeitsstand._

Die Pascal-Entwicklungsumgebung und Dokumentation kann von
http://kc85.info/ / Download / Programmiersprachen heruntergeladen werden.

Zum Disassemblieren wird z80dasm benutzt. Markennamen, die auf doppelten
Unterstrich enden, sind frei geraten. Die Datei p51.comment enthält
Notizen zum Programm. Zum Disassemblieren wird sie nicht gebraucht.

# Anpassungen

Die Anpassungen stecken in pas51x.asm. Um nicht selbst assemblieren zu müssen, kann pas51x.kcc verwendet werden.

## Version 5.1b

### Erweiterungen

- Beim Laden und Speichern wird der Dateiname immer an ISRO und ISRI übergeben.
- Das Carry-Flag der I/O-Operationen wird abhaengig von der
  CAOS-Version ausgewertet.
- Ist das Device das Magnetband, erfolgt die Fehlerbehandlung wie in
  KC-Pascal 5.1. Andernfalls wird bei erkannten Fehlern sofort
  abgebrochen.

### Korrekturen

- Die Endeadresse im KCC-Header der generierten COM-Datei ist jetzt korrekt.

## Version 5.1c

### Erweiterungen

- Das Kommando T (Translate) erkennt jetzt den 4 Parameter. Beginnt
  der 4. Parameter mit "1", dann wird die KCC-Datei selbststartend. In
  allen anderen Fällen bleibt es dabei, dass man das generierte
  Programm nach dem Laden manuell starten muss.

### Korrekturen

- Der Vorblock wird mit 00H aufgefüllt.
- Nach dem Laden des Quellcodes wird ein Zeilenumbruch ausgegeben.

## Version 5.1d

### Korrekturen

- PasEx wird nur noch bis CAOS-Version 4.5 aufgerufen.
- Der Dateiname im Vorblock wird mit 20h statt 0h aufgefüllt.
- Neue Fehler aus Version 5.1c beim Load und Save wurden beseitigt.


## Testmöglichkeit

Zum Test der angepassten KC-Pascal-Version sollte natürlich jeder sein
eigenes Pascal-Programm schreiben und prüfen, dass ein korrektes
KCC-Programm generiert wird. Hilfsweise kann fepen.pas benutzt werden
(siehe
https://github.com/duhlig/KC85_software/tree/main/kcpascal5/beispiele).
