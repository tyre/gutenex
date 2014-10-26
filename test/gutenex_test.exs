defmodule GutenexTest do
  use ExUnit.Case

  setup do
    {:ok, server_pid} = Gutenex.start_link()
    {:ok, %{server: server_pid}}
  end

  test "getting the context", %{server: server} do
    assert %Gutenex.PDF.Context{} == Gutenex.context(server)
  end

  test "setting the context", %{server: server} do
    assert %Gutenex.PDF.Context{} == Gutenex.context(server)

    new_context = %Gutenex.PDF.Context{ meta_data: %{ author: "Kurt Vonnegut", title: "Slaughterhouse-five"} }
    Gutenex.context(server, new_context)

    assert new_context == Gutenex.context(server)
  end

  test "getting the stream", %{server: server} do
    assert <<>> == Gutenex.stream(server)
  end

  test "appending to the stream", %{server: server} do
    assert <<>> == Gutenex.stream(server)

    Gutenex.append_to_stream(server, "Billy Pilgrim")
    Gutenex.append_to_stream(server, ", Kilgore Trout")
    Gutenex.append_to_stream(server, ", Roland Weary")

    assert "Billy Pilgrim, Kilgore Trout, Roland Weary" == Gutenex.stream(server)
  end

  test "setting the current page", %{server: server} do
    assert %Gutenex.PDF.Context{current_page: 1} == Gutenex.context(server)
    Gutenex.set_page(server, 2)
    assert %Gutenex.PDF.Context{current_page: 2} == Gutenex.context(server)
  end

# Existing errors!
# Validating file "alpaca.pdf" for conformance level pdfa-1b
# The 'xref' keyword was not found or the xref table is malformed.
# The file trailer dictionary is missing or invalid.
# The "endobj" keyword is missing.
# The file trailer dictionary must have an id key.
# The key Metadata is required but missing.
# The documents contains no pages.
# The document does not conform to the requested standard.
# The file format (header, trailer, objects, xref, streams) is corrupted.
# The document doesn't conform to the PDF reference (missing required entries, wrong value types, etc.).
# The document's meta data is either missing or inconsistent or corrupt.
# Done.

  test "integration!" do
    File.rm("./tmp/alpaca.pdf")
    image = %Imagineer.Image{alias: "Alpaca", uri: "./test/support/images/alpaca.png"}
      |> Imagineer.Image.load()
      |> Imagineer.Image.process()
    context = Gutenex.PDF.add_page(%Gutenex.PDF.Context{}, "Walrus")
    File.write "./tmp/alpaca.pdf", Gutenex.PDF.Builder.build(context)
    |> Gutenex.PDF.Exporter.export()
  end
end
