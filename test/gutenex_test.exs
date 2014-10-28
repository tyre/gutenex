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


  test "integration!" do
    File.rm("./tmp/alpaca.pdf")
    text = """
    BT
      /Helvetica 48 Tf
      20 40 Td
      0 Tr
      0.5 g
      (ABC) Tj
      /Courier 32 Tf
      90 Tr
      (xyz) Tj
    ET
    """
    context = Gutenex.PDF.add_page(%Gutenex.PDF.Context{}, text)
    File.write "./tmp/alpaca.pdf", Gutenex.PDF.Builder.build(context)
    |> Gutenex.PDF.Exporter.export()
  end
end
