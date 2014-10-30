defmodule Gutenex.PDF.BuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Builder
  alias Gutenex.PDF.Context

  test "#build_catalog" do
    assert Builder.build_catalog(99, 7) == {:dict, %{
           "Type"  => {:name, "Catalog"},
           "Pages" => {:ptr, 99, 7}}}
  end

  test "#build_meta_data" do
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
    {:dict, meta_data} = Builder.build_meta_data(context)
    assert Map.get(meta_data, "Title")        ==  {:string, context.meta_data.title}
    assert Map.get(meta_data, "Author")       ==  {:string, context.meta_data.author}
    assert Map.get(meta_data, "Creator")      ==  {:string, context.meta_data.creator}
    assert Map.get(meta_data, "Subject")      ==  {:string, context.meta_data.subject}
    assert Map.get(meta_data, "Producer")     ==  {:string, context.meta_data.producer}
    assert Map.get(meta_data, "Keywords")     ==  {:string, context.meta_data.keywords}
    assert Map.get(meta_data, "CreationDate") ==  {:date, context.meta_data.creation_date}
  end
end
