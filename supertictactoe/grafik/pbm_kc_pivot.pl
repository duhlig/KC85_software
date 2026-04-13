#!/usr/bin/perl
use strict;
use warnings;

sub skip_ws_and_comments {
    my ($fh) = @_;
    while (1) {
        my $c = getc($fh);
        last unless defined $c;

        if ($c eq '#') {
            while (defined($c) && $c ne "\n" && $c ne "\r") {
                $c = getc($fh);
            }
        } elsif ($c =~ /\s/) {
            next;
        } else {
            seek($fh, -1, 1) or die "seek failed: $!";
            last;
        }
    }
}

if (@ARGV != 2) {
    die "Usage: $0 in.pbm out.pbm\n";
}

my ($infile, $outfile) = @ARGV;

open my $fin, '<:raw', $infile or die "Cannot open '$infile': $!";

# Magic
read($fin, my $magic, 2) == 2 or die "Cannot read magic\n";
die "Not a P4 PBM\n" unless $magic eq "P4";

# width / height lesen
skip_ws_and_comments($fin);
my $w = '';
while (read($fin, my $ch, 1)) {
    last if $ch =~ /\s/;
    $w .= $ch;
}
$w =~ /^\d+$/ or die "Bad width\n";

skip_ws_and_comments($fin);
my $h = '';
while (read($fin, my $ch2, 1)) {
    last if $ch2 =~ /\s/;
    $h .= $ch2;
}
$h =~ /^\d+$/ or die "Bad height\n";

$w = int($w);
$h = int($h);

my $bytes_per_row_in  = int( ($w + 7) / 8 );
my $img_size_in       = $bytes_per_row_in * $h;

read($fin, my $data, $img_size_in) == $img_size_in
    or die "Failed to read image data\n";
close $fin;

# Neue Dimensionen: 8 Pixel breit, Streifen untereinander
my $new_w = 8;
my $num_stripes = int( ($w + 7) / 8 );
my $new_h = $h * $num_stripes;

my $bytes_per_row_out = int( ($new_w + 7) / 8 ); # = 1
my $img_size_out      = $bytes_per_row_out * $new_h;
my $out = chr(0) x $img_size_out;

sub get_bit {
    my ($buf, $width, $bytes_per_row, $x, $y) = @_;
    return 0 if $x < 0 || $y < 0;
    my $byte_index = $y * $bytes_per_row + int($x / 8);
    return 0 if $byte_index >= length($buf);
    my $bit_in_byte = 7 - ($x % 8); # MSB zuerst [web:1][web:5]
    my $byte = ord(substr($buf, $byte_index, 1));
    return ($byte >> $bit_in_byte) & 1;
}

sub set_bit {
    my ($bufref, $bytes_per_row, $x, $y, $val) = @_;
    return if $x < 0 || $y < 0;
    my $byte_index = $y * $bytes_per_row + int($x / 8);
    return if $byte_index >= length($$bufref);
    my $bit_in_byte = 7 - ($x % 8);
    my $byte = ord(substr($$bufref, $byte_index, 1));
    if ($val) {
        $byte |= (1 << $bit_in_byte);
    } else {
        $byte &= ~(1 << $bit_in_byte);
    }
    substr($$bufref, $byte_index, 1) = chr($byte);
}

# Mapping:
# Eingabe: Pixel (x, y), 0 <= x < w, 0 <= y < h
# Streifen-Index: stripe = x / 8
# Bit im Streifen: bit_in_stripe = x % 8
# Ausgangskoordinate:
#   new_x = bit_in_stripe (0..7)
#   new_y = stripe * h + y       (Streifen untereinander) [web:1][web:5]

for my $y (0 .. $h-1) {
    for my $x (0 .. $w-1) {
        my $bit_val = get_bit($data, $w, $bytes_per_row_in, $x, $y);

        my $stripe        = int($x / 8);
        my $bit_in_stripe = $x % 8;

        my $new_x = $bit_in_stripe;
        my $new_y = $stripe * $h + $y;

        set_bit(\$out, $bytes_per_row_out, $new_x, $new_y, $bit_val);
    }
}

open my $fout, '>:raw', $outfile or die "Cannot open '$outfile': $!";
print $fout "P4\n$new_w $new_h\n";
print $fout $out;
close $fout;

exit 0;
