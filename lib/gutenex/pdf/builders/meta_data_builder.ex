defmodule Gutenex.PDF.Builders.MetaDataBuilder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext

  @doc """
  Given a PDF Context and index, generate the metadata information dictionary
  """
  def build({%RenderContext{}=render_context, %Context{}=context}) do
    {
      add_meta_data_to_render_context(render_context, context),
      context
    }
  end

  defp add_meta_data_to_render_context(%RenderContext{}=render_context, %Context{}=context) do
    set_meta_data_index(render_context)
    |> set_meta_data(context)
  end

  defp set_meta_data(%RenderContext{}=render_context, %Context{}=context) do
    %RenderContext{ render_context |
      meta_data: {
        {:obj, render_context.meta_data_index, render_context.generation_number},
        meta_data_dictionary(context)
      }
    }
  end

  defp set_meta_data_index(%RenderContext{}=render_context) do
    render_context = RenderContext.next_index(render_context)
    %RenderContext{ render_context | meta_data_index: render_context.current_index}
  end

  defp meta_data_dictionary(%Context{}=context) do
    {
      :dict,
      %{
        "Title" => {:string, context.meta_data.title},
        "Author" => {:string, context.meta_data.author},
        "Creator" => {:string, context.meta_data.creator},
        "Subject" => {:string, context.meta_data.subject},
        "Producer" => {:string, context.meta_data.producer},
        "Keywords" => {:string, context.meta_data.keywords},
        "CreationDate" => {:date, context.meta_data.creation_date}
      }
    }
  end

end
