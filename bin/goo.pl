#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: goo.pl
#
#        USAGE: ./goo.pl  
#
#  DESCRIPTION: Google lookup
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Gabriel Sharp <osirisgothra@hotmail.com>
# ORGANIZATION: ---
#      VERSION: 1.0
#      CREATED: 09/19/2014 07:30:29 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use v5.14;
use Getopt::Long;
use Test::File;
use File::Spec qw(:all);
use File::Spec::Functions;
use Path::Class;

use Cwd;
use Config::General;
no warnings 'experimental';

my $term = 0;
my $help = 0;
my $appname = eval { $0 =~ s/^(.*)\/([^\/]+$)/$2/g; return $0; };
my $browserflags = "";

my @presets_etc = &get_presets( 'etc' );
my @presets_usr = &get_presets( 'home' );


my @presets_builtin = qw ^ http://images.google.com/search?q=%s
			   http://www.duckduckgo.com/?q=%s+!
                           http://www.duckduckgo.com/?q=%s
                           http://www.google.com/search?q=%s&Btni=l
			   http://www.google.com/search?q=%s ^;

my @presets = ( @presets_builtin, @presets_usr, @presets_etc );
my $preset_index = 0;
my $list_presets = 0;
my $joinexpr = '+';

GetOptions ( "term"  => \$term,
		"preset=i" => \$preset_index,
		"list-presets" => \$list_presets,
			 "help"  => \$help,
			 "joinchars=s" => \$joinexpr,
"browserflags=s" => \$browserflags,
		 )
  or die("Error in command line arguments\n");



print <<EOF
usage: $appname [--term|--help] [--preset <n> | --list-presets] [--joinchars <str>] searchterm ...
                [--browserflags [flag 1,flag 2, ... ]

	--joinchars <str>  	character(s) placed between search terms when put in the url (defaults to '+')
	--preset <n>    	Select a preset (builtin or defined in .goodirsrc or /etc/goodirs.rc 
	--list-presets 		Show the table of presets available and their corrosponding number (for use with <n>)
	--term				prioritize terminal-based browsers
 	--browserflags [flags]		quoted string of parameters to pass to browser, separated by commas (,)
	--help				this help message

EOF
and exit 0 if $help;

if ( $list_presets ) {
 for (@presets ) {
	my $i++;
	print "$i : $_ \n";
  }
 exit 0;
}

my $preset = ( $preset_index < @presets ? $presets[$preset_index] : $presets[0] );

my @browsers = qw ! surf firefox chromium google-chrome konqueror rekonq !;

splice ( @browsers,0,0,qw ! links2 links lynx !) if $term == 1;

my @paths = ( exists($ENV{PATH}) ? split(":",$ENV{PATH}) : ("/bin","/usr/bin","/usr/local/bin") );
unless (@paths) {
		print "No PATH environment variable with a valid set of paths exported, use current directory? (warning, could be unsafe!";
		$_ = <STDIN>;
		chomp;

		if (/[Yy]e?s?/) {
			push @paths, cwd();
		}
}

my $browser = undef;

OUTER: foreach my $path (@paths)
{
	 for my $curbrowser (@browsers)
	 {
		my $filename = File::Spec->catfile($path,$curbrowser);
		#say "checking $curbrowser for $path...";
		#say "(filename=$filename)";
		if ( -f $filename && -s $filename) {
			$browser = $filename;
			#say "OK: $filename";
			last OUTER;
		}
	 }
}


if ($#ARGV < 0)
{
	say "Need some arguments!"
}
else
{
	#/usr/local/bin/fcheck 
	# say "Found browser: $browser";	

	my $arg = sprintf($preset,join($joinexpr, @ARGV ));
	my $opid = $$;
	# don't fork if running in a terminal priority mode
	fork unless $term;
	if ($opid != $$ || $term) {
		close STDERR; # no errors, please
		my @params;
		@params = length($browserflags) > 0 ? split(',',$browserflags) : "";
		@params = grep /\A\S.+\S\z/, @params;
		print "params: \"$browser\" \"@params\" \"$arg\"\n";
		system $browser,@params,$arg or print "warning: command returned with an error code ($?)\n";
		print "perl warning: $!\n" if $!;
	}
	exit 0;
}

sub get_presets($)
{
	return ();
	my $kind = shift; # "etc" or "home"
	my $filespec  = Path::Class->dir("etc");
	given ($kind)
	{
		when (/etc/) {
			$filespec  = dir("etc","goo.rc");
		}
		when (/home/) {
			$filespec  = dir( $ENV{HOME}, ".goorc" );
		}
	}

	print $filespec;
	if ( -e -f -r -s $filespec )
	{
		my $cnf = Config::General->new($filespec);
		my %cdat = $cnf->getall();
		return $cdat{Browsers};

	}



}




