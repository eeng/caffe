defmodule CaffeWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :caffe
  use Absinthe.Phoenix.Endpoint

  socket "/socket", CaffeWeb.UserSocket,
    websocket: true,
    longpoll: false

  plug CORSPlug

  # Serve at "/uploads" the arc files from "priv/uploads" directory
  plug Plug.Static,
    at: "/uploads",
    from: "priv/uploads",
    gzip: false

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
