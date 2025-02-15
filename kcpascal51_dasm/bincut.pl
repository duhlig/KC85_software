#!/usr/bin/perl
# Aufruf: ./bincut.pl -i p51.bin -o p51k.bin -b c,c,c,7c,0 -a 0,0,41,53,43,49,49

use strict;
use warnings;
use Getopt::Std;

my %opts;
getopts('b:a:i:o:', \%opts);

$opts{"o"} or die "Parameter -o fehlt";
$opts{"i"} or die "Parameter -i fehlt";
$opts{"b"} or die "Parameter -b fehlt";
$opts{"a"} or die "Parameter -a fehlt";

open(OFI, ">:raw :bytes", $opts{"o"}) or die;
open(IFI, "<:raw :bytes", $opts{"i"}) or die;

my @bybef = map(hex, split(/,/, $opts{"b"}));
my @byaft = map(hex, split(/,/, $opts{"a"}));
my ($bblen, $balen) = ($#bybef, $#byaft);

die "Muster -b zu kurz" if ($bblen < 4);
die "Muster -a zu kurz" if ($balen < 4);

my $ilen = -s $opts{"i"};
my $ifis;
read(IFI, $ifis, $ilen);
close IFI;

my @ifia = map(ord, unpack("(a)*", $ifis));

sub cmppat {
    for (my $i=0; $i<=$#_; $i++) {
	return 0 if ($ifia[$i] != $_[$i]);
    }
    return 1;
}

die "Datei zu kurz" if ($#ifia <= $bblen);
my $found = 0;
while ($#ifia > $bblen) {
    if (cmppat(@bybef)) {
	for (0..$bblen) {
	    print OFI pack("C", shift(@ifia));
	}
	$found = 1;
	last;
    } else {
	print OFI pack("C", shift(@ifia));
    }
}
die "Muster -b nicht gefunden" if (not $found);

$found = 0;
while ($#ifia >= $balen) {
    if (cmppat(@byaft)) {
	foreach (@ifia) {
	    print OFI pack("C", $_);
	}
	$found = 1;
	last;
    } else {
	shift(@ifia);
    }
}
die "Muster -a nicht gefunden" if (not $found);

close OFI;
