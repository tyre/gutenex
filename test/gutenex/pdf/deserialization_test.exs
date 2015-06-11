defmodule Gutenex.PDF.DeserializationTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Deserialization

  test "#deserialize an object with a dict" do
    source = """
    1 0 obj % Document catalog
      << /Type /Catalog
      /Pages 2 0 R
      /Metadata 6 0 R
      >>
    endobj
    """
    assert Deserialization.deserialize(source) == [[
      {:obj, 1, 0},
      %{
          "Type" => "Catalog",
          "Pages" => {:ptr, 2, 0},
          "Metadata" => {:ptr, 6, 0}
      }
    ]]
  end

  test "#deserialize a nested dict" do
    source = """
    1 0 obj << /Type /Catalog /Pages <</Style (Swagalicious)>>>>
    endobj
    """
    assert Deserialization.deserialize(source) == [[
      {:obj, 1, 0},
      %{
        :Type => :Catalog,
        :Pages => %{
          :Style => "Swagalicious"
        }
      }
    ]]
  end

  test "#deserialize with a ptr" do
    assert Deserialization.deserialize("1 2 R") == [{:ptr, 1, 2}]
  end
end
