#!/usr/bin/perl
# Aufrufbeispiele:
#  perl bm2bin.pl -1 "\." -0 "#" tx_super.txt tx_super.bin

use strict;
use Getopt::Std;

our ($opt_f, $opt_0, $opt_1) = (0, '\.( |$)', '##');
getopts("f0:1:");

my ($bmf, $binf);  # Dateinamen

($bmf = shift @ARGV) or die "ERROR: Parameter Bitmap-Textdatei fehlt.\n";
die "ERROR: Datei $bmf nicht gefunden.\n" if not -r $bmf;

($binf = shift @ARGV) or die "ERROR: Parameter Binaerdatei fehlt.\n";
die "ERROR: Datei $binf existiert bereits. Zum Ueberschreiben Option -f benutzen.\n"
    if -r $binf and not $opt_f;

open BMF, '<', $bmf or die;
open BINF, '>:raw :bytes', $binf or die;

my $bd="";
while (my $l = <BMF>) {
    $l =~ s/$opt_0/0/g;
    $l =~ s/$opt_1/1/g;
    chomp $l;
    while (my $sn = substr($l, 0, 8, '')) {
	$bd .= pack("C", oct("0b" . $sn . "0" x (8 - length($sn))));
#	$bd .= sprintf("%02X", oct("0b" . $sn . "0" x (8 - length($sn))));
#	print ".";
    }
}
#print "\n";
print BINF $bd;
close BINF;
close BMF;
