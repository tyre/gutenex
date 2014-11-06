defmodule Gutenex.PDF.Builders.CatalogBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.Builders.CatalogBuilder

  test "#build" do
    render_context = %RenderContext{
      current_index: 7,
      generation_number: 13,
      page_tree_index: 12,
      catalog_index: nil
    }
    {updated_render_context, _context} = CatalogBuilder.build({render_context, %Context{}})
    assert updated_render_context.catalog ==
    {{:obj, render_context.current_index, render_context.generation_number}, {:dict, %{
           "Type"  => {:name, "Catalog"},
           "Pages" => {:ptr, render_context.page_tree_index, render_context.generation_number}}}}
    assert updated_render_context.current_index == render_context.current_index + 1
  end
end
