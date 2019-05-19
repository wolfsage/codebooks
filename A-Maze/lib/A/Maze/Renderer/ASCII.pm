package A::Maze::Renderer::ASCII;
use Moose;

with 'A::Maze::Renderer';

use feature qw(say state postderef signatures);
use experimental qw(postderef signatures);

sub render ($self, $grid, $arg = {}) {
  say "+" . ("---+" x $grid->cols);

  $grid->do_with_each_row(sub ($grid, $row) {
    my $top = "|";
    my $bottom = "+";

    for my $cell (@$row) {
      $cell //= A::Maze::Cell->new({
        row => -1,
        col => -1,
      });

      my $body = "   "; # 3sp
      my $east_boundary = ($cell->east && $cell->linked($cell->east)) ? " " : "|";
      $top .= $body .= $east_boundary;

      my $south_boundary = ($cell->south && $cell->linked($cell->south)) ? "   " : "---";
      my $corner = "+";
      $bottom .= $south_boundary .= $corner;
    }

    say $top;
    say $bottom;
  });
}

1;
