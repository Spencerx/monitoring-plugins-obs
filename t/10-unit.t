#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 9;
require './check_obs_events';## no critic (Modules::RequireBarewordIncludes)
our $VERSION = 0; # make perlcritic happy

my $got;
my $expected;
my $mcoe = Monitoring::Check::OBS::Events->new();
$BSConfig::bsdir = undef; ## no critic (Variables::ProhibitPackageVars)

$mcoe->{results} = [
  { name => 'a', 'state' => 0, diff => 0, events => 1, perfdata => 'a=1'},
  { name => 'b', 'state' => 1, diff => 5, events => 2, perfdata => 'b=2'},
  { name => 'c', 'state' => 2, diff => 4, events => 3, perfdata => 'c=3'},
  { name => 'd', 'state' => 3, diff => 3, events => 4, perfdata => 'd=4'},
];

$expected =[
  { name => 'd', 'state' => 3, diff => 3, events => 4, perfdata => 'd=4'},
  { name => 'c', 'state' => 2, diff => 4, events => 3, perfdata => 'c=3'},
  { name => 'b', 'state' => 1, diff => 5, events => 2, perfdata => 'b=2'},
];

is_deeply($mcoe->failed, $expected, 'Checking method failed');
is($mcoe->get_failed_max_state, 3, 'Checking maximum failed state');
is(
  $mcoe->format_output_fail(2),
  'CRITICAL -  d (3/4/3) c (2/3/4) b (1/2/5) | a=1; b=2; c=3; d=4',
  'Checking failed output'
);
$BSConfig::bsdir = 't/data/'; ## no critic (Variables::ProhibitPackageVars)

###############################################################################
# Checking sorting for output
$mcoe->{results} = [
  { name => 'a', 'state' => 0, diff => 0, events => 1, perfdata => 'a=1'},
  { name => 'b', 'state' => 1, diff => 5, events => 2, perfdata => 'b=2'},
  { name => 'c', 'state' => 2, diff => 4, events => 3, perfdata => 'c=3'},
  { name => 'd', 'state' => 2, diff => 3, events => 4, perfdata => 'd=4'},
];

$got = $mcoe->format_output_fail(2);
$expected = 'CRITICAL -  c (2/3/4) d (2/4/3) b (1/2/5) | a=1; b=2; c=3; d=4';
is($got, $expected, 'Checking sorting for output');

###############################################################################
# Checking OK
$mcoe->config({
  directories_to_check => [
    {
      dir => 'ok',
      warning => 4,
      critical => 5,
    },
    {
      dir => 'ok_2',
      warning => 2,
      critical => 3,
    }
  ]
});

$mcoe->check_dir_list();
is($mcoe->get_failed_max_state, 0, 'Checking state OK');
is(
  $mcoe->format_output_ok(),
  "OK - all eventdirs checked | 'ok'=3;4;5; 'ok_2'=1;2;3\n",
  'Checking OK message'
);


###############################################################################
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
is($mcoe->get_failed_max_state, 1, 'Checking state WARNING');

# Testing CRITICAL
$mcoe = Monitoring::Check::OBS::Events->new(warning => 4, critical => 9);
$mcoe->config({
directories_to_check => [
{ dir => 'ok' },
{ dir => 'warning' },
{ dir => 'critical' }
]
});

$mcoe->check_dir_list();
my $state = $mcoe->get_failed_max_state;
is($state, 2, 'Checking state CRITICAL');
exit 0;
