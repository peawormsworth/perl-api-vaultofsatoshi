package VaultofSatoshi::Processor;
use strict;

use base qw(VaultofSatoshi::DefaultPackage);

use constant DEBUG => 0;

# you can use a lower version, but then you are responsible for SSL cert verification code...
use LWP::UserAgent 6;
use URI;
use CGI;
use JSON;
use MIME::Base64;
use Time::HiRes qw(gettimeofday);
use Digest::SHA qw(hmac_sha512_hex);

use VaultofSatoshi::Ticker;
use VaultofSatoshi::OrderBook;
use VaultofSatoshi::Currency;
use VaultofSatoshi::Transactions;
use VaultofSatoshi::CurrencyInfo;
use VaultofSatoshi::AccountInfo;
use VaultofSatoshi::BalanceInfo;
use VaultofSatoshi::WalletAddressInfo;
use VaultofSatoshi::WalletHistoryInfo;
use VaultofSatoshi::TickerInfo;
use VaultofSatoshi::QuoteInfo;
use VaultofSatoshi::OrderBookInfo;
use VaultofSatoshi::OrdersInfo;
use VaultofSatoshi::OrderDetailInfo;
use VaultofSatoshi::PlaceTrade;
use VaultofSatoshi::CancelTrade;

use constant ATTRIBUTES       => qw(key secret);
use constant ERROR_NO_REQUEST => 'No request object to send';
use constant ERROR_NOT_READY  => 'Not enough information to send a %s request';

sub attributes { ATTRIBUTES }

use constant CLASS_ACTION_MAP => {
    # Public requests:
    ticker              => 'VaultofSatoshi::Ticker',
    orderbook           => 'VaultofSatoshi::OrderBook',
    currency            => 'VaultofSatoshi::Currency',
    transactions        => 'VaultofSatoshi::Transactions',
    # Info requests:
    currency_info       => 'VaultofSatoshi::CurrencyInfo',
    account_info        => 'VaultofSatoshi::AccountInfo',
    balance_info        => 'VaultofSatoshi::BalanceInfo',
    wallet_address_info => 'VaultofSatoshi::WalletAddressInfo',
    wallet_history_info => 'VaultofSatoshi::WalletHistoryInfo',
    ticker_info         => 'VaultofSatoshi::TickerInfo',
    quote_info          => 'VaultofSatoshi::QuoteInfo',
    orderbook_info      => 'VaultofSatoshi::OrderBookInfo',
    orders_info         => 'VaultofSatoshi::OrdersInfo',
    order_detail_info   => 'VaultofSatoshi::OrderDetailInfo',
    # Trade requests:
    place_trade         => 'VaultofSatoshi::PlaceTrade',
    cancel_trade        => 'VaultofSatoshi::CancelTrade',
};

sub is_ready_to_send {
    my $self = shift;
    my $ready = 0;
    # here we are checking whether or not to default to '0' (not ready to send) based on this objects settings.
    # the settings in here are the token and the secret provided to you by VaultofSatoshi.
    # if we dont have to add a nonce, then 
    if (not $self->request->is_private or (defined $self->secret and defined $self->key)) {
       $ready = $self->request->is_ready_to_send;
    }
    warn sprintf "The request IS%s READY to send\n", ($ready ? '' : ' NOT');

    return $ready;
}

sub send {
    my $self = shift;

    # clear any previous response values... because if you wan it, you shoulda put a variable on it.
    $self->response(undef);
    $self->error(undef);

    unless ($self->request) {
        $self->error({
            type    => __PACKAGE__,
            message => ERROR_NO_REQUEST,
        });
    }
    else {
        # validate that the minimum required request attributes are set here.
        if (not $self->is_ready_to_send) {
             $self->error({
                 type    => __PACKAGE__,
                 message => sprintf(ERROR_NOT_READY, ref $self->request),
             });
        }
        else {
            # make sure we have an request to send...
            my $request = $self->http_request(HTTP::Request->new);
            $request->method($self->request->request_type);
            $request->uri($self->request->url);
            my $uri = URI->new;
            my %query_form = $self->request->request_content;
            if ($self->request->is_private) {
                $query_form{nonce} = $self->nonce;
            }
            $uri->query_form(%query_form);
            if ($self->request->request_type eq 'POST') {
                $request->content($uri->query);
                $request->content_type($self->request->content_type);
            }
            elsif ($self->request->request_type eq 'GET' and $uri->query) {
                $request->uri($request->uri . '?' . $uri->query);
            }
   
            $request->header('Accept'   => 'application/json');
#warn Data::Dumper->Dump([$request, $self->http_request]);
#warn sprintf "Content: %s\n", $self->http_request->content;
            if ($self->request->is_private) {
                #$request->header('Api-Key'  => $self->key);
                #$request->header('Api-Sign' => $self->sign);
                $request->header(api_key  => $self->key);
                $request->header(api_sign => $self->sign);
            }

            # Assuming here that user_agent is flushed on each request... check this... otherwise create a new user_agent each time...
            $self->user_agent(LWP::UserAgent->new);
            $self->user_agent->agent('Mozilla/8.0');
            $self->user_agent->ssl_opts(verify_hostname => 1);

            warn Data::Dumper->Dump([$self->user_agent, $request],[qw(UserAgent Request)]) if DEBUG;

            $self->http_response($self->user_agent->request($request));
            $self->process_response;
        }
    }
    return $self->is_success;
}

