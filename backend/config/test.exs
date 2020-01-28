use Mix.Config

# Configure your database
config :caffe, Caffe.Repo,
  url: System.get_env("DATABASE_URL", "ecto://postgres:postgres@localhost/caffe_test"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :caffe, CaffeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :caffe, Caffe.Commanded.Application,
  event_store: [
    adapter: Commanded.EventStore.Adapters.InMemory,
    event_store: Caffe.EventStore
  ],
  pubsub: :local,
  registry: :local

config :caffe, Caffe.EventStore, serializer: Commanded.Serialization.JsonSerializer

# Otherwise there were some random background errors in tests where the projector
# would try to access the connection after the test had finished.
config :commanded, default_consistency: :strong

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
