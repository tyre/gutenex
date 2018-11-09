defmodule Gutenex.PDF.Builders.FontBuilder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext

  # Builds each font object, adding the font objects and references to the
  # render context. Returns {render_context, context}
  def build({%RenderContext{} = render_context, %Context{} = context}) do
    updated_render_context = build_fonts(render_context, Map.to_list(context.fonts))
    {updated_render_context, context}
  end

  defp build_fonts(%RenderContext{} = render_context, []) do
    %RenderContext{
      render_context
      | font_objects: Enum.reverse(render_context.font_objects)
    }
  end

  defp build_fonts(%RenderContext{} = render_context, [{font_alias, font_definition} | fonts]) do
    render_context = %RenderContext{
      RenderContext.next_index(render_context)
      | font_aliases: add_font_alias(render_context, font_alias),
        font_objects: add_font_object(render_context, font_definition)
    }

    build_fonts(render_context, fonts)
  end

  defp add_font_alias(render_context, font_alias) do
    reference = RenderContext.current_reference(render_context)
    Map.put(render_context.font_aliases, font_alias, reference)
  end

  defp add_font_object(render_context, font_definition) do
    [
      {
        RenderContext.current_object(render_context),
        {:dict, font_definition}
      }
      | render_context.font_objects
    ]
  end
end
