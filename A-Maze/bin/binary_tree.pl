#!/usr/bin/env perl

use strict;
use warnings;

use lib qw(lib);

use A::Maze::Grid;
use A::Maze::Generator::BinaryTree;

use Path::Tiny;

my $renderer = shift;
my $debug = shift;

my $bt = A::Maze::Generator::BinaryTree->new;
my $grid = A::Maze::Grid->new({
  rows => 8,
  cols => 8,
  ( $renderer ? (renderer => $renderer) : () ), # Default to ASCII
});

$bt->on($grid);

$grid->render({
  ( $debug ? (debug_filename => Path::Tiny->tempfile(UNLINK => 0)) : () ),
});
