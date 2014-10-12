defmodule Gutenex.Geometry.Utils do

  # Integer
  def character_list(int) when is_integer(int) do
    to_char_list(int)
  end

  # Float
  def character_list(float) when is_float(float) do
    Float.to_char_list(float, [decimals: 2])
  end

  # Non-empty list
  def character_list([head | tail]) do
    character_list(head) ++ ' ' ++ character_list(tail)
  end

  # Empty list
  def character_list([]) do
    ''
  end

  # Atom
  def character_list(atom) when is_atom(atom) do
    Atom.to_char_list(atom)
  end

  def move_to({point_x, point_y}) do
    character_list([point_x, point_y]) ++ 'm '
  end


end
