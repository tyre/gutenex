Gutenex
=======

PDF generation!

What started out as a wrapper for the Erlang [erlguten](https://github.com/ztmr/erlguten) library has turned into a full rewrite in Elixir.

## Plan

The first steps were to wrap erlguten's functions with Elixir counterparts. Next, we [forked erlguten](https://github.com/SenecaSystems/erlguten) to allow for multiple concurrent PDF generations.

Up next is rewriting the basic PDF functionality (text, fonts, images, rendering). That also means documentation, which is currently non-existent. Since this changes the GenServer state to be incompatible with erlguten, the wrapper functions will be removed.

# Currant Usage

```elixir
{:ok, pid} = Gutenex.start_link
Gutenex.begin_text(pid)
  |> Gutenex.set_font("Helvetica", 48)
  |> Gutenex.text_position(20, 40)
  |> Gutenex.text_render_mode(:fill)
  |> Gutenex.write_text("ABC")
  |> Gutenex.set_font("Courier", 32)
  |> Gutenex.text_render_mode(:stroke)
  |> Gutenex.write_text("xyz")
  |> Gutenex.end_text()
  |> Gutenex.export("./tmp/alpaca.pdf")
```

Now open up that file and you should see some text near the bottom. Hurray!
