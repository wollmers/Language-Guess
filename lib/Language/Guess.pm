package Language::Guess;

use strict;
use warnings;

use 5.008;
our $VERSION = '0.01';

use Unicode::Normalize;
use Language::Guess::Words;

use Data::Dumper;

sub new {
  my $class = shift;
  # uncoverable condition false
  bless @_ ? @_ > 1 ? {@_} : {%{$_[0]}} : {}, ref $class || $class;
}

sub guess {
  my ($self, $text) = @_;

  my $text_NFC = NFC(lc($text));

  my @tokens = $text_NFC =~ m/([\p{Letter}\p{Mark}]+)/xmsg;
  #print Dumper(\@tokens);

  my $words = Language::Guess::Words->words();

  my $guesses = {};

  for my $token (@tokens) {
    if (exists $words->{$token}) {
      #print $token,': ',join(',',@{$words->{$token}}),"\n";
      for my $lang (@{$words->{$token}}) {
        $guesses->{$lang}++;
      }
    }
  }
  my ($guess) = sort { $guesses->{$b} <=> $guesses->{$a} } keys(%$guesses);
  return $guess;
}


1;

__END__

=encoding utf-8

=head1 NAME

Language::Guess - Guess language from text using top 1000 words

=begin html

<a href="https://travis-ci.org/wollmers/Language-Guess"><img src="https://travis-ci.org/wollmers/Language-Guess.png" alt="Language-Guess"></a>
<a href='https://coveralls.io/r/wollmers/Language-Guess?branch=master'><img src='https://coveralls.io/repos/wollmers/Language-Guess/badge.png?branch=master' alt='Coverage Status' /></a>
<a href='http://cpants.cpanauthors.org/dist/Language-Guess'><img src='http://cpants.cpanauthors.org/dist/Language-Guess.png' alt='Kwalitee Score' /></a>
<a href="http://badge.fury.io/pl/Language-Guess"><img src="https://badge.fury.io/pl/Language-Guess.svg" alt="CPAN version" height="18"></a>

=end html

=head1 SYNOPSIS

  use Langauge::Guess;
  my $guessed_language = Language::Guess->guess($text);


=head1 DESCRIPTION

Language::Guess matches the words in the text against lists of the top 1000 words
in each of 45 different languages.

=head2 CONSTRUCTOR

=over 4

=item new()

Creates a new object which maintains internal storage areas
for the Language::Guess computation.  Use one of these per concurrent
Language::Guess->guess() call.

=back

=head2 METHODS

=over 4


=item guess($text)

Returns the language code with the most words found.

=back

=head2 EXPORT

None by design.

=head1 STABILITY

Until release of version 1.00 the included methods, names of methods and their
interfaces are subject to change.

Beginning with version 1.00 the specification will be stable, i.e. not changed between
major versions.


=head1 SOURCE REPOSITORY

L<http://github.com/wollmers/Language-Guess>

=head1 AUTHOR

Helmut Wollmersdorfer E<lt>helmut.wollmersdorfer@gmail.comE<gt>

=begin html

<a href='http://cpants.cpanauthors.org/author/wollmers'><img src='http://cpants.cpanauthors.org/author/wollmers.png' alt='Kwalitee Score' /></a>

=end html

=head1 COPYRIGHT

Copyright 2016- Helmut Wollmersdorfer

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

Text::Language::Guess

=cut
