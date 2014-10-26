defmodule Gutenex.PDF.Exporter do

  @start_mark "%PDF-1.4\n"
  @end_mark "%%EOF\r\n"

  def export({root_index, meta_data_index, objects}) do
    # sorted_objects = List.keysort(objects)
    serialized_objects =
      Enum.map(objects, &Gutenex.PDF.Serialization.serialize/1)
    @start_mark <>
    Enum.join(serialized_objects) <>
    cross_reference_table(serialized_objects) <>
    trailer(root_index, meta_data_index, objects) <>
    start_cross_reference(serialized_objects) <>
    @end_mark
  end

  def trailer(root_index, meta_data_index, objects) do
    """
    trailer
    <<
    /Size #{length(objects) + 1} 0 R
    /Root #{root_index} 0 R
    /Info #{meta_data_index} 0 R
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


# startxref(Objects) ->
#     ["startxref\n",
#      i(lists:foldl(fun(A, Accu) -> objsize(A) + Accu end,
#        length(startmark()) + length(pdfbmagic()),
#         Objects)),
#      "\n"].


# %% xref
# %% 0 9
# %% 0000000000 65535 f
# %% 0000000033 00000 n
# %% 0000000098 00000 n
# %% 0000000144 00000 n
# %% 0000000203 00000 n
# %% 0000000231 00000 n
# %% 0000000409 00000 n
# %% 0000000721 00000 n
# %% 0000000835 00000 n
# xref(Objects) ->
#     {XRefs, _EndAccu} =
#   lists:mapfoldl(
#     fun xref/2, length(startmark()) + length(pdfbmagic()),
#     Objects ),
#     ["xref\n",
#      "0 ",i(nobjects(Objects) + 1), "\n",
#      xref1(0,"65535 f"),
#      XRefs
#     ].

# xref(Obj, Pos) ->
#     {xref1(Pos, "00000 n"), Pos + objsize(Obj)}.

# xref1(I, Str) ->
#     lists:flatten(io_lib:format("~10.10.0w ~s \n", [I,Str])).

# export(InfoRef, Objects) ->
  #   SortedObjects = lists:keysort(1,Objects),
  #   BObjects = serialise2bin(SortedObjects),
  #   b([
  #      startmark(),
  #      pdfbmagic(),
  #      BObjects,
  #      xref(BObjects),
  #      trailer(InfoRef, SortedObjects),
  #      startxref(BObjects),
  #      endmark()
  #     ]).

# %% trailer
# %% <<
# %% /Size 9
# %% /Root 1 0 R
# %% /Info 8 0 R
# %% >>
# %% startxref
# %% 1073
# %% %%EOF
# trailer(InfoRef, Objects) ->
#     [Root] = get_objects_of_type("Catalog", Objects),
#     RootRef = get_ref(Root),
#     ["trailer\n",
#      "<<\n",
#      "/Size ",i(nobjects(Objects) + 1), "\n",
#      "/Root ",i(RootRef), " 0 R\n",
#      "/Info ", i(InfoRef), " 0 R\n",
#      ">>\n"].


end
