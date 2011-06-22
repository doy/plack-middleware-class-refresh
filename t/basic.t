#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Plack::Test;
use lib 't/lib';
use Test::PMCR;

use File::Copy;
use File::Spec::Functions 'catfile';
use HTTP::Request::Common;

use Plack::Middleware::Class::Refresh;

my $dir = Test::PMCR::setup_temp_dir('basic');

require Foo;
require Foo::Bar;
require Baz::Quux;

my $app = sub {
    return [
        200,
        [],
        [join "\n", Foo->call, Foo::Bar->call, Baz::Quux->call]
    ];
};

test_psgi
    app    => Plack::Middleware::Class::Refresh->wrap($app),
    client => sub {
        my $cb = shift;
        {
            my $res = $cb->(GET 'http://localhost/');
            is($res->code, 200, "right code");
            is($res->content, "Foo\nFoo::Bar\nBaz::Quux");
        }
        copy(catfile(qw(t data_new basic Foo.pm)), catfile($dir, 'Foo.pm'))
            || die "couldn't copy: $!";
        {
            my $res = $cb->(GET 'http://localhost/');
            is($res->code, 200, "right code");
            is($res->content, "FOO\nFoo::Bar\nBaz::Quux");
        }
    };

done_testing;
