defmodule Gutenex.PDF.Builders.ImageBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Builders.ImageBuilder

  setup do
    {:ok, image} = Imagineer.load("./test/support/images/alpaca.png")

    image_x_object =
      {100,
       [
         {{:obj, 100, 30},
          {:stream,
           {:dict,
            %{
              "Type" => {:name, "XObject"},
              "Subtype" => {:name, "Image"},
              "Width" => 96,
              "Height" => 96,
              "Filter" => {:name, "FlateDecode"},
              "BitsPerComponent" => 8,
              "DecodeParams" =>
                {:dict,
                 %{"Predictor" => 15, "Colors" => 3, "BitsPerComponent" => 8, "Columns" => 96}},
              "ColorSpace" => {:name, "DeviceRGB"}
            }}, Imagineer.Image.PNG.to_binary(image)}},
         []
       ]}

    {:ok, %{image: image, image_x_object: image_x_object}}
  end

  test "#build", %{image: image, image_x_object: x_object} do
    context = %Context{images: %{"Bobby" => image}, generation_number: 30}
    {_obj_count, [raw_x_object, []]} = x_object

    {new_render_context, ^context} =
      ImageBuilder.build({%RenderContext{current_index: 100, generation_number: 30}, context})

    assert new_render_context.current_index == 101
    assert new_render_context.image_objects == [raw_x_object]
  end
end
