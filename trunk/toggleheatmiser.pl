use Net::Telnet ();
$t = new Net::Telnet( Timeout => 15 );
my $address  = 0x01;
my $function = 0x00;
my $data = 0x00;

if ($ARGV[0] =~ /unit/i ) {
	$function = 0x82;
} elsif ($ARGV[0] =~ /Frost$/i ) {
	$function = 0xe4;
} elsif ($ARGV[0] =~ /settemp/i ) {
	$function = 0x84;
} elsif ($ARGV[0] =~ /frosttemp/i ) {
	$function = 0x87;
}else {
	print "Missing function\n";
	exit;
}

if ($ARGV[1] =~ /off/i ) {
	$data = 0x00;
} elsif ($ARGV[1] =~ /on/i ) {
	$data = 0xFF;
} elsif ($ARGV[1] =~ /\d{1,2}/ ) {
	$data = $ARGV[1];
}else {
	print "Missing data\n";
	exit;
}

if ($ARGV[2] =~ /\d{1,2}/ ) {
        $address = $ARGV[2];
}else {
        print "Missing unit number\n";
        exit;
}
                        
my ($sum)    = ( ($address + $function + $data ) | 0xff00 ) - 0xff00;
$t->open( Host => "127.0.0.1", Port => 2009 );
#print chr($address) .chr($function) . chr(0xff) . chr($sum);
@lines = $t->print( chr($address), chr($function), chr($data), chr($sum) );
$line = $t->getline;
$t->close;

@bytes = split( //, $line );

$lastone = 'fail';

foreach (@bytes) {
    $lastone    = ord($_);
    $newcalcsum = $newcalcsum + $lastone;
}
$newcalcsum = $newcalcsum - $lastone;
$newcalcsum = ( $newcalcsum | 0xff00 ) - 0xff00;

if ( $newcalcsum == $lastone ) {
    print "Success\n";
}
else {
    print "Checksum Error\n";
}
