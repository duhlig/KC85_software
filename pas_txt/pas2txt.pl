#!/usr/bin/perl
# Zweck: Konvertieren von KC-Pascal-Dateien (.pas mit CAOS-Vorblock) in Text
# Autor: Dietmar Uhlig
# Version: 1.0
# letzte Aenderung: 19.2.2023
#
# Aufruf: pas2txt.pl DATEINAME
# Der Text wird auf STDOUT ausgegeben.

use strict;

use constant {   # Zustaende der Auswerteschleife
    ZLNRLO => 0,
    ZLNRHI => 1,
    ANZL   => 2,
    QTXT   => 3
};

my $pas;              # Name der Pascal-Datei
my $b;                # eingelesenes Byte
my $bb;               # Zahlenwert des Bytes
my $z;                # Zustand der Auswerteschleife
my ($znr, $znr_vor);  # aktuelle und vorherige Zeilennummer


($pas = shift @ARGV) or die "ERROR: Parameter Pacal-Datei fehlt.\n";
die "ERROR: Datei $pas nicht gefunden.\n" if not -r $pas;

open PAS, '<:raw :bytes', $pas or die;
seek(PAS, 0x80, 0); # Vorblock ueberspringen

$z = ZLNRLO;
$znr_vor = 0;

while (read PAS, $b, 1) {
    $bb = ord($b);
    if ($z == ZLNRLO) {
	$znr = $bb;
	$z = ZLNRHI;
    } elsif ($z == ZLNRHI) {
	$znr += $bb << 8;
	last if ($znr == 0);
	print("WARNING: Zeilennummer nicht aufsteigend. Dateiende?\n")
	    if $znr <= $znr_vor;
	$znr_vor = $znr;
	printf("%5d ", $znr);
	$z = ANZL;
    } elsif ($z == ANZL) {
	print " " x $bb;
	$z = QTXT;
    } elsif ($z == QTXT) {
	if    ($bb == 0x0d) { print "\n";  $z = ZLNRLO; }
	elsif ($bb >= 0x20 and $bb <= 0x7f) {  print $b; }
	elsif ($bb == 0x81) { print "PROGRAM";   }
	elsif ($bb == 0x82) { print "DIV";       }
	elsif ($bb == 0x83) { print "CONST";     }
	elsif ($bb == 0x84) { print "PROCEDURE"; }
	elsif ($bb == 0x85) { print "FUNCTION";  }
	elsif ($bb == 0x86) { print "NOT";       }
	elsif ($bb == 0x87) { print "OR";        }
	elsif ($bb == 0x88) { print "AND";       }
	elsif ($bb == 0x89) { print "MOD";       }
	elsif ($bb == 0x8a) { print "VAR";       }
	elsif ($bb == 0x8b) { print "OF";        }
	elsif ($bb == 0x8c) { print "TO";        }
	elsif ($bb == 0x8d) { print "DOWNTO";    }
	elsif ($bb == 0x8e) { print "THEN";      }
	elsif ($bb == 0x8f) { print "UNTIL";     }
	elsif ($bb == 0x90) { print "END";       }
	elsif ($bb == 0x91) { print "DO";        }
	elsif ($bb == 0x92) { print "ELSE";      }
	elsif ($bb == 0x93) { print "REPEAT";    }
	elsif ($bb == 0x94) { print "CASE";      }
	elsif ($bb == 0x95) { print "WHILE";     }
	elsif ($bb == 0x96) { print "FOR";       }
	elsif ($bb == 0x97) { print "IF";        }
	elsif ($bb == 0x98) { print "BEGIN";     }
	elsif ($bb == 0x99) { print "WITH";      }
	elsif ($bb == 0x9a) { print "GOTO";      }
	elsif ($bb == 0x9b) { print "SET";       }
	elsif ($bb == 0x9c) { print "ARRAY";     }
	elsif ($bb == 0x9d) { print "FORWARD";   }
	elsif ($bb == 0x9e) { print "RECORD";    }
	elsif ($bb == 0x9f) { print "TYPE";      }
	elsif ($bb == 0xa0) { print "IN";        }
	elsif ($bb == 0xa1) { print "LABEL";     }
	elsif ($bb == 0xa2) { print "NIL";       }
	elsif ($bb == 0xa3) { print "PACKED";    }
	else                { printf("\\%.2X", $bb); }
    }
}
if ($z != ZLNRHI) { print "\n"; }
close PAS;
exit 0;
