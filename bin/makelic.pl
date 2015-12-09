#!/usr/bin/env perl

use warnings;
use strict;
use Getopt::Long;
use Pod::Usage qw ! pod2usage !;
use v5.18;
use File::Slurp;
use Time::Piece;
use Term::ANSIColor;

use Term::ANSIColor 2.00 qw(:pushpop);
print PUSHCOLOR RED ON_GREEN "This text is red on green.\n";
print PUSHCOLOR BRIGHT_BLUE "This text is bright blue on green.\n";
print RESET BRIGHT_BLUE "This text is just bright blue.\n";
print POPCOLOR "Back to red on green.\n";
print LOCALCOLOR GREEN ON_BLUE "This text is green on blue.\n";
print "This text is red on green.\n";
{
	local $Term::ANSIColor::AUTOLOCAL = 1;
	print ON_BLUE "This text is red on blue.\n";
	print "This text is red on green.\n";
}
print POPCOLOR "Back to whatever we started as.\n";

my $LIBNAME                = "<library-name>";
my $LIBDESC                = "<desc-of-lib>";
my $COMPANY_DISCLAIMED     = "Sew Paw Bras, Inc";
my $COMPANY_DISCLAIMED_REP = "Sue Pervisor";
my $COMPANY_DISCLAIMED_REP_DATE =
  Time::Piece->new()->strftime();    # defaults to 'now'
my $COMPANY_DISCLAIMED_REP_POS = "Sue Pervisor - Supervisor";
my $PROGNAME                   = "Unknown";
my $PROGDESC                   = "Unknown";
my $AUTHORNAME                 = "Gabriel Sharp";
my $AUTHOREMAIL                = 'osirisgothra@hotmail.com';
my $PRESET                     = undef;
my $MAN_HELP                   = 0;
my $HELP                       = 0;
my $COMMENT                    = '';
my $COMMENT_END                = '';
my $SLCOMMENT                  = '';
my $MLASSIGNER                 = '';
my $MLASSIGNER_END             = '';
my $YEAR                       = ( localtime() )[5] + 1900;
my %presets                    = (
	"c"      => [ "/*",  "*/",  "",  "char* aboutstr=\"", "\";" ],
	"python" => [ '"""', '"""', "",  "aboutstr='''",      "'''" ],
	"perl"   => [ '#',   '#',   '#', 'my $aboutstr="',    '";' ],
	"sh"     => [ '#',   '#',   '#', "ABOUTSTR='",        '"' ],
	"html"   => [
		'<!--', '-->', '*** ',
		"<script><!--\nvar aboutstr='",
		"'; -->\n</script>"
	],
	"jscript" => [ '//', '//', '//', "var aboutstr='", "';" ],
);
my $LICENSE = "gpl3";

# language presets
sub setpresetvars(@) {

	# my COMMENT = shift;
	$COMMENT        = shift;
	$COMMENT_END    = shift;
	$SLCOMMENT      = shift;
	$MLASSIGNER     = shift;
	$MLASSIGNER_END = shift;
}

sub selectpreset($) {
	my $prs     = shift;
	my @presetv = @{ $presets{$prs} };
	setpresetvars @presetv;

}

Getopt::Long::GetOptions(
	"name|n=s"         => \$PROGNAME,
	"desc|d=s"         => \$PROGDESC,
	"author|a=s"       => \$AUTHORNAME,
	"email|m=s"        => \$AUTHOREMAIL,
	"year|m=n"         => \$YEAR,
	"preset|p=s"       => \$PRESET,
	'help|h|?'         => \$HELP,
	'man|manpage|m|??' => \$MAN_HELP,
	'license|l=s'      => \$LICENSE,
	"company|C=s"      => \$COMPANY_DISCLAIMED,
	"representor|R=s"  => \$COMPANY_DISCLAIMED_REP,
	"rep-signdate|S=s" => \$COMPANY_DISCLAIMED_REP_DATE,
	"rep-position|P=s" => \$COMPANY_DISCLAIMED_REP_POS,
	"libname|L=s"      => \$LIBNAME,
	"libdesc|l=s"      => \$LIBDESC,
);

pod2usage(1) if $HELP;
pod2usage( -exitstatus => 0, -verbose => 2 ) if $MAN_HELP;

selectpreset($PRESET) unless !defined($PRESET);

my $FILENAME = "" if !@ARGV;
$FILENAME = shift @ARGV if @ARGV > 0;

warn "Too many arguments!!" if (@ARGV);

