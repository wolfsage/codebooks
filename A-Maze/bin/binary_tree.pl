#!/usr/bin/env perl

use strict;
use warnings;

use lib qw(lib);

use A::Maze::Grid;
use A::Maze::Generator::BinaryTree;

my $bt = A::Maze::Generator::BinaryTree->new;
my $grid = A::Maze::Grid->new({
  rows => 4,
  cols => 4,
});

$bt->on($grid);
