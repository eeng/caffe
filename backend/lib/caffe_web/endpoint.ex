defmodule CaffeWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :caffe
  use Absinthe.Phoenix.Endpoint

  socket "/socket", CaffeWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug CORSPlug

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :caffe,
    gzip: false,
    only: ~w(css fonts images js uploads favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_caffe_key",
    signing_salt: "Pr8XlJ+Q"

  plug CaffeWeb.Router
end
