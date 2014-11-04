defmodule Gutenex.PDF.Builders.MetaDataBuilder do
  alias Gutenex.PDF.Context

  def build(%Context{}=context, meta_data_index) when is_integer(meta_data_index) do
    {{:obj, meta_data_index, context.generation_number},
                  build_meta_data(context)}
  end

  defp build_meta_data(%Context{} = context) do
    {:dict, %{
      "Title" => {:string, context.meta_data.title},
      "Author" => {:string, context.meta_data.author},
      "Creator" => {:string, context.meta_data.creator},
      "Subject" => {:string, context.meta_data.subject},
      "Producer" => {:string, context.meta_data.producer},
      "Keywords" => {:string, context.meta_data.keywords},
      "CreationDate" => {:date, context.meta_data.creation_date}
    }}
  end

end
