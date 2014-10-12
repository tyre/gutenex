defmodule Gutenex.PDF.Bezier do
  @moduledoc """
  Bezier curves
  """
  def bezier(pdf,{x1,y1},{x2,y2},{x3,y3},{x4,y4}) do
    :eg_pdf.bezier(pdf,{x1,y1},{x2,y2},{x3,y3},{x4,y4})
  end

  def bezier(pdf,x1,y1,x2,y2,x3,y3,x4,y4) do
    :eg_pdf.bezier(pdf,x1,y1,x2,y2,x3,y3,x4,y4)
  end

  def bezier_c(pdf,point1,point2,point3) do
    :eg_pdf.bezier_c(pdf,point1,point2,point3)
  end

  def bezier_v(pdf, point1, point2 ) do
    :eg_pdf.bezier_v(pdf, point1, point2 )
  end

  def bezier_y(pdf, point1, point3) do
    :eg_pdf.bezier_y(pdf, point1, point3)
  end
end
