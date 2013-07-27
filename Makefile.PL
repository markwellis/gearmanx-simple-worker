use inc::Module::Install;

all_from('lib/GearmanX/Simple/Worker.pm');

requires 'App::Daemon';
requires 'Gearman::Worker';

test_requires 'Test::More';
test_requires 'Cwd';
test_requires 'File::Basename';
test_requires 'Gearman::Client';
test_requires 'Exporter';
test_requires 'List::Util';
test_requires 'IO::Socket::INET';
test_requires 'POSIX';
test_requires 'FindBin';
test_requires 'constant';
test_requires 'Gearman::Server';

perl_version '5.008';

resources(
    'repository'  => 'https://github.com/n0body-/gearmanx-simple-worker.git',
);

auto_install;
WriteAll;