my %licenses = (
	gpl3 => "$COMMENT
$SLCOMMENT
$SLCOMMENT 	$PROGNAME - $PROGDESC
$SLCOMMENT 	Copyright (C) $YEAR $AUTHORNAME <$AUTHOREMAIL>
$SLCOMMENT
$SLCOMMENT 	This program is free software: you can redistribute it and/or modify
$SLCOMMENT 	it under the terms of the GNU General Public License as published by
$SLCOMMENT 	the Free Software Foundation, either version 3 of the License, or
$SLCOMMENT 	(at your option) any later version.
$SLCOMMENT
$SLCOMMENT 	This program is distributed in the hope that it will be useful,
$SLCOMMENT 	but WITHOUT ANY WARRANTY; without even the implied warranty of
$SLCOMMENT 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
$SLCOMMENT 	GNU General Public License for more details.
$SLCOMMENT
$SLCOMMENT 	You should have received a copy of the GNU General Public License
$SLCOMMENT 	along with this program.  If not, see <http://www.gnu.org/licenses/>.
$SLCOMMENT
$COMMENT_END

$MLASSIGNER
	$PROGNAME Copyright (C) $YEAR $AUTHORNAME	
	This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
	This is free software, and you are welcome to redistribute it
	under certain conditions; type `show c' for details.
$MLASSIGNER_END
",

	lgpl2 => "$COMMENT
$SLCOMMENT
$SLCOMMENT $PROGNAME - $PROGDESC
$SLCOMMENT Copyright (C) $YEAR $AUTHORNAME <$AUTHOREMAIL>
$SLCOMMENT
$SLCOMMENT Your Rights are Protected by the GNU LGPL 2.1 LICENSE
$SLCOMMENT
$SLCOMMENT This library is free software; you can redistribute it and/or
$SLCOMMENT modify it under the terms of the GNU Lesser General Public
$SLCOMMENT License as published by the Free Software Foundation; either
$SLCOMMENT version 2.1 of the License, or (at your option) any later version.
$SLCOMMENT
$SLCOMMENT This library is distributed in the hope that it will be useful,
$SLCOMMENT but WITHOUT ANY WARRANTY; without even the implied warranty of
$SLCOMMENT MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
$SLCOMMENT Lesser General Public License for more details.
$SLCOMMENT
$SLCOMMENT You should have received a copy of the GNU Lesser General Public
$SLCOMMENT License along with this library; if not, write to the Free Software
$SLCOMMENT Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
$SLCOMMENT
$COMMENT_END

$MLASSIGNER
	$PROGNAME Copyright (C) $YEAR $AUTHORNAME	
	$COMPANY_DISCLAIMED, hereby disclaims all copyright interest in
	the library `$LIBNAME' ($LIBDESC) written
	by $AUTHORNAME.

	signature of $COMPANY_DISCLAIMED_REP, $COMPANY_DISCLAIMED_REP_DATE
	$COMPANY_DISCLAIMED_REP_POS
$MLASSIGNER_END
",
);

my $LICENSE_TEXT = $licenses{$LICENSE};
print $FILENAME;

if ( $FILENAME ne "" ) {
	File::Slurp::write_file( $FILENAME, $LICENSE_TEXT );
}
else {
	print $LICENSE_TEXT;
}

__END__

=head1 NAME

	makelic - generate GNU GPL 3 (and soon others) BETA!!

=head1 SYNOPSIS

	makelic [options]
	 Options:
	   -help               brief help message
	   -man                full documentation
	   -preset [preset]    output language (perl, c, or python)
	   -[detail] [text]    set detail item to text, see below

=head1 OPTIONS

	detail items that can be changed in the text

						 "name|n=s" => \$PROGNAME,
						 "desc|d=s" => \$PROGDESC,
						 "author|a=s" => \$AUTHORNAME,
						 "email|m=s"=> \$AUTHOREMAIL,
						 "year|m=n" => \$YEAR,
	name		name of the program before description and copyright
	desc        description text after program (license body only)
	author      name of the author, usually your full name
	email       e-mail address, without the brackets
	year        the copyright year to use, the default is the current year

	licenses

	currently only GPL3 is supported however new licenses are planned

	languages

	c           c or c++ compatible languages (compliant at least with C89)
	perl        perl 5.0->5.18 compliant (the default, may be even earlier than 5)
	python      python 2.6-3.4 compatible code, comments as docstrings
	sh          posix shell compatible (sh compatible bash)

=head1 DESCRIPTION

B<This program> will output a license file in the specified format, for the specified
language.

=head1 LICENSE

This program's license is obtained by using the '-n makelic -d generator -y 2015'
to run the program.

=cut
