#!/usr/bin/perl -w

# assumes this file is in appropriate placement (see /<root>/MANIFEST)
# /<root>/etc/devel/staging/../../../lib = /<root>/lib
use lib '../../../lib';
use Autox::Config;
use File::Slurp::Tiny;
use Path::Class::Dir;


my $y = Path::Class::Dir->new($ENV{HOME}, "tmp","test","config","values");
my @dirs = ();

for (my $idx=0; $idx < $y->dir_list; $idx++)
{
	push @dirs, Path::Class::Dir->new($y->dir_list(0,$idx))->stringify ;
}




my $x = Autox::Config->new("/tmp/testconfig");

my %values = $x->read_config_values("axbe_aliases");

print "$_\n" for %values;


















