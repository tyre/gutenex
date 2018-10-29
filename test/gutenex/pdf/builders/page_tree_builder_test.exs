defmodule Gutenex.PDF.PageTreeBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Page
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Builders.PageTreeBuilder

  test "#media_box converts coordinates to a list" do
    assert PageTreeBuilder.media_box({0, 0, 100, 200}) == [0, 0, 100, 200]
  end

  test "#page_resources builds a dictionary of fonts and  XObjects" do
    render_context = %RenderContext{
      font_aliases: %{"Helvetica" => {:ptr, 31, 0}, "Times-Roman" => {:ptr, 28, 0}},
      x_object_dictionary_reference: {:ptr, 2, 0}
    }

    assert PageTreeBuilder.page_resources(render_context) == {
             :dict,
             %{
               "Font" => {:dict, render_context.font_aliases},
               "XObject" => render_context.x_object_dictionary_reference
             }
           }
  end

  test "#build" do
    # Set up the test context and variables
    context = %Context{media_box: Page.page_size(:a0)}

    render_context = %RenderContext{
      generation_number: 0,
      current_index: 99,
      page_references: [
        {:ptr, 4, 0},
        {:ptr, 8, 0},
        {:ptr, 15, 0},
        {:ptr, 16, 0},
        {:ptr, 23, 0},
        {:ptr, 42, 0}
      ],
      font_aliases: %{
        "Bingo" => {:ptr, 3, 0},
        "Bango" => {:ptr, 6, 0},
        "Bongo" => {:ptr, 9, 0}
      }
    }

    {updated_render_context, ^context} = PageTreeBuilder.build({render_context, context})

    {
      {:obj, 100, 0},
      {:dict, page_tree}
    } = updated_render_context.page_tree

    assert updated_render_context.page_tree_reference == {:ptr, 100, 0}
    assert Map.get(page_tree, "Type") == {:name, "Pages"}

    assert Map.get(page_tree, "Kids") ==
             {:array,
              [
                {:ptr, 4, 0},
                {:ptr, 8, 0},
                {:ptr, 15, 0},
                {:ptr, 16, 0},
                {:ptr, 23, 0},
                {:ptr, 42, 0}
              ]}

    assert Map.get(page_tree, "Count") == 6
    assert Map.get(page_tree, "MediaBox") == {:rect, [0, 0, 2380, 3368]}

    assert Map.get(page_tree, "Resources") ==
             {:dict,
              %{
                "Font" => {:dict, render_context.font_aliases},
                "XObject" => {:ptr, 99, render_context.generation_number}
              }}
  end
end
