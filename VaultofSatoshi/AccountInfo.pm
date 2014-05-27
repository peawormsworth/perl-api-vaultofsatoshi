package VaultofSatoshi::AccountInfo;
use base qw(VaultofSatoshi::Request);
use strict;

use constant URL           => 'https://api.vaultofsatoshi.com/info/account';
use constant ATTRIBUTES    => qw();
use constant READY_TO_SEND => 1;

sub url               { URL           }
sub attributes        { ATTRIBUTES    }
sub is_ready_to_send  { READY_TO_SEND }

1;

__END__

