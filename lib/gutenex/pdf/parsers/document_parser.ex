defmodule Gutenex.Pdf.Parsers.DocumentParser do
  alias Gutenex.Pdf.ParseContext
  @moduledoc """
  Parses a complete PDF document, minus any updates.
  """

  # Lines can end in a newline, a carriage return, both, and/or some spaces
  @eol "[\n\r\s]+"

  @xref ~r/startxref#{@eol}(?<xref_offset>\d+)#{@eol}/
  @object_end ~r/endobj#{@eol}/

  def parse(context=%ParseContext{}) do
    context |> parse_xrefs
  end

  # There can be multiple xrefs, corresponding with updates to individual
  # objects. We want to condese all of that into one set of objects
  defp parse_xrefs(context=%ParseContext{}) do
    context = parse_xref_locations(context)
    Enum.reduce(context.xref_byte_offsets, context, fn (xref_byte_offset, context) ->
      xref = parse_xref(context, xref_byte_offset)
      %ParseContext{context | xrefs: context.xrefs ++ [xref],  objects: context.objects ++ xref.objects}
    end)
  end

  def parse_xref_locations(context=%ParseContext{}) do
    case Regex.scan(@xref, context.document, capture: :all_names) do
      [] -> raise "Could not find startxref"
      xref_byte_offsets ->
        xref_byte_offsets = List.flatten(xref_byte_offsets)
        |> Enum.map &String.to_integer/1
        %ParseContext{context | xref_byte_offsets: xref_byte_offsets}
    end
  end

  # Pull out from the location of the xref to the end. We will then need to
  # parse the trailer and individual objects separately.
  def parse_xref(context, xref_location) do
    bytes_until_end = byte_size(context.document) - xref_location
    xref_until_end = :binary.part(context.document, xref_location, bytes_until_end)
    [xref, trailer, _rest] = Regex.split(~r/startxref|trailer/, xref_until_end, parts: 2)
    %ParseContext{
      context |
      objects: parse_objects(xref),
      trailer: []
    }
  end

  def parse_objects(xref) do
    Gutenex.Pdf.Parsers.XrefParser.parse(xref).entries
  end

  def parse_trailer(trailer) do
    ""
  end

  def index_of(regex, string) do

  end
end
