1. Don't include every basic font object by default, only as used 
```elixir
%Context{used_fonts: HashSet.new()}
```
2. Add more natural text output syntax. Instead of
```elixir
{:ok, pid} = Gutenex.start_link
Gutenex.begin_text(pid)
  |> Gutenex.set_font("Helvetica", 48)
  |> Gutenex.text_position(40, 180)
  |> Gutenex.text_render_mode(:fill)
  |> Gutenex.write_text("Screen Images Simulated")
  |> Gutenex.end_text
```
How about:
```elixir
{:ok, pid} = Gutenex.start_link
Gutenex.text(pid) do
  import Gutenex
  set_font("Helvetica", 48)
  text_position(40, 180)
  text_render_mode(:fill)
  write_text("Screen Images Simulated")
end
```
Or maybe a function:
```elixir
{:ok, pid} = Gutenex.start_link
text_options = %{position: {40, 180}, font: {"Helvetica", 48}, render_mode: :fill}
Gutenex.text(pid, text_options, fn ->
  Gutenex.write_text(pid, "Screen Images Simulated")
end)
```
Who knows!
