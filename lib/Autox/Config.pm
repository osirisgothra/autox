package Autox::Config;
use strict;
use warnings;
use v5.20;
# modules we use, internally


use Carp qw ! carp croak confess longmess shortmess !;
require Path::Class;
use File::Slurp::Tiny;
use Config::INI::Reader;
use Config::INI::Writer;


# stuff used elsewhere by Ax:: stuff

BEGIN { require Path::Class }


=head1 new(configdir)
creates a configuration object
and sets itself as a valid config, if the file is found
=cut
sub new {
    my $class = shift;
	my $self = bless {}, $class;
	my $configdir = shift or confess("configdir can not be ommitted - $!");
	my $configpath = Path::Class::Dir->new($configdir,"autoxrc")->stringify;
	$self->{configfile} = -r -f $configdir ? $configdir : -r -f $configpath ? $configpath :
	confess "configdir was not: 1) an FQPN to a readable file, or 2) a FQPN to a readable dir containing a file named 'autoxrc'";
	return $self;
}

sub read_config_values
{
	my $self = shift;
	my $section = shift;
	if (-r $self->{configfile})
	{
		chomp ( my @lines = File::Slurp::Tiny::read_lines($self->{configfile}) );
		# remove comments and aliases
		map { s/([;#].*$|^\s*|\s*$)//g } @lines;
		my @sectlines = grep { /^\s*\[$section\]\s*/ ... /^\[[^\]]+\]\s*$/ } @lines;
		# remove empty lines and the section markers
		@sectlines = grep { /[[:word:]]/ && /^[^\[\]]+$/ } @sectlines;
		my %return = ();
		for my $sect (@sectlines)
		{
			my ($key, $value) = (split(/=/,$sect,2));
			$return{$key} = $value;
		}
		%return;
		

	}
	else
	{
		carp "Can't read configuration, it's not open.\n" . Dumper($self); ();
	}

}
sub read_config_value
{
	my $self = shift;
	my $section = shift;
	my $name = shift;
	my $default = shift;
	
	my %sectionvalues = $self->read_config_values($section);
	return $sectionvalues{$name} // $default;
	
}
sub read_entire_config
{
	my $self = shift;
	my $conf = Config::INI::Reader->new($self->{configfile});
	
	
}

sub write_config_setting
{
	my $self = shift;
	my $destination = shift;


}




1;
