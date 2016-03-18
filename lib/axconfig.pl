#!/usr/bin/perl
#===============================================================================
#
#         FILE: axconfig.pl
#
#        USAGE: ./axconfig.pl
#
#  DESCRIPTION: AutoX's perl bindings for the config/autoxrc file
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Gabriel T. Sharp (etherial raine), osirisgothra@hotmail.com
# ORGANIZATION: Prolific Agnostic Research And Development Into Shared Information Media
#      VERSION: 1.0
#      CREATED: 09/30/2015 06:17:01 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use lib "/src/ax/lib";

use Autox::Config;
use Path::Class;

my $home = $ENV{HOME} // `echo ~`;
my $sysconf = Autox::Config::new( ( $ENV{AX_BASE} // '' ) . '/config/autoxrc');
my @guessdirs = qw ! /src/ax /ax /autox /usr/local/share/autox /usr/share/autox  /opt/autox !;



my $conf = Autox::Config::new($home . "/.config/autox/autoxrc");


