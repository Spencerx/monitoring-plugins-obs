#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 6;
require './check_obs_events';

$BSConfig::bsdir = undef;
my $expected;

my $mcoe = Monitoring::Check::OBS::Events->new();

$mcoe->{results} = [
  { dir => 'a', 'state' => 0},
  { dir => 'b', 'state' => 1},
  { dir => 'c', 'state' => 2},
  { dir => 'd', 'state' => 3},
];

$expected =[
  {
    'dir' => 'd',
    'state' => 3
  },
  {
    'state' => 2,
    'dir' => 'c'
  },
  {
    'dir' => 'b',
    'state' => 1
  }
];

is_deeply($mcoe->failed, $expected, 'Checking method failed');
is($mcoe->get_failed_max_state, 3, 'Checking maximum failed state');

$BSConfig::bsdir = 't/data/';

# Checking OK
$mcoe->config({
  directories_to_check => [
    { 
      dir => 'ok',
      warning => 4,
      critical => 5,
    }
  ]
});

$mcoe->check_dir_list();
is($mcoe->get_failed_max_state, 0, "Checking state OK") || print Dumper($mcoe);

# Testing WARNING
$mcoe = Monitoring::Check::OBS::Events->new(warning => 3, critical => 10);
is($mcoe->warning, 3, 'Checking warning');
$mcoe->config({
directories_to_check => [
{ dir => 'ok' },
{ dir => 'warning' }
]
});

$mcoe->check_dir_list();
is($mcoe->get_failed_max_state, 1, "Checking state WARNING");

# Testing CRITICAL
$mcoe = Monitoring::Check::OBS::Events->new(warning => 3, critical => 9);
$mcoe->config({
directories_to_check => [
{ dir => 'ok' },
{ dir => 'warning' },
{ dir => 'critical' }
]
});

$mcoe->check_dir_list();
is($mcoe->get_failed_max_state, 2, "Checking state CRITICAL");

exit 0;
