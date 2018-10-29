defmodule Gutenex.PDF.Utils do
  # Base case, escaping the empty string is the empty string
  def escape(<<>>) do
    <<>>
  end

  # escape left parenthesis
  def escape(<<"(", rest::binary>>) do
    "\\(" <> escape(rest)
  end

  # escape right parenthesis
  def escape(<<")", rest::binary>>) do
    "\\)" <> escape(rest)
  end

  # escape backslash
  def escape(<<"\\", rest::binary>>) do
    "\\\\" <> escape(rest)
  end

  # Head doesn't need escaping, escape the rest
  def escape(<<first_byte::binary-size(1), rest::binary>>) do
    first_byte <> escape(rest)
  end
end
