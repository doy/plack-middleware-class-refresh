package Plack::Middleware::Class::Refresh;
use strict;
use warnings;
use Plack::Util::Accessor 'verbose';
# ABSTRACT: Refresh your app classes with Class::Refresh before requests

use Class::Refresh;

use base 'Plack::Middleware';

=head1 SYNOPSIS

  use Plack::Builder;
  builder {
      enable 'Class::Refresh', verbose => 1;
      ...
  }

=head1 DESCRIPTION

This middleware simply calls C<< Class::Refresh->refresh >> before each
request, to ensure that the most recent versions of all of your classes are
loaded. This is a faster alternative to L<Plack::Loader::Restarter>, although
be sure you read the caveats in L<Class::Refresh>, as this module will likely
be less reliable in some cases.

You can set the C<verbose> option when debugging to make it give a warning
whenever it refreshes any classes.

=cut

sub call {
    my $self = shift;

    if ($self->verbose && (my @changed = Class::Refresh->modified_modules)) {
        warn ((@changed > 1
                 ? "Classes " . join(', ', @changed) . " have"
                 : "Class $changed[0] has")
           . " been changed, refreshing");
    }

    Class::Refresh->refresh;

    $self->app->(@_);
}

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-plack-middleware-class-refresh at rt.cpan.org>, or browse to
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Plack-Middleware-Class-Refresh>.

=head1 SEE ALSO

L<Class::Refresh>

L<Plack>

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc Plack::Middleware::Class::Refresh

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Plack-Middleware-Class-Refresh>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Plack-Middleware-Class-Refresh>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Plack-Middleware-Class-Refresh>

=item * Search CPAN

L<http://search.cpan.org/dist/Plack-Middleware-Class-Refresh>

=back

=begin Pod::Coverage

call

=end Pod::Coverage

=cut

1;
