#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: picosay
#
#        USAGE: ./picosay  
#
#  DESCRIPTION: Intelligent standard cat-like behavior for pico2wave to make it 
#               be able to easily interface such programs like speech-dispatcher*
#      OPTIONS: ARGUMENTS MUST BE FILENAMES OR (nothing) TO USE STDIN (DIRECT) MODE
# REQUIREMENTS: You need to have pico2wave utility installed (ELF binary)
#               (package = libttspico0 >= 1.0 March 26,2013 release)
#               (requires you to have libc6 >= 2.4)
#         BUGS: STDIN mode needs fixed to handle file streamed input for whitespace
#               but this would break the whitespace checking when entering text
#        NOTES: *I've not written the spd modules (yet) but there are some already!
#       AUTHOR: Gabriel Thomas Sharp (gts), osirisgothra@hotmail.com
# ORGANIZATION: Paradisim Enterprises, LLC - http://paradisim.twilightparadox.com
#      VERSION: 1.0.9.14
#      CREATED: 09/25/2014 10:38:26 AM THURSDAY
#     REVISION: INITIAL
#===============================================================================

# {{{ Script Compiler Insructions
use strict;
use warnings;
use utf8;
use v5.14;
use File::Temp qw/ :mktemp /;
no warnings "experimental";
# }}}
# {{{ Variables, Init
# program name, followed by it's flags (single words only, if expanded will need quoted or embedded sublists
# note: play flags: c1 is essential for play, since pico2wave does NOT write out wav files in stereo, and 
#                      some might assume they are in stereo, this results in x2 "chipmunked" playback.
#                    q is essential for play, it tells play not to show it's fancy output while playing back, 
#                      which is annoying especially in STDIN mode (your text flies off the page in no time).
#   pico2wave flags: w is essential, this tells pico2wave the name of the file it needs to write, which MUST end 
#                      in .wav (or you'll get a not-so-descriptive error that it couldnt write to the file).
our %flags = qw ! pico2wave -w play -qc1 !;
# use to alter the program's name, change the SECOND value (ie, "pico2wave some_other_pico2wave play wave-player-of-a-different-color")
our %exec  = qw ! pico2wave pico2wave play play !;
# just shortcuts to prevent too much typing, dont change these! (and if you do, you must change their values above:
# NOTE: THIS ONLY AFFECTS THE INTERNAL HASH NAMES NOT THE PROGRAMS FOR THAT SEE THE PREVIOUS COMMENT!!)
our ($s, $p) = ( "pico2wave", "play" ); # $s = short for [s]peech program    $p = short for wave [p]layer program
our $wavfile;
# }}}
# {{{ Subroutines 
# get output from stdin if we need it to
sub diehard { die "$exec{$p} failed (on text: $_), with code $?. and file $wavfile [perl says $!]\n" };
sub speak {	
	($_) = @_ if ($#_ != -1); chomp;
	$wavfile = mktemp("picosay.wav." . "X" x 16) . ".wav";
	!system ($exec{$s},$flags{$s},$wavfile,$_)	or diehard;
	!system ($exec{$p},$flags{$p},$wavfile)	or diehard;
	unlink $wavfile or warn "\nUnable to delete the file: $wavfile\n";
}
# }}}
# {{ { MAIN PROGRAM <- MOVE { NEXT TO OR AWAY TO DISABLE THIS FOLD
# main program, making sure we take line by line for stdin, so the user doesnt have to wait to hear it after a CTRL+D (EOF) :)

given ($#ARGV)
{	when ( $_ == -1 ) 
	{	say "No arguments were given, I'll read the words from STDIN instead.\nPress EOF (Ctrl+D) to end session if you are typing this in.";
		say "-" x int(exists($ENV{"COLUMNS"}) ? $ENV{"COLUMNS"} : 80);
		while (1)
		{	chomp(my $line = <STDIN>);
			$line =~ s/[].//g; # remove any formatters (they get used alot by groff-based documents)
			say $line;		
			speak $line; } }	
	speak for <> }
exit 0;

# }}}

