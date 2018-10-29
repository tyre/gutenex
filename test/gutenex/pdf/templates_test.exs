defmodule Gutenex.PDF.TemplatesTest do
  use ExUnit.Case, async: true
  alias Gutenex.PDF.Templates

  test "#load" do
    contents = File.read!("./test/support/templates/cucumber_salads.pdf")
    template_alias = Templates.template_alias("./test/support/templates/cucumber_salads.pdf")

    assert {template_alias, contents} ==
             Templates.load("./test/support/templates/cucumber_salads.pdf")
  end
end
