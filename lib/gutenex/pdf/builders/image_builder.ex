defmodule Gutenex.PDF.Builders.ImageBuilder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Images

  def build({%RenderContext{}=render_context, %Context{}=context}) do
    render_context = add_images(render_context, Map.to_list(context.images))
    {render_context, context}
  end

  def add_images(%RenderContext{}=render_context, []) do
    %RenderContext{
      render_context |
      image_objects: Enum.reverse(render_context.image_objects)
    }
  end

  def add_images(%RenderContext{}=render_context, [{image_alias, current_image} | images_tail]) do
    add_image(render_context, current_image, image_alias)
    |> add_images(images_tail)
  end

  defp add_image(render_context, image, image_alias) do
    add_image_extra_object(render_context, image)
    |> add_image_object(image)
    |> add_image_alias(image_alias)
    |> RenderContext.next_index
  end

  @doc """
  Calculate the attributes, any additional objects, and add the image to the
  list of images
  """
  defp add_image_object(%RenderContext{}=render_context, %Imagineer.Image{format: :png}=image) do
    image_object = {
      RenderContext.current_object(render_context),
      {:stream,
        image_attributes(image, extra_attributes(image)),
        image.content
      }
    }
    %RenderContext{
      render_context |
      image_objects: [image_object | render_context.image_objects]
    }
  end

  @doc """
  Adds the alias to the RenderContext#image_aliases map, under the assumption
  that the current index is that of the image object
  """
  defp add_image_alias(render_context, image_alias) do
    image_reference = RenderContext.current_reference(render_context)
    %RenderContext{
      render_context |
      image_aliases: Map.put(render_context.image_aliases, image_alias, image_reference)
    }
  end

  @doc """
  Extra attributes specific to the image format, color type, or other attributes
  """
  def extra_attributes(%Imagineer.Image{format: :png, attributes: %{ color_type: 2 }}=image) do
    %{
      "Filter"            => {:name, "FlateDecode"},
      "ColorSpace"        => {:name, Images.png_color(image.attributes.color_type)},
      "DecodeParms"       => decode_params(image),
      "BitsPerComponent"  => image.bit_depth
    }
  end

  @doc """
  PNGs with color type 2 have no extra object
  returns the render_context
  """
  defp add_image_extra_object(render_context, %Imagineer.Image{format: :png, attributes: %{ color_type: 2 }}) do
    render_context
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
end
