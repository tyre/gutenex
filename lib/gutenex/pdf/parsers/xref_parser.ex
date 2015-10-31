defmodule Gutenex.Pdf.Parsers.XrefParser do
  alias Gutenex.Pdf.Xref
  alias Gutenex.Pdf.Xref.ObjectEntry
  @eol ~r/[\n\r]+/
  @object_range ~r/(?<object_start>\d+)\s(?<length>\d+)/
  @doc ~S(
    Takes in an xref table and turns it into objects we can reason about
    ## Examples

        iex> Gutenex.Pdf.Parsers.XrefParser.parse """
        ...> xref
        ...> 0 3
        ...> 0000000000 65535 f
        ...> 0000045738 00000 n
        ...> 0000001805 00000 n
        ...> """
        %Gutenex.Pdf.Xref{
          object_start: 0,
          object_end: 2,
          entries: [
            %Gutenex.Pdf.Xref.ObjectEntry{object_number: 0, byte_offset: 0, generation_number: 65535, free: true},
            %Gutenex.Pdf.Xref.ObjectEntry{object_number: 1, byte_offset: 45738, generation_number: 0, free: false},
            %Gutenex.Pdf.Xref.ObjectEntry{object_number: 2, byte_offset: 1805, generation_number: 0, free: false}
          ]
        }

        iex> Gutenex.Pdf.Parsers.XrefParser.parse """
        ...> xref
        ...> 12 1
        ...> 0000045738 00005 n
        ...> """
        %Gutenex.Pdf.Xref{
          object_start: 12,
          object_end: 12,
          entries: [
            %Gutenex.Pdf.Xref.ObjectEntry{object_number: 12, byte_offset: 45738, generation_number: 5, free: false}
          ]
        }
    )

  def parse(<<"xref", rest::binary>>) do
    [object_range | entries] = Regex.split(@eol, String.strip(rest))
    parse_object_range(%Xref{}, object_range)
    |> parse_object_entries(entries)
  end

  defp parse_object_range(xref, xref_string) do
    matches = Regex.named_captures(@object_range, xref_string)
    case matches do
      %{"object_start" => object_start, "length" => length} ->
        object_start = String.to_integer(object_start)
        %Xref{xref |
          object_start: object_start,
          object_end: object_start + String.to_integer(length) - 1
        }
      _ ->
        raise "Malformatted or missing object range at start of xref"
    end
  end

  # If you ain't got no entries take your broke ass home
  defp parse_object_entries(%Xref{}=xref, []) do
    xref
  end

  defp parse_object_entries(%Xref{}=xref, entries) do
    parse_object_entries(xref, xref.object_start, entries)
  end

  defp parse_object_entries(%Xref{}=xref, _object_number, []) do
    xref
  end

  defp parse_object_entries(%Xref{}=xref, object_number, [entry | entries]) do
    object_entry = parse_object_entry(object_number, entry)
    parse_object_entries(
      %Xref{ xref | entries: List.insert_at(xref.entries, object_number, object_entry)},
      object_number + 1,
      entries)
  end

  defp parse_object_entry(object_number,
    <<byte_offset::binary-size(10), " ", generation_number::binary-size(5), " ",
      free::binary-size(1), _rest::binary>>) do
    is_free = (free == "f")
    %ObjectEntry{
      byte_offset: String.to_integer(byte_offset),
      object_number: object_number,
      generation_number: String.to_integer(generation_number),
      free: is_free
    }
  end
end
