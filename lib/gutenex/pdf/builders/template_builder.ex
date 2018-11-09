defmodule Gutenex.PDF.Builders.TemplateBuilder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext

  @doc """
  If template(s) were used, build references to them and adds the references
  to the x_object_reference_dictionary
  """
  def build({%RenderContext{} = render_context, %Context{} = context}) do
    updated_render_context = build_templates(render_context, context)
    {updated_render_context, context}
  end

  defp build_templates(render_context, context) do
    build_templates(render_context, context, context.templates)
  end

  defp build_templates(render_context, _context, []) do
    %RenderContext{
      render_context
      | template_objects: Enum.reverse(render_context.template_objects)
    }
  end

  # Skip over nil templates
  defp build_templates(render_context, context, [nil | templates]) do
    build_templates(render_context, context, templates)
  end

  defp build_templates(render_context, context, [template_alias | templates]) do
    template = Map.get(context.template_aliases, template_alias)
    template_object = build_template(render_context, context, template)

    updated_aliases =
      Map.put(
        render_context.template_aliases,
        template_alias,
        RenderContext.current_reference(render_context)
      )

    updated_render_context = %RenderContext{
      RenderContext.next_index(render_context)
      | template_objects: [template_object | render_context.template_objects],
        template_aliases: updated_aliases
    }

    build_templates(updated_render_context, context, templates)
  end

  defp build_template(render_context, context, template_body) do
    {
      RenderContext.current_object(render_context),
      {
        :stream,
        template_dictionary(context),
        template_body
      }
    }
  end

  # Builds the dictionary to describe the template stream,
  # setting the bounding box to be the size of the entire page
  defp template_dictionary(%Context{} = context) do
    {
      :dict,
      %{
        "Type" => "XObject",
        "SubType" => "Form",
        "BBox" => {:array, Tuple.to_list(context.media_box)},
        "Resources" => {:dict, %{"ProcSet" => {:name, "PDF"}}}
      }
    }
  end
end
