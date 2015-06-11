defmodule Gutenex.Pdf.ParseContext do
  defstruct(
    version: nil,
    source: nil,
    objects: [],
    document: nil,
    updates: [],
    xref_byte_offsets: [],
    xrefs: [],
    trailer: nil
  )
end
