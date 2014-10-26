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
        {"Font", {:array, context.fonts} },
        {"XObject", image_objects }
      ]
    }
  end

  test "#build_page_tree" do
    # Set up the test context and variables
    context = %Context{media_box: Page.page_size(:a0)}
    page_references = [4, 8, 15, 16, 23, 42]
    image_objects = [{:stream, "of images!"}]

    {:dict, page_tree } = Builder.build_page_tree(context, page_references, image_objects)

    assert List.keyfind(page_tree, "Type", 0)      == {"Type", {:name, "Pages"}}
    assert List.keyfind(page_tree, "Kids", 0)      ==
           {"Kids", {:array, [{:ptr, 4, 0}, {:ptr, 8, 0}, {:ptr, 15, 0},
                              {:ptr, 16, 0}, {:ptr, 23, 0}, {:ptr, 42, 0}]}}
    assert List.keyfind(page_tree, "Count", 0)     == {"Count", 6}
    assert List.keyfind(page_tree, "MediaBox", 0)  == {"MediaBox", {:rect, [0, 0, 2380, 3368]}}
    assert List.keyfind(page_tree, "Resources", 0) == {"Resources",
           {:dict, [{"Font", {:array, context.fonts}}, {"XObject", image_objects }]}}
  end

  test "#build_catalog" do
    assert Builder.build_catalog(99) == {:dict,[
           {"Type", {:name, "Catalog"}},
           {"Pages", {:ptr, 99, 0}}]}
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
    assert List.keyfind(meta_data, "Title", 0)        ==  {"Title", {:string, context.meta_data.title}}
    assert List.keyfind(meta_data, "Author", 0)       ==  {"Author", {:string, context.meta_data.author}}
    assert List.keyfind(meta_data, "Creator", 0)      ==  {"Creator", {:string, context.meta_data.creator}}
    assert List.keyfind(meta_data, "Subject", 0)      ==  {"Subject", {:string, context.meta_data.subject}}
    assert List.keyfind(meta_data, "Producer", 0)     ==  {"Producer", {:string, context.meta_data.producer}}
    assert List.keyfind(meta_data, "Keywords", 0)     ==  {"Keywords", {:string, context.meta_data.keywords}}
    assert List.keyfind(meta_data, "CreationDate", 0) ==  {"CreationDate", {:date, context.meta_data.creation_date}}
  end
end
