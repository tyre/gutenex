defmodule Gutenex.PDF.Builders.ImageBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Context
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
    assert ImageBuilder.build(context, 100) ==
      {102, {:ptr, 101, 30}, [raw_x_object, {{:obj, 101, 30}, {:dict, %{"Bobby" => {:ptr, 100, 30}}}}]}
  end

  test "#images_summary with no images" do
    assert ImageBuilder.images_summary([], 100, 40) ==
      {101, {:ptr, 100, 40}, [{{:obj, 100, 40}, {:dict, %{}}}]}
  end

  test "#images_summary with one image", %{image: image, image_x_object: x_object} do
    {_obj_count, [raw_x_object, []]} = x_object
    assert ImageBuilder.images_summary([{"Img4", image}], 100, 30) ==
      {102, {:ptr, 101, 30}, [raw_x_object, {{:obj, 101, 30}, {:dict, %{"Img4" => {:ptr, 100, 30}}}}]}
  end

  test "outputting a PNG to an XObject", %{image: image, image_x_object: x_object} do
    {object_number, object_generation_number} = {100, 30}
    assert ImageBuilder.image_to_x_object(image, object_number, object_generation_number) == x_object
  end
end
