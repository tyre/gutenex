defmodule Gutenex.PDF.Builder do
  alias Gutenex.PDF.Context
#   %% L = [int()] = list of objects representing pages


  def build(%Context{} = context) do
    {current_index, image_references, image_objects} =
      Gutenex.PDF.Image.images_summary(context.images)
    page_root_index = current_index
    {current_index, page_references, page_objects} = build_pages(context, page_root_index)
    page_tree = {{:obj, page_root_index, 0},
                  build_page_tree(context, page_references, image_references)}
    catalog_root_index = current_index
    catalog = {{:obj, catalog_root_index, 0}, build_catalog(page_root_index)}
    meta_data_index = catalog_root_index + 1
    meta_data = {{:obj, meta_data_index, 0}, build_meta_data(context)}

    all_objects = image_objects ++ [page_tree | page_objects] ++ [catalog, meta_data]
    Apex.ap(inspect(all_objects))
    {catalog_root_index, meta_data_index, all_objects}
  end

  # Pages are built into two objects
  # The first contains the stream of the page contents
  # The second is a dictionary describing the page, a reference to the
  # page tree, and a reference to the page contents
  def build_pages(%Context{} = context, root_index) do
    build_pages(root_index, root_index + 1, context.pages, [], [])
  end

  defp build_pages(_root_index, current_index, []=_pages_left_to_build, page_references, built_objects) do
    {current_index, Enum.reverse(page_references), Enum.reverse(built_objects)}
  end

  defp build_pages(root_index, current_index, [page|pages_left_to_build], page_references, built_objects) do
    page_summary_reference = current_index + 1
    page_contents = {{:obj, current_index, 0}, {:stream, page}}
    page_summary = page_summary(root_index, page_summary_reference, current_index)

    page_references = [page_summary_reference | page_references]
    built_objects = [page_summary, page_contents | built_objects]
    # We are adding two objects so next index should be two greater than start
    build_pages(root_index, current_index + 2, pages_left_to_build, page_references, built_objects)
  end

  defp page_summary(root_index, current_index, contents_reference) do
    {{:obj, current_index, 0}, {:dict, [
      {"Type", {:name, "Page"}},
      {"Parent", {:ptr, root_index, 0}},
      {"Contents", {:ptr, contents_reference, 0}}]}}
  end

  def build_page_tree(%Context{} = context, page_references, image_objects) do
    {:dict, [
      {"Type", {:name, "Pages"}},
      {"Count", length(page_references)},
      {"MediaBox", {:array, media_box(context.media_box)}},
      {"Kids", {:array, page_pointers(page_references)}},
      {"Resources", page_resources(context, image_objects)}
    ]}
  end

  def build_catalog(page_tree_reference) do
    {:dict,[
     {"Type", {:name, "Catalog"}},
     {"Pages", {:ptr, page_tree_reference, 0}}]}
  end

  def build_meta_data(%Context{} = context) do
    {:dict, [
      {"Title", {:string, context.meta_data.title}},
      {"Author", {:string, context.meta_data.author}},
      {"Creator", {:string, context.meta_data.creator}},
      {"Subject", {:string, context.meta_data.subject}},
      {"Producer", {:string, context.meta_data.producer}},
      {"Keywords", {:string, context.meta_data.keywords}},
      {"CreationDate", {:date, context.meta_data.creation_date}}
    ]}
  end

  def media_box({top_left, top_right, bottom_left, bottom_right}) do
    [top_left, top_right, bottom_left, bottom_right]
  end

  def page_pointers(page_references) do
    Enum.map page_references, fn(page_reference) ->
      { :ptr, page_reference, 0 }
    end
  end

  def page_resources(context, image_objects) do
    {:dict, [
      {"Font", {:array, context.fonts }},
      {"XObject", image_objects },
      # TODO: What are procsets? Do I need to add some for images?
      {"ProcSet",
        {:array,
          [
            {:name, "PDF"},
            {:name, "Text"},
            {:name, "ImageC"}
          ]
        }
      }
    ]}
  end

#   mk_pages([], _, N, P, O) -> {N, lists:reverse(P), lists:reverse(O)};
# mk_pages([{page,Str}|T], Parent, I, L, E) ->
#     O1 = {{obj,I,0},mkPageContents(Str)},
#     O2 = {{obj,I+1,0},mkPage( Parent, I)},
#     mk_pages(T, Parent, I+2, [I+1|L], [O2,O1|E]);
# mk_pages([{page,Str,Script}|T], Parent, I, L, E) ->
#     O1 = {{obj,I,0},mkPageContents(Str)},
#     O2 = {{obj,I+1,0},mkScript(Script)},
#     O3 = {{obj,I+2,0},mkPage( Parent, I, I+1)},
#     mk_pages(T, Parent, I+3, [I+2|L], [O3,O2,O1|E]).


end
