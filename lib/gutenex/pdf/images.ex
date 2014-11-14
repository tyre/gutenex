defmodule Gutenex.PDF.Images do
  alias Gutenex.PDF.Graphics
  alias Imagineer.Image

  def set_image(image_alias, %Image{}=image, options\\%{}) do
    Graphics.with_state fn ->
      scale(image_options(image, options)) <>
      Graphics.paint(image_alias)
    end
  end

  # So named because `alias` is not something I want to redefine
  def image_alias(%Image{uri: uri}=image) when not is_nil(uri) do
    :crypto.hash(:md5, uri)
  end

  defp image_options(image, options) do
    default_options = %{
      width: image.width,
      height: image.height,
      translate_x: 0,
      translate_y: 0,
      skew_x: 0,
      skew_y: 0
    }
    Dict.merge(default_options, options)
  end

  defp scale(options) do
    scale_params = Enum.map([
      Map.get(options, :width),
      Map.get(options, :skew_x),
      Map.get(options, :skew_y),
      Map.get(options, :height),
      Map.get(options, :translate_x),
      Map.get(options, :translate_y)
    ], &to_string/1)
    |> Enum.join(" ")
    "#{scale_params} cm\n"
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
