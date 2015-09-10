#!/usr/bin/env perl
use v5.18;
use warnings;
use strict;
use File::Slurp;

my %zonedata = qw();
my $fmt = '%20s\t%20s\n';
my $MYDIR = undef;
my @zones = ( );

opendir($MYDIR, ".")
	or die("cant open directory: $!");

@zones = grep { /^zone[0-9]+$/ } readdir( $MYDIR );
closedir $MYDIR;

################### get zone info


chomp ( $zonedata{$_} = (File::Slurp::read_file($_ . '/' . $_ . '.txt'))[0] for @zones; )


printf($fmt , 'Zone Name' , 'Description(s)');
for (keys %zonedata)
{
	printf($fmt , $_ , $zonedata{$_});
}
printf($fmt,'-' x 20 , '-' x 20);



