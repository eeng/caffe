import Config

config :caffe, Caffe.Repo,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE", "10"))

config :caffe, CaffeWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT", "4000"))],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

config :caffe, Caffe.EventStore, url: System.fetch_env!("EVENTSTORE_DATABASE_URL")
