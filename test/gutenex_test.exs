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

  test "#move_to", %{server: server} do
    server = Gutenex.move_to(server, 20, 30)
    assert "20 30 m\n" == Gutenex.stream(server)
  end

  test "integration!" do
    File.rm("./tmp/alpaca.pdf")
    {:ok, pid} = Gutenex.start_link
      Gutenex.begin_text(pid)
      |> Gutenex.set_font("Helvetica", 48)
      |> Gutenex.text_position(40, 180)
      |> Gutenex.text_render_mode(:fill)
      |> Gutenex.write_text("ABC")
      |> Gutenex.set_font("Courier", 32)
      |> Gutenex.text_render_mode(:stroke)
      |> Gutenex.write_text("xyz")
      |> Gutenex.end_text()
      |> Gutenex.move_to(400, 20)
      |> Gutenex.draw_image("./test/support/images/alpaca.png", %{
        translate_x: 300,
        translate_y: 500,
      })
      |> Gutenex.export("./tmp/alpaca.pdf")
  end
end
