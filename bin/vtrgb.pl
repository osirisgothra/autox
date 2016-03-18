#!/usr/bin/perl

use warnings;
use strict;
use v5.18;
use Getopt::Long;





print STDERR "generating a linear color palette...\n";
my @r = ( 0,170,0,170,0,170,0,170,85,255,85,255,85,255,85,255 );
my @g = ( 0,0,170,85,0,0,170,170,85,85,255,255,85,85,255,255 );
my @b = ( 0,0,0,0,170,170,170,170,85,85,85,85,255,255,255,255 );


# Translation Table
# IMPORTANT: DO NOT CHANGE THE NUMBERS ON THE LEFT!
#            because they are the source numbers used above!
#            (unless you change those, in which case you dont need to use
#             this table and would set the 'use' value to '0'
my %translators = (	use => 1, 	  # use this table? (0=no 1=yes)
					170 => 152,   # used for darker values
					85  => 96,    # used as hue-softening component and black level on bright parts
				   	255 => 250, ); # used for lighter values

# do translating
if ($translators{use})
{
    for my $key (keys %translators) 
    {
        if ( $key ne "use" )
        { 
            for my $v (@r, @g, @b)
            {
                if ($v == $key) 
                {
                    $v = $translators{$key};
                }
                
            }
        }   
    }
}
else
{
    warn "not using the conversion table (use set to 0)";
}
# output table, so we can see it (or write it)

print "$_ " for @r; print "\n";
print "$_ " for @g; print "\n";
print "$_ " for @b; print "\n";





				