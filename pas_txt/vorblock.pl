#!/usr/bin/perl
# Zweck: Vorblock generieren und Eingabedatei mit Vorblock ausgeben,
#        so dass sich die Datei mit TIN() in KC-Pascal laden lässt
# Autor: Dietmar Uhlig
# Version: 1.0
# letzte Aenderung: 24.5.2023
#
# Aufruf: vorblock.pl -o AUS_DATEINAME [-s STARTADR] [EIN_DATEINAME]
#   -o ... Hinweis: KC-Pascal erwartet bei TIN() die Dateierweiterung PAS.
#   -s ... Die Startadresse ist unwichtig. Als Vorgabe wird 0x200 verwendet.

use strict;
use Getopt::Std;

our %opts;

getopts('o:s:', \%opts)
    or die "ERROR: unbekannte Option\n";

die "ERROR: Ausgabedatei (Option -o) fehlt.\n"
    if not defined $opts{'o'};

#open PAS, '<:raw :bytes', $pas or die;


print $#ARGV . " Argumente:\n";
while (my $a = shift @ARGV) { print "3. " . $a; }
