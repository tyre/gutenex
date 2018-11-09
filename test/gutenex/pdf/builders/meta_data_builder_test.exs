defmodule Gutenex.PDF.Builders.MetaDataBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Builders.MetaDataBuilder

  setup do
    render_context = %RenderContext{
      generation_number: 3,
      current_index: 100
    }

    context = %Context{
      meta_data: %{
        creator: "Thomas Paine",
        creation_date: {{1776, 7, 4}, {15, 15, 15}},
        producer: "Continental Congress",
        author: "America",
        title: "Colonial Independence",
        subject: "Revolution",
        keywords: "free-mp3s how-to-build-a-startup-online stock-tips"
      }
    }

    {:ok, %{render_context: render_context, context: context}}
  end

  test "#build", %{render_context: render_context, context: context} do
    {new_render_context, _new_context} = MetaDataBuilder.build({render_context, context})
    meta_data_index = render_context.current_index
    generation_number = render_context.generation_number

    {
      {:obj, ^meta_data_index, ^generation_number},
      {:dict, meta_data}
    } = new_render_context.meta_data

    assert new_render_context.meta_data_reference == {:ptr, 100, 3}
    assert new_render_context.current_index == meta_data_index + 1
    assert Map.get(meta_data, "Title") == {:string, context.meta_data.title}
    assert Map.get(meta_data, "Author") == {:string, context.meta_data.author}
    assert Map.get(meta_data, "Creator") == {:string, context.meta_data.creator}
    assert Map.get(meta_data, "Subject") == {:string, context.meta_data.subject}
    assert Map.get(meta_data, "Producer") == {:string, context.meta_data.producer}
    assert Map.get(meta_data, "Keywords") == {:string, context.meta_data.keywords}
    assert Map.get(meta_data, "CreationDate") == {:date, context.meta_data.creation_date}
  end
end
