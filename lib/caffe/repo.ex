defmodule Caffe.Repo do
  use Ecto.Repo,
    otp_app: :caffe,
    adapter: Ecto.Adapters.Postgres
end
