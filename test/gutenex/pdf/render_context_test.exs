defmodule Gutenex.PDF.RenderContextTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.RenderContext

  test "#next_index" do
    render_context = %RenderContext{current_index: 11}
    new_render_context = RenderContext.next_index(render_context)
    assert new_render_context.current_index == render_context.current_index + 1
  end

  test "#image_references returns the references from the image aliases" do
    render_context = %RenderContext{
      image_aliases: %{
        "Alpaca" => {:ptr, 1, 0},
        "Byzantium" => {:ptr, 2, 0}
      }
    }
    assert RenderContext.image_references(render_context) ==
       Map.values(render_context.image_aliases)
  end

  test "#font_references returns the references from the font aliases" do
    render_context = %RenderContext{
      font_aliases: %{
        "Bingo" => {:ptr, 3, 0},
        "Bango" => {:ptr, 6, 0},
        "Bongo" => {:ptr, 9, 0}
      }
    }
    assert RenderContext.font_references(render_context) ==
           Map.values(render_context.font_aliases)
  end

  test "#current_object returns an :obj with the current index and generation number" do
    render_context = %RenderContext{
      current_index: 17,
      generation_number: 88
    }
    assert RenderContext.current_object(render_context) ==
           {:obj, render_context.current_index, render_context.generation_number}
  end

  test "#current_reference returns a :ptr with the current index and generation number" do
    render_context = %RenderContext{
      current_index: 17,
      generation_number: 88
    }
    assert RenderContext.current_reference(render_context) ==
           {:ptr, render_context.current_index, render_context.generation_number}
  end
end
