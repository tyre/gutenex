defmodule Gutenex.PDF.Builders.ImageBuilder do
  alias Gutenex.PDF.Images

  def build(context, start_object_number) do
    images_summary(Map.to_list(context.images), start_object_number, context.generation_number)
  end

  def image_to_x_object(%Imagineer.Image{format: :png}=image, object_number, object_generation_number) do
    image_to_x_object(image, {object_number, object_generation_number})
  end

  defp image_to_x_object(image, {object_index, object_generation_number}) when is_integer(object_index) do
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

  def extras(%Imagineer.Image{format: :png, attributes: %{ color_type: 2 }}=image) do
    extra_attributes = %{
      "Filter"            => {:name, "FlateDecode"},
      "ColorSpace"        => {:name, Images.png_color(image.attributes.color_type)},
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
        "Colors"            => Images.png_bits(image.attributes.color_type),
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

  def images_summary([{image_alias, current_image} | images_tail], {object_index, object_generation_number}, image_aliases, x_objects) do
    {next_object_index, x_objects} = case image_to_x_object(current_image, {object_index, object_generation_number}) do
      {next_object_index, [x_object, []]} ->
        {next_object_index, [x_object | x_objects]}
      {next_object_index, [x_object, extra_objects]} ->
        {next_object_index, [x_object, extra_objects | x_objects]}
    end
    image_aliases = Map.put image_aliases, image_alias, object_index
    images_summary(images_tail, {next_object_index + 1, object_generation_number}, image_aliases, x_objects)
  end

  defp image_aliases_objects(images, object_generation_number) do
    Enum.reduce images, %{}, fn ({aliass, image_index}, aliases) ->
      Map.put aliases, aliass, {:ptr, image_index, object_generation_number}
    end
  end
end
