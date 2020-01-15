defmodule Caffe.MixProject do
  use Mix.Project

  def project do
    [
      app: :caffe,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
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
      mod: {Caffe.Application, []},
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
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:cors_plug, "~> 1.5"},
      {:commanded, "~> 0.19"},
      {:commanded_eventstore_adapter, "~> 0.6", runtime: Mix.env() != :test},
      {:commanded_ecto_projections, "~> 0.8"},
      {:exnumerator, "~> 1.6"},
      {:absinthe_plug, "~> 1.4"},
      {:absinthe_phoenix, "~> 1.4.0"},
      {:dataloader, "~> 1.0.0"},
      {:argon2_elixir, "~> 2.0"},
      {:arc_ecto, "~> 0.11.3"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "event_store.setup": ["event_store.create", "event_store.init"],
      "event_store.reset": ["event_store.drop", "event_store.setup"],
      "db.setup": ["event_store.setup", "ecto.setup"],
      "db.reset": ["event_store.reset", "ecto.reset"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
