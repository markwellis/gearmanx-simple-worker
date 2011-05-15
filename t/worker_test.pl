use strict;
use warnings;

use GearmanX::Simple::Worker;

my $worker = GearmanX::Simple::Worker->new( ["127.0.0.1:4370"], {
    "reverse" => sub { warn "asdsad"; return reverse( $_[0]->arg ) },
} );

$worker->work;
