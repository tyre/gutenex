defmodule Gutenex.PDF.Geometry do
  def move_to({point_x, point_y}) do
    "#{point_x} #{point_y} m\n"
  end
end
