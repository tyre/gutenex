defmodule Gutenex.PDF.RenderContext do
  alias Gutenex.PDF.RenderContext
  defstruct(
    generation_number: 0,
    current_index: 1,

    # Objects
    catalog: nil,
    meta_data: nil,
    image_objects: [],
    font_objects: [],
    page_objects: [],

    # References
    image_references: [],
    font_references: %{},
    page_references: [],

    # Aliases
    image_aliases: %{},

    # Indicies
    image_summary_reference: nil,
    page_tree_reference: nil,
    catalog_index: nil,
    meta_data_index: nil
  )

  @doc """
  Returns RenderContext where the render context's current_index
  has been incremented by one
  """
  def next_index(%RenderContext{}=render_context) do
    %RenderContext{render_context | current_index: render_context.current_index + 1}
  end


end
