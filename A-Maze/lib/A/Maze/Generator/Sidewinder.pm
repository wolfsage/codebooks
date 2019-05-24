package A::Maze::Generator::Sidewinder;
use Moose;

with 'A::Maze::Generator';

use feature qw(say state postderef signatures);
use experimental qw(postderef signatures);

sub on ($self, $grid) {
  $grid->do_with_each_row(sub ($grid, $row) {
    my @run;

    for my $cell (@$row) {
      push @run, $cell;

      my $at_eastern_boundary = ! $cell->east;
      my $at_northern_boundary = ! $cell->north;

      my $should_close_out = $at_eastern_boundary
        || (! $at_northern_boundary && int(rand(2)) == 0);

      if ($should_close_out) {
        my $member = $run[ rand(@run) ];
        $member->link($member->north) if $member->north;
        @run = ();
      } else {
        $cell->link($cell->east);
      }
    }
  });
}

1;
