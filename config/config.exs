# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :caffe,
  ecto_repos: [Caffe.Repo]

# Configures the endpoint
config :caffe, CaffeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hPgXX9IhB3XjcL0m3Wx75/RsQuTLuMDaMIcGE7kIG5/5R5PSWtQeUYeMUsi2WN9N",
  render_errors: [view: CaffeWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Caffe.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: Caffe.Repo

config :vex,
  sources: [Caffe.Commands.Validators, Vex.Validators]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
