defmodule Gutenex.PDF.ImagesTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Images

  test "#set_image" do
    aliaz = "Image1000"
    image = %Imagineer.Image{width: 237, height: 191}
    assert Images.set_image(aliaz, image) ==
           "q\n237 0 0 191 0 0 cm\n/#{aliaz} Do\nQ\n"
  end
end
