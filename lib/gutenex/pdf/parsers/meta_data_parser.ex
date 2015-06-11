defmodule Gutenex.Pdf.Parsers.MetaDataParser do
  alias Gutenex.Pdf.ParseContext
  @eof ~r/%%EOF[\r\n\s]*/
  @version_comment ~r/\A%PDF\-(?<version>\d+\.\d+)/

  def parse(parse_context=%ParseContext{}) do
    split_out_updates(parse_context)
    |> parse_version
  end

  defp split_out_updates(parse_context) do
    [original_pdf | updates] = Regex.split(@eof, parse_context.source, trim: true)
    %ParseContext{parse_context | document: original_pdf, updates: updates}
  end

  defp parse_version(parse_context) do
    case Regex.named_captures(@version_comment, parse_context.document) do
      %{"version" =>  version} ->
        %ParseContext{parse_context | version: version}
      nil -> parse_context
    end
  end

end
