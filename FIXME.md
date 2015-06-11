# Generating PDFs

## Context Cleanup
Don't include every basic font object by default, only as used
```elixir
%Context{used_fonts: HashSet.new()}
```

# Parsing PDFs

## Deserialization Detergenting

Use named captures in regexes to get rid of all of these:
```elixir
[matched_string, what, i, want, _comment] = Regex.run @match, raw_string
```
