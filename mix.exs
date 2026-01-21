defmodule Website.MixProject do
  use Mix.Project

  def project do
    [
      app: :website,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Website.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1.6", runtime: Mix.env() == :dev},
      {:floki, ">= 0.37.1", only: :test},
      {:phoenix, "~> 1.7.21"},
      {:makeup_elixir, "~> 1.0.1"},
      {:makeup_erlang, "~> 1.0.0"},
      {:nimble_publisher, "~> 0.1.2"},
      {:phoenix_view, "~> 2.0"},
      {:phoenix_live_view, "~> 1.0.1"},
      {:phoenix_live_dashboard, "~> 0.8.7"},
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:xml_builder, "~> 2.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"],
      "assets.deploy": ["esbuild default --minify", "tailwind default --minify", "phx.digest"]
    ]
  end
end
