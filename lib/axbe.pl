=head1 NAME

	axbe - AX Blind Editor

=head1 SYNOPSIS

	axbe [options] [file ...]
	 Options:
	   -help            brief help message
	   -man             full documentation

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=item B<-list>

Lists files (and B<aliases>) available for edit through this utility.

=back

=head1 DESCRIPTION

B<axbe> will read the given input file(s) and blindly launch your favorite editor on the contents thereof.
If you do not specify your favorite editor (in environment variable AXBE_EDITOR) then a hard-coded default will be
searched for, see HARD CODED EDITORS below.

=head1 ALIASES

If configured in autoxrc, aliases can be used for your favorite files. Some filenames which are included in autox
are already listed there.

=over 8

=item The alias format is simply:

=over 8

=item aliasname=filename.ext

=back
=back

You must place the aliases under the configuration [axbe_aliases]. If you do not do this, they will be ignored. Also, you must make sure you use the ENTIRE filename including the extension. This is to disambiguate future aliases or components that would be mistaken for. Generally speaking, "fuzzy" finding is limited to the command line because it has the effect of allowing the user to type less. In the configuration file, typing less is not an issue since it only needs to be done one time for each file.


=cut

use warnings;
use strict;
use v5.16;
use Getopt::Long;
use Pod::Usage;
use Path::Class;
use File::Which;
use Autox::Config;    # lives with axbe.pl's root dir
use File::Find;
use File::Listing;

use Term::UI;
use Term::ReadLine;
my $term = Term::ReadLine->new($ENV{TERM} // "linux");


# VARIABLES

sub absolute_env {

	# parameters
	# needed for komodo and other ide's calltips
	my $name = shift;

	# subroutine
	my $value        = $ENV{$name}      // "";
	my $missing_link = readlink($value) // $value;
	return $missing_link if -d $missing_link;
	return undef;
}

sub unshift_if_exec {
	my $envitem = shift;
	my $listref = shift;

	my $transitem = absolute_env("AX_EDITOR");
	if ( defined $transitem ) {
		unshift @{$listref}, $transitem if -x $transitem;
	}

}

my @hardcoded_editors =  ( 'editor', 'vim', 'emacs', 'jed', 'nano', 'pico', 'vi', 'ed', 'edit' );
unshift_if_exec( "AX_EDITOR", \@hardcoded_editors );
my $backupsfound = 0;
my @foundbackups = ();
my $editorpath;
my $man       = 0;
my $help      = 0;
my $myname    = $0;
my $axbasedir = Path::Class::Dir->new( absolute_env("AX_BASE") // "" );
my $axbase    = $axbasedir->stringify();
my $axconf    = Path::Class::Dir->new( $axbase, "config" )->stringify();
my $list 	  = 0;
my %aliases   = ( );

# COMMAND LINE

GetOptions(
	'editor|e' => \$editorpath,
	'list|l' => \$list,
	'help|?' => \$help,
	man      => \$man,
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -exitstatus => 0, -verbose => 2 ) if $man;

=head1 HARD CODED EDITORS

 editors to look for in the path
 the reason they are hardcoded is as explained:

=over 8

=item B<editor>

Usually guarenteed by /etc/alternatives via /usr/bin/editor

=item B<vim>

Default installed on many freeware operating systems

=item B<emacs,jed,nano,pico>

Most popular choices to be used instead of /etc/alternatives/editor

=item B<vi,ed>

Guarenteed to be on any *nix distribution, and mac osx.

=item B<edit>

Guarenteed to be on most nonstandard operating systems, and any Windows Operating
system. It is also available on most unix based systems, however unlikely it would
be used since it is the last resort editor.if (-x)	{

=back

The above editors need to be in  your path!

=cut

# PRE-LAUNCH CHECKS

die "Insufficient arguments, you need to specify a name or name(s).\n"
  unless @ARGV > 0;
die "This library requires AX to be running.\n" unless -d $ENV{AX_BASE};
die "autox (AX) is not configured, please configure it first\n"
  unless -r $axconf;
die "This program is mislocated, please reinstall"
  unless <../lib/lib.id>
  and <lib.id>
  and <../lib/$0>;    # must be in /lib and have a lib.id

# CONFIGURATION HANDLERS

my $axconfig = Autox::Config->new($axconf);
# add your own extensions or prefix names here
my $unwantedfiles = qr!((?<dot>[.])(?<extensions>id|dat|act)\z|\A(?<prefixes>apt|make))!; 

unless ( -r -f -x ($editorpath) || -r -f -x ($editorpath = $axconfig->read_config_value("axbe","editor","")))
{
	for (@hardcoded_editors)
	{
		$_ = which($_) // $_;
		$editorpath = $_ and last if -x;
	}
}
else {
	say "using editor: $editorpath"
}

die
"Cannot continue, no executable editor can be located, neither in your PATH or in AX_EDITOR environment variable!"
  unless -x $editorpath;


# FILEDIR TREE READER

my @files      = @ARGV;
my @foundfiles = ();
my @okbasedirs =  qw < alias bootstrap.d config templates data env bind completers func prof >;
my @dirloc =  ( $axbase  );

find(
	 {
			wanted =>
			sub
			{
				my $name = $File::Find::name;

				for (@okbasedirs)
				{
					if ($name =~ /$_/ && -f $name) {

						$name = file($name)->basename;

						for my $file (@files)
						{

							if ($name =~ /$file/ )
							{
								if ( $name =~ /.*(\.save|~)$/ )
								{
									$backupsfound = 1;
									print "not editing backup file: $name\n";
									push @foundbackups, $File::Find::name;
								}
								elsif ( $name =~ $unwantedfiles )
								{
									print "skipping unwanted file '$name' (pattern = $unwantedfiles)\n"; 
								}
								else
								{
									push @foundfiles, $File::Find::name;
									last;
								}
							}
						}
					}
				}
			},
			follow_fast => 1,
		}, @dirloc
);
if (@foundfiles)
{
	print "Found files in tree, processing...\n";
	print "$_\n" for @foundfiles;
	my $response;	# NOTE: used by the next two prompt parts (but are not related)

	if ($backupsfound) 
	{
		while(1) 
		{
			print "Found $#foundbackups in tree, remove them now? [type 'y' or 'n']: ";
			chomp ( $response = <STDIN> );
			if ($response eq 'y')
			{
				system $ENV{AX_BASE} . "/lib/gentags.pl","--cleanup";
				last;
			}
			elsif ($response eq 'n')
			{
				print "NOT deleting backup, continuing...\n";
				last;
			}
			else
			{
				print "Invalid choice!\n";
			}
		}
	}
	
	if (@foundfiles > 1)
	{
		$response = $term->get_reply(
			prompt => "Found more than one file matching that criteria, please pick one:",
			choices => [ @foundfiles ],
			default => $foundfiles[0],
		);
	}
	else
	{
		$response = $foundfiles[0];
	}
	
	system $editorpath,$response;	

}
else
{
	print "No files found to edit. Please try again";
}
