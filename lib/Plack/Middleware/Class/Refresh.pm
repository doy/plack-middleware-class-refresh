package Plack::Middleware::Class::Refresh;
use strict;
use warnings;
use Plack::Util::Accessor 'verbose';

use Class::Refresh;

use base 'Plack::Middleware';

sub call {
    my $self = shift;

    my @changed = Class::Refresh->modified_modules;
    warn "Classes " . join(', ', @changed) . " have been changed, refreshing"
        if $self->verbose && @changed;

    Class::Refresh->refresh;

    $self->app->(@_);
}

1;
