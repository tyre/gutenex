defmodule Gutenex do
  use GenServer
  alias Gutenex.PDF
  alias Gutenex.PDF.Context
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
  end

  @doc """
  Sets the current page
  """
  def set_page(pid, page) when is_integer(page) do
    GenServer.cast(pid, {:context, :put, {:current_page, page}})
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
  end

  @doc """
  Export the PDF document to a binary
  """

  def export(pid) do
    GenServer.call(pid, :export)
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
    {:reply, PDF.export(context, stream)}
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

end
