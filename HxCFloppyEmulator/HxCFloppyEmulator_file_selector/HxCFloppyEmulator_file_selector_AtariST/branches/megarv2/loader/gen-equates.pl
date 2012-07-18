#!/usr/bin/perl


my $srcfileprg = "temp/depack.prg";
my $packedfn   = "temp/packed.n2b";
my $stage2fn   = "temp/stage2.bin";


my $buffer;
my $MINTSTACKOFFSET, $TEXTlen, $DATALEN, $BSSlen, $STAGE2len, $PACKlen;



open(FH, $srcfileprg)  ||  die("unable to open " . $srcfileprg . " for reading.");
binmode FH;
read(FH, $buffer, -s FH);
close(FH);

$TEXTlen = (ord(substr($buffer, 2, 1))<<24) + (ord(substr($buffer, 3, 1))<<16) + (ord(substr($buffer, 4, 1))<<8) + (ord(substr($buffer, 5, 1))<<0);
$DATAlen = (ord(substr($buffer, 6, 1))<<24) + (ord(substr($buffer, 7, 1))<<16) + (ord(substr($buffer, 8, 1))<<8) + (ord(substr($buffer, 9, 1))<<0);
$BSSlen = (ord(substr($buffer, 10, 1))<<24) + (ord(substr($buffer, 11, 1))<<16) + (ord(substr($buffer, 12, 1))<<8) + (ord(substr($buffer, 13, 1))<<0);
$MINTSTACKOFFSET = index($buffer, "\$Version: MiNTLib");
if (-1 != $MINTSTACKOFFSET) {
    $MINTSTACKOFFSET += 256;
    $MINTSTACKOFFSET -= 28;
}



open(FH, $stage2fn)  ||  ($STAGE2len = 1234);
if ($STAGE2len != 1234) {
    binmode(FH);
    read(FH, $buffer, -s FH);
    close(FH);

    $STAGE2len = length($buffer);
#    if ( 0 != (ord(substr($buffer, -1, 1)) + ord(substr($buffer, -2, 1)) + ord(substr($buffer, -3, 1)) + ord(substr($buffer, -4, 1))) ) {
#        die "$stage2fn is not pc-relative";
#    }
}

open(FH, $packedfn)  ||  die("unable to open " . $packedfn . " for reading.");
binmode(FH);
$PACKlen = -s FH;
close(FH);


print ";This file is auto-generated by gen-equates.pl DO NOT EDIT\n";
#print "MINTSTACKOFFSET = $MINTSTACKOFFSET" . "\n";
print "TEXTlen         = $TEXTlen" . "\n";
print "DATAlen         = $DATAlen" . "\n";
print "BSSlen          = $BSSlen" . "\n";
print "STAGE2len       = ($STAGE2len+1)/2*2" . "\n";
print "PACKlen         = ($PACKlen+1)/2*2" . "\n";