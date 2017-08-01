#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 6;
use Carp;

require './check_obs_events';## no critic (Modules::RequireBarewordIncludes)
our $VERSION = 0; # make perlcritic happy

my $ret;
my $got;
my $expected;
$BSConfig::bsdir = undef; ## no critic (Variables::ProhibitPackageVars)

my $mcoe = Monitoring::Check::OBS::Events->new();

$BSConfig::bsdir = 't/data/'; ## no critic (Variables::ProhibitPackageVars)

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

$ret = eval {
  $mcoe->check_dir_list();
};

$expected = "Error  while opening 't/data//events/not-existing-dir': No such file or directory\n";
is($@, $expected, 'Checking for exception if directory does not exist');

# checking ARGV
{
  local *STDERR; ## no critic (Variables::RequireInitializationForLocalVars)
  open STDERR, '>', '/dev/null' || croak("Could not open /dev/null: $!");
  local *STDOUT; ## no critic (Variables::RequireInitializationForLocalVars)
  open STDOUT, '>', '/dev/null' || croak("Could not open /dev/null: $!");
  local @ARGV=('--fail');
  $ret = eval {
    $mcoe->getopt();
  };
  $expected="Error: Wrong arguments!\n";
  is($@, $expected,'Checking cli arguments');
}

# checking non-existant config file
{
  $mcoe->config_file('non-existant-file.yml');
  $ret = eval {
    $mcoe->get_config();
  };
  $expected="Config file 'non-existant-file.yml' not found!\n";
  is($@, $expected,'Checking exception if config file not found');
}

# checking empty directory list
# only for code coverage
$mcoe->config({});
$mcoe->check_dir_list();
$got = eval {
 $mcoe->format_output_fail(0);
};

{
  ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
  ## no critic (ValuesAndExpressions::ProhibitEmptyQuotes)

  like($@, qr/State\s""\snot\sknown\sat/smx, 'Checking $self->format_output_fail(0)');
  $got = eval {
   $mcoe->format_output_fail(undef);
  };
  like($@, qr/State\s""\snot\sknown\sat/smx, 'Checking $self->format_output_fail(undef)');
  $got = eval {
   $mcoe->format_output_fail('');
  };
  like($@, qr/State\s""\snot\sknown\sat/smx, 'Checking $self->format_output_fail("")');
}
exit 0;
