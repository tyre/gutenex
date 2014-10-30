defmodule Gutenex.PDF.Builders.PageBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Builders.PageBuilder
  alias Gutenex.PDF.Context

  test "#build returns the tree of pages" do
    page_1 = "1 2 3 4"
    page_2 = "alpha beta gamma delta"
    context = %Context{pages: [page_1, page_2]}

    # Pass in the context and the root index for the pages
    {current_index, page_references, page_objects} = PageBuilder.build(context, 57)
    assert current_index == 62
    assert page_references == [59, 61]

    [page_1_contents, page_1_summary, page_2_contents, page_2_summary] = page_objects

    assert page_1_contents == {{:obj, 58, 0}, {:stream, page_1}}
    assert page_1_summary  == {
      {:obj, 59, 0}, {:dict, %{
                              "Type" => {:name, "Page"},
                              "Parent" => {:ptr, 57, 0},
                              "Contents" => {:ptr, 58, 0}}}}

    assert page_2_contents  == {{:obj, 60, 0}, {:stream, page_2}}
    assert page_2_summary   == {
      {:obj, 61, 0}, {:dict, %{
                                "Type" => {:name, "Page"},
                                "Parent" => {:ptr, 57, 0},
                                "Contents" => {:ptr, 60, 0}}}}

  end
end
