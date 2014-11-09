defmodule Gutenex.PDF.Builders.PageTreeBuilder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext

  def build({%RenderContext{}=render_context, %Context{}=context}) do
    render_context = RenderContext.next_index(render_context)
    {
      %RenderContext{
        render_context |
        page_tree_reference: {:ptr, render_context.current_index, render_context.generation_number},
        page_tree: build_page_tree(render_context, context)
      },
      context,
    }
  end

  defp build_page_tree(%RenderContext{}=render_context, %Context{}=context) do
    {
      {:obj, render_context.current_index, render_context.generation_number},
      {:dict, %{
        "Type" => {:name, "Pages"},
        "Count" => length(render_context.page_references),
        "MediaBox" => {:rect, media_box(context.media_box)},
        "Kids" => {:array, render_context.page_references},
        "Resources" => page_resources(render_context)}}
    }
  end

  def media_box({top_left, top_right, bottom_left, bottom_right}) do
    [top_left, top_right, bottom_left, bottom_right]
  end

  def page_resources(%RenderContext{}=render_context) do
    {:dict, %{
      "Font" => {:dict, render_context.font_aliases},
      "XObject" => {:dict, render_context.image_aliases}
    }}
  end
end
