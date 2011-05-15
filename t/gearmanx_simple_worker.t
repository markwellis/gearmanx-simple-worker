use strict;
use warnings;

use Test::More;
use Cwd 'abs_path';
use File::Basename;

use Gearman::Client;

use lib 't';
use TestGearman;

if (start_server(4370)) {
    plan tests => 1;
} else {
    plan skip_all => "Can't find server to test with";
    exit 0;
}

my $dir = dirname( abs_path( $0 ) );

`perl -I $dir/../lib $dir/worker_test.pl start`;

my $client = Gearman::Client->new;
$client->job_servers("127.0.0.1:4370");

my $result_ref = $client->do_task("reverse", "987654321");
is( $$result_ref, "123456789", "string has been reversed by worker");

`perl -I $dir/../lib $dir/worker_test.pl stop`;
