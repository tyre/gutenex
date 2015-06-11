defmodule Gutenex.PDF.Deserialization do
  @moduledoc """
  Deserialize PDF objects. Major shoutout to Dave Thomas' [guide on parsing
  Markdown in Elixir](http://pragdave.me/blog/2014/02/12/pattern-matching-and-parsing/)
  for inspiration when I got stuck <3

  For example:
    2 0 obj % Page tree
      << /Type /Pages
         /Kids [3 0 R]
         /Count 1
      >>
    endobj
  """

  # "%" followed by 0 or more characters
  @comment ~r/%.*/

  # Lines can end with arbitrary amounts of space or a comment
  @line_end ~r/\s*(#{Regex.source(@comment)})?\z/

  # Objects are an object number, a generation number, then the literal string
  # "obj". After that there can be a comment, which we don't care about
  @object_start ~r/(?<object_number>\d+) (?<generation_number>\d+) obj#{Regex.source(@line_end)}/
  @object_end "endobj"

  # Pointers or references are made up of an object number, a generation number,
  # and the literal "R"
  @ptr ~r/\A(\d+) (\d+) R(#{Regex.source(@line_end)})/

  # Strings are demarked by just a forward slash
  @string ~r/\A\s*\/(?<string>\w+)\s*\Z/

  # Dictionaries are demarcated by pairs of double carets, followed by pairs of
  # symbols (keys) and their values (anything).
  # For Example:
  # ```
  # << /Bob /Dole
  # /John /Wall
  # /Antonin /Scalia
  # >>
  # ```
  @dictionary_start ~r/\A\s*<<\s*/
  @dictionary_end ~r/\A\s*>>\s*\Z/
  @dict_key_value_pair ~r/\/(?<key>\w+)\s+(?<value>.+)#{Regex.source(@line_end)}/
  @doc """
  Deserializes a string into a list of gutenex objects (tuples).
  This takes multiple passes, trading efficiency for human processing.
  """
  def deserialize(string=raw_string) do
    String.split(raw_string, "\n", trim: true)
    |> typify
  end

  def deserialize([], parsed_lines) do
    parsed_lines
  end

  def deserialize(unparsed_lines, parsed_lines) do

  end

  defp typify(untyped) do
    typify(untyped, [])
  end

  defp typify([], typed_lines) do
    Enum.reverse typed_lines
  end

  defp typify([current_line | rest], typed_lines) do
    [still_untyped, been_typed] = cond do
      Regex.match? @ptr, current_line ->
        typify_ptr(current_line, rest, typed_lines)
      Regex.match? @object_start, current_line ->
        typify_obj(current_line, rest, typed_lines)
      Regex.match? @dictionary_start, current_line ->
        typify_dict(current_line, rest, typed_lines)
      Regex.match? @string, current_line ->
        typify_string(current_line, rest, typed_lines)
      true ->
        [rest, [:unknown | typed_lines]]
    end
    typify(still_untyped, been_typed)
  end

  # Pointers are thankfully simple — just match the reference numbers and be
  # done with it! E.g. "1 0 R" == {:ptr, 1, 0}
  defp typify_ptr(ptr_string, untyped_lines, typed_lines) do
    [_match, object_number, generation_number, _comment] = Regex.run @ptr, ptr_string
    been_typed = [{
      :ptr,
      String.to_integer(object_number),
      String.to_integer(generation_number)
    } | typed_lines]
    [untyped_lines, been_typed]
  end

  defp typify_string(current_line, untyped_lines, typed_lines) do
    matches = Regex.named_captures @string, current_line
    [untyped_lines, [Map.get(matches, "string") | typed_lines]]
  end

  defp typify_obj(object_beginning, untyped_lines, typed_lines) do
    {object_contents, [_obj_end | rest_untyped]} = Enum.split_while(untyped_lines, fn (line) ->
      line != @object_end
    end)
    # Smelly
    [contents] = typify(object_contents, [])
    object = [
      parse_object_header(object_beginning),
      contents
    ]
    [rest_untyped, [object | typed_lines]]
  end

  defp parse_object_header(object_beginning) do
    matches = Regex.named_captures @object_start, object_beginning
    {
      :obj,
      String.to_integer(Map.get(matches, "object_number")),
      String.to_integer(Map.get(matches, "generation_number"))
    }
  end

  # Dictionaries are a little tricky. Ideally, they would start clearly on one
  # line with `<<` and finish with a distinct `>>`.
  # Unfortunately, they can have key/value pairs on the first line so we must be
  # vigilent!
  defp typify_dict(start_line, untyped_lines, typed_lines) do
    {dict_contents, rest_untyped} = extract_dict_contents(untyped_lines)
    dict = parse_dict_contents(start_line, dict_contents)
    [rest_untyped, [dict | typed_lines]]
  end

  defp extract_dict_contents(untyped_lines) do
    {dict_contents, untyped_lines} = Enum.split_while(untyped_lines, fn (line) ->
      !Regex.match? @dictionary_end, line
    end)
    # The first of the untyped lines we know is the end dictionary symbol.
    # Toss it.
    [_dict_end | rest_untyped] = untyped_lines
    {dict_contents, rest_untyped}
  end

  # Special case to include parsing of the first line. Parse it, then use that
  # map (either empty or with one key/value if the first line has a pair) as the
  # beginning of our recursive partay
  defp parse_dict_contents(start_line, dict_contents) when is_binary(start_line) do
    reduce_function = fn (key_value_line, contents) ->
      Map.merge(contents, parse_dict_key_value(key_value_line))
    end
    Enum.reduce(dict_contents, parse_dict_start_line(start_line), reduce_function)
  end

  defp parse_dict_start_line(start_line) do
    purged_start_line = Regex.replace(@dictionary_start, start_line, "")
      |> String.strip
    if String.starts_with? purged_start_line, "/" do
      parse_dict_key_value purged_start_line
    else
      %{}
    end
  end

  defp parse_dict_key_value(raw_string) do
    matches = Regex.named_captures @dict_key_value_pair, raw_string
    # I don't like this. It's dirty. I should be able to deserialize single strings
    [parsed_value] = typify([Map.get(matches, "value")])
    Map.put(%{}, Map.get(matches, "key"), parsed_value)
  end
end
