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

    new_context = %Gutenex.PDF.Context{ info: %{ author: "Kurt Vonnegut", title: "Slaughterhouse-five"} }
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

  test "#export", %{server: server} do
    { pdf, _number_of_pages } = Gutenex.export(server)
    IO.puts(inspect(pdf))

  end
end
