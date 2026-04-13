#!/usr/bin/env perl
use strict;
use warnings;
binmode STDIN;

my @cnt = (0) x 256;

while ( read(STDIN, my $buf, 8192) ) {
    my $len = length($buf);
    for my $i (0 .. $len-1) {
        $cnt[ ord(substr($buf, $i, 1)) ]++;
    }
}

for my $b (0..255) {
    printf "%3d 0x%02X %10d\n", $b, $b, $cnt[$b];
}
