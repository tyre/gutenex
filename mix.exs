defmodule Gutenex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :gutenex,
      name: "Gutenex",
      version: "0.2.0",
      source_url: "https://github.com/SenecaSystems/gutenex",
      elixir: "~> 1.0",
      deps: deps(),
      description: description(),
      package: package()
   ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:imagineer, "~> 0.3" },
      {:ex_doc, "~> 0.19", only: :dev },
      {:apex, "~>1.0"}
    ]
  end

  defp description do
    """
    PDF Generation in Elixir
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{github: "https://github.com/SenecaSystems/gutenex"},
      contributors: ["Chris Maddox"]
    ]
  end
end
