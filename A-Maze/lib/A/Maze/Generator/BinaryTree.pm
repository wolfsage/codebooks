package A::Maze::Generator::BinaryTree;
use Moose;

use feature qw(say state postderef signatures);
use experimental qw(postderef signatures);

sub on ($self, $grid) {
  $grid->do_with_each_cell(sub ($grid, $cell) {
    my @neighbors;

    push @neighbors, $cell->north if $cell->north;
    push @neighbors, $cell->east if $cell->east;

    if (my $neighbor = $neighbors[ rand(@neighbors) ]) {
      $cell->link($neighbor);
    }
  });
}

1;
