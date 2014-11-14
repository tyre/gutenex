defmodule Gutenex.PDF.Templates do
  def template_alias(template_path) do
    :crypto.hash :md5, template_path
  end
end
