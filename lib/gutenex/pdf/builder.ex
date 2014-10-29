defmodule Gutenex.PDF.Builder do
  alias Gutenex.PDF.Context

  def build(%Context{} = context) do
    {current_index, image_references, image_objects} =
      Gutenex.PDF.Image.images_summary(context.images, 1, context.generation_number)
    {page_root_index, font_references, font_objects} = build_fonts(current_index, context.generation_number, context.fonts)
    {catalog_root_index, page_references, page_objects} = build_pages(context, page_root_index)
    page_tree = {{:obj, page_root_index, context.generation_number},
                  build_page_tree(context, page_references, image_references, font_references)}
    
    catalog = {{:obj, catalog_root_index, context.generation_number},
                build_catalog(page_root_index, context.generation_number)}
    
    meta_data_index = catalog_root_index + 1
    meta_data = {{:obj, meta_data_index, context.generation_number},
                  build_meta_data(context)}

    all_objects = image_objects ++ font_objects ++ [page_tree | page_objects] ++ 
                  [catalog, meta_data]
    {catalog_root_index, context.generation_number, meta_data_index, all_objects}
  end

  # Builds each font object, returning the last object index, the reference
  # dictionary (for each font, "FontReference" => {:ptr, font_index, font_generation_number})
  # and the font objects themselves
  def build_fonts(current_index, generation_number, fonts) do
    build_fonts({current_index, generation_number}, Map.to_list(fonts), %{}, [])
  end

  def build_fonts({current_index, generation_number}, [], font_references, font_objects) do
    {current_index, font_references, Enum.reverse(font_objects)}
  end

  def build_fonts({current_index, generation_number}, [{font_alias, font_definition}|rest_of_fonts]=fonts, font_references, font_objects) do
    font_objects = [{{:obj, current_index, generation_number}, {:dict, font_definition}} | font_objects]
    font_references = Map.put font_references, font_alias, {:ptr, current_index, generation_number}
    next_index = current_index + 1
    build_fonts({next_index, generation_number}, rest_of_fonts, font_references, font_objects)
  end

  # Pages are built into two objects
  # The first contains the stream of the page contents
  # The second is a dictionary describing the page, a reference to the
  # page tree, and a reference to the page contents
  def build_pages(%Context{} = context, root_index) do
    build_pages({root_index, context.generation_number}, root_index + 1, context.pages, [], [])
  end

  defp build_pages(_index_and_generation_number, current_index, []=_pages_left_to_build, page_references, built_objects) do
    {current_index, Enum.reverse(page_references), Enum.reverse(built_objects)}
  end

  defp build_pages({root_index, generation_number}, current_index, [page|pages_left_to_build], page_references, built_objects) do
    page_summary_reference = current_index + 1
    page_contents = {{:obj, current_index, generation_number}, {:stream, page}}
    page_summary = page_summary({root_index, generation_number}, page_summary_reference, current_index)

    page_references = [page_summary_reference | page_references]
    built_objects = [page_summary, page_contents | built_objects]
    # We are adding two objects so next index should be two greater than start
    build_pages({root_index, generation_number}, current_index + 2, pages_left_to_build, page_references, built_objects)
  end

  defp page_summary({root_index, generation_number}, current_index, contents_reference) do
    {
      {:obj, current_index, generation_number},
      {:dict, %{
        "Type" => {:name, "Page"},
        "Parent" => {:ptr, root_index, generation_number},
        "Contents" => {:ptr, contents_reference, generation_number}
      }}
    }
  end

  def build_page_tree(%Context{} = context, page_references, image_references, font_references) do
    {:dict, %{ 
      "Type" => {:name, "Pages"},
      "Count" => length(page_references),
      "MediaBox" => {:rect, media_box(context.media_box)},
      "Kids" => {:array, page_pointers(page_references, context.generation_number)},
      "Resources" => page_resources(image_references, font_references)}}
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

  def media_box({top_left, top_right, bottom_left, bottom_right}) do
    [top_left, top_right, bottom_left, bottom_right]
  end

  def page_pointers(page_references, generation_number) do
    Enum.map page_references, fn(page_reference) ->
      {:ptr, page_reference, generation_number}
    end
  end
  

  def page_resources(image_references, font_references) do
    {:dict, %{
      "Font" => {:dict, font_references },
      "XObject" => image_references
    }}
  end
end
