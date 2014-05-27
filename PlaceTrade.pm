package VaultofSatoshi::PlaceTrade;
use base qw(VaultofSatoshi::Request);
use strict;

use constant URL        => 'https://api.vaultofsatoshi.com/trade/place';
use constant ATTRIBUTES => qw(type order_currency units payment_currency price);

sub type              { my $self = shift; $self->get_set(@_) }
sub order_currency    { my $self = shift; $self->get_set(@_) }
sub units             { my $self = shift; $self->get_set(@_) }
sub payment_currency  { my $self = shift; $self->get_set(@_) }
sub price             { my $self = shift; $self->get_set(@_) }
sub url               { URL        }
sub attributes        { ATTRIBUTES }
sub is_ready_to_send  { 
    my $self = shift;
    return defined $self->type
       and defined $self->order_currency
       and defined $self->units
       and defined $self->payment_currency
       and defined $self->price;
}

1;

__END__

