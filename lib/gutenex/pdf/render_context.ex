defmodule Gutenex.PDF.RenderContext do
  alias Gutenex.PDF.RenderContext
  defstruct(
    generation_number: 0,
    current_index: 1,

    # Objects
    catalog: nil,
    meta_data: nil,
    page_tree: nil,
    image_objects: [],
    font_objects: [],
    page_objects: [],

    # References
    meta_data_reference: nil,
    catalog_reference: nil,
    page_tree_reference: nil,
    image_summary_reference: nil,
    page_references: [],

    # Aliases
    font_aliases: %{},
    image_aliases: %{}
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
end
