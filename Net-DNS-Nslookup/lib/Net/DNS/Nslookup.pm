package Net::DNS::Nslookup;

# Copyright (c) 2007 Paul Grinberg. All rights reserved.
# This program is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.

use strict;
use vars qw($VERSION);
$VERSION = 0.01;

$|=1;

my $so = $^O;
my $cmd = "nslookup";
$cmd = '/usr/sbin/nslookup' if $so ne 'MSWin32';
my $flags = 'reserved_for_future_use';

sub just_ip {
    my $dnsquery = $_[1];
	my @dnsresult;
	my @just_ip;
	my $justswitch = 0;	

	my @output = `$cmd $dnsquery`;
	chomp @output;
	foreach (@output){
		push @dnsresult, "$_\n";
	}
	foreach my $dnsresultline (@dnsresult){
			if($dnsresultline =~ m/^Address/) {
				if ($justswitch == "0") {
					$justswitch = 1;
				} else {
					if($dnsresultline =~ m/^Addre(ss|sses):\s\s(.*)$/) {
						my @splitdnsresult = split(/, /, $2);
						foreach my $secsplitdnsresult (@splitdnsresult) {
							push(@just_ip, $secsplitdnsresult);
						}
					}
				}
			}
		}
	chomp @just_ip;
	return @just_ip;
}


1;
__END__

=head1 NAME

  Net::DNS::Nslookup - Perl module for getting simple nslookup output.

=head1 DESCRIPTION

  Nslookup module provides simple way to resolve DNS name to 
  IP address(es) on a local system (Linux, Win*, Mac OS X 10.3.9, Solaris).

=head1 SYNOPSIS

  use strict;
  use Net::DNS::Nslookup;
  my $dnsname = "www.google.com";
  my @nslookup = Net::DNS::Nslookup->just_ip($dnsname);
  for (@nslookup) { print "$_\n"; }
  
  Output:
	Non-authoritative answer:
	64.233.169.103
	64.233.169.147
	64.233.169.104
	64.233.169.99
	
	
  use strict;
  use Net::DNS::Nslookup;
  my @sites = ("www.google.com","www.cnn.com","www.jobs.com");
 
  foreach my $dnsname (@sites) {
  my @nslookup = Net::DNS::Nslookup->just_ip($dnsname);
  for (@nslookup) { print "$_\n"; }
  }
  
  Output:
	Non-authoritative answer:
	64.233.169.103
	64.233.169.147
	64.233.169.104
	64.233.169.99
	Non-authoritative answer:
	64.236.29.120
	64.236.91.21
	64.236.91.22
	64.236.91.23
	Non-authoritative answer:
	204.188.136.6
	204.188.136.9
	
=head1 METHODS

=head2 just_ip()

  @nslookup = Net::DNS::Nslookup->just_ip($dnsname);

  Resolve name such as www.google.com to IP address(es). 

=head1 SYSTEM REQUIREMENTS

  This module requires "nslookup" binary.  

=head1 SEE ALSO

  man nslookup

=head1 AUTHOR

  Paul Grinberg, grinberg at isrcomputing.com
  http://nsvu.blogspot.com
  http://www.isrcomputing.org
    
=head1 COPYRIGHT

  Copyright (c) 2007 Paul Grinberg. All rights reserved.
  This program is free software; you can redistribute it
  and/or modify it under the same terms as Perl itself.

=cut
