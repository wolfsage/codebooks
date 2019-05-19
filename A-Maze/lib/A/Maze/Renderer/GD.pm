package A::Maze::Renderer::GD;
use Moose;

with 'A::Maze::Renderer';

use feature qw(say state postderef signatures);
use experimental qw(postderef signatures);

use GD;
use Path::Tiny;

sub render ($self, $grid, $arg = {}) {
  my $cell_size = $arg->{cell_size} || 10;
  my $filename = $arg->{filename};
  my $file = $filename ? path($filename) : Path::Tiny->tempfile(UNLINK => 0);

  my $img_width = $cell_size * $grid->cols;
  my $img_height = $cell_size * $grid->rows;

  my $img = GD::Image->new($img_width + 1, $img_height + 1);

  my $background = $img->colorAllocate(255, 255, 255);
  my $wall = $img->colorAllocate(0, 0, 0);

  $img->fill(0, 0, $background);

  $grid->do_with_each_cell(sub ($grid, $cell) {
    my $x1 = $cell->col * $cell_size;
    my $y1 = $cell->row * $cell_size;
    my $x2 = ($cell->col + 1) * $cell_size;
    my $y2 = ($cell->row + 1) * $cell_size;

    $img->line($x1, $y1, $x2, $y2, $wall) unless $cell->north;
    $img->line($x1, $y1, $x1, $y2, $wall) unless $cell->west;

    $img->line($x2, $y1, $x2, $y2, $wall) unless $cell->linked($cell->east);
    $img->line($x1, $y2, $x2, $y2, $wall) unless $cell->linked($cell->south);
  });

  $file->spew_raw($img->png);  

  return $file;
}

1;
