defmodule Gutenex.PDF.Builders.CatalogBuilder do
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Context

  def build({%RenderContext{}=render_context, %Context{}=context}) do
    render_context = add_catalog(render_context)
    |> add_catalog_reference
    |> RenderContext.next_index
    {render_context, context}
  end

  defp add_catalog(%RenderContext{}=render_context) do
    %RenderContext{
      render_context |
      catalog: {
        {:obj, render_context.current_index, render_context.generation_number},
        {:dict, %{
          "Type" => {:name, "Catalog"},
          "Pages" => render_context.page_tree_reference
        }}
      }
    }
  end

  defp add_catalog_reference(render_context) do
    %RenderContext{
      render_context |
      catalog_reference: RenderContext.current_reference(render_context)
    }
  end
end
