defmodule Gutenex.Geometry.Line do
  import Gutenex.Geometry

  def line_width(number) do
    "#{number} w q "
  end

  def line({from_point, to_point}) do
    move_to(from_point) <>
    draw_line(to_point) <>
    "S\n"
  end

  def line({from_x, from_y}, {to_x, to_y}) do
    line({{from_x, from_y}, {to_x, to_y}})
  end

  def line(from_x, from_y, to_x, to_y) do
    line({{from_x, from_y}, {to_x, to_y}})
  end

  def lines(list_of_lines) do
    Enum.map(list_of_lines, &line(&1))
  end

  defp draw_line({point_x, point_y}) do
    "#{point_x} #{point_y} l "
  end
end
