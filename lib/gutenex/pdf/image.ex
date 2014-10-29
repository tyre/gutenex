defmodule Gutenex.PDF.Image do
  alias Imagineer.Image
  # process a png into x_object
  def to_x_object(%Image{format: :png}=image, object_number, object_generation_number) do
    to_x_object(image, {object_number, object_generation_number})
  end

  defp to_x_object(image, {object_index, object_generation_number}) when is_integer(object_index) do
    {extra_attributes, extra_object} = extras(image)
    # total_object_count is object_index + 1 if there is an extra object
    total_object_count = if extra_object == [] do
      object_index
    else
      object_index + 1
    end
    {
      object_index,
      [
        {
          {:obj, total_object_count, object_generation_number},
          {:stream,
            image_attributes(image, extra_attributes),
            image.content
          }
        },
        extra_object
      ]
    }
  end

  def extras(%Image{format: :png, attributes: %{ color_type: 2 }}=image) do
    extra_attributes = %{
      "Filter"            => {:name, "FlateDecode"},
      "ColorSpace"        => {:name, png_color(image.attributes.color_type)},
      "DecodeParms"       => decode_params(image),
      "BitsPerComponent"  => image.bit_depth
    }
    { extra_attributes, []}
  end

  defp image_attributes(image, extra_attributes) do
    {:dict,
      Map.merge(%{
        "Type"    => {:name, "XObject"},
        "Width"   => image.width,
        "Height"  => image.height,   
        "Subtype" => {:name, "Image"}
      }, extra_attributes)
    }
  end

  defp decode_params(image) do
    {
      :dict,
      %{
        "Colors"            => png_bits(image.attributes.color_type),
        "Columns"           => image.width,
        "Predictor"         => 15,
        "BitsPerComponent"  => image.bit_depth
      }
    }
  end


  def images_summary(images, object_index, object_generation_number) do
    images_summary(images, {object_index, object_generation_number}, %{}, [])
  end

  def images_summary([], {object_index, object_generation_number}, image_aliases, x_objects) do
    aliases = image_aliases_objects(image_aliases, object_generation_number)
    summary = {
      {:obj, object_index, object_generation_number},
      {:dict, aliases}
    }
    {
      object_index + 1,
      {:ptr, object_index, object_generation_number},
      Enum.reverse([summary|x_objects])
    }
  end

  def images_summary([current_image | images_tail], {object_index, object_generation_number}, image_aliases, x_objects) do
    {next_object_index, x_objects} = case to_x_object(current_image, {object_index, object_generation_number}) do
      {next_object_index, [x_object, []]} ->
        {next_object_index, [x_object | x_objects]}
      {next_object_index, [x_object, extra_objects]} ->
        {next_object_index, [x_object, extra_objects | x_objects]}
    end
    image_aliases = Map.put image_aliases, "Img#{object_index}", object_index
    images_summary(images_tail, {next_object_index + 1, object_generation_number}, image_aliases, x_objects)
  end

  defp image_aliases_objects(images, object_generation_number) do
    Enum.reduce images, %{}, fn ({aliass, image_index}, aliases) ->
      Map.put aliases, aliass, {:ptr, image_index, object_generation_number}
    end
  end

  defp png_color(0), do: "DeviceGray"
  defp png_color(2), do: "DeviceRGB"
  defp png_color(3), do: "DeviceGray"
  defp png_color(4), do: "DeviceGray"
  defp png_color(6), do: "DeviceRGB"

  defp png_bits(0), do: 1
  defp png_bits(2), do: 3
  defp png_bits(3), do: 1
  defp png_bits(4), do: 1
  defp png_bits(6), do: 3
end
