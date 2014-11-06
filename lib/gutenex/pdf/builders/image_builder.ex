defmodule Gutenex.PDF.Builders.ImageBuilder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Images

  def build(%RenderContext{}=render_context, %Context{}=context) do
    render_context = add_images_summary(render_context, context)
  end

  defp add_images_summary(%RenderContext{}=render_context, %Context{}=context) do
    images_summary(Map.to_list(context.images), render_context)
  end

  def images_summary([], %RenderContext{generation_number: generation_number}=render_context) do
    {render_context, summary} = summary_object(render_context, aliases)
    %RenderContext{
      render_context |
      image_summary_reference: {:ptr, render_context.current_index, generation_number},
      image_aliases: image_aliases,
      image_objects: Enum.reverse([summary|x_objects]
    }
  end

  def images_summary([{image_alias, current_image} | images_tail], %RenderContext{generation_number: generation_number}=render_context) do
    render_context = add_image(render_context, current_image, image_alias)
    images_summary(images_tail, render_context)
  end

  defp add_image(render_context, image, aliaz) do
    add_image_extra_object(render_context, image)
    |> RenderContext.next_index
    |> add_image_object(image)
    |> add_image_alias(aliaz)
  end

  defp summary_object(render_context, aliases) do
    render_context = RenderContext.next_index(render_context)
    {
      render_context,
      {{:obj, render_context.current_index, render_context.generation_number}, {:dict, aliases}}
    }
  end

  @doc """
  Calculate the attributes, any additional objects, and add the image to the
  list of images
  """
  defp add_image_object(%RenderContext{}=render_context, %Imagineer.Image{format: :png}=image) do
    image_object = {
      {:obj, render_context.current_index, render_context.generation_number},
      {:stream,
        image_attributes(image, extras_attributes(image)),
        image.content
      }
    }
    %RenderContext{
      render_context |
      images: [image_object | render_context.images]
    }
  end

  @doc """
  Adds the alias to the RenderContext#image_aliases map, under the assumption
  that the current index is that of the image object
  """
  defp add_image_alias(render_context, aliaz) do
    %RenderContext{
      render_context |
      image_aliases: Map.put(RenderContext.image_aliases, aliaz, {:ptr, render_context.current_index, render_context.generation_number})
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
