#!/usr/bin/env perl
use lib qw(lib ../lib ../mojo/lib ../../mojo/lib);
use Mojo::Base -strict;

# Disable Bonjour, IPv6 and libev
BEGIN {
  $ENV{MOJO_NO_BONJOUR} = $ENV{MOJO_NO_IPV6} = 1;
  $ENV{MOJO_IOWATCHER} = 'Mojo::IOWatcher';
}

use Test::More;

package MyTestApp::I18N::de;
use Mojo::Base -strict;
use base 'MyTestApp::I18N';

our %Lexicon = ( _AUTO => 1, hello => 'hallo');

# "Aw, he looks like a little insane drunken angel."
package main;
use Mojolicious::Lite;

use Test::Mojo;

# I18N plugin
plugin I18N => {namespace => 'MyTestApp::I18N'};

# GET /
get '/' => 'index';

# GET /english
get '/english' => 'english';

# GET /german
get '/german' => 'german';

# GET /mixed
get '/mixed' => 'mixed';

# GET /nothing
get '/nothing' => 'nothing';

# GET /unknown
get '/unknown' => 'unknown';

# Hey, I don’t see you planning for your old age.
# I got plans. I’m gonna turn my on/off switch to off.
my $t = Test::Mojo->new;

# German (detected)
$t->get_ok('/' => {'Accept-Language' => 'de, en-US'})->status_is(200)
  ->content_is("hallode\n");

# English (detected)
$t->get_ok('/' => {'Accept-Language' => 'en-US'})->status_is(200)
  ->content_is("helloen\n");

# English (manual)
$t->get_ok('/english' => {'Accept-Language' => 'de'})->status_is(200)
  ->content_is("helloen\n");

# German (manual)
$t->get_ok('/german' => {'Accept-Language' => 'en-US'})->status_is(200)
  ->content_is("hallode\n");

# Mixed (manual)
$t->get_ok('/mixed' => {'Accept-Language' => 'de, en-US'})->status_is(200)
  ->content_is("hallode\nhelloen\n");

# Nothing
$t->get_ok('/nothing')->status_is(200)->content_is("helloen\n");

# Unknown (manual)
$t->get_ok('/unknown')->status_is(200)->content_is("unknownde\nunknownen\n");

# Unknwon (manual)
$t->get_ok('/unknown' => {'Accept-Language' => 'de, en-US'})->status_is(200)
  ->content_is("unknownde\nunknownen\n");

done_testing;

__DATA__
@@ index.html.ep
<%=l 'hello' %><%= languages %>

@@ english.html.ep
% languages 'en';
<%=l 'hello' %><%= languages %>

@@ german.html.ep
% languages 'de';
<%=l 'hello' %><%= languages %>

@@ mixed.html.ep
% languages 'de';
<%=l 'hello' %><%= languages %>
% languages 'en';
<%=l 'hello' %><%= languages %>

@@ nothing.html.ep
<%=l 'hello' %><%= languages %>

@@ unknown.html.ep
% languages 'de';
<%=l 'unknown' %><%= languages %>
% languages 'en';
<%=l 'unknown' %><%= languages %>
