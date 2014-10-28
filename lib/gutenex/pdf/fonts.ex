defmodule Gutenex.PDF.Fonts do
  # Helpful PDF on fonts in PDFs: http://www.ntg.nl/eurotex/KacvinskyPDF.pdf
  @standard_fonts  %{
    "Times-Roman" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Times-Roman" }},
    "Times-Italic" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Times-Italic" }},
    "Times-Bold" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Times-Bold" }},
    "Times-BoldItalic" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Times-BoldItalic" }},
    "Helvetica" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Helvetica" }},
    "Helvetica-Oblique" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Helvetica-Oblique" }},
    "Helvetica-Bold" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Helvetica-Bold" }},
    "Helvetica-BoldOblique" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Helvetica-BoldOblique" }},
    "Courier" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Courier" }},
    "Courier-Oblique" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Courier-Oblique" }},
    "Courier-Bold" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Courier-Bold" }},
    "Courier-BoldOblique" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Courier-BoldOblique" }},
    "Symbol" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "Symbol" }},
    "ZapfDingbats" => %{
      "Encoding"  => {:name, "MacRomanEncoding"},
      "Type"      => {:name, "Font"},
      "Subtype"   => {:name, "Type1"},
      "BaseFont"  => {:name, "ZapfDingbats" }}
  }

  def standard_fonts do
    @standard_fonts
  end
  
end
