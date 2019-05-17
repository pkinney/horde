defmodule Routing.MixProject do
  use Mix.Project

  def project do
    [
      app: :routing,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Routing, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:horde, path: "../.."},
      {:libcluster, "~> 3.0.3"},
      {:uuid, "~> 1.1"}
    ]
  end
end
