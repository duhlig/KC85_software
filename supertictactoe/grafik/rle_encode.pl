#!/usr/bin/perl
use strict;
use warnings;

# encode2.pl in.raw out.rle
#  - erkennt Runs von 0x00 / 0xFF mit Länge >= 4
#  - kodiert:
#      Typ0 (0x00-Run): 0LLLLLLL (Bit7=0, Länge in Bits6-0)
#      Typ1 (0xFF-Run): 10LLLLLL (Bit7=1, Bit6=0, Länge in Bits5-0)
#      Typ2 (Literal):  11LLLLLL (Bit7=1, Bit6=1, Länge in Bits5-0)
#    wobei Länge in allen Fällen 1..63 ist.

if (@ARGV != 2) {
    die "Usage: $0 in.raw out.rle\n";
}

my ($infile, $outfile) = @ARGV;

open my $fin, '<:raw', $infile or die "Cannot open '$infile': $!";
local $/;
my $data = <$fin>;
close $fin;

my $len = length($data);
my $i   = 0;

open my $fout, '>:raw', $outfile or die "Cannot open '$outfile': $!";

while ($i < $len) {
    my $b = ord(substr($data, $i, 1));

    # 1) Langer 0x00-Run?
    if ($b == 0x00) {
        my $j = $i + 1;
        while ($j < $len && ord(substr($data, $j, 1)) == 0x00) {
            $j++;
        }
        my $run_len = $j - $i;

        if ($run_len >= 4) {
            my $remaining = $run_len;
            while ($remaining > 0) {
                my $chunk = $remaining > 63 ? 63 : $remaining;
                my $header = $chunk & 0x7F;       # Bit7=0, Bits6-0=Länge
                print $fout chr($header);
                $remaining -= $chunk;
            }
            $i = $i + $run_len;
            next;
        }
        # kürzer als 4 -> als Literal behandeln
    }

    # 2) Langer 0xFF-Run?
    if ($b == 0xFF) {
        my $j = $i + 1;
        while ($j < $len && ord(substr($data, $j, 1)) == 0xFF) {
            $j++;
        }
        my $run_len = $j - $i;

        if ($run_len >= 4) {
            my $remaining = $run_len;
            while ($remaining > 0) {
                my $chunk = $remaining > 63 ? 63 : $remaining;
                my $header = 0x80 | ($chunk & 0x3F);  # 10LLLLLL
                print $fout chr($header);
                $remaining -= $chunk;
            }
            $i = $i + $run_len;
            next;
        }
        # kürzer als 4 -> als Literal behandeln
    }

    # 3) Literal-Segment aufbauen
    my $lit_start = $i;
    my $lit_len   = 0;

    while ($i < $len && $lit_len < 63) {
        my $c = ord(substr($data, $i, 1));

        # Prüfen, ob an dieser Position ein langer Run beginnen würde,
        # dann beenden wir das Literal hier, damit der Run gesondert kodiert wird.
        if ($c == 0x00) {
            my $k = $i + 1;
            while ($k < $len && ord(substr($data, $k, 1)) == 0x00) {
                $k++;
            }
            my $run_len = $k - $i;
            last if $run_len >= 4;
        } elsif ($c == 0xFF) {
            my $k = $i + 1;
            while ($k < $len && ord(substr($data, $k, 1)) == 0xFF) {
                $k++;
            }
            my $run_len = $k - $i;
            last if $run_len >= 4;
        }

        # sonst gehört das Byte zum Literal-Block
        $i++;
        $lit_len++;
    }

    if ($lit_len > 0) {
        my $chunk = substr($data, $lit_start, $lit_len);
        my $header = 0xC0 | ($lit_len & 0x3F);   # 11LLLLLL
        print $fout chr($header), $chunk;
    }
}

close $fout;
exit 0;
