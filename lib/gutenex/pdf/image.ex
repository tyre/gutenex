defmodule Gutenex.PDF.Image do
  alias Imagineer.Image
  # process a png into x_object
  def to_x_object(%Image{format: :png}=image) do
    to_x_object(image, 1)
  end

  defp to_x_object(image, object_index) when is_integer(object_index) do
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
          {:obj, total_object_count, 0},
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


  def images_summary(images) do
    images_summary(images, 1, %{}, [])
  end

  def images_summary([], total_object_count, image_aliases, x_objects) do
    aliases = image_aliases_objects(image_aliases)
    summary = {
      {:obj, total_object_count, 0},
      {:dict, aliases}
    }
    {
      total_object_count + 1,
      {:ptr, total_object_count, 0},
      Enum.reverse([summary|x_objects])
    }
  end

  def images_summary([current_image | images_tail], existing_object_count, image_aliases, x_objects) do
    {total_object_count, x_objects} = case to_x_object(current_image, existing_object_count) do
      {total_object_count, [x_object, []]} ->
        {total_object_count, [x_object | x_objects]}
      {total_object_count, [x_object, extra_objects]} ->
        {total_object_count, [x_object, extra_objects | x_objects]}
    end
    image_aliases = Map.put image_aliases, "Img#{existing_object_count}", existing_object_count
    images_summary(images_tail, total_object_count + 1, image_aliases, x_objects)
  end

  defp image_aliases_objects(images) do
    Enum.reduce images, %{}, fn ({aliass, image_index}, aliases) ->
      Map.put aliases, aliass, {:ptr, image_index, 0}
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
