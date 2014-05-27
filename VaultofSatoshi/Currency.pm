package VaultofSatoshi::Currency;
use base qw(VaultofSatoshi::Request);
use strict;

use constant URL           => 'https://api.vaultofsatoshi.com/public/currency';
use constant ATTRIBUTES    => qw(currency);
use constant PRIVATE       => 0;
use constant READY_TO_SEND => 1;

sub currency          { my $self = shift; $self->get_set(@_) }
sub url               { URL           }
sub attributes        { ATTRIBUTES    }
sub is_private        { PRIVATE       }
sub is_ready_to_send  { READY_TO_SEND }

1;

__END__

