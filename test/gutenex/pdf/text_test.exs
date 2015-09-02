defmodule Gutenex.PDF.TextTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Text

  test "#begin_text" do
    assert Text.begin_text() == "BT\n"
  end

  test "#end_text" do
    assert Text.end_text() == "ET\n"
  end

  test "#break_text" do
    assert Text.break_text() == " T*\n"
  end

  test "#write_text" do
    assert Text.write_text("Bananas") == "(Bananas) Tj\n"

    assert Text.write_text("(Bananas)") == "(\\(Bananas\\)) Tj\n", "it escapes parenthesis"
    assert Text.write_text("\\Bananas") == "(\\\\Bananas) Tj\n", "it escapes backslashes"
  end
  
  test "#write_text_br" do
    assert Text.write_text_br("Bananas") == "(Bananas) Tj\n T*\n"
  end
  
  test "#text_position" do
    assert Text.text_position(200, 30) == "200 30 Td\n"
  end

  test "#render_mode" do
    assert Text.render_mode(:fill) == "0 Tr\n", 
           "it can set the fill render mode"
    assert Text.render_mode(:stroke) == "1 Tr\n", 
           "it can set the stroke render mode"
    assert Text.render_mode(:fill_stroke) == "2 Tr\n", 
           "it can set the fill_stroke render mode"
    assert Text.render_mode(:invisible) == "3 Tr\n", 
           "it can set the invisible render mode"
    assert Text.render_mode(:fill_clip) == "4 Tr\n", 
           "it can set the fill_clip render mode"
    assert Text.render_mode(:stroke_clip) == "5 Tr\n", 
           "it can set the stroke_clip render mode"
    assert Text.render_mode(:fill_stroke_clip) == "6 Tr\n", 
           "it can set the fill_stroke_clip render mode"
    assert Text.render_mode(:clip) == "7 Tr\n", 
           "it can set the clip render mode"
  end

  test "#character_spacing" do
    assert Text.character_spacing(10) == "10 Tc\n"
  end

  test "#scale" do
    assert Text.scale(90) == "90 Tz\n", "it can set the scale of the text"
    assert Text.scale(:web) == "9001 Tz\n", "it can do web scale"
  end

  test "#word_spacing" do
    assert Text.word_spacing(90) == "90 Tw\n"
  end

  test "#line_spacing" do
    assert Text.line_spacing(10) == "10 Tl\n"
  end
end
