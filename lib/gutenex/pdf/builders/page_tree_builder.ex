defmodule Gutenex.PDF.Builders.PageTreeBuilder do
  def build(context, object_number, resources) do
    {
      {:obj, object_number, context.generation_number},
      build_tree(context, resources)
    }
  end

  defp build_tree(context, resources) do
    pages = Map.get(resources, :pages, [])
    images = Map.get(resources, :images, [])
    fonts = Map.get(resources, :fonts, [])
    {:dict, %{
      "Type" => {:name, "Pages"},
      "Count" => length(pages),
      "MediaBox" => {:rect, media_box(context.media_box)},
      "Kids" => {:array, page_pointers(pages, context.generation_number)},
      "Resources" => page_resources(images, fonts)}}
  end

  def media_box({top_left, top_right, bottom_left, bottom_right}) do
    [top_left, top_right, bottom_left, bottom_right]
  end

  def page_pointers(pages, generation_number) do
    Enum.map pages, fn (page) ->
      {:ptr, page, generation_number}
    end
  end

  def page_resources(images, fonts) do
    {:dict, %{
      "Font" => {:dict, fonts},
      "XObject" => images
    }}
  end
end
