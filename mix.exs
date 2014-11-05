defmodule Gutenex.Mixfile do
  use Mix.Project

  def project do
    [app: :gutenex,
     name: "Gutenex",
     version: "0.0.1-dev",
     source_url: "https://github.com/SenecaSystems/gutenex",
     elixir: "~> 1.0.0",
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:imagineer, github: "SenecaSystems/imagineer" },
      {:apex, "~>0.3.0" },
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.6", only: :dev }
    ]
  end
end
