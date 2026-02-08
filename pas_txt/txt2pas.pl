#!/usr/bin/perl
# Zweck: Konvertieren einer Textdatei in  KC-Pascal-Format (.pas mit CAOS-Vorblock)
# Autor: Dietmar Uhlig
# Version: 0.1
# letzte Aenderung: 2026
#
# Aufruf: txt2pas.pl DATEINAME_TEXT DATEINAME_KCPASCAL
#
# Die Textdatei darf entweder keine Zeilennummern enthalten oder
# die Zeilennummern muessen durchgehend und aufsteigend sein.
# Weiterhin darf die maximale Zeilenlaenge
# nicht ueberschritten werden, die von KC-Pascal vorgegeben wird.

use strict;
use Getopt::Std;

use constant {   # Zustaende der Auswerteschleife
    QTXT   => 0, # Quelltext
    BZEI   => 1, # Bezeichner
    ZKET   => 2  # Zeichenkette
};

my %token = (
    "PROGRAM"   => 0x81,
    "DIV"       => 0x82,
    "CONST"     => 0x83,
    "PROCEDURE" => 0x84,
    "FUNCTION"  => 0x85,
    "NOT"       => 0x86,
    "OR"        => 0x87,
    "AND"       => 0x88,
    "MOD"       => 0x89,
    "VAR"       => 0x8a,
    "OF"        => 0x8b,
    "TO"        => 0x8c,
    "DOWNTO"    => 0x8d,
    "THEN"      => 0x8e,
    "UNTIL"     => 0x8f,
    "END"       => 0x90,
    "DO"        => 0x91,
    "ELSE"      => 0x92,
    "REPEAT"    => 0x93,
    "CASE"      => 0x94,
    "WHILE"     => 0x95,
    "FOR"       => 0x96,
    "IF"        => 0x97,
    "BEGIN"     => 0x98,
    "WITH"      => 0x99,
    "GOTO"      => 0x9a,
    "SET"       => 0x9b,
    "ARRAY"     => 0x9c,
    "FORWARD"   => 0x9d,
    "RECORD"    => 0x9e,
    "TYPE"      => 0x9f,
    "IN"        => 0xa0,
    "LABEL"     => 0xa1,
    "NIL"       => 0xa2,
    "PACKED"    => 0xa3
    );

my $txt;                # Dateiname der Textdatei
my $pas;                # Dateiname der zu schreibenden KC-Pascal-Datei
my $pasv;               # Dateiname im Vorblock
my ($zn, $za) = (1, 1); # Zeilennummer, Zeilenabstand
my $qzv = 0;            # vorherige Quellzeile (fuer Opt. -z)
my $tz = 1;             # Zeile in der eingelesenen Textdatei
my $s;                  # Status des Zustandsautomaten beim Scannen der Zeile
my $pd = "";            # Inhalt der Pascal-Datei
my $dfuell;             # Anzahl 0-Bytes zum Auffuellen auf letzten Block
my @q;                  # Zeichen der aktuellen Quelltextzeile

getopts("hfnN:z", \my %opts);

if ($opts{'h'}) { usage(); exit(0); }

($txt = shift @ARGV) or die "ERROR: Parameter Quelltext-Datei fehlt.\n";
die "ERROR: Datei $txt nicht gefunden.\n" if not -r $txt;

($pas = shift @ARGV) or die "ERROR: Parameter Pascal-Datei fehlt.\n";
die "ERROR: Datei $pas existiert bereits. Zum Ueberschreiben Option -f benutzen.\n"
    if -r $pas and not $opts{'f'};

die "ERROR: Optionen -n und -N nicht gleichzeitig angeben.\n"
    if ($opts{'n'} and $opts{'N'});
($zn, $za) = (10, 10) if ($opts{'n'});
($zn, $za) = split(/,/, $opts{'N'}) if ($opts{'N'});
die "ERROR: Erste Zeilennummer muss >0 sein.\n" unless ($zn > 0);
die "ERROR: Erste Zeilennummer muss <32767 sein.\n" if ($zn > 32766);
die "ERROR: Zeilenabstand muss >0 sein.\n" unless ($za > 0);
die "ERROR: Zeilenabstand >1000 ist nicht sinnvoll.\n" if ($za > 1000);

open TXT, '<', $txt or die;
open PAS, '>:raw :bytes', $pas or die;

