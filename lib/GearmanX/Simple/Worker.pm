package GearmanX::Simple::Worker;
use strict;
use warnings;

our $VERSION = '0.001';
$VERSION = eval $VERSION;

use App::Daemon;
use Gearman::Worker;

sub new{
    my ( $invocant, $servers, $functions ) = @_;

    my $class = ref($invocant) || $invocant;
    my $self = { };
    bless($self, $class);

    $self->{'worker'} = Gearman::Worker->new;
    $self->{'worker'}->job_servers( @{$servers} );

    if ( $functions && ( ref( $functions ) eq 'HASH' ) ){
        foreach my $function ( keys( %{$functions} ) ){
            $self->register( $function => $functions->{ $function } );
        }
    }

    return $self;
}

sub register{
    my ( $self, $name, $sub ) = @_;

    $self->{'worker'}->register_function( $name => $sub );
}

sub work{
    my ( $self ) = @_;

    App::Daemon::daemonize();
    $self->{'worker'}->work while 1;
}

1;

=head1 NAME

GearmanX::Simple::Worker - simple Gearman worker interface

=head1 SYNOPSIS

    use GearmanX::Simple::Worker;

    sub do_something{
        my ( $job ) = @_;

        #do something here when called
    }

    my $worker = GearmanX::Simple::Worker->new( ["127.0.0.1:4730"], {
        'do_something' => \&do_something,
    } );

    sub do_something_else{
        my ( $job ) = @_;

        #does something else
    }

    $worker->register( "do_something_else", \&do_something_else );

    $worker->work;

is the same as

    use App::Daemon;
    use Gearman::Worker;

    my $worker = Gearman::Worker->new;
    $worker->job_servers( "127.0.0.1:4730" );

    sub do_something{
        my ( $job ) = @_;

        #do something here when called
    }

    $worker->register_function( "do_something" => \&do_something );
    
    sub do_something_else{
        my ( $job ) = @_;

        #does something else
    }

    $worker->register_function( "do_something_else" => \&do_something_else );

    App::Daemon::daemonize();
    $worker->work while 1;

=head1 DESCRIPTION

Simple interface to Gearman::Worker and App::Daemon - for quick and easy creation of gearman workers that daemonise automatically

=head1 METHODS

=head2 new

takes two arguments
arrayref of gearman servers
(optional) hashref of function_name => function_ref 

    GearmanX::Simple::Worker->new(
        \@gearman_servers,
        {
            $function_name => $function_ref
        }
    );

=head2 register

so you can register functions after the creation of the $worker object

    $worker->register( $function_name, $function_ref );

=head2 work

start work and daemonise, no more functions can be registered once this has been called

=head1 SUPPORT

Bugs should always be submitted via the CPAN bug tracker

For other issues, contact the maintainer

=head1 AUTHORS

n0body E<lt>n0body@thisaintnews.comE<gt>

=head1 SEE ALSO

L<http://thisaintnews.com>, L<Gearman::Worker>, L<App:Daemon>

=head1 LICENSE

Copyright (C) 2011 by n0body L<http://thisaintnews.com/>

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
