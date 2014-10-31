defmodule Gutenex.PDF.Images do
  alias Gutenex.PDF.Graphics
  alias Imagineer.Image

  def set_image(image_alias, %Image{}=image) do
    Graphics.with_state fn ->
      scale(image) <> draw_image(image_alias)
    end
  end

  defp scale(image) do
    "#{image.width} 0 0 #{image.height} 0 0 cm\n"
  end

  defp draw_image(image_alias) do
    "/#{image_alias} Do\n"
  end

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