while(my $t = <TXT>) {
    chomp($t);
    if ($t =~ /^([ 0-9]{4}[0-9]) (.*)/) { # Zeilennummer mit fuehrenden Leerz.
	zeilennummer($1); # setzt $zn wenn Option -z angegeben wurde
	$t = $2;
    }

    # Aufbau der Zeile in der PAS-Datei:
    #   2 Byte Zeilennummer, verdichteter Quelltext, Zeilenabschluss mit 0x0D
    $pd .= pack("S<", $zn);
    quelltext($t);
    $pd .= "\r";

    $zn += $za;
    $tz++;  # fuer Fehlermeldung
}

$pd .= pack("S<", 0); # Zeilennummer 0 als Endekennzeichen

$dfuell = (128 - (length($pd) % 128)) % 128;
$pasv = $pas;
$pasv =~ s/^([^.]).*/$1/;
$pasv = uc(substr($pasv, 0, 7));

# Vorblock
print PAS pack("A8A3x5CS<S<x107", $pasv, "PAS", 2, 0x1800, 0x1800 + length($pd) + 1);
print PAS $pd;
# letzten Block auffuellen
print PAS "\0" x $dfuell;

close PAS;
close TXT;

exit 0;

# -------------------------

sub zeilennummer($) {
    if ($opts{'z'}) {
	$zn = $1;
	die "ERROR: Zeile $tz: Zeilennummer nicht aufsteigend\n"
	    if $zn <= $qzv;
	$qzv = $zn;
    } elsif ($tz == 1) {
	die "ERROR: Zeilennummer gefunden. Bitte aus dem Quelltext " .
	    "entfernen oder\n" .
	    "       Option -z benutzen\n";
    }
}

sub quelltext($) {
    my $qt = shift;
    my @q;     # Quelltextzeichen als Array
    my $c;     # aktuelles Zeichen im Quelltext
    my $bzei;

    die "ERROR: Zeile $tz zu lang\n" if ($#q > 73);

    # Leerzeichen am Zeilenanfang verdichten, nur die Anzahl speichern
    $qt =~ /^(\ *)(.*)$/;
    $pd .= pack("C", length($1));
    @q = split(//, $2);
    
    $s = QTXT;
    while ($#q>=0) {
	$c = shift(@q);
	die "ERROR: Zeile $tz: ungueltiges Zeichen\n"
	    unless (32 <= ord($c) < 127);

	if ($s == QTXT) {
	    if    ($c eq "'")           { $pd .= $c; $s = ZKET; }
	    elsif ($c =~ /[[:alpha:]]/) { $s = BZEI; $bzei = $c; }
	    else                        { $pd .= $c; }
	} elsif ($s == BZEI) {
	    if    ($c =~ /[[:alnum:]]/) { $bzei .= $c; }
	    else                        { bezeichner($bzei); unshift(@q, $c); }
	} elsif ($s == ZKET)            { $pd .= $c; $s = QTXT if ($c eq "'");
	} else { die "ERROR: Interner Fehler, falscher Status\n"; }
    }

    # Aktionen am Zeilenende
    if ($s == BZEI) {
	bezeichner($bzei);
    }
}

sub bezeichner($) {
    my $b = shift;
    
    if   ($token{$b} == undef) { $pd .= $b; }
    else                       { $pd .= pack("C", $token{$b}); }
    $s = QTXT;
}

sub usage {
    print "Aufruf:\n";
    print "\n  txt2pas.pl [OPTIONEN] TEXTDATEI PASCALDATEI\n\n";
    print "Zweck: wandelt eine Text-Datei in das KC-Pascal-Format um\n\n";
    print "Bedingungen ergeben sich aus KC-Pascal:\n";
    print "  - Zeilenlaenge max. 74 Zeichen\n";
    print "  - nur druckbare ASCII-Zeichen\n";
    print "  - Zeilennummern weglassen oder durchgaengig und aufsteigend\n";
    print "    in den ersten 5 Zeichen jeder Zeile mit fuehrenden Leerzeichen\n\n";
    print "Optionen:\n";
    print "  -h     ... diese Hilfe\n";
    print "  -f     ... Zieldatei ueberschreiben\n";
    print "  -z     ... Textdatei enthaelt Zeilennummern\n";
    print "  -n     ... entspricht '-N 10,10'\n";
    print "  -N e,s ... e: erste Zeilennummer, s: Schrittweite\n";
    print "  Ohne -n und -N wird '-N 1,1' angenommen.\n";
}
