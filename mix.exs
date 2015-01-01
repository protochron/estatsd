defmodule Estatsd.Mixfile do
  use Mix.Project

  def project do
    [app: :estatsd,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps,
     package: package]
  end

  def application do
    [applications: [:logger, :conform],
    mod: {Estatsd, []}]
  end

  defp deps do
    [{:conform, "~> 0.12.0"},
     {:decimal, "~> 1.1.0"}
    ]
  end

  defp package do
    [contributers: ["Dan Norris"],
     licenses: ["Apache"]
    ]

  end
end
