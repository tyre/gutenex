defmodule Gutenex.PDF.Builders.CatalogBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.Builders.CatalogBuilder

  test "#build" do
    render_context = %RenderContext{
      current_index: 7,
      generation_number: 13,
      page_tree_reference: {:ptr, 12, 0},
      template_aliases: %{"Francis" => {:ptr, 22, 1}}
    }

    {updated_render_context, _context} = CatalogBuilder.build({render_context, %Context{}})

    assert updated_render_context.catalog_reference ==
             RenderContext.current_reference(render_context)

    assert updated_render_context.catalog == {
             RenderContext.current_object(render_context),
             {:dict,
              %{
                "Type" => {:name, "Catalog"},
                "Pages" => render_context.page_tree_reference,
                "Names" => {
                  :dict,
                  %{
                    "Templates" => {:dict, render_context.template_aliases}
                  }
                }
              }}
           }

    assert updated_render_context.current_index == render_context.current_index + 1
  end
end
