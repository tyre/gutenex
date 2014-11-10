defmodule Gutenex.PDF.Builders.ImageBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Builders.ImageBuilder

  setup do
    image = %Imagineer.Image{uri: "./test/support/images/alpaca.png"} |>
            Imagineer.Image.load() |>
            Imagineer.Image.process()
    image_x_object = {100, [{{:obj, 100, 30}, {:stream, {:dict, %{"Type" => {:name, "XObject"}, "Subtype" => {:name, "Image"}, "Width" => 96, "Height" => 96, "Filter" => {:name, "FlateDecode"}, "BitsPerComponent" => 8, "DecodeParms" => {:dict, %{"Predictor" => 15, "Colors" => 3, "BitsPerComponent" => 8, "Columns" => 96}}, "ColorSpace" => {:name, "DeviceRGB"}}}, image.content}}, []]}
    {:ok, %{image: image, image_x_object: image_x_object}}
  end

  test "#build", %{image: image, image_x_object: x_object} do
    context = %Context{images: %{"Bobby" => image}, generation_number: 30}
    {_obj_count, [raw_x_object, []]} = x_object
    {new_render_context, ^context} = ImageBuilder.build({%RenderContext{current_index: 100, generation_number: 30}, context})
    assert new_render_context.current_index == 102
    assert new_render_context.image_objects == [raw_x_object, {{:obj, 101, 30}, {:dict, %{"Bobby" => {:ptr, 100, 30}}}}]
  end

  test "#add_image_summary with no images" do
    new_render_context = ImageBuilder.add_image_summary(%RenderContext{current_index: 100, generation_number: 40})
    assert new_render_context.current_index == 101
    assert new_render_context.image_summary_reference == {:ptr, 100, 40}
    assert new_render_context.image_objects == [{{:obj, 100, 40}, {:dict, %{}}}]
  end

  test "#add_image_summary with one image", %{image_x_object: x_object} do
    {_obj_count, [raw_x_object, []]} = x_object
    new_render_context = ImageBuilder.add_image_summary(%RenderContext{
      image_objects: [raw_x_object],
      image_aliases: %{"Img4" => {:ptr, 100, 30}},
      current_index: 101,
      generation_number: 30})
    assert new_render_context.current_index == 102
    assert new_render_context.image_summary_reference == {:ptr, 101, 30}
    assert new_render_context.image_objects == [raw_x_object, {{:obj, 101, 30}, {:dict, %{"Img4" => {:ptr, 100, 30}}}}]
  end
end
