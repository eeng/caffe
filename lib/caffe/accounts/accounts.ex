defmodule Caffe.Accounts do
  @moduledoc """
  The Accounts bounded context
  """

  alias Caffe.Repo
  alias Caffe.Accounts.{User, Password}

  def create_user(attrs) do
    %User{} |> User.changeset(attrs) |> Repo.insert()
  end

  def authenticate(username, password) do
    user = Repo.get_by(User, username: username)

    with %{password: digest} <- user,
         true <- Password.valid?(password, digest) do
      {:ok, user}
    else
      _ -> {:error, :invalid_credentials}
    end
  end
end
