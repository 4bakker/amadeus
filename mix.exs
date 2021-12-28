defmodule Amadeus.MixProject do
  use Mix.Project

  def project do
    [
      app: :amadeus,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, git: "https://github.com/4bakker/req.git"},
      {:finch, "~> 0.9.1", override: true},
      {:exvcr, "~> 0.13.2", only: [:test, :dev]}
    ]
  end
end
