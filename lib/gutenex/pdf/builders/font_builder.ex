defmodule Gutenex.PDF.Builders.FontBuilder do

  # Builds each font object, returning the last object index, the reference
  # dictionary (for each font, "FontReference" => {:ptr, font_index, font_generation_number})
  # and the font objects themselves
  def build(context, start_object_index) do
    build({start_object_index, context.generation_number}, Map.to_list(context.fonts), %{}, [])
  end

  def build({current_index, _generation_number}, [], font_references, font_objects) do
    {current_index, font_references, Enum.reverse(font_objects)}
  end

  def build({current_index, generation_number}, [{font_alias, font_definition}|rest_of_fonts], font_references, font_objects) do
    font_objects = [{{:obj, current_index, generation_number}, {:dict, font_definition}} | font_objects]
    font_references = Map.put font_references, font_alias, {:ptr, current_index, generation_number}
    next_index = current_index + 1
    build({next_index, generation_number}, rest_of_fonts, font_references, font_objects)
  end

end
