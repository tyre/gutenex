defmodule Gutenex do
  use GenServer
  alias Gutenex.PDF
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.Text
  alias Gutenex.PDF.Font
  #######################
  ##       Setup       ##
  #######################

  @doc """
  Starts the PDF generation server.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Returns the default context and stream (empty binary)
  """
  def init(:ok) do
    {:ok, [%Context{}, <<>>]}
  end

  #######################
  ##    Client API     ##
  #######################

  @doc """
  Returns the current context
  """
  def context(pid) do
    GenServer.call(pid, :context)
  end

  @doc """
  Sets the current context
  """
  def context(pid, new_context) do
    GenServer.cast(pid, {:context, new_context})
    pid
  end

  @doc """
  Sets the current page
  """
  def set_page(pid, page) when is_integer(page) do
    GenServer.cast(pid, {:context, :put, {:current_page, page}})
    pid
  end

  @doc """
  Begin a text block
  """
  def begin_text(pid) do
    GenServer.cast(pid, {:text, :begin})
    pid
  end
  
  @doc """
  Set the text position
  """
  def text_position(pid, x_coordinate, y_coordinate) do
    GenServer.cast(pid, {:text, :position, {x_coordinate, y_coordinate}})
    pid
  end
  
  @doc """
  Set the text render mode
  """
  def text_render_mode(pid, render_mode) do
    GenServer.cast(pid, {:text, :render_mode, render_mode})
    pid
  end
  
  @doc """
  Write text to the stream
  """
  def write_text(pid, text_to_write) do
    GenServer.cast(pid, {:text, :write, text_to_write})
    pid
  end
  
  @doc """
  End a text block
  """
  def end_text(pid) do
    GenServer.cast(pid, {:text, :end})
    pid
  end
  

  @doc """
  Set the font
  """
  def set_font(pid, font_name) do
    GenServer.cast(pid, {:font, :set, font_name})
    pid
  end

  @doc """
  Set the font and font size
  """
  def set_font(pid, font_name, font_size) do
    GenServer.cast(pid, {:font, :set, {font_name, font_size}})
    pid
  end  

  @doc """
  Gets the current stream
  """
  def stream(pid) do
    GenServer.call(pid, :stream)
  end

  @doc """
  Append to the current stream
  """
  def append_to_stream(pid, content) do
    GenServer.cast(pid, {:stream, :append, content})
    pid
  end

  @doc """
  Export the PDF document to a binary
  """
  def export(pid) do
    GenServer.call(pid, :export)
  end

  def export(pid, file_name) do
    File.write file_name, export(pid)
  end

  #######################
  ##   Call handlers   ##
  #######################


  @doc """
  Returns the current context
  """
  def handle_call(:context, _from, [context, stream]) do
    {:reply, context, [context, stream]}
  end

  @doc """
  Returns the stream
  """
  def handle_call(:stream, _from, [context, stream]) do
    {:reply, stream, [context, stream]}
  end

  @doc """
  Export the PDF to binary format
  """

  def handle_call(:export, _from, [context, stream]) do
    {:reply, PDF.export(context, stream), [context, stream]}
  end

  #######################
  ##   Cast handlers   ##
  #######################

  @doc """
  Sets the current context
  """
  def handle_cast({:context, new_context}, [_context, stream]) do
    {:noreply, [new_context, stream]}
  end

  @doc """
  Appends to the stream
  """
  def handle_cast({:stream, :append, str}, [context, stream]) do
    new_stream = stream <> str
    {:noreply, [context, new_stream]}
  end

  @doc """
  Sets the current page
  """
  def handle_cast({:context, :put, {key, value}}, [context, stream]) do
    new_context = Map.put context, key, value
    {:noreply, [new_context, stream]}
  end

  @doc """
    Begin a section of text
  """
  def handle_cast({:text, :begin}, [context, stream]) do
    stream = stream <> Text.begin_text
    {:noreply, [context, stream]}
  end
  
  @doc """
    End a section of text
  """
  def handle_cast({:text, :end}, [context, stream]) do
    stream = stream <> Text.end_text
    {:noreply, [context, stream]}
  end
  
  @doc """
    Write some text!
  """
  def handle_cast({:text, :write, text_to_write}, [context, stream]) do
    stream = stream <> Text.write_text(text_to_write)
    {:noreply, [context, stream]}
  end

  @doc """
    Set the text position
  """
  def handle_cast({:text, :position, {x_coordinate, y_coordinate}}, [context, stream]) do
    stream = stream <> Text.text_position(x_coordinate, y_coordinate)
    {:noreply, [context, stream]}
  end

  @doc """
    Set the text render mode
  """
  def handle_cast({:text, :render_mode, render_mode}, [context, stream]) do
    stream = stream <> Text.render_mode(render_mode)
    {:noreply, [context, stream]}
  end

  #####################################
  #               Fonts               #
  #####################################

  @doc """
    Set the font and size
  """
  def handle_cast({:font, :set, {font_name, font_size}}, [context, stream]) do
    stream = stream <> Font.set_font(context.fonts, font_name, font_size)
    {:noreply, [context, stream]}
  end

  @doc """
    Set the font
  """
  def handle_cast({:font, :set, font_name}, [context, stream]) do
    stream = stream <> Font.set_font(context.fonts, font_name)
    {:noreply, [context, stream]}
  end

end
