defmodule Gutenex.PDF.Exporter do

  # Declare the PDF version and a magic comment to imply binary data
  @start_mark """
  %PDF-1.4
  """
  @end_mark "%%EOF\r\n"

  def export({root_index, generation_number, meta_data_index, objects}) do
    serialized_objects =
      Enum.map(objects, &Gutenex.PDF.Serialization.serialize/1)
    @start_mark <>
    Enum.join(serialized_objects) <>
    cross_reference_table(serialized_objects) <>
    trailer(root_index, generation_number, meta_data_index, objects) <>
    start_cross_reference(serialized_objects) <>
    @end_mark
  end

  def trailer(root_index, generation_number, meta_data_index, objects) do
    """
    trailer
      << /Size #{length(objects) + 1}
        /Root #{root_index} #{generation_number} R
        /Info #{meta_data_index} #{generation_number} R
      >>
    """
  end

  def cross_reference_table(serialized_objects) do
    pdf_start_position = String.length(@start_mark)
    {xrefs, _acc} = :lists.mapfoldl &xref/2, pdf_start_position, serialized_objects
    """
    xref
    0 #{length(serialized_objects) + 1}
    #{xref1(0, "65535 f")}#{xrefs}
    """
  end

  def start_cross_reference(serialized_objects) do
    total_length = Enum.reduce serialized_objects, String.length(@start_mark), fn (object, total) ->
      String.length(object) + total
    end

    """
    startxref
    #{total_length}
    """
  end

  def xref(serialized_objects, position) do
    objects_length = String.length(serialized_objects)
    {xref1(position, "00000 n"), position + objects_length}
  end

  def xref1(position, string) do
    :io_lib.format("~10.10.0w ~s \n", [position, string])
  end

end
