defmodule Gutenex.PDF.Page do
  use Gutenex.PDF.Page.PageSizes

  def to_pdf(parent_reference, contents_reference, generation_number, options \\ %{}) do
    {
      :dict,
      [
        {"Type", {:name, "Page"}},
        {"Parent", {:ptr, parent_reference, generation_number}},
        {"Contents", {:ptr, contents_reference, generation_number}}
        | Enum.map(options, &page_option(&1))
      ]
    }
  end

  defp page_option({key, value}) do
    atom_to_page_key(key)
    |> page_option(value)
  end

  defp page_option("LastModified", value) do
    {"LastModified", {:date, value}}
  end

  defp page_option(key, value) do
    {key, value}
  end

  defp atom_to_page_key(:last_modified), do: "LastModified"
  defp atom_to_page_key(:resources), do: "Resources"
  defp atom_to_page_key(:annotations), do: "Annots"
  defp atom_to_page_key(anything), do: anything

  @a0 {2380, 3368}
  @a1 {1684, 2380}
  @a2 {1190, 1684}
  @a3 {842, 1190}
  @a4 {595, 842}
  @a5 {421, 595}
  @a6 {297, 421}
  @a7 {210, 297}
  @a8 {148, 210}
  @a9 {105, 148}
  @b0 {2836, 4008}
  @b1 {2004, 2836}
  @b2 {1418, 2004}
  @b3 {1002, 1418}
  @b4 {709, 1002}
  @b5 {501, 709}
  @b6 {355, 501}
  @b7 {250, 355}
  @b8 {178, 250}
  @b9 {125, 178}
  @b10 {89, 125}
  @c5e {462, 649}
  @comm10e {298, 683}
  @dle {312, 624}
  @executive {542, 720}
  @folio {595, 935}
  @ledger {1224, 792}
  @legal {612, 1008}
  @letter {612, 792}
  @tabloid {792, 1224}

  def page_size(width, height) when is_integer(width) and is_integer(height) do
    {0, 0, width, height}
  end

  def page_size({width, height}) when is_integer(width) and is_integer(height) do
    page_size(width, height)
  end

  def page_size(:a0) do
    page_size(@a0)
  end

  def page_size(:a1) do
    page_size(@a1)
  end

  def page_size(:a2) do
    page_size(@a2)
  end

  def page_size(:a3) do
    page_size(@a3)
  end

  def page_size(:a4) do
    page_size(@a4)
  end

  def page_size(:a5) do
    page_size(@a5)
  end

  def page_size(:a6) do
    page_size(@a6)
  end

  def page_size(:a7) do
    page_size(@a7)
  end

  def page_size(:a8) do
    page_size(@a8)
  end

  def page_size(:a9) do
    page_size(@a9)
  end

  def page_size(:b0) do
    page_size(@b0)
  end

  def page_size(:b1) do
    page_size(@b1)
  end

  def page_size(:b2) do
    page_size(@b2)
  end

  def page_size(:b3) do
    page_size(@b3)
  end

  def page_size(:b4) do
    page_size(@b4)
  end

  def page_size(:b5) do
    page_size(@b5)
  end

  def page_size(:b6) do
    page_size(@b6)
  end

  def page_size(:b7) do
    page_size(@b7)
  end

  def page_size(:b8) do
    page_size(@b8)
  end

  def page_size(:b9) do
    page_size(@b9)
  end

  def page_size(:b10) do
    page_size(@b10)
  end

  def page_size(:c5e) do
    page_size(@c5e)
  end

  def page_size(:comm10e) do
    page_size(@comm10e)
  end

  def page_size(:dle) do
    page_size(@dle)
  end

  def page_size(:executive) do
    page_size(@executive)
  end

  def page_size(:folio) do
    page_size(@folio)
  end

  def page_size(:ledger) do
    page_size(@ledger)
  end

  def page_size(:legal) do
    page_size(@legal)
  end

  def page_size(:letter) do
    page_size(@letter)
  end

  def page_size(:tabloid) do
    page_size(@tabloid)
  end
end
