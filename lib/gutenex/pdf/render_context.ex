defmodule Gutenex.PDF.RenderContext do
  alias Gutenex.PDF.RenderContext
  defstruct(
    generation_number: 0,
    current_index: 1,

    # Objects
    catalog: nil,
    meta_data: nil,
    page_tree: nil,
    x_object_dictionary: nil,
    image_objects: [],
    font_objects: [],
    page_objects: [],
    template_objects: [],

    # References
    catalog_reference: nil,
    meta_data_reference: nil,
    page_tree_reference: nil,
    x_object_dictionary_reference: nil,
    image_summary_reference: nil,
    page_references: [],

    # Aliases
    font_aliases: %{},
    image_aliases: %{},
    template_aliases: %{}
  )

  @doc """
  Returns RenderContext where the render context's current_index
  has been incremented by one
  """
  def next_index(%RenderContext{}=render_context) do
    %RenderContext{render_context | current_index: render_context.current_index + 1}
  end

  @doc """
  Returns a reference to the current index and generation number of the provided
  render context
  """
  def current_reference(%RenderContext{}=render_context) do
    {:ptr, render_context.current_index, render_context.generation_number}
  end

  @doc """
  Returns an :obj with the current index and generation number of the provided
  render context
  """
  def current_object(%RenderContext{}=render_context) do
    {:obj, render_context.current_index, render_context.generation_number}
  end

  @doc """
  Returns a list of all font references for the given render context
  """
  def font_references(%RenderContext{}=render_context) do
    Map.values render_context.font_aliases
  end

  @doc """
  Returns a list of all image references for the given render context
  """
  def image_references(%RenderContext{}=render_context) do
    Map.values render_context.image_aliases
  end

  @doc """
  Returns a list of all objects for rendering
  """
  def objects(%RenderContext{}=render_context) do
    List.flatten([
      render_context.x_object_dictionary,
      render_context.page_tree,
      render_context.image_objects,
      render_context.font_objects,
      render_context.template_objects,
      render_context.page_objects,
      render_context.catalog,
      render_context.meta_data])
    |> Enum.sort_by(&object_sort/1)
  end

  defp object_sort({{:obj, index, _}, _}) do
    index
  end

  @doc """
  """
  def trailer(%RenderContext{}=render_context) do
    {:trailer, {:dict, %{
      "Size" => length(objects(render_context)) + 1,
      "Root" => render_context.catalog_reference,
      "Info" => render_context.meta_data_reference
    }}}
  end
end
