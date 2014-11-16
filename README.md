Gutenex
[![Build Status](https://travis-ci.org/SenecaSystems/gutenex.svg?branch=master)](https://travis-ci.org/SenecaSystems/gutenex)
=======

PDF generation!

What started out as a wrapper for the Erlang [erlguten](https://github.com/ztmr/erlguten) library has turned into a full rewrite in Elixir.

## Plan

Rewriting the basic PDF functionality means:

- [x] text
- [x] fonts
- [x] images
- [x] rendering/exporting
- [ ] templating
- [ ] documentation

# Usage

```elixir
  {:ok, pid} = Gutenex.start_link

  Gutenex.begin_text(pid)
  |> Gutenex.set_font("Helvetica", 48)
  |> Gutenex.text_position(40, 180)
  |> Gutenex.text_render_mode(:fill)
  |> Gutenex.write_text("ABC")
  |> Gutenex.set_font("Courier", 32)
  |> Gutenex.text_render_mode(:stroke)
  |> Gutenex.write_text("xyz")
  |> Gutenex.end_text()
  |> Gutenex.move_to(400, 20)
  |> Gutenex.draw_image("./test/support/images/alpaca.png", %{
    translate_x: 300,
    translate_y: 500,
  })
  |> Gutenex.export("./tmp/alpaca.pdf")
```

Now open up that file and you should see some text near the bottom and a picture
of what I believe to be an alpaca. Could also be a llama.
