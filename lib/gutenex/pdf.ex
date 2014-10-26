defmodule Gutenex.PDF do
  require Record
  alias Gutenex.Geometry.Line
  alias Gutenex.PDF.Context

  def start_link() do
    something = :eg_pdf.new()
    case something do
      {:ok, p} when is_pid(p) ->
        p
      {:error, {:already_started, p}} when is_pid(p) ->
        p
      {:error, message} ->
        IO.puts("Error starting Gutenex PDF server: #{message}")
    end
  end

  def export(%Context{} = context, _stream) do
    Gutenex.PDF.Builder.build(context)
    |> Gutenex.PDF.Exporter.export()
  end

  def add_page(%Context{} = context, stream) do
    next_page_number = context.current_page + 1
    %Context{ context |
      current_page: next_page_number,
      pages: Enum.reverse([stream | context.pages])
    }
  end

  def set_page(%Context{} = context, _stream) do

  end



  def set_page(pdf, page_number) do
    :eg_pdf.set_page(pdf, page_number)
  end

  def set_pagesize(pid, size) do
    :eg_pdf.set_pagesize(pid, size)
  end

  def set_pagesize(pid, width, height) do
    :eg_pdf.set_pagesize(pid, width, height)
  end

  @doc """
  Exports to binary PDF format
  """
  def export(pdf) do
    :eg_pdf.export(pdf)
  end

  def delete(pdf) do
    :eg_pdf.delete(pdf)
  end

  def get_state(pdf) do
    :eg_pdf.get_state(pdf)
  end

  def new_page(pdf) do
    :eg_pdf.new_page(pdf)
  end

  def add_start_xref(file, xref_start_position) do
    :eg_pdf.add_start_xref(file, xref_start_position)
  end

  # objects = {object_number, start_position}
  def add_trailer(file, objects, root, info) do
    :eg_pdf.add_trailer(file, objects, root, info)
  end

  # objects = {object_number, start_position}
  def add_xref(file, objects) do
    :eg_pdf.add_xref(file, objects)
  end

  def append_stream(pdf, string) do
    :eg_pdf.append_stream(pdf, string)
  end

  def begin_text(pdf) do
    :eg_pdf.begin_text(pdf)
  end

  def end_text(pdf) do
    :eg_pdf.end_text(pdf)
  end

  def break_text(pdf) do
    :eg_pdf.break_text(pdf)
  end

  def text(pdf, text) do
    :eg_pdf.text(pdf, text)
  end

  def text_break(pdf,text) do
    :eg_pdf.textbr(pdf,text)
  end

  def kernedtext(pdf, text) do
    :eg_pdf.kernedtext(pdf, text)
  end

  def set_text_pos(pdf, x, y) do
    :eg_pdf.set_text_pos(pdf, x, y)
  end

  def set_text_leading(pdf, l) do
    :eg_pdf.set_text_leading(pdf, l)
  end

  def set_text_rendering(pdf, mode) do
    :eg_pdf.set_text_rendering(pdf, mode)
  end

  def set_character_space(pdf, character_space) do
    :eg_pdf.set_char_space(pdf, character_space)
  end

  def set_word_space(pdf, word_space) do
    :eg_pdf.set_word_space(pdf, word_space)
  end

  def set_text_scale(pdf, text_scale) do
    :eg_pdf.set_text_scale(pdf, text_scale)
  end

  def set_text_rise(pdf, rise) do
    :eg_pdf.set_text_rise(pdf, rise)
  end

  ## Fonts

  def set_font(pdf, font_name, size) do
    :eg_pdf.set_font(pdf, font_name, size)
  end

  def ensure_font_gets_loaded(pdf, font_name) do
    :eg_pdf.ensure_font_gets_loaded(pdf, font_name)
  end

  # Shapes

  def circle(pdf, {x,y}, r) do
    :eg_pdf.circle(pdf, {x,y}, r)
  end

  def ellipse(pdf, {x, y}, {rx, ry}) do
    :eg_pdf.ellipse(pdf, {x, y}, {rx, ry})
  end

  ## Rectangles

  def rectangle(pdf,{x,y},{wx,wy}) do
    :eg_pdf.rectangle(pdf,{x,y},{wx,wy})
  end

  def rectangle(pdf,{x,y},{wx,wy}, stroketype) do
    :eg_pdf.rectangle(pdf,{x,y},{wx,wy}, stroketype)
  end

  def rectangle(pdf,x,y,wx,wy) when is_pid(pdf) do
    :eg_pdf.rectangle(pdf,x,y,wx,wy)
  end

  def rectangle(pdf,x,y,wx,wy,option) do
    :eg_pdf.rectangle(pdf,x,y,wx,wy,option)
  end

  def round_rect(pdf, point, size, radius) do
    :eg_pdf.round_rect(pdf, point, size, radius)
  end

  def round_top_rect(pdf, point, size, radius) do
    :eg_pdf.round_top_rect(pdf, point, size, radius)
  end

  ## Line styles

  def set_line_width(pdf,w) do
    :eg_pdf.set_line_width(pdf,w)
  end

  def set_line_cap(pdf,mode) do
    :eg_pdf.set_line_cap(pdf,mode)
  end

  def set_line_join(pdf, mode) do
    :eg_pdf.set_line_join(pdf, mode)
  end

  def set_miter_limit(pdf,limit) do
    :eg_pdf.set_miter_limit(pdf,limit)
  end

  def set_dash(pdf, mode) do
    :eg_pdf.set_dash(pdf, mode)
  end

  def set_dash(pdf, array, phase) do
    :eg_pdf.set_dash(pdf, array, phase)
  end

  ## Graphics State
  def save_state(pdf) do
    :eg_pdf.save_state(pdf)
  end

  def restore_state(pdf) do
    :eg_pdf.restore_state(pdf)
  end

  # Geometric transformation

  def transform(pdf, a, b, c, d, e, f) do
    :eg_pdf.transform(pdf, a, b, c, d, e, f)
  end

  def text_transform(pdf, a, b, c, d, e, f) do
    :eg_pdf.text_transform(pdf, a, b, c, d, e, f)
  end

  def translate(pdf, x, y) do
    :eg_pdf.translate(pdf, x, y)
  end

  def scale(pdf, scale_x, scale_y) when is_integer(scale_x) and is_integer(scale_y) do
    :eg_pdf.scale(pdf, scale_x, scale_y)
  end

  @doc """
  Rotates pdf by `angle` degrees
  """
  def rotate(pdf, angle) do
    :eg_pdf.rotate(pdf, angle)
  end

  @doc """
  Rotates pdf text by `angle` degrees
  """
  def text_rotate(pdf, angle) do
    :eg_pdf.text_rotate(pdf, angle)
  end

  def text_rotate_position(pdf, x, y, angle) do
    :eg_pdf.text_rotate_position(pdf, x, y, angle)
  end

  def skew(pdf, x_scew_angle, y_skew_angle) do
    :eg_pdf.skew(pdf, x_scew_angle, y_skew_angle)
  end

  def mirror_yaxis(pdf, x_translate) do
    :eg_pdf.mirror_yaxis(pdf, x_translate)
  end

  def mirror_xaxis(pdf, y_translate) do
    :eg_pdf.mirror_xaxis(pdf, y_translate)
  end

  # Colors

  def set_fill_color_cmyk(pdf, cyan, magenta, yellow, key) do
    :eg_pdf.set_fill_color_cmyk(pdf, cyan, magenta, yellow, key)
  end

  def set_stroke_color_cmyk(pdf, cyan, magenta, yellow, key) do
    :eg_pdf.set_stroke_color_cmyk(pdf, cyan, magenta, yellow, key)
  end

  def set_fill_color_rgb(pdf, red, green, blue) do
    :eg_pdf.set_fill_color_rgb(pdf, red, green, blue)
  end

  def set_fill_color(pdf, color) do
    :eg_pdf.set_fill_color(pdf, color)
  end

  def set_stroke_color(pdf, color) do
    :eg_pdf.set_stroke_color(pdf, color)
  end

  def set_fill_gray(pdf, gray) do
    :eg_pdf.set_fill_gray(pdf, gray)
  end

  def set_stroke_gray(pdf, gray) do
    :eg_pdf.set_stroke_gray(pdf, gray)
  end

  ## Moving and showing

  def move_and_show(pdf, x, y, string) do
    :eg_pdf_lib.moveAndShow(pdf, x, y, string)
  end

  def move_and_show(pdf, x, y, string, scale) do
    :eg_pdf_lib.moveAndShow(pdf, x, y, string, scale)
  end

  def move_and_show_rotated(pdf, x, y, string, rotation) do
    :eg_pdf_lib.moveAndShowRot(pdf, x, y, string, rotation)
  end

  ## Graphics

  def path(pid, type) do
    :eg_pdf.path(pid, type)
  end

  def move_to(pid, point) do
    :eg_pdf.move_to(pid, point)
  end

  def line(pid, from_to) when is_pid(pid) do
    Line.line(from_to)
  end

  def line(pid, from, to) when is_pid(pid) do
    Line.line(from, to)
  end

  def line(pid, x1, y1, x2, y2) when is_pid(pid) do
    Line.line(x1, y1, x2, y2 )
  end

  def lines(pid, line_list) when is_pid(pid) do
    Line.line(line_list)
  end

  def poly(pid, points) do
    :eg_pdf.poly(pid, points)
  end

  def grid(pid, x_list, y_list) do
    :eg_pdf.grid(pid, x_list, y_list)
  end

end
