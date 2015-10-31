defmodule Gutenex.PDF.ParserTest do
  use ExUnit.Case, async: true
  alias Gutenex.Pdf.Parser

  setup do
    {:ok, %{
      file: File.read!("./test/support/VonnegutQuotes.pdf")
    }}
  end

  test "parsing out the PDF version", %{file: file} do
    context = Parser.parse file
    assert context.version == "1.3"
    assert length(context.updates) == 0
    assert length(context.objects) == 71
  end
end

# %PDF-1.5
# %Á¥db
