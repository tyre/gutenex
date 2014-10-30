defmodule Gutenex.PDF.PageTreeBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Builders.PageTreeBuilder
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.Page

  test "#media_box converts coordinates to a list" do
    assert PageTreeBuilder.media_box({0, 0, 100, 200}) == [0, 0, 100, 200]
  end

  test "#page_pointers returns a pointer for each page reference" do
    assert PageTreeBuilder.page_pointers([4, 8, 15, 16, 23, 42], 15) ==
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
    assert PageTreeBuilder.page_resources(image_references, font_references) == {
      :dict, %{
        "Font" => {:dict, font_references},
        "XObject" => image_references
      }
    }
  end

  test "#build" do
    # Set up the test context and variables
    context = %Context{media_box: Page.page_size(:a0)}
    pages = [4, 8, 15, 16, 23, 42]
    fonts = %{"Helvetica" => {:ptr, 31, 0}, "Times-Roman" => {:ptr, 28, 0}}
    images = [{:array, [1,2,3]}, {:ptr, 1, 0}]
    generation_number = context.generation_number
    {
      {:obj, 100, ^generation_number},
      {:dict, page_tree }
    } = PageTreeBuilder.build(context, 100, %{
          pages: pages,
          images: images,
          fonts: fonts})

    assert Map.get(page_tree, "Type")      == {:name, "Pages"}
    assert Map.get(page_tree, "Kids")      == {:array,
      [{:ptr, 4, 0}, {:ptr, 8, 0}, {:ptr, 15, 0}, {:ptr, 16, 0}, {:ptr, 23, 0},
       {:ptr, 42, 0}]}
    assert Map.get(page_tree, "Count")     == 6
    assert Map.get(page_tree, "MediaBox")  == {:rect, [0, 0, 2380, 3368]}
    assert Map.get(page_tree, "Resources") == {:dict,
      %{"Font" => {:dict, fonts}, "XObject" => images }}
  end

end
