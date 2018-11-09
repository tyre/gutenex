defmodule GutenexTest do
  use ExUnit.Case

  setup do
    {:ok, server_pid} = Gutenex.start_link()
    {:ok, %{server: server_pid}}
  end

  test "can stop server" do
    {:ok, server_pid} = Gutenex.start_link()
    assert Process.alive?(server_pid)

    :ok = Gutenex.stop(server_pid)

    assert !Process.alive?(server_pid)
  end

  test "setting the context", %{server: server} do
    new_context = %Gutenex.PDF.Context{
      meta_data: %{author: "Kurt Vonnegut", title: "Slaughterhouse-five"}
    }

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
    assert 1 == Gutenex.context(server).current_page
    Gutenex.set_page(server, 2)
    assert 2 == Gutenex.context(server).current_page
  end

  test "#move_to", %{server: server} do
    server = Gutenex.move_to(server, 20, 30)
    assert "20 30 m\n" == Gutenex.stream(server)
  end

  @tag :integration
  test "integration!" do
    File.rm("./tmp/alpaca.pdf")
    {alpaca_alias, alpaca_rendition} = Gutenex.PDF.Images.load("./test/support/images/alpaca.png")
    {:ok, pid} = Gutenex.start_link()

    Gutenex.add_image(pid, alpaca_alias, alpaca_rendition)
    |> Gutenex.begin_text()
    |> Gutenex.text_leading(48)
    |> Gutenex.set_font("Helvetica", 48)
    |> Gutenex.text_position(40, 180)
    |> Gutenex.text_render_mode(:fill)
    |> Gutenex.write_text_br("ABC")
    |> Gutenex.set_font("Courier", 32)
    |> Gutenex.text_render_mode(:stroke)
    |> Gutenex.write_text("xyz")
    |> Gutenex.end_text()
    |> Gutenex.move_to(400, 20)
    |> Gutenex.draw_image(alpaca_alias, %{
      translate_x: 300,
      translate_y: 500
    })
    |> Gutenex.export("./tmp/alpaca.pdf")
  end
end
