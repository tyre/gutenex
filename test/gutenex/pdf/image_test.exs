defmodule Gutenex.PDF.ImageTest do
  use ExUnit.Case, async: true

  setup do
    image = %Imagineer.Image{uri: "./test/support/images/alpaca.png"} |>
            Imagineer.Image.load() |>
            Imagineer.Image.process()
    x_object = {1,[{{:obj, 1, 0}, {:stream, {:dict, %{"Type" => {:name, "XObject"}, "Subtype" => {:name, "Image"}, "Width" => 96, "Height" => 96, "Filter" => {:name, "FlateDecode"}, "BitsPerComponent" => 8, "DecodeParms" => {:dict, %{"Predictor" => 15, "Colors" => 3, "BitsPerComponent" => 8, "Columns" => 96}}, "ColorSpace" => {:name, "DeviceRGB"}}}, image.content}}, []]}
    {:ok, %{image: image, x_object: x_object}}
  end

  test "outputting a PNG to an XObject", %{image: image, x_object: x_object} do
    assert Gutenex.PDF.Image.to_x_object(image) == x_object
  end

  test "#images_summary with no images" do
    assert Gutenex.PDF.Image.images_summary([]) ==
      {2, {:ptr, 1, 0}, [{{:obj, 1, 0}, {:dict, %{}}}]}
  end

  test "#images_summary with one image", %{image: image, x_object: x_object} do
    {_obj_count, [raw_x_object, []]} = x_object
    assert Gutenex.PDF.Image.images_summary([image]) ==
      {3, {:ptr, 2, 0}, [raw_x_object, {{:obj, 2, 0}, {:dict, %{"Img1" => {:ptr, 1, 0}}}}]}
  end
end
