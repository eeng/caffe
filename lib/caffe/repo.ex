defmodule Caffe.Repo do
  use Ecto.Repo,
    otp_app: :caffe,
    adapter: Ecto.Adapters.Postgres

  def fetch(queryable, id) do
    case get(queryable, id) do
      nil -> {:error, :not_found}
      record -> {:ok, record}
    end
  end
end
