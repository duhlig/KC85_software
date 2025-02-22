# KC-Pascal 5.1 disassembliert

_Das ist ein Arbeitsstand._

Die Pascal-Entwicklungsumgebung und Dokumentation kann von
http://kc85.info/ / Download / Programmiersprachen heruntergeladen werden.

Zum Disassemblieren wird z80dasm benutzt. Markennamen, die auf doppelten
Unterstrich enden, sind frei geraten. Die Datei p51.comment enthält
Notizen zum Programm. Zum Disassemblieren wird sie nicht gebraucht.

# Anpassungen

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

## Testmöglichkeit

Zum Test der angepassten KC-Pascal-Version sollte natürlich jeder sein eigenes Pascal-Programm schreiben und prüfen, dass ein korrektes KCC-Programm generiert wird. Hilfsweise kann fepen.pas benutzt werden.

Fepen.pas enthält absichtlich einen Syntaxfehler auf Zeile 1000. Dort fehlt das abschließende Semikolon. Damit wird man zu einem Kurztest des Editors gezwungen.

- Variante 1: Korrektur vor dem Übersetzen

        E1000 [Enter]
        X
        ; [Enter]
        [Enter]
        C

- Variante 2: Fehler durch den Compiler finden lassen, korrigieren und
  neu übersetzen

        C
        (Anzeige der Fehlermeldung in Zeile 1010)
        P
        ; [Enter]
        [Enter]
        C
