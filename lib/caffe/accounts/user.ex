defmodule Caffe.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Caffe.Accounts.Password

  schema "users" do
    field :fullname, :string
    field :username, :string
    field :password, :string
    field :role, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :fullname, :role])
    |> validate_required([:username, :password, :fullname, :role])
    |> validate_inclusion(:role, roles())
    |> unique_constraint(:username)
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    update_change(changeset, :password, &Password.hash/1)
  end

  def roles do
    ~w[admin chef waitstaff customer]
  end
end
