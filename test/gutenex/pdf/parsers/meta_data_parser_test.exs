defmodule Gutenex.PDF.MetaDataParserTest do
  use ExUnit.Case, async: true
  alias Gutenex.Pdf.Parser

  setup do
    {:ok, %{
      file: File.read!("./test/support/MozillaProcessManagement.pdf")
    }}
  end

  test "parsing out the PDF version", %{file: file} do
    Parser.parse(file)
  end
end
