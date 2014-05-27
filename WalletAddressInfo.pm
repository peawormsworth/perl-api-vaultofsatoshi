package VaultofSatoshi::WalletAddressInfo;
use base qw(VaultofSatoshi::Request);
use strict;

use constant URL           => 'https://api.vaultofsatoshi.com/info/wallet_address';
use constant ATTRIBUTES    => qw(currency);
use constant READY_TO_SEND => 1;

sub currency          { my $self = shift; $self->get_set(@_) }
sub url               { URL           }
sub attributes        { ATTRIBUTES    }
sub is_ready_to_send  { READY_TO_SEND }

1;

__END__

