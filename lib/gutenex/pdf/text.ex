defmodule Gutenex.PDF.Text do
  import Gutenex.PDF.Utils

  @begin_text_marker "\nBT\n"
  @end_text_marker "\nET\n"
  @break_text_marker " T*\n"

  def begin_text do
    @begin_text_marker
  end

  def end_text do
    @end_text_marker
  end

  def break_text do
    @break_text_marker
  end

  def write_text(text_to_write) do
    "(#{escape(text_to_write)}) Tj\n"
  end

  # Moves to the next line and positions the cursor offset by
  # (x_coordinate, y_coordinate)
  def text_position(x_coordinate, y_coordinate) do
    "#{x_coordinate} #{y_coordinate} Td "
  end

end
