defmodule Gutenex.PDFTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF

  test "#add_page with no current pages" do
    context = %Gutenex.PDF.Context{}
    current_page_stream = "Stream of Consciousness"
    {context, new_stream} = PDF.add_page(context, current_page_stream)

    assert context.current_page == 2, "It increments the current page"
    assert List.first(context.pages) == current_page_stream, "It adds the content to the #pages"
    assert <<>> == new_stream, "It resets the stream to empty"
  end
end
