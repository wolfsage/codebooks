#!/usr/bin/env perl

use strict;
use warnings;

use lib qw(lib);

use A::Maze::Grid;
use A::Maze::Generator::Sidewinder;

my $renderer = shift;

my $bt = A::Maze::Generator::Sidewinder->new;
my $grid = A::Maze::Grid->new({
  rows => 20,
  cols => 20,
  ( $renderer ? (renderer => $renderer) : () ), # Default to ASCII
});

$bt->on($grid);

my $res = $grid->render;

if ($res) {
  print "$res\n";
}


