defmodule Gutenex.PDF.Builders.MetaDataBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.Builders.MetaDataBuilder

  test "#build" do
    meta_data_index = 20
    generation_number = 3
    context = %Context{
      generation_number: generation_number,
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
    {{:obj, ^meta_data_index, ^generation_number}, {:dict, meta_data}} =
      MetaDataBuilder.build(context, meta_data_index)
    assert Map.get(meta_data, "Title")        ==  {:string, context.meta_data.title}
    assert Map.get(meta_data, "Author")       ==  {:string, context.meta_data.author}
    assert Map.get(meta_data, "Creator")      ==  {:string, context.meta_data.creator}
    assert Map.get(meta_data, "Subject")      ==  {:string, context.meta_data.subject}
    assert Map.get(meta_data, "Producer")     ==  {:string, context.meta_data.producer}
    assert Map.get(meta_data, "Keywords")     ==  {:string, context.meta_data.keywords}
    assert Map.get(meta_data, "CreationDate") ==  {:date, context.meta_data.creation_date}
  end
end
