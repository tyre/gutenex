Gutenex
=======

## Example

```elixir
pid = Gutenex.Pdf.start_link
Gutenex.Pdf.set_pagesize(pid,:letter)
Gutenex.Pdf.set_page(pid,1)
Gutenex.Pdf.set_dash(pid, [1])
Gutenex.Pdf.set_stroke_gray(pid, 0.5)
Gutenex.Pdf.set_line_width(pid,1)
Gutenex.Pdf.round_rect(pid, {360,705},{210,75}, 5)
Gutenex.Pdf.path(pid, :stroke)
Gutenex.Pdf.set_font(pid,'Helvetica', 10)
Gutenex.Pdf.move_and_show(pid, 100, 100, 'Hello, World!')
Gutenex.Pdf.move_and_show(pid, 100, 200, 'Goodbye, World!')
{serialized, _number_of_pages} = Gutenex.export(pid)
File.write! "bubbles.pdf", serialized
```
