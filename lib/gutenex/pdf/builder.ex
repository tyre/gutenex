defmodule Gutenex.PDF.Builder do
  alias Gutenex.PDF.Context
#   %% L = [int()] = list of objects representing pages

  def page_tree(%Context{} = context, x_objects) do
    {:dict, [
      {"Type", {:name, "Page"}},
      {"Count", length(context.pages)},
      {"MediaBox", {:array, media_box(context.media_box)}},
      {"Kids", {:array, page_pointers(context.pages)}},
      {"Resources", page_resources(context, x_objects)}
    ]}
  end

  def media_box({top_left, top_right, bottom_left, bottom_right}) do
    [top_left, top_right, bottom_left, bottom_right]
  end

  def page_pointers(pages) do
    Enum.with_index(pages)
    |> Enum.map fn({_page, page_number}) ->
      { :ptr, page_number + 1, 0 }
    end
  end

  def page_resources(context, x_objects) do
    {:dict, [
      {"Font", context.fonts },
      {"XObject", x_objects },
      # TODO: What are procsets? Do I need to add some for images?
      {"ProcSet",
        {:array,
          [
            {:name, "PDF"},
            {:name, "Text"}
          ]
        }
      }
    ]}
  end

#   mk_pages([], _, N, P, O) -> {N, lists:reverse(P), lists:reverse(O)};
# mk_pages([{page,Str}|T], Parent, I, L, E) ->
#     O1 = {{obj,I,0},mkPageContents(Str)},
#     O2 = {{obj,I+1,0},mkPage( Parent, I)},
#     mk_pages(T, Parent, I+2, [I+1|L], [O2,O1|E]);
# mk_pages([{page,Str,Script}|T], Parent, I, L, E) ->
#     O1 = {{obj,I,0},mkPageContents(Str)},
#     O2 = {{obj,I+1,0},mkScript(Script)},
#     O3 = {{obj,I+2,0},mkPage( Parent, I, I+1)},
#     mk_pages(T, Parent, I+3, [I+2|L], [O3,O2,O1|E]).


end
