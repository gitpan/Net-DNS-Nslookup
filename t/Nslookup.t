use Test::More tests => 1;
BEGIN { use_ok('use Net::DNS::Nslookup') };

use strict;
use Net::DNS::Nslookup;

my $nslookup = Net::DNS::Nslookup->get_ips("www.google.com");
print "$nslookup\n";

exit(0);