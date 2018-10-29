defmodule Gutenex.PDF.Builders.TemplateBuilderTest do
  use ExUnit.Case, async: true

  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Builders.TemplateBuilder

  test "#build" do
    context = %Context{
      templates: [nil, "Hi", nil],
      template_aliases: %{"Hi" => "Bubbles!"}
    }

    render_context = %RenderContext{
      current_index: 129,
      generation_number: 0
    }

    {updated_render_context, ^context} = TemplateBuilder.build({render_context, context})

    assert updated_render_context.current_index == render_context.current_index + 1

    # It should add the alias
    assert updated_render_context.template_aliases ==
             %{"Hi" => RenderContext.current_reference(render_context)}

    # It shouldn't build for nil templates
    assert length(updated_render_context.template_objects) == 1

    [
      {
        template_object,
        template_stream
      }
    ] = updated_render_context.template_objects

    assert template_object == RenderContext.current_object(render_context)

    # Test the template stream itself
    {
      :stream,
      {
        :dict,
        template_dictionary
      },
      template_contents
    } = template_stream

    assert template_contents == "Bubbles!"
    assert Map.get(template_dictionary, "Type") == "XObject"
    assert Map.get(template_dictionary, "BBox") == {:array, Tuple.to_list(context.media_box)}
    assert Map.get(template_dictionary, "SubType") == "Form"
  end
end
