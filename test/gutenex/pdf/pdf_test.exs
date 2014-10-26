defmodule Gutenex.PDFTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF
  alias Gutenex.PDF.Context

  test "#add_page with no current pages" do
    context = %Context{}
    current_page_stream = "Stream of Consciousness"
    PDF.add_page(context, current_page_stream)

    assert context.current_page == 2, "It increments the current page"
    assert List.first(context.pages) == current_page_stream, "It adds the content to the #pages"
  end
end
