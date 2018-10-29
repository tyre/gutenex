defmodule Gutenex.PDF.Builders.PageTreeBuilder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext

  def build({%RenderContext{} = render_context, %Context{} = context}) do
    updated_render_context =
      build_x_objects(render_context)
      |> build_page_tree(context)

    {updated_render_context, context}
  end

  defp build_page_tree(%RenderContext{} = render_context, %Context{} = context) do
    %RenderContext{
      RenderContext.next_index(render_context)
      | page_tree_reference: RenderContext.current_reference(render_context),
        page_tree: page_tree(render_context, context)
    }
  end

  defp page_tree(render_context, context) do
    {
      RenderContext.current_object(render_context),
      {:dict,
       %{
         "Type" => {:name, "Pages"},
         "Count" => length(render_context.page_references),
         "MediaBox" => {:rect, media_box(context.media_box)},
         "Kids" => {:array, render_context.page_references},
         "Resources" => page_resources(render_context)
       }}
    }
  end

  defp build_x_objects(%RenderContext{} = render_context) do
    %RenderContext{
      RenderContext.next_index(render_context)
      | x_object_dictionary: x_object_dictionary(render_context),
        x_object_dictionary_reference: RenderContext.current_reference(render_context)
    }
  end

  # Merge all of the necessary objects for the reference dictionary
  defp x_object_dictionary(render_context) do
    {
      RenderContext.current_object(render_context),
      {:dict, render_context.image_aliases}
    }
  end

  def media_box({top_left, top_right, bottom_left, bottom_right}) do
    [top_left, top_right, bottom_left, bottom_right]
  end

  def page_resources(%RenderContext{} = render_context) do
    {:dict,
     %{
       "Font" => {:dict, render_context.font_aliases},
       "XObject" => render_context.x_object_dictionary_reference
     }}
  end
end
