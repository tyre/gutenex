defmodule Gutenex.PDF.Builder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.Builders.ImageBuilder
  alias Gutenex.PDF.Builders.FontBuilder
  alias Gutenex.PDF.Builders.PageBuilder
  alias Gutenex.PDF.Builders.PageTreeBuilder
  alias Gutenex.PDF.Builders.CatalogBuilder
  alias Gutenex.PDF.Builders.MetaDataBuilder

  # The way I'm building this looks suspiciously like a GenServer...
  def build(%Context{}=context) do
    render_context = %RenderContext{current_index: 1}
    {next_index, image_references, image_objects} = ImageBuilder.build({render_context, context})
    {page_root_index, font_references, font_objects} = FontBuilder.build(context, next_index)
    {catalog_root_index, page_references, page_objects} = PageBuilder.build(context, page_root_index)
    page_tree = PageTreeBuilder.build(context, page_root_index, %{
      images: image_references,
      fonts: font_references,
      pages: page_references
    })
    catalog = CatalogBuilder.build(context, catalog_root_index, page_root_index)

    meta_data_index = catalog_root_index + 1
    meta_data = MetaDataBuilder.build(context, meta_data_index)

    all_objects = image_objects ++ font_objects ++ [page_tree | page_objects] ++
                  [catalog, meta_data]
    {catalog_root_index, context.generation_number, meta_data_index, all_objects}
  end
end
