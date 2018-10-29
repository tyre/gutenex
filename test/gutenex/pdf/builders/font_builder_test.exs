defmodule Gutenex.PDF.Builders.FontBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Builders.FontBuilder

  setup do
    font_1 = %{"Name" => "Abra", "Subtype" => "Type1", "Type" => "Font"}
    font_2 = %{"Name" => "Barbara", "Subtype" => "Type1", "Type" => "Font"}
    font_3 = %{"Name" => "Cabana", "Subtype" => "Type1", "Type" => "Font"}
    fonts = %{"Abra" => font_1, "Barbara" => font_2, "Cabana" => font_3}

    {render_context, context} =
      FontBuilder.build({
        %RenderContext{current_index: 100, generation_number: 47},
        %Context{fonts: fonts}
      })

    {:ok, %{context: context, render_context: render_context}}
  end

  test "#build increments the current index", %{render_context: render_context} do
    assert render_context.current_index == 103
  end

  test "#build adds the font references", %{render_context: render_context} do
    assert render_context.font_aliases == %{
             "Abra" => {:ptr, 100, 47},
             "Barbara" => {:ptr, 101, 47},
             "Cabana" => {:ptr, 102, 47}
           }
  end

  test "#build adds the font objects", %{context: context, render_context: render_context} do
    assert render_context.font_objects == [
             {{:obj, 100, 47}, {:dict, Map.get(context.fonts, "Abra")}},
             {{:obj, 101, 47}, {:dict, Map.get(context.fonts, "Barbara")}},
             {{:obj, 102, 47}, {:dict, Map.get(context.fonts, "Cabana")}}
           ]
  end
end
