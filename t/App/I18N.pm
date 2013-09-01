package App::I18N;
use base 'Locale::Maketext';

sub init {
  my $lh = $_[0];  # a newborn handle
  
  $lh->SUPER::init();
  $lh->fail_with('fail_handler');  
  return;
}

sub fail_handler{
  my ($failing_lh, $key, $params) = @_;
  
  return "failed_$key";
}

package App::I18N::ru;
use Mojo::Base 'App::I18N';
use utf8;

our %Lexicon = ( _AUTO => 0, hello => 'Привет', hello2 => 'Привет два');

package App::I18N::en;
use Mojo::Base 'App::I18N';

our %Lexicon = (_AUTO => 0, hello2 => 'Hello two');



1;
