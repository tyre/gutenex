defmodule Gutenex.PDF.BuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Builder
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.Page

  test "#media_box converts coordinates to a list" do
    assert Builder.media_box({0, 0, 100, 200}) == [0, 0, 100, 200]
  end

  test "#build_pages returns the tree of pages" do
    page_1 = "1 2 3 4"
    page_2 = "alpha beta gamma delta"
    context = %Context{pages: [page_1, page_2]}

    # Pass in the context and the root index for the pages
    {current_index, page_references, page_objects} = Builder.build_pages(context, 57)
    assert current_index == 62
    assert page_references == [59, 61]

    [page_1_contents, page_1_summary, page_2_contents, page_2_summary] = page_objects

    assert page_1_contents == {{:obj, 58, 0}, {:stream, page_1}}
    assert page_1_summary  == {{:obj, 59, 0}, {:dict, [
                            {"Type", {:name, "Page"}}, {"Parent", {:ptr, 57, 0}},
                            {"Contents", {:ptr, 58, 0}}]}}

    assert page_2_contents  == {{:obj, 60, 0}, {:stream, page_2}}
    assert page_2_summary   == {{:obj, 61, 0}, {:dict, [
                                {"Type", {:name, "Page"}},
                                {"Parent", {:ptr, 57, 0}},
                                {"Contents", {:ptr, 60, 0}}]}}

  end

  test "#page_pointers returns a pointer for each page reference" do
    assert Builder.page_pointers([4, 8, 15, 16, 23, 42]) ==
           [
            {:ptr, 4, 0},
            {:ptr, 8, 0},
            {:ptr, 15, 0},
            {:ptr, 16, 0},
            {:ptr, 23, 0},
            {:ptr, 42, 0}
           ]
  end

  test "#page_resources builds a dictionary of fonts and image objects" do
    context = %Context{ fonts: [:bingo, :bango, :bongo] }
    image_objects = [{:array, [1,2,3]}, {:ptr, 1, 0}]
    assert Builder.page_resources(context, image_objects) == {
      :dict, [
        {"Font", context.fonts },
        {"XObject", image_objects },
        {"ProcSet", {:array,[{:name, "PDF"}, {:name, "Text"}]}}
      ]
    }
  end

  test "#build_page_tree" do
    # Set up the test context and variables
    context = %Context{media_box: Page.page_size(:a0)}
    page_references = [4, 8, 15, 16, 23, 42]
    image_objects = [{:stream, "of images!"}]

    {:dict, page_tree } = Builder.build_page_tree(context, page_references, image_objects)

    assert List.keyfind(page_tree, "Type", 0)      == {"Type", {:name, "Page"}}
    assert List.keyfind(page_tree, "Kids", 0)      ==
           {"Kids", {:array, [{:ptr, 4, 0}, {:ptr, 8, 0}, {:ptr, 15, 0},
                              {:ptr, 16, 0}, {:ptr, 23, 0}, {:ptr, 42, 0}]}}
    assert List.keyfind(page_tree, "Count", 0)     == {"Count", 6}
    assert List.keyfind(page_tree, "MediaBox", 0)  == {"MediaBox", {:array, [0, 0, 2380, 3368]}}
    assert List.keyfind(page_tree, "Resources", 0) == {"Resources",
           {:dict, [{"Font", context.fonts }, {"XObject", image_objects },
                    {"ProcSet", {:array,[{:name, "PDF"}, {:name, "Text"}]}}]}}
  end
end
