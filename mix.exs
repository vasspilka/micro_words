defmodule MicroWords.MixProject do
  use Mix.Project

  def project do
    [
      app: :micro_words,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      releases: [microwords: [strip_beams: false]],
      deps: deps()
    ]
  end

  # Configuration for the OTP application.right
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MicroWords.Application, []},
      extra_applications: [:crypto, :logger, :runtime_tools, :os_mon]
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
      {:commanded, "~> 1.4.0"},
      {:commanded_eventstore_adapter, "~> 1.4.0"},
      {:ecto_sql, "~> 3.4"},
      {:eventstore, "~> 1.4.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.6"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:phoenix_live_view, "~> 0.17.0"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:typed_struct, "~> 0.2.1"},
      {:esbuild, "~> 0.2", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:credo, "~> 1.3", only: [:dev, :test], runtime: false},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:faker, "~> 0.16", only: [:test, :dev]},
      {:floki, ">= 0.0.0", only: :test}
      # Possibly usefull
      # {:norm, "~> 0.12"},
      # {:stream_data, "~> 0.4"},
      # {:edantic, "~> 0.1.0"},
      # {:commanded_ecto_projections, "~> 1.2.0"},
      # If it will be chosen to store action sideeffect actions in the action itself as a function
      # {:safeish, "~> 0.5.0"},
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
      setup: ["deps.get", "ecto.setup", "cmd --cd assets npm install"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      "assets.deploy": [
        "cmd --cd assets npm run deploy",
        "esbuild default --minify",
        "phx.digest"
      ]
    ]
  end
end
