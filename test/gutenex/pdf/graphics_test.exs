defmodule Gutenex.PDF.GraphicsTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Graphics

  test "#save_state" do
    assert Graphics.save_state() == "q\n"
  end

  test "#restore_state" do
    assert Graphics.restore_state() == "Q\n"
  end

  test "#with_state" do
    assert Graphics.with_state(fn ->
             "Bubbles!"
           end) == "#{Graphics.save_state()}Bubbles!#{Graphics.restore_state()}"
  end

  test "#paint" do
    assert Graphics.paint("Banananas") == "/Banananas Do\n"
  end
end
