defmodule Gutenex.PDF.ImagesTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Images

  test "#set_image" do
    aliaz = "Image1000"
    image = %Imagineer.Image.PNG{width: 237, height: 191}
    assert Images.set_image(aliaz, image) == "q\n237 0 0 191 0 0 cm\n/#{aliaz} Do\nQ\n"
  end

  test "#set_image with a custom width and height" do
    aliaz = "Image1000"
    image = %Imagineer.Image.PNG{width: 237, height: 191}

    assert Images.set_image(aliaz, image, %{width: 100, height: 100}) ==
             "q\n100 0 0 100 0 0 cm\n/#{aliaz} Do\nQ\n"
  end

  test "#set_image with a translation" do
    aliaz = "Image1000"
    image = %Imagineer.Image.PNG{width: 100, height: 100}

    assert Images.set_image(aliaz, image, %{translate_x: 500, translate_y: 300}) ==
             "q\n100 0 0 100 500 300 cm\n/#{aliaz} Do\nQ\n"
  end

  test "#set_image with a skew" do
    aliaz = "Image1000"
    image = %Imagineer.Image.PNG{width: 100, height: 100}

    assert Images.set_image(aliaz, image, %{skew_x: 15, skew_y: 7}) ==
             "q\n100 15 7 100 0 0 cm\n/#{aliaz} Do\nQ\n"
  end
end
