#!/usr/bin/perl -wT

use 5.010;
use warnings;
use strict;
use lib qw(.);

use VaultofSatoshi::Processor;
use Data::Dumper;
use JSON;

use constant DEBUG => 1;

# Enter your VaultofSatoshi keys found here: https://www.vaultofsatoshi.com/myapikeys
use constant API_KEY                  => 'Vault of Satoshi API key    goes here';
use constant API_SECRET               => 'Vault of Satoshi API secret goes here';

# Public Tests...
use constant TEST_TICKER              => 0;
use constant TEST_ORDERBOOK           => 0;
use constant TEST_CURRENCY            => 0;
use constant TEST_TRANSACTIONS        => 0;

use constant TEST_CURRENCY_INFO       => 0;
use constant TEST_ACCOUNT_INFO        => 0;
use constant TEST_BALANCE_INFO        => 0;
use constant TEST_WALLET_ADDRESS_INFO => 0;
use constant TEST_WALLET_HISTORY_INFO => 0;
use constant TEST_TICKER_INFO         => 0;
use constant TEST_QUOTE_INFO          => 0;
use constant TEST_ORDERBOOK_INFO      => 0;
use constant TEST_ORDERS_INFO         => 0;

# Note: this tests both the placing and the cancelling a single trade request...
use constant TEST_PLACE_TRADE         => 1;
# This is only tested when a place_trade test is also performed...
use constant TEST_ORDER_DETAIL_INFO   => 1;


main->new->go;

sub new       { bless {} => shift }
sub json      { shift->{json}      || JSON->new }
sub processor { shift->{processor} ||= VaultofSatoshi::Processor->new(key => API_KEY, secret => API_SECRET) }

