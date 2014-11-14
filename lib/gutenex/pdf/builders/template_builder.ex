defmodule Gutenex.PDF.Builders.TemplateBuilder do
  alias Gutenex.PDF.Context
  alias Gutenex.PDF.RenderContext

  @doc """
  If template(s) were used, build references to them and adds the references
  to the x_object_reference_dictionary
  """
  def build({%RenderContext{}=render_context, %Context{}=context}) do
    {render_context, context}
  end

end
