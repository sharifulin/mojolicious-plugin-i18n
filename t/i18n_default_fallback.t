#!/usr/bin/env perl
use lib qw(t lib ../lib ../mojo/lib ../../mojo/lib);
use Mojo::Base -strict;

# Disable Bonjour, IPv6 and libev
BEGIN {
  $ENV{MOJO_NO_BONJOUR} = $ENV{MOJO_NO_IPV6} = 1;
  $ENV{MOJO_IOWATCHER} = 'Mojo::IOWatcher';
}

use Test::More;
use Test::Mojo;
use Mojolicious::Lite;

# I18N plugin
plugin I18N => { namespace => 'App::I18N', default => 'es' };

# GET /
get '/' => 'index';

my $t = Test::Mojo->new;

# Falling back to default with a lexicon defined
$t->get_ok('/' => { 'Accept-Language' => 'de' })->status_is(200)
  ->content_is("holaes\n");

done_testing;

__DATA__
@@ index.html.ep
<%=l 'hello' %><%= languages %>
