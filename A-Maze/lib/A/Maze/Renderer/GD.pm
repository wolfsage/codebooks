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
  my $debug_filename = $arg->{debug_filename};
  my $debug_file = path($debug_filename) if $debug_filename;

  my $img_width = $cell_size * $grid->cols;
  my $img_height = $cell_size * $grid->rows;

  my $img = GD::Image->new($img_width + 7, $img_height + 7);

  my $debug = $debug_file ? sub ($finish = 0) {
    state $gifdata = do { $img->gifanimbegin(1) . $img->gifanimadd; };

    if ($finish) {
      $gifdata .= $img->gifanimend;

      return $gifdata;
    }

    $gifdata .= $img->gifanimadd(1, 0, 0, 0);
  } : sub (@) {};

  my $background = $img->colorAllocate(255, 255, 255);
  my $wall = $img->colorAllocate(0, 0, 0);

  $img->fill(0, 0, $background);

  $debug->();

  $grid->do_with_each_cell(sub ($grid, $cell) {
    # Shift x/y 3 pixels so we get our maze drawn within a border
    # and its outer walls are visible with dark backgrounds
    my $x1 = $cell->col * $cell_size + 3;
    my $y1 = $cell->row * $cell_size + 3;
    my $x2 = $x1 + $cell_size;
    my $y2 = $y1 + $cell_size;

    $img->line($x1, $y1, $x2, $y1, $wall) unless $cell->north;
    $debug->() unless $cell->north;

    $img->line($x1, $y1, $x1, $y2, $wall) unless $cell->west;
    $debug->() unless $cell->west;

    $img->line($x2, $y1, $x2, $y2, $wall) unless $cell->linked($cell->east);
    $debug->() unless $cell->linked($cell->east);

    $img->line($x1, $y2, $x2, $y2, $wall) unless $cell->linked($cell->south);
    $debug->() unless $cell->linked($cell->south);
  });

  $file->spew_raw($img->png);

  if ($debug_file) {
    my $debug_gif = $debug->("end");
    $debug_file->spew_raw($debug_gif);
    warn "Debug image: $debug_file\n";
  }

  return $file;
}

1;
