Gutenex
=======

PDF generation!

What started out as a wrapper for the Erlang [erlguten](https://github.com/ztmr/erlguten) library has turned into a full rewrite in Elixir.

## Plan

The first steps were to wrap erlguten's functions with Elixir counterparts. Next, we [forked erlguten](https://github.com/SenecaSystems/erlguten) to allow for multiple concurrent PDF generations.

Up next is rewriting the basic PDF functionality (text, fonts, images, rendering). That also means documentation, which is currently non-existent. Since this changes the GenServer state to be incompatible with erlguten, the wrapper functions will be removed.

The ultimate dream is to write a DSL using macros to make rendering PDFs fun. Or at least easy. To heighten your excitement for something that doesn't exist, here is kind of what we're thinking about:

```elixir
Gutenex.render do
  image "dunder_mifflin_logo.png", %{ coordinates: {20, 20} }
  text "Dwight, at 8am today, someone poisons the coffee.", %{ coordinates: {80, 150} }
  text "Do not drink the coffee. More instructions will follow.", %{ coordinates: {80, 160} }
  text "Cordially,", %{ coordinates: {80, 190} }
  text "Future Dwight", %{ coordinates: { 85, 200 } }
end
```

Dream on!
