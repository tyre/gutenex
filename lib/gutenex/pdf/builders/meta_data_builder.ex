defmodule Gutenex.PDF.Builders.MetaDataBuilder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext

  @doc """
  Given a PDF Context and index, generate the metadata information dictionary
  """
  def build({%RenderContext{} = render_context, %Context{} = context}) do
    {
      add_meta_data_to_render_context(render_context, context),
      context
    }
  end

  defp add_meta_data_to_render_context(%RenderContext{} = render_context, %Context{} = context) do
    set_meta_data_reference(render_context)
    |> set_meta_data(context)
  end

  defp set_meta_data(%RenderContext{} = render_context, %Context{} = context) do
    %RenderContext{
      RenderContext.next_index(render_context)
      | meta_data: {
          RenderContext.current_object(render_context),
          meta_data_dictionary(context)
        }
    }
  end

  defp set_meta_data_reference(%RenderContext{} = render_context) do
    %RenderContext{
      render_context
      | meta_data_reference: RenderContext.current_reference(render_context)
    }
  end

  defp meta_data_dictionary(%Context{} = context) do
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
