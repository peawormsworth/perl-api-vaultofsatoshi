package VaultofSatoshi::OrdersInfo;
use base qw(VaultofSatoshi::Request);
use strict;

use constant URL           => 'https://api.vaultofsatoshi.com/info/orders';
use constant ATTRIBUTES    => qw(count before after before_id open_only);
use constant READY_TO_SEND => 1;

sub count             { my $self = shift; $self->get_set(@_) }
sub before            { my $self = shift; $self->get_set(@_) }
sub after             { my $self = shift; $self->get_set(@_) }
sub before_id         { my $self = shift; $self->get_set(@_) }
sub open_only         { my $self = shift; $self->get_set(@_) }
sub url               { URL           }
sub attributes        { ATTRIBUTES    }
sub is_ready_to_send  { READY_TO_SEND }

1;

__END__

