package Iter;

use 5.006;
use strict;
use warnings;

use Carp;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(iter counter value VALUE key KEY get) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

our $VERSION = '0.01.05';

# Preloaded methods go here.

our @result;

sub _KEY { 0 }
sub _VALUE { 1 }
sub _COUNT { 2 }

sub iter
{
	my $cnt = 0;
	
	my $ref_data = shift;
	
	@result = ();

	unless( @_ )
	{
		if( ref $ref_data eq 'HASH'  )
		{		
			while ( my ($key, $value ) = each %{ $ref_data } )
			{
				my $obj = [];
				
				@$obj[ _KEY, _VALUE, _COUNT ] = ( $key, $value, $cnt );
				
				push @result, bless $obj, __PACKAGE__;
				
				$cnt++;
			}
		}
		elsif( ref $ref_data eq 'ARRAY' )
		{				
			@result = ();
			
			foreach my $value ( @$ref_data )
			{
				my $obj = [];
				
				@$obj[ _VALUE, _COUNT ] = ( $value, $cnt );
														
				push @result, bless $obj, __PACKAGE__;
				
				$cnt++;
			}
		}
		else
		{
			croak "iter() only accepts reference to ARRAY or HASH";
		}
	}
	else
	{
		croak "iter() only accepts one parameter (reference to ARRAY or HASH)";
	}
	
return @result;  
}

sub counter
{
	my $this = shift || $_;

	$this = shift unless ref $this eq __PACKAGE__;
	
return $this->[_COUNT];
}

sub value
{
	my $this = shift || $_;

	$this = shift unless ref $this eq __PACKAGE__;

return $this->[_VALUE];
}

sub VALUE { value( @_ ) }

sub key
{
	my $this = shift || $_;

	$this = shift unless ref $this eq __PACKAGE__;

return $this->[_KEY];
}

sub KEY { key( @_ ) }

sub getvalue
{
	my $pos = shift || -1;

return $result[$pos]->[_VALUE];
}

sub get
{
	my $pos = shift || -1;

return $result[$pos];
}

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

Iter - easily iterate over a hash/array

=head1 SYNOPSIS

use Iter qw(:all);
	
my @days = qw/Mon Tue Wnd Thr Fr Su So/;

	foreach ( iter \@days )
	{		
		printf "Day: %s [%s]\n", VALUE, counter;
	}

	foreach my $i ( iter \@days )
	{		
		printf "Day: %s [%s]\n", $i->VALUE, $i->counter;
	}

my %numbers = ( 1 => 'one', 2 => 'two', 3 => 'three', 4 => 'four' );

	foreach ( iter \%numbers )
	{	
		printf "%10s [%10s] %10d\n", key, value, counter;
	}

	foreach my $i ( iter \%numbers )
	{	
		printf "%10s [%10s] %10d\n", $i->key, $i->value, $i->counter;
	}

	foreach ( iter \%numbers )
	{	
		printf "%10s [%10s] %10d\n", KEY, VALUE, counter;
	}


=head1 DESCRIPTION

Iter provides functions for comfortably iterating over perl data structures.

=head2 iter

Accepts a reference to an ARRAY or HASH. Returns a sorted list of 'Iter' objects.

=head2 key() or KEY()

Returns the current key (HASHs only).

=head2 value() or VALUE()

Returns the current value.

=head2 counter()

Returns the current counter (starting at 0).

=head2 getvalue( index )

Returns the value at index. It behaves like an array index.

=head2 get( index )

Returns the Iter object at index. It behaves like an array index.

CAVE: Future variables are read-only ! It is the common "foreach( @something ) not change during iteration through it" story.

Example: 

	get(-1) will return the last iterator object. 
	
	get(-1)->value will return the position of the last

	get(-1)->value will return the value of the last
	
	get(1+counter) will return the next object

=head2 BUGS

Not get(counter+1), but get(1+counter) will function correctly (under perl 5.6.0).

And get(counter - 1) does not work.
	
=head2 EXPORT

none by default.

all: iter counter value VALUE key KEY get

=head1 AUTHOR

M. Ünalan, E<lt>muenalan@cpan.orgE<gt>

=head1 SEE ALSO

L<Class::Iter>, L<Tie::Array::Iterable>, L<Object::Iterate>

=cut
