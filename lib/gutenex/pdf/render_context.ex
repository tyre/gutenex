defmodule Gutenex.PDF.RenderContext do
  alias Gutenex.PDF.RenderContext
  defstruct(
    generation_number: 0,
    current_index: 1,

    # Objects
    catalog: nil,
    meta_data: nil,
    image_objects: [],

    # References
    image_references: [],
    font_references: %{},
    page_references: [],

    # Aliases
    image_aliases: %{},

    # Indicies
    image_summary_reference: nil,
    page_tree_index: nil,
    catalog_index: nil,
    meta_data_index: nil
  )

  @doc """
  Returns a pointer to the page tree index with the current generation number
  """
  def page_tree_reference(%RenderContext{}=render_context) do
    {:ptr, render_context.page_tree_index, render_context.generation_number}
  end

  @doc """
  Returns RenderContext where the render context's current_index
  has been incremented by one
  """
  def next_index(%RenderContext{}=render_context) do
    %RenderContext{render_context | current_index: render_context.current_index + 1}
  end


end
