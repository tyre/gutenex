defmodule Gutenex.PDF.Builder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.Builders.ImageBuilder
  alias Gutenex.PDF.Builders.FontBuilder
  alias Gutenex.PDF.Builders.PageBuilder
  alias Gutenex.PDF.Builders.PageTreeBuilder

  def build(%Context{} = context) do
    {next_index, image_references, image_objects} = ImageBuilder.build(context, 1)
    {page_root_index, font_references, font_objects} = FontBuilder.build(context, next_index)
    {catalog_root_index, page_references, page_objects} = PageBuilder.build(context, page_root_index)
    page_tree = PageTreeBuilder.build(context, page_root_index, %{
      images: image_references,
      fonts: font_references,
      pages: page_references
    })
    catalog = {{:obj, catalog_root_index, context.generation_number},
                build_catalog(page_root_index, context.generation_number)}

    meta_data_index = catalog_root_index + 1
    meta_data = {{:obj, meta_data_index, context.generation_number},
                  build_meta_data(context)}

    all_objects = image_objects ++ font_objects ++ [page_tree | page_objects] ++
                  [catalog, meta_data]
    {catalog_root_index, context.generation_number, meta_data_index, all_objects}
  end


  def build_catalog(page_tree_reference, generation_number) do
    {:dict, %{
      "Type" => {:name, "Catalog"},
      "Pages" => {:ptr, page_tree_reference, generation_number}}}
  end

  def build_meta_data(%Context{} = context) do
    {:dict, %{
      "Title" => {:string, context.meta_data.title},
      "Author" => {:string, context.meta_data.author},
      "Creator" => {:string, context.meta_data.creator},
      "Subject" => {:string, context.meta_data.subject},
      "Producer" => {:string, context.meta_data.producer},
      "Keywords" => {:string, context.meta_data.keywords},
      "CreationDate" => {:date, context.meta_data.creation_date}
    }}
  end
end
