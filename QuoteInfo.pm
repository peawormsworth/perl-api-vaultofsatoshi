package VaultofSatoshi::QuoteInfo;
use base qw(VaultofSatoshi::Request);
use strict;

use constant URL           => 'https://api.vaultofsatoshi.com/info/quote';
use constant ATTRIBUTES    => qw(order_currency payment_currency type units price);

sub order_currency    { my $self = shift; $self->get_set(@_) }
sub payment_currency  { my $self = shift; $self->get_set(@_) }
sub type              { my $self = shift; $self->get_set(@_) }
sub units             { my $self = shift; $self->get_set(@_) }
sub price             { my $self = shift; $self->get_set(@_) }
sub url               { URL        }
sub attributes        { ATTRIBUTES }
sub is_ready_to_send  {
    my $self = shift;
    return defined $self->type
       and defined $self->units
       and defined $self->price
       and defined $self->order_currency
       and defined $self->payment_currency;
}

1;

__END__

