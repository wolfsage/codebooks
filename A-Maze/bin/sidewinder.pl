#!/usr/bin/env perl

use strict;
use warnings;

use lib qw(lib);

use A::Maze::Grid;
use A::Maze::Generator::Sidewinder;

use Path::Tiny;

my $renderer = shift;
my $debug = shift;

my $bt = A::Maze::Generator::Sidewinder->new;
my $grid = A::Maze::Grid->new({
  rows => 20,
  cols => 20,
  ( $renderer ? (renderer => $renderer) : () ), # Default to ASCII
});

$bt->on($grid);

my $res = $grid->render({
  ( $debug ? (debug_filename => Path::Tiny->tempfile(UNLINK => 0)) : () ),
});

if ($res) {
  print "$res\n";
}
