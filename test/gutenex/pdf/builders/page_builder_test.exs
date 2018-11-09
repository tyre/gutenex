defmodule Gutenex.PDF.Builders.PageBuilderTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext
  alias Gutenex.PDF.Builders.PageBuilder

  test "#build adds the page objects" do
    page_1 = "1 2 3 4"
    page_2 = "alpha beta gamma delta"
    page_tree_reference = {:ptr, 39, 0}

    context = %Context{pages: [page_1, page_2], templates: [nil, "Richard"]}

    {render_context, ^context} =
      PageBuilder.build({
        %RenderContext{
          page_tree_reference: page_tree_reference,
          page_tree: {{:obj, 1, 0}, {:dict, %{}}}
        },
        context
      })

    assert render_context.current_index == 5

    assert render_context.page_references == [
             {:ptr, render_context.current_index - 3, render_context.generation_number},
             {:ptr, render_context.current_index - 1, render_context.generation_number}
           ]

    [page_1_contents, page_1_summary, page_2_contents, page_2_summary] =
      render_context.page_objects

    assert page_1_contents == {{:obj, 1, 0}, {:stream, page_1}}

    assert page_1_summary ==
             {{:obj, 2, 0},
              {:dict,
               %{
                 "Type" => {:name, "Page"},
                 "Parent" => page_tree_reference,
                 "Contents" => {:ptr, 1, 0},
                 "TemplateInstantiated" => {:name, nil}
               }}}

    assert page_2_contents == {{:obj, 3, 0}, {:stream, page_2}}

    assert page_2_summary ==
             {{:obj, 4, 0},
              {:dict,
               %{
                 "Type" => {:name, "Page"},
                 "Parent" => page_tree_reference,
                 "Contents" => {:ptr, 3, 0},
                 "TemplateInstantiated" => {:name, "Richard"}
               }}}

    assert render_context.page_tree == {
             {:obj, 1, 0},
             {:dict,
              %{
                "Count" => 2,
                "Kids" => {:array, [{:ptr, 2, 0}, {:ptr, 4, 0}]}
              }}
           }
  end
end
