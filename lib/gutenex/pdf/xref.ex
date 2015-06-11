defmodule Gutenex.Pdf.Xref do
  defstruct(
    object_start: 0,
    object_end: 0,
    entries: []
  )

  def add_object_entry(xref, object_entry) do

  end

  # An object's entry in the cross-reference table has a byte offset for where
  # that object begins in the document, a generation number which is incremented
  # by one every time an update is made, and whether or not that object is in
  # use or free
  defmodule ObjectEntry do
    defstruct(
      byte_offset: 0,
      object_number: 0,
      generation_number: 0,
      free: false
    )
  end
end
