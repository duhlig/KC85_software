#!/usr/bin/perl
use strict;
use warnings;

my $t = 0; # 1: Bereich mit Testcode

while (<>) {
    $t = 1 if /\(\*<T\*\)/;
    print unless ($t);
    $t = 0 if /\(\*T>\*\)/;
}
