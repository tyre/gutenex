Gutenex
=======

PDF generation!

What started out as a wrapper for the Erlang [erlguten](https://github.com/ztmr/erlguten) library has turned into a full rewrite in Elixir.

## Plan

The first steps were to wrap erlguten's functions with Elixir counterparts. Next, we [forked erlguten](https://github.com/SenecaSystems/erlguten) to allow for multiple concurrent PDF generations.

Up next is rewriting the basic PDF functionality (text, fonts, images, rendering). That also means documentation, which is currently non-existent. Since this changes the GenServer state to be incompatible with erlguten, the wrapper functions will be removed.

# Currant Usage

```elixir


```
