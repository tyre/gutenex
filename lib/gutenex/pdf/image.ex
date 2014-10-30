defmodule Gutenex.PDF.Image do
  alias Imagineer.Image

  def png_color(0), do: "DeviceGray"
  def png_color(2), do: "DeviceRGB"
  def png_color(3), do: "DeviceGray"
  def png_color(4), do: "DeviceGray"
  def png_color(6), do: "DeviceRGB"
  
  def png_bits(0), do: 1
  def png_bits(2), do: 3
  def png_bits(3), do: 1
  def png_bits(4), do: 1
  def png_bits(6), do: 3
end
