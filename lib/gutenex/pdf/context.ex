defmodule Gutenex.PDF.Context do
  alias Gutenex.PDF.Page
  defstruct(
    info: %{
      creator: "Elixir",
      creation_date: :calendar.local_time(),
      producer: "Gutenex",
      author: "",
      title: "",
      subject: "",
      keywords: ""
    },
    images: [],
    fonts: [],
    pages: [],
    scripts: [],
    convert_mode: "utf8_to_latin2",
    current_page: 1,
    media_box: Page.page_size(:letter))
end
