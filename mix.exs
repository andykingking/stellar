defmodule Stellar.Mixfile do
  use Mix.Project

  def project do
    [
      app: :stellar,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      escript: [main_module: Stellar],
      deps: deps(),
      preferred_cli_env: [
        "credo": :test,
        "lint": :test
      ],
      aliases: [
        "lint": ["credo --strict"],
        "test": ["lint", "test"]
      ],

      # Docs
      name: "Stellar",
      source_url: "https://github.com/andykingking/stellar",
      docs: [
        main: "Stellar",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      applications: [
        :logger,
        :httpoison
      ]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.9.0"},
      {:poison, "~> 3.0"},
      {:mogrify, "~> 0.4.0"},

      {:ex_doc, "~> 0.14", only: :dev},
      {:credo, "~> 0.4", only: [:dev, :test]}
    ]
  end
end
