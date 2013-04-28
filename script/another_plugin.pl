#!/usr/bin/env perl
use lib qw(../lib ../../mojo/lib);

package Mojolicious::Plugin::Iam18nAware::I18N::ru;
use Mojo::Base 'Locale::Maketext';
use utf8;

our %Lexicon = ('The password was wrong' => 'Пароль указан не верно');

package Mojolicious::Plugin::IamI18nAware;
use Mojo::Base 'Mojolicious::Plugin';

has support_i18n_langs => sub { [qw(ru en)] };

sub register {
  my ($self, $mojo) = @_;
  
  $mojo->helper(
    login => sub {
      my $c = shift;
      my $pwd = shift || '';
	  
	  $self->_init_i18n($c);
	  
      return 1 if $pwd eq 'p4ssw0rd';
      $c->stash(error => $c->l('The password was wrong'));
      return;
    }
  );
};

sub _init_i18n {
	my $self = shift;
	return if $self->{_init_18n};
	
	my $c    = shift || return;
	my $i18n = $c->stash('i18n') || return;
	
	for (@{ $self->support_i18n_langs || [] }) {
		my $m = "$i18n->{namespace}::${_}::Lexicon";
		my $p = "Mojolicious::Plugin::Iam18nAware::I18N::${_}::Lexicon"; # __PACKAGE__
		
		eval "\$${m}{\$_} = \$${p}{\$_} for keys \%$p"; # XXX: durty hard code :-)
		warn $@ if $@;
	}
	
	$self->{_init_18n}++;
}

# 

package App::I18N::ru;
use Mojo::Base 'Locale::Maketext';
use utf8;

our %Lexicon = (hello => 'Привет');

package main;
use Mojolicious::Lite;

plugin I18N => {namespace => 'App::I18N', default => 'ru', support_url_langs => [qw(ru en)]};
plugin 'IamI18nAware';

get '/' => 'index';

app->start;

__DATA__

@@ index.html.ep

%= l 'hello'

Login: <%= login %>
Error: <%= stash 'error' %>
