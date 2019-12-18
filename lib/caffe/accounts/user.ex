defmodule Caffe.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :fullname, :string
    field :username, :string
    field :password, Comeonin.Ecto.Password
    field :role, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :fullname, :role])
    |> validate_required([:username, :password, :fullname, :role])
  end
end
