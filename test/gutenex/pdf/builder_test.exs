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

  test "#page_pointers returns a pointer for each page reference" do
    assert Builder.page_pointers([4, 8, 15, 16, 23, 42], 15) ==
           [
            {:ptr, 4, 15},
            {:ptr, 8, 15},
            {:ptr, 15, 15},
            {:ptr, 16, 15},
            {:ptr, 23, 15},
            {:ptr, 42, 15}
           ]
  end

  test "#page_resources builds a dictionary of fonts and image objects" do
    font_references = %{"Helvetica" => {:ptr, 31, 0}, "Times-Roman" => {:ptr, 28, 0}}
    image_references = [{:array, [1,2,3]}, {:ptr, 1, 0}]
    assert Builder.page_resources(image_references, font_references) == {
      :dict, %{
        "Font" => {:dict, font_references},
        "XObject" => image_references
      }
    }
  end

  test "#build_page_tree" do
    # Set up the test context and variables
    context = %Context{media_box: Page.page_size(:a0)}
    page_references = [4, 8, 15, 16, 23, 42]
    font_references = %{"Helvetica" => {:ptr, 31, 0}, "Times-Roman" => {:ptr, 28, 0}}
    image_references = [{:array, [1,2,3]}, {:ptr, 1, 0}]

    {:dict, page_tree } = Builder.build_page_tree(context, page_references, image_references, font_references)

    assert Map.get(page_tree, "Type")      == {:name, "Pages"}
    assert Map.get(page_tree, "Kids")      == {:array, 
      [{:ptr, 4, 0}, {:ptr, 8, 0}, {:ptr, 15, 0}, {:ptr, 16, 0}, {:ptr, 23, 0},
       {:ptr, 42, 0}]}
    assert Map.get(page_tree, "Count")     == 6
    assert Map.get(page_tree, "MediaBox")  == {:rect, [0, 0, 2380, 3368]}
    assert Map.get(page_tree, "Resources") == {:dict, 
      %{"Font" => {:dict, font_references}, "XObject" => image_references }}
  end

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

  test "#build_fonts" do
    font_1 = %{"Name" => "Abra",    "Subtype" => "Type1", "Type" => "Font"}
    font_2 = %{"Name" => "Barbara", "Subtype" => "Type1", "Type" => "Font"}
    font_3 = %{"Name" => "Cabana",  "Subtype" => "Type1", "Type" => "Font"}
    fonts = %{"Abra" => font_1, "Barbara" => font_2, "Cabana" => font_3}
    {next_index, font_references, font_objects} = Builder.build_fonts(100, 47, fonts)
    assert next_index == 103, "it returns the next index"
    assert font_references == %{
      "Abra" => {:ptr, 100, 47},
      "Barbara" => {:ptr, 101, 47},
      "Cabana" => {:ptr, 102, 47}
    }
    assert font_objects == [
      {{:obj, 100, 47}, {:dict, font_1}},
      {{:obj, 101, 47}, {:dict, font_2}},
      {{:obj, 102, 47}, {:dict, font_3}}
    ]
  end
end
