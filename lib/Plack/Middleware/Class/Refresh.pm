package Plack::Middleware::Class::Refresh;
use strict;
use warnings;
use Plack::Util::Accessor 'verbose';

use Class::Refresh;

use base 'Plack::Middleware';

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

1;
