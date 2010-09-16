use Net::Telnet ();
$t = new Net::Telnet( Timeout => 15 );
my $address  = 0x01;
if ($ARGV[0] =~ /\d{1,2}/ ) {
        $address = $ARGV[0];
        }else {
                print "Missing unit number\n";
                        exit;
                        }
                        my $function = 0x26;
my $data     = 0x00;
my ($sum)    = ( $address + $function + $data );
$t->open( Host => "127.0.0.1", Port => 2009 );
@lines = $t->print( chr($address), chr($function), chr($data), chr($sum) );
$line = $t->getline;
$line2 =  $t->getline;
$t->close;
$line = $line . $line2;
@bytes = split( //, $line );
foreach (@bytes) {
    $lastone    = ord($_);
    $newcalcsum = $newcalcsum + $lastone;
}
$newcalcsum = $newcalcsum - $lastone;
$newcalcsum = ( $newcalcsum | 0xff00 ) - 0xff00;

if ( $newcalcsum == $lastone ) {

    my $floor_status   = $bytes[3] >> 7;
    my $preheat        = ( $bytes[3] >> 4 ) & 0x07;
    my $week           = $bytes[3] & 0x0F;
    my $hour           = ord( $bytes[4] );
    my $minute         = ord( $bytes[5] );
    my $temp           = ord( $bytes[6] );
    my $switching_diff = ord( $bytes[7] ) >> 4;
    my $part_no        = ord( $bytes[7] ) % 0x0F;
    my $tempformat     = ord( $bytes[8] ) & 0x01;
    my $frost_mode     = ord( $bytes[8] ) & 0x02;
    my $sensor         = ord( $bytes[8] ) & 0x04;
    my $floor_limit    = ord( $bytes[8] ) & 0x08;
    my $output         = ord( $bytes[8] ) & 0x10;
    my $frost_protect  = ord( $bytes[8] ) & 0x20;
    my $keys_locked    = ord( $bytes[8] ) & 0x40;
    my $state          = ord( $bytes[8] ) & 0x80;
    my $set_temp       = ord( $bytes[9] );
    my $frost_temp     = ord( $bytes[10] );
    my $output_delay   = ord( $bytes[11] );
    my $floor_temp     = ord( $bytes[12] );

   #print $line . "\n";
   # print "Floor Status " . ( ($floor_status) ? "ON\n" : "OFF\n" );
   # print "Pre-heat " .     ( ($preheat)      ? "ON\n" : "OFF\n" );
    print "Switching Diff $switching_diff\n";
  #  print "Time " . $hour . ":" . $minute;
  #  print "Part No $part_no\n";
    print "Temp Format " . ( ($tempformat) ? "F\n" : "C\n" );
    print "Frost Mode " . ( ($frost_mode)  ? "ENABLED\n" : "DISABLED\n" );
    print "Keys " .       ( ($keys_locked) ? "LOCKED\n"  : "UNLOCKED\n" );
    print "Temp = $temp\n";
    print "Set Temp = $set_temp Frost Temp = $frost_temp\n";
    print "Output delay = $output_delay\n";
    print "Frost Protect " . ( ($frost_protect) ? "ON\n" : "OFF\n" );
    print "State " .         ( ($state)         ? "ON\n" : "OFF\n" );
    print "Output " .        ( ($output)        ? "ON\n" : "OFF\n" );
}
else {
    print "Checksum Error\n";
    foreach (@bytes) {
      print  ord($_) . " ";
    }
}