#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 10;
require './check_obs_events';
my $expected;

my $mcoe = Monitoring::Check::OBS::Events->new();
ok(ref($mcoe) eq 'Monitoring::Check::OBS::Events', "Checking generation of Monitoring::Check::OBS::Events object");

# testing default option values
$mcoe->getopt();

is($mcoe->config_file, '/etc/nagios/check_obs_events.yml', 'Checking default config file');
is($mcoe->warning, 0, 'Checking default warning value');
is($mcoe->critical, 0, 'Checking default critical value');


# testing long option values
@ARGV = qw(--critical 20 --warning 10 --config t/data/00/config-1.yml);
$mcoe->getopt();

is($mcoe->config_file, 't/data/00/config-1.yml', 'Checking cli option "--config" file');
is($mcoe->warning, 10, 'Checking cli option "--warning"');
is($mcoe->critical, 20, 'Checking cli option for  "--critical"');

# testing short option values
@ARGV = qw(-c 90 -w 80);
$mcoe->getopt();

is($mcoe->warning, 80, 'Checking cli option "-w"');
is($mcoe->critical, 90, 'Checking cli option "-c"');

# Tesing reading of config
$mcoe->get_config();
$expected = {
  'allowed_files' => 'c d',
  'allowed_directories' => 'a b',
  'directories_to_check' => [
    {
      'warning' => '1',
      'dir' => 'e',
      'critical' => '2'
    }
  ]
};

is_deeply($mcoe->config, $expected, "Checking config file parsing");



exit 0;
