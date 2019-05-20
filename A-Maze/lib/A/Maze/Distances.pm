package A::Maze::Distances;
use Moose;

use feature qw(say state postderef signatures);
use experimental qw(postderef signatures);

has _cells => (
  is => 'ro',
  isa => 'HashRef',
  lazy => 1,
  builder => '_build_cells',
);

has root => (
  is => 'ro',
  isa => 'A::Maze::Cell',
  required => 1,
);

sub _build_cells ($self) {
  $self->_cells->{$self->root} = [$self->root, 0];
}

sub set_distance ($self, $cell, $distance) {
  $self->_cells->{$cell} = [$cell, $distance];
}

sub distance ($self, $cell) {
  $self->_cells->{$cell}[1];
}

sub cells ($self) {
  return map { $_->[0] } values $self->_cells->%*;
}

1;
