defmodule Gutenex.PDF.Builders.CatalogBuilder do
  alias Gutenex.PDF.Context

  def build(%Context{}=context, catalog_root_index, page_root_index) do
    {{:obj, catalog_root_index, context.generation_number},
                build_catalog(page_root_index, context.generation_number)}
  end

  defp build_catalog(page_tree_reference, generation_number) do
    {:dict, %{
      "Type" => {:name, "Catalog"},
      "Pages" => {:ptr, page_tree_reference, generation_number}}}
  end
end
