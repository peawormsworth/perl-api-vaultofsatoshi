package VaultofSatoshi::Transactions;
use base qw(VaultofSatoshi::Request);
use strict;

use constant URL               => 'https://api.vaultofsatoshi.com/public/recent_transactions';
use constant ATTRIBUTES        => qw(order_currency payment_currency count offset since_id);
use constant IS_PRIVATE        => 0;

sub order_currency    { my $self = shift; $self->get_set(@_) }
sub payment_currency  { my $self = shift; $self->get_set(@_) }
sub count             { my $self = shift; $self->get_set(@_) }
sub offset            { my $self = shift; $self->get_set(@_) }
sub since_id          { my $self = shift; $self->get_set(@_) }
sub url               { URL }
sub attributes        { ATTRIBUTES }
sub is_private        { IS_PRIVATE }
sub is_ready_to_send  {
    my $self = shift;
    return defined $self->order_currency
       and defined $self->payment_currency;
}

1;

__END__

