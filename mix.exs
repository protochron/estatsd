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
    [ {:statistics, "~> 0.2.1"},
     {:timex, "~> 0.13.3"},
     {:exrm, "~> 0.14.16"},
     {:earmark, "~> 0.1.12", only: :dev},
     {:ex_doc, "~> 0.7.0", only: :dev}
    ]
  end

  defp package do
    [contributers: ["Dan Norris"],
     licenses: ["Apache"]
    ]

  end
end
