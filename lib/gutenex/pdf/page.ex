defmodule Gutenex.PDF.Page do

  def page_size(width, height) when is_integer(width) and is_integer(height) do
    {0, 0, width, height}
  end

  def page_size(:a0) do
    page_size(2380, 3368)
  end

  def page_size(:a1) do
    page_size(1684, 2380)
  end

  def page_size(:a2) do
    page_size(1190, 1684)
  end

  def page_size(:a3) do
    page_size(842, 1190)
  end

  def page_size(:a4) do
    page_size(595, 842)
  end

  def page_size(:a5) do
    page_size(421, 595)
  end

  def page_size(:a6) do
    page_size(297, 421)
  end

  def page_size(:a7) do
    page_size(210, 297)
  end

  def page_size(:a8) do
    page_size(148, 210)
  end

  def page_size(:a9) do
    page_size(105, 148)
  end

  def page_size(:b0) do
    page_size(2836, 4008)
  end

  def page_size(:b1) do
    page_size(2004, 2836)
  end

  def page_size(:b2) do
    page_size(1418, 2004)
  end

  def page_size(:b3) do
    page_size(1002, 1418)
  end

  def page_size(:b4) do
    page_size(709, 1002)
  end

  def page_size(:b5) do
    page_size(501, 709)
  end

  def page_size(:b6) do
    page_size(355, 501)
  end

  def page_size(:b7) do
    page_size(250, 355)
  end

  def page_size(:b8) do
    page_size(178, 250)
  end

  def page_size(:b9) do
    page_size(125, 178)
  end

  def page_size(:b10) do
    page_size(89, 125)
  end

  def page_size(:c5e) do
    page_size(462, 649)
  end

  def page_size(:comm10e) do
    page_size(298, 683)
  end

  def page_size(:dle) do
    page_size(312, 624)
  end

  def page_size(:executive) do
    page_size(542, 720)
  end

  def page_size(:folio) do
    page_size(595, 935)
  end

  def page_size(:ledger) do
    page_size(1224, 792)
  end

  def page_size(:legal) do
    page_size(612, 1008)
  end

  def page_size(:letter) do
    page_size(612, 792)
  end

  def page_size(:tabloid) do
    page_size(792, 1224)
  end
end
