package A::Maze::Cell;
use Moose;

use feature qw(say state postderef signatures);
use experimental qw(postderef signatures);

has row => (is => 'ro', isa => 'Int', required => 1);
has col => (is => 'ro', isa => 'Int', required => 1);

has north => (is => 'rw', isa => 'A::Maze::Cell');
has south => (is => 'rw', isa => 'A::Maze::Cell');
has east  => (is => 'rw', isa => 'A::Maze::Cell');
has west  => (is => 'rw', isa => 'A::Maze::Cell');

has _links => (
  is      => 'ro',
  isa     => 'HashRef',
  traits  => ['Hash'],
  handles => {
    _link   => 'set',
    _unlink => 'delete',
    links   => 'values',
    _linked  => 'exists'
  },
);

sub linked ($self, $cell) {
  return unless $cell;

  return $self->_linked($cell);
}

sub link ($self, $cell) {
  $self->_link($cell => $cell);
  $cell->_link($self => $self);

  $self;
}

sub unlink ($self, $cell) {
  $self->_unlink($cell);
  $cell->_unlink($self);

  $self
}

sub neighbors ($self) {
  my @list = grep {
    defined
  } map {
    $self->$_
  } qw(north south east west);
}

1;
