package VaultofSatoshi::OrderDetailInfo;
use base qw(VaultofSatoshi::Request);
use strict;

use constant URL           => 'https://api.vaultofsatoshi.com/info/order_detail';
use constant ATTRIBUTES    => qw(order_id);

sub order_id          { my $self = shift; $self->get_set(@_) }
sub url               { URL        }
sub attributes        { ATTRIBUTES }
sub is_ready_to_send  { defined shift->order_id }

1;

__END__

