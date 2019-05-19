#!/usr/bin/env perl

use strict;
use warnings;

use lib qw(lib);

use A::Maze::Grid;
use A::Maze::Generator::BinaryTree;

my $bt = A::Maze::Generator::BinaryTree->new;
my $grid = A::Maze::Grid->new({
  rows => 8,
  cols => 8,
});

$bt->on($grid);

$grid->render;
