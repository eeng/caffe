defmodule Caffe.Repo do
  use Ecto.Repo,
    otp_app: :caffe,
    adapter: Ecto.Adapters.Postgres

  defoverridable get: 2, get: 3

  def get(query, id, opts \\ []) do
    super(query, id, opts)
  rescue
    Ecto.Query.CastError -> nil
  end

  def fetch(queryable, id) do
    case get(queryable, id) do
      nil -> {:error, :not_found}
      record -> {:ok, record}
    end
  end
end
