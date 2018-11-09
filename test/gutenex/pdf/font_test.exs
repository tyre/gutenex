defmodule Gutenex.PDF.FontTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Font

  test "setting a font" do
    assert Font.set_font(Font.standard_fonts(), "Courier", 32) == "/Courier 32 Tf\n",
           "it returns the font set command"

    assert Font.set_font(Font.standard_fonts(), "Helvetica") == "/Helvetica 12 Tf\n",
           "it defaults the size to 12"

    assert Font.set_font(Font.standard_fonts(), "Bananas") == "/Helvetica 12 Tf\n",
           "it defaults the font to Helvetica when font is not found"
  end
end
