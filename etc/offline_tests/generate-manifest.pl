#!/usr/bin/perl -w

use strict;
use v5.16;
use File::Slurp;
use Cwd;


my %zonedata = qw();
my $desclen = 20;
my $fmt = "%${desclen}s %-${desclen}s\n";
my $MYDIR = undef;
my @zones = ( );
my $cols = int( $ENV{COLUMNS} // 80 ); 

opendir($MYDIR, ".") or die("cant open directory: $!");

@zones = grep { /^zone[0-9]+$/ } readdir( $MYDIR );
closedir $MYDIR;
sub hr() {	printf($fmt,('-' x $desclen) , ('-' x ( $cols - $desclen - 1 ))); }

################### get zone info

for ( @zones )
{
	my @zonelines = File::Slurp::read_file( $_ . '/' . $_ . '.txt');
	chomp(@zonelines);
	$zonedata{$_} = $zonelines[0];
}

################# show info

hr();
printf($fmt , 'Zone Name' , 'Description(s)');
printf($fmt , 'File Listing','(Comments)');
hr();
for (keys %zonedata)
{	
	printf($fmt , $_ , $zonedata{$_});
	chdir $_;
	for (`ls -C1`) {
	chomp;
	printf($fmt, "+--",$_);
	}
	printf($fmt,"","");
	
	chdir "..";
}
hr();

my $PWD = getcwd;

say "creating/updating manifest...";
write_file("MANIFEST",`ls $PWD -RC1`);
