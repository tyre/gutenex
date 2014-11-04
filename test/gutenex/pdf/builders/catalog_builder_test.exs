defmodule Gutenex.PDF.Builders.CatalogBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.Builders.CatalogBuilder

  test "#build" do
    catalog_root_index = 7
    page_root_index = 12
    context = %Context{generation_number: 13}
    assert CatalogBuilder.build(context, catalog_root_index, page_root_index) ==
    {{:obj, catalog_root_index, context.generation_number}, {:dict, %{
           "Type"  => {:name, "Catalog"},
           "Pages" => {:ptr, page_root_index, context.generation_number}}}}
  end
end
