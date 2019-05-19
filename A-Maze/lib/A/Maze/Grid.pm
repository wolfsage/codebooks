package A::Maze::Grid;
use Moose;

use feature qw(say state postderef signatures);
use experimental qw(postderef signatures);

use A::Maze::Cell;

has rows => (is => 'ro', isa => 'Int', required => 1);
has cols => (is => 'ro', isa => 'Int', required => 1);

has grid => (
  is      => 'ro',
  isa     => 'ArrayRef',
  lazy    => 1,
  builder => 'prepare_grid',
);

sub cells ($self) {
  my @cells;

  for my $row ($self->grid->@*) {
    push @cells, $row->@*;
  }

  return @cells;
}

sub prepare_grid ($self) {
  my @grid;

  for my $row (0..$self->rows - 1) {
    for my $col (0..$self->cols - 1) {
      $grid[$row][$col] = A::Maze::Cell->new({
        row => $row,
        col => $col,
      });
    }
  }

  return \@grid;
}

sub BUILD ($self, @) {
  $self->configure_cells;
}

sub configure_cells ($self) {
  $self->do_with_each_cell(sub ($self, $cell) {
    my ($row, $col) = ($cell->row, $cell->col);

    for my $spec (
      [ north => $row - 1, $col ],
      [ south => $row + 1, $col ],
      [ east  => $row, $col - 1 ],
      [ west  => $row, $col + 1 ],
    ) {
      my ($dir, $x, $y) = @$spec;

      if (my $adjacent = $self->grid->[$x] && $self->grid->[$x][$y]) {
        $cell->$dir($adjacent);
      }
    }
  });
}

sub random_cell ($self) {
  my $row = $self->grid->[ rand($self->grid->@*) ];
  return $row->[ rand(@$row) ];
}

sub size ($self) { 
  $self->rows * $self->cols;
}

sub do_with_each_row ($self, $code) {
  for my $row ($self->grid->@*) {
    $code->($self, $row);
  }
}

sub do_with_each_cell ($self, $code) {
  for my $cell ($self->cells) {
    $code->($self, $cell);
  }
}

1;