sub go  {
    my $self = shift;

    say '=== Begin PUBLIC tests';
    if (TEST_TICKER) {
        my $ticker = $self->processor->ticker(
            order_currency   => 'BTC',
            payment_currency => 'USD',
        );
        say 'Ticker...';
        if ($ticker) {
            say 'success';
            say Dumper $ticker if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_ORDERBOOK) {
        foreach my $order_currency (qw(BTC LTC)) {
            foreach my $payment_currency (qw(CAD USD)) {
                say "Orderbook: buy $order_currency with $payment_currency...";
                my $orderbook = $self->processor->orderbook(
                    order_currency   => $order_currency,
                    payment_currency => $payment_currency,
                );
                if ($orderbook) {
                    say 'success';
                    say Dumper $orderbook if DEBUG;
                }
                else {
                    say 'failed';
                    say Dumper $self->processor->error if DEBUG;
                }
            }
        }
    }

    if (TEST_CURRENCY) {
        say 'Currency';
        my $currency = $self->processor->currency;
        if ($currency) {
            say 'success';
            say Dumper $currency if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
        foreach my $currency (qw(BTC LTC CAD USD)) {
            say "Currency: $currency...";
            my $currency = $self->processor->currency(
                currency => $currency
            );
            if ($currency) {
                say 'success';
                say Dumper $currency if DEBUG;
            }
            else {
                say 'failed';
                say Dumper $self->processor->error if DEBUG;
            }
        }
    }

    if (TEST_TRANSACTIONS) {
        foreach my $order_currency (qw(BTC LTC)) {
            foreach my $payment_currency (qw(CAD USD)) {
                say "Transactions: buy $order_currency with $payment_currency...";
                my $transactions = $self->processor->transactions(
                    order_currency   => $order_currency,
                    payment_currency => $payment_currency,
                );
                if ($transactions) {
                    say 'success';
                    say Dumper $transactions if DEBUG;
                }
                else {
                    say 'failed';
                    say Dumper $self->processor->error if DEBUG;
                }
            }
        }
    }

    say '=== Done PUBLIC tests';

    say '=== Begin INFO tests';

    if (TEST_CURRENCY_INFO) {
        say 'Currency Info';
        my $currency = $self->processor->currency_info;
        if ($currency) {
            say 'success';
            say Dumper $currency if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
        foreach my $currency (qw(BTC LTC CAD USD)) {
            say "Currency: $currency...";
            my $currency = $self->processor->currency_info(
                currency => $currency
            );
            if ($currency) {
                say 'success';
                say Dumper $currency if DEBUG;
            }
            else {
                say 'failed';
                say Dumper $self->processor->error if DEBUG;
            }
        }
    }

    if (TEST_ACCOUNT_INFO) {
        say 'Account Info';
        my $account = $self->processor->account_info;
        if ($account) {
            say 'success';
            say Dumper $account if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_BALANCE_INFO) {
        say 'Balance Info';
        my $balance = $self->processor->balance_info;
        if ($balance) {
            say 'success';
            say Dumper $balance if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
        foreach my $currency (qw(BTC LTC CAD USD)) {
            say "Currency: $currency...";
            my $balance = $self->processor->balance_info(
                currency => $currency
            );
            if ($balance) {
                say 'success';
                say Dumper $balance if DEBUG;
            }
            else {
                say 'failed';
                say Dumper $self->processor->error if DEBUG;
            }
        }
    }

    if (TEST_WALLET_ADDRESS_INFO) {
        say 'Wallet Address Info';
        my $wallet_address = $self->processor->wallet_address_info;
        if ($wallet_address) {
            say 'success';
            say Dumper $wallet_address if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
        foreach my $currency (qw(BTC LTC)) {
            say "Currency: $currency...";
            my $wallet_address = $self->processor->wallet_address_info(
                currency => $currency
            );
            if ($wallet_address) {
                say 'success';
                say Dumper $wallet_address if DEBUG;
            }
            else {
                say 'failed';
                say Dumper $self->processor->error if DEBUG;
            }
        }
    }

    if (TEST_WALLET_HISTORY_INFO) {
        say 'Wallet History Info';
        my $wallet_history = $self->processor->wallet_history_info;
        if ($wallet_history) {
            say 'success';
            say Dumper $wallet_history if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
        foreach my $currency (qw(BTC LTC)) {
            say "Currency: $currency...";
            my $wallet_history = $self->processor->wallet_history_info(
                currency => $currency
            );
            if ($wallet_history) {
                say 'success';
                say Dumper $wallet_history if DEBUG;
            }
            else {
                say 'failed';
                say Dumper $self->processor->error if DEBUG;
            }
        }
    }

    if (TEST_TICKER_INFO) {
        say 'Ticker Info';
        my $ticker = $self->processor->ticker_info(
            order_currency   => 'BTC',
            payment_currency => 'USD',
        );
        if ($ticker) {
            say 'success';
            say Dumper $ticker if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    # NOTE: I dont thing the response from VoS is valid for this request...
    # I mean I dont understand if my request params are correct...
    if (TEST_QUOTE_INFO) {
        say 'Quote Info';
        my $quote = $self->processor->quote_info(
            type             => 'bid',
            order_currency   => 'BTC',
            payment_currency => 'CAD',
            units            => {
                precision => 0,
                value     => '2',
                value_int => 2,
            },
            price            => {
                precision => 5,
                value     => '100000000',
                value_int => 1000.00000,
            },
        );
        if ($quote) {
            say 'success';
            say Dumper $quote if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_ORDERBOOK_INFO) {
        foreach my $order_currency (qw(BTC LTC)) {
            foreach my $payment_currency (qw(CAD USD)) {
                say "Orderbook Info: buy $order_currency with $payment_currency...";
                my $orderbook = $self->processor->orderbook_info(
                    order_currency   => $order_currency,
                    payment_currency => $payment_currency,
                );
                if ($orderbook) {
                    say 'success';
                    say Dumper $orderbook if DEBUG;
                }
                else {
                    say 'failed';
                    say Dumper $self->processor->error if DEBUG;
                }
            }
        }
    }

    if (TEST_ORDERS_INFO) {
        say "Orders Info...";
        my $orders = $self->processor->orders_info;
        if ($orders) {
            say 'success';
            say Dumper $orders if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }
    }

    if (TEST_PLACE_TRADE) {
        my @order_ids;
        say "Placing a BID Trade...";
        my $place_trade1 = $self->processor->place_trade(
            type             => 'bid',
            order_currency   => 'BTC',
            payment_currency => 'CAD',
            units            => {
                precision => 8,
                value     => '0.0001',
                value_int => 10000,
            },
            price            => {
                precision => 0,
                value     => '10',
                value_int => 10,
            },
        );
        if ($place_trade1) {
            say 'success';
            push @order_ids, $place_trade1->{order_id};
            say Dumper $place_trade1 if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }

        say "Placing an ASK Trade...";
        my $place_trade2 = $self->processor->place_trade(
            type             => 'ask',
            order_currency   => 'BTC',
            payment_currency => 'USD',
            units            => {
                precision => 8,
                value     => '0.0001',
                value_int => 10000,
            },
            price            => {
                precision => 0,
                value     => '10000',
                value_int => 10000,
            },
        );
        if ($place_trade2) {
            say 'success';
            push @order_ids, $place_trade2->{order_id};
            say Dumper $place_trade2 if DEBUG;
        }
        else {
            say 'failed';
            say Dumper $self->processor->error if DEBUG;
        }

        foreach my $order_id (@order_ids) {
            # order details...
            if (TEST_ORDER_DETAIL_INFO) {
                say "Detail Info for Order ID: $order_id...";
                my $order = $self->processor->order_detail_info(order_id => $order_id);
                if ($order) {
                    say 'success';
                    say Dumper $order if DEBUG;
                }
                else {
                    say 'failed';
                    say Dumper $self->processor->error if DEBUG;
                }
            }

            # cancel trade...
            # always do this to remove the test order...
            say "Cancelling Order ID: $order_id...";
            my $cancel = $self->processor->cancel_trade(order_id => $order_id);
            # how can i tell whether this was successful???
        }
    }

}

1;

__END__

