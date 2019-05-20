package A::Maze::Cell;
use Moose;

use feature qw(say state postderef signatures);
use experimental qw(postderef signatures);

use A::Maze::Distances;

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

sub distances ($self) {
  my $distances = A::Maze::Distances->new($self);
  my @frontier = ($self);

  while (@frontier) {
    my @new_frontier;

    for my $cell (@frontier) {
      for my $link ($cell->links) {
        next if $distances->get_distance($link);

        $distances->set_distance($link, $distances->get_distance($cell) + 1);

        push @new_frontier, $link;
      }
    }

    @frontier = @new_frontier;
  }
}

1;
