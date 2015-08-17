#!/usr/bin/perl

use warnings;
use strict;
use v5.16;

use Term::ReadLine;
use Term::ReadKey;

use Path::Class;
use Path::Class::Dir;
use Path::Class::File;
use Cwd;
use Getopt::Long qw ! :config no_ignore_case !;

$|++;

my $verbose     = 0;
my $gentags     = 0;
my $killbackups = 0;

GetOptions(
	'verbose|v' => \$verbose,
	'cleanup|c' => \$killbackups,
	'tags|t'    => \$gentags,
);

my $level = 0;
chdir $ENV{AX_BASE} or die "Can't locate default autox path, please set AX_BASE! (or reinstall autox)";

sub readsub {
	my $startdir = shift;
	my $allfiles = shift;
	
	$startdir //=  '.';
	$allfiles //= 0;

	my @filenames = ();
	if ( -d $startdir ) {
		chdir $startdir;
		for (<* .*>) {
			unless ( /^\.\.$/ or /^\.$/ ) {
				$level++;
				unshift @filenames, readsub( $_, $allfiles ) if -d;
				$level--;
				unshift @filenames, Cwd::fast_abs_path($_) unless -d;
			}
		}
	}

	chdir ".." if $level;

	if ( $level || $allfiles ) {
		@filenames;
	}
	else {
		grep {
			my $f  = Path::Class::File->new($_);
			my $rv = 1;
			for ( $f->components() ) {
				$rv = 0 if /.git/ || /^[A-Z]+$/ || /\.save$/ || /~$/;
			}
			$rv && !-d;

		} @filenames;
	}
}
sub gentree
{
	print for (<*/>)
	
}


if ($gentags) {

	my @ctagargs = ( 'ctags', readsub );
	push @ctagargs, "-V" if $verbose;
	say "command line: @ctagargs" if $verbose;
	say "current dir: " . cwd;
	system @ctagargs;
}
if ($killbackups) {
	say "cleaning up backups...";
	my @files =  grep { /\.save\z/ || /~\z/ } readsub('.',1);
	say for @files;
	while ( Term::ReadKey )
	{
		
	}


}

