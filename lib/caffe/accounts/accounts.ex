defmodule Caffe.Accounts do
  @moduledoc """
  The Accounts bounded context
  """

  alias Caffe.Repo
  alias Caffe.Accounts.{User, Password}

  def create_user(attrs) do
    %User{} |> User.changeset(attrs) |> Repo.insert()
  end

  def get_user(id) do
    Repo.fetch(User, id)
  end

  def list_users do
    Repo.all(User)
  end

  def authenticate(email, password) do
    user = Repo.get_by(User, email: email)

    with %{password: digest} <- user,
         true <- Password.valid?(password, digest) do
      {:ok, user}
    else
      _ -> {:error, :invalid_credentials}
    end
  end
end
