defmodule Gutenex.PDF.Templates do

  def load(path) do
    {
      template_alias(path),
      File.read!(path)
    }
  end

  def template_alias(template_path) do
    Base.hex_encode32(template_path)
    |> String.strip(?=)
  end
end