sub process_response {
    my $self = shift;

    warn sprintf "Server Response CODE: %s\n", $self->http_response->code if DEBUG;
    warn sprintf "Content: %s\n", $self->http_response->content if DEBUG;

    my $content;
    eval {
        warn Data::Dumper->Dump([$self->http_response],['Response'])  if DEBUG;
        $content = $self->json->decode($self->http_response->content);
        1;
    } or do {
        $content = {};
        warn "Request/JSON error: $@\n";
    };


    if (exists $content->{status}) {
        $self->status($content->{status});
        if (lc $content->{status} eq 'success') {
            $self->response($content->{data});
        }
        elsif ($content->{status} eq 'error') {
            warn sprintf "Vault of Satoshi error: '%s'\n", $content->{message};
            $self->error($content->{message});
        }
        else {
            # we got a response but the result was not 'success'...
            warn "VaultofSatoshi returned an unknown status...\n";
            warn Data::Dumper->Dump([$content],['Invalid VaultofSatoshi Response Content']);
            $self->error('unknown status');
        }
    }
    else {
        # we did not get valid content from BitPay. Assume an unknown HTTP error occurred...
        $self->error({
            type    => __PACKAGE__,
            message => 'no status',
        });
    }
    return $self->is_success;
}

# TODO: The below is not true... please correct this wording...
# signature : is a HMAC-SHA256 encoded message containing nonce, API token, relative API
# request path and alphabetically sorted post parameters. The message must be generated using
# the Secret Key that was created with your API token.
sub sign {
    my $self    = shift;
    my $path    = $self->http_request->uri->path;
    my $content = $self->http_request->content || '';
    #printf "INPUTS: %s %s %s\n", $path, $content, $self->secret;
    return encode_base64(hmac_sha512_hex($path . chr(0) . $content, $self->secret), '');
}

sub nonce        { sprintf '%d%06d' => gettimeofday }
sub json         { shift->{json} ||= JSON->new }
sub is_success   { defined shift->response }

# this method makes the action call routines simpler...
sub _class_action {
    my $self = shift;
    my $class = CLASS_ACTION_MAP->{((caller(1))[3] =~ /::(\w+)$/)[0]};
    $self->request($class->new(@_));
    return $self->send ? $self->response : undef;
}

sub ticker              { _class_action(@_) }
sub orderbook           { _class_action(@_) }
sub currency            { _class_action(@_) }
sub transactions        { _class_action(@_) }
sub currency_info       { _class_action(@_) }
sub account_info        { _class_action(@_) }
sub balance_info        { _class_action(@_) }
sub wallet_address_info { _class_action(@_) }
sub wallet_history_info { _class_action(@_) }
sub ticker_info         { _class_action(@_) }
sub quote_info          { _class_action(@_) }
sub orderbook_info      { _class_action(@_) }
sub orders_info         { _class_action(@_) }
sub order_detail_info   { _class_action(@_) }
sub place_trade         { _class_action(@_) }
sub cancel_trade        { _class_action(@_) }

sub key           { my $self = shift; $self->get_set(@_) }
sub secret        { my $self = shift; $self->get_set(@_) }
sub error         { my $self = shift; $self->get_set(@_) }
sub http_response { my $self = shift; $self->get_set(@_) }
sub request       { my $self = shift; $self->get_set(@_) }
sub response      { my $self = shift; $self->get_set(@_) }
sub http_request  { my $self = shift; $self->get_set(@_) }
sub user_agent    { my $self = shift; $self->get_set(@_) }
sub status        { my $self = shift; $self->get_set(@_) }

1;

__END__


