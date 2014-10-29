defmodule Gutenex.PDF.ImageTest do
  use ExUnit.Case, async: true

  setup do
    image = %Imagineer.Image{uri: "./test/support/images/alpaca.png"} |>
            Imagineer.Image.load() |>
            Imagineer.Image.process()
    x_object = {100, [{{:obj, 100, 30}, {:stream, {:dict, %{"Type" => {:name, "XObject"}, "Subtype" => {:name, "Image"}, "Width" => 96, "Height" => 96, "Filter" => {:name, "FlateDecode"}, "BitsPerComponent" => 8, "DecodeParms" => {:dict, %{"Predictor" => 15, "Colors" => 3, "BitsPerComponent" => 8, "Columns" => 96}}, "ColorSpace" => {:name, "DeviceRGB"}}}, image.content}}, []]}
    {:ok, %{image: image, x_object: x_object}}
  end

  test "outputting a PNG to an XObject", %{image: image, x_object: x_object} do
    {object_number, object_generation_number} = {100, 30}
    assert Gutenex.PDF.Image.to_x_object(image, object_number, object_generation_number) == x_object
  end

  test "#images_summary with no images" do
    assert Gutenex.PDF.Image.images_summary([], 100, 40) ==
      {101, {:ptr, 100, 40}, [{{:obj, 100, 40}, {:dict, %{}}}]}
  end

  test "#images_summary with one image", %{image: image, x_object: x_object} do
    {_obj_count, [raw_x_object, []]} = x_object
    assert Gutenex.PDF.Image.images_summary([image], 100, 30) ==
      {102, {:ptr, 101, 30}, [raw_x_object, {{:obj, 101, 30}, {:dict, %{"Img100" => {:ptr, 100, 30}}}}]}
  end
end
