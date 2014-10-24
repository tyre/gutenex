defmodule Gutenex.PDF.BuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Builder
  alias Gutenex.PDF.Context

  test "#media_box converts coordinates to a list" do
    assert Builder.media_box({0, 0, 100, 200}) == [0, 0, 100, 200]
  end

  test "#page_pointers returns a pointer for each page number" do
    assert Builder.page_pointers([:page, :page, :page, :page]) == [
      {:ptr, 1, 0},
      {:ptr, 2, 0},
      {:ptr, 3, 0},
      {:ptr, 4, 0}
    ]
  end

  test "#page_resources builds a dictionary of fonts and x_objects" do
    context = %Context{ fonts: [:bingo, :bango, :bongo] }
    x_objects = [{:array, [1,2,3]}, {:ptr, 1, 0}]
    assert Builder.page_resources(context, x_objects) == {
      :dict, [
        {"Font", context.fonts },
        {"XObject", x_objects },
        {"ProcSet", {:array,[{:name, "PDF"}, {:name, "Text"}]}}
      ]
    }
  end
end
