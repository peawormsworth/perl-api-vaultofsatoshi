package VaultofSatoshi::Request;
use strict;

use base qw(VaultofSatoshi::DefaultPackage);

use constant URL               => 'https://api.vaultofsatoshi.com';
use constant REQUEST_TYPE      => 'POST';
use constant CONTENT_TYPE      => 'application/x-www-form-urlencoded';
use constant ATTRIBUTES        => qw();
use constant READY_TO_SEND     => 0;
use constant IS_PRIVATE        => 1;

sub url               { URL           }
sub request_type      { REQUEST_TYPE  }
sub content_type      { CONTENT_TYPE  }
sub attributes        { ATTRIBUTES    }
sub is_ready_to_send  { READY_TO_SEND }
sub is_private        { IS_PRIVATE    }

# dump all the fields as a hash...
sub request_content {
    my $self = shift;
    my %content;
    foreach my $field ($self->attributes) {
        if (defined $self->$field) {
            my $value = $self->$field;
            if (ref $value and ref $value eq 'HASH') {
                foreach my $sub_field (keys %$value) {
                    $content{sprintf('%s[%s]', $field, $sub_field)} = $value->{$sub_field}
                }
            }
            else {
                $content{$field} = $self->$field;
            }
        }
    }
    return %content;
}

1;

__END__

