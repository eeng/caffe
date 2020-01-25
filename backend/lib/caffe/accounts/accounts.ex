defmodule Caffe.Accounts do
  alias Caffe.Repo
  import Caffe.Authorization.Macros, only: [authorize: 2]
  alias Caffe.Accounts.{User, Password}

  def authenticate(email, password) do
    user = Repo.get_by(User, email: email)

    with %{password: digest} <- user,
         true <- Password.valid?(password, digest) do
      {:ok, user}
    else
      _ -> {:error, :invalid_credentials}
    end
  end

  def create_user(params, user) do
    authorize user do
      %User{} |> User.changeset(params) |> Repo.insert()
    end
  end

  def list_users(user) do
    authorize user do
      {:ok, Repo.all(User)}
    end
  end

  def me(user) do
    authorize user do
      get_user(user.id)
    end
  end

  def get_user(id) do
    Repo.fetch(User, id)
  end
end
