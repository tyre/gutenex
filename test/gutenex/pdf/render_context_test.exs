defmodule Gutenex.PDF.RenderContextTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.RenderContext

  test "#page_tree_reference" do
    render_context = %RenderContext{page_tree_index: 12, generation_number: 96}
    assert RenderContext.page_tree_reference(render_context) ==
           {:ptr, render_context.page_tree_index, render_context.generation_number}
  end

  test "#next_index" do
    render_context = %RenderContext{current_index: 11}
    {new_render_context, next_index} = RenderContext.next_index(render_context)
    assert new_render_context.current_index == render_context.current_index + 1
    assert next_index == render_context.current_index + 1
  end
end
