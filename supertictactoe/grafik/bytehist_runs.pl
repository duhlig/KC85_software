#!/usr/bin/env perl
use strict;
use warnings;
use List::Util 'max';

binmode STDIN;

my @cnt = (0) x 256;      # Byte-Häufigkeiten
my %runlen;               # Histogramm der Kettenlängen

my $prev;
my $run = 0;
my $have_prev = 0;

while ( read(STDIN, my $buf, 8192) ) {
    my $len = length($buf);
    for my $i (0 .. $len-1) {
        my $c = substr($buf, $i, 1);
        my $b = ord($c);
        $cnt[$b]++;

        if ($have_prev && $b == $prev) {
            $run++;
        } else {
            # alte Kette abschließen
            $runlen{$run}++ if $have_prev && $run > 0;
            $run = 1;
            $prev = $b;
            $have_prev = 1;
        }
    }
}

# letzte Kette abschließen
$runlen{$run}++ if $have_prev && $run > 0;

# Ausgabe Byte-Histogramm
print "Byte-Histogramm:\n";
for my $b (0..255) {
    next unless $cnt[$b];
    printf "%3d 0x%02X %10d\n", $b, $b, $cnt[$b];
}

# Ausgabe Run-Length-Histogramm
print "\nRun-Length-Histogramm (Längen gleicher Byte-Ketten):\n";
my $max_run = max(keys %runlen) || 0;
for my $l (sort { $a <=> $b } keys %runlen) {
    printf "L=%6d : %10d\n", $l, $runlen{$l};
}
print "\nMaximale Kettenlänge: $max_run\n";
