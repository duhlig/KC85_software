# KC-Pascal 5.2

_Das ist ein Arbeitsstand._

Die originale Pascal-Entwicklungsumgebung und Dokumentation kann von
http://kc85.info/ / Download / Programmiersprachen heruntergeladen werden.

KC-Pascal 5.1 wurde disassembliert, siehe
https://github.com/duhlig/KC85_software/tree/main/kcpascal51_dasm. Hier
liegt die Weiterentwicklung. Die Dokumentation steht auf
https://github.com/duhlig/KC85_software/tree/main/_Papier/kcpascal_dok
bereit.

# Änderungshistorie

## Version 5.2

### Erweiterungen

- Kommando T (Translate) verwendet die Dateierweiterung KCC statt COM.
- PasEx2 funktioniert grundlegend. Details siehe Doku.
- Beispielprogramme
  - fepen: verwendet REAL und möglichst viele Syntax-Konstrukte.
  - gruss: TIN und TOUT, Test von PasEx2 möglich


# Testmöglichkeit

Zum Test der angepassten KC-Pascal-Version sollte natürlich jeder sein
eigenes Pascal-Programm schreiben und prüfen, dass ein korrektes
KCC-Programm generiert wird. Hilfsweise kann fepen.pas benutzt werden.

Fepen.pas enthält absichtlich einen Syntaxfehler auf Zeile 1000. Dort
fehlt das abschließende Semikolon. Damit wird man zu einem Kurztest
des Editors gezwungen.

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
