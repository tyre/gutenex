defmodule Gutenex.PDF.TextTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Text

  test "#begin_text" do
    assert Text.begin_text() == "\nBT\n"
  end

  test "#end_text" do
    assert Text.end_text() == "\nET\n"
  end

  test "#break_text" do
    assert Text.break_text() == " T*\n"
  end

  test "#write_text" do
    assert Text.write_text("Bananas") == "(Bananas) Tj\n"

    assert Text.write_text("(Bananas)") == "(\\(Bananas\\)) Tj\n", "it escapes parenthesis"
    assert Text.write_text("\\Bananas") == "(\\\\Bananas) Tj\n", "it escapes backslashes"
  end

  test "#text_position" do
    assert Text.text_position(200, 30) == "200 30 Td "
  end

end
