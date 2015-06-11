defmodule Gutenex.Pdf.Parser do
  alias Gutenex.Pdf.ParseContext
  alias Gutenex.Pdf.Parsers.MetaDataParser
  alias Gutenex.Pdf.Parsers.DocumentParser
  @moduledoc """
  # Intro

  This is not a comprehensive view of what constitutes a PDF. The following
  exists to give a primer to those who want to learn more or want to get their
  bearings to start contributing or locate a likely candidate for bugginess.

  If you want the full fun of PDF specification, please see the [official spec](http://www.adobe.com/content/dam/Adobe/en/devnet/acrobat/pdfs/pdf_reference_1-7.pdf).

  # PDF Layout

  PDFs are generally composed a header, a body, a cross-reference (or xref)
  section, and a trailer. The xref section tells us where all of the objects
  inside of the body.

  Once a PDF is generated for the first time, it can't be edited. The reason for
  this is that parsing begins at the bottom of the PDF (because why the hell
  not?) and proceeds using byte-offsets. Changing anything in the body will
  throw off every byte-offset and an invalid file.

  Instead, changes are made via updates appended to the bottom of the file, with
  each update referencing the previous one (and the first update referencing the
  original xref.) In essence, this is what we're working with:

  ```
  Header
  Original body
  Original cross-reference section
  Original trailer
  Body update 1
  Cross-reference section 1
  Updated trailer 1
  Body update n
  Cross-reference section n
  Updated trailer n
  ```

  # Objects

  PDF supports eight basic types of objects:
  - Boolean values
  - Integer and real numbers
  - Strings
  - Names
  - Arrays
  - Dictionaries
  - Streams
  - The null object

  The first three correspond with what you'd expect in Elixir. Names are atoms,
  arrays are lists, dictionaries are maps, streams are binary data with a
  map for metadata, and null is `nil`.
  """
  @start_object "\s*(\d+)\s+(\d+)\s+obj"
  @end_object "^\s*endobj\s*$"

  def parse(source) do
    %ParseContext{source: source}
    |> MetaDataParser.parse
    |> DocumentParser.parse
  end

  def parse_file(filename) do
    File.read! filename
      |> parse
  end
end
