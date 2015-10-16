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
    [ {:statistics, "~> 0.3.1"},
     {:timex, "~> 1.0.0-rc1"},
     {:exrm, "~> 0.19.9"},
     {:earmark, "~> 0.1.17"},
     {:ex_doc, "~> 0.7.0", only: :dev}
    ]
  end

  defp package do
    [contributers: ["Dan Norris"],
     licenses: ["Apache"]
    ]

  end
end
