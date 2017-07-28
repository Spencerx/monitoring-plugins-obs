#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 1;
require './check_obs_events';

$BSConfig::bsdir = undef;
my $expected;

my $mcoe = Monitoring::Check::OBS::Events->new();

$BSConfig::bsdir = 't/data/';

# Checking OK
$mcoe->config({
  directories_to_check => [
    { 
      dir => 'not-existing-dir',
      warning => 4,
      critical => 5,
    }
  ]
});
eval {
  $mcoe->check_dir_list();
};

is($@, "Error  while opening 't/data//events/not-existing-dir': No such file or directory\n", "Checking for exception if directory does not exist");

exit 0;
