defmodule Gutenex.PDF.Builders.PageBuilder do
  alias Gutenex.PDF.Context
  @doc """
    Pages are built into two objects
    The first contains the stream of the page contents
    The second is a dictionary describing the page, a reference to the
    page tree, and a reference to the page contents
  """
  def build(%Context{} = context, root_index) do
    build({root_index, context.generation_number}, root_index + 1, context.pages, [], [])
  end

  defp build(_index_and_generation_number, current_index, []=_pages_left_to_build, page_references, built_objects) do
    {current_index, Enum.reverse(page_references), Enum.reverse(built_objects)}
  end

  defp build({root_index, generation_number}, current_index, [page|pages_left_to_build], page_references, built_objects) do
    page_summary_reference = current_index + 1
    page_contents = {{:obj, current_index, generation_number}, {:stream, page}}
    page_summary = page_summary({root_index, generation_number}, page_summary_reference, current_index)

    page_references = [page_summary_reference | page_references]
    built_objects = [page_summary, page_contents | built_objects]
    # We are adding two objects so next index should be two greater than start
    build({root_index, generation_number}, current_index + 2, pages_left_to_build, page_references, built_objects)
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
end
