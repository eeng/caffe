use Mix.Config

# Configure your database
config :caffe, Caffe.Repo,
  username: "postgres",
  password: "postgres",
  database: "caffe_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :caffe, CaffeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.InMemory

config :commanded, Commanded.EventStore.Adapters.InMemory,
  serializer: Commanded.Serialization.JsonSerializer
