defmodule Gutenex.PDF.Builder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.Builders.ImageBuilder
  alias Gutenex.PDF.Builders.FontBuilder
  alias Gutenex.PDF.Builders.PageBuilder
  alias Gutenex.PDF.Builders.PageTreeBuilder
  alias Gutenex.PDF.Builders.CatalogBuilder
  alias Gutenex.PDF.Builders.MetaDataBuilder

  # The way I'm building this looks suspiciously like a GenServer...
  @doc """
  Takes in a PDF.Context and returns a PDF.RenderContext
  """
  def build(%Context{}=context) do
    {_render_context, ^context} = {%Gutenex.PDF.RenderContext{}, context}
      |> ImageBuilder.build
      |> FontBuilder.build
      |> PageTreeBuilder.build
      |> PageBuilder.build
      |> CatalogBuilder.build
      |> MetaDataBuilder.build
  end
end
