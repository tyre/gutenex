defmodule Gutenex.PDF.Builders.FontBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.Builders.FontBuilder

  setup do
    font_1 = %{"Name" => "Abra",    "Subtype" => "Type1", "Type" => "Font"}
    font_2 = %{"Name" => "Barbara", "Subtype" => "Type1", "Type" => "Font"}
    font_3 = %{"Name" => "Cabana",  "Subtype" => "Type1", "Type" => "Font"}
    fonts = %{"Abra" => font_1, "Barbara" => font_2, "Cabana" => font_3}
    {:ok, %{ context: %Context{fonts: fonts, generation_number: 47} }}
  end

  test "#build", %{context: context} do
    {next_index, font_references, font_objects} = FontBuilder.build(context, 100)

    assert next_index == 103, "it returns the next index"
    assert font_references == %{
      "Abra" => {:ptr, 100, 47},
      "Barbara" => {:ptr, 101, 47},
      "Cabana" => {:ptr, 102, 47}
    }
    assert font_objects == [
      {{:obj, 100, 47}, {:dict, Map.get(context.fonts, "Abra")}},
      {{:obj, 101, 47}, {:dict, Map.get(context.fonts, "Barbara")}},
      {{:obj, 102, 47}, {:dict, Map.get(context.fonts, "Cabana")}}
    ]
  end
end
