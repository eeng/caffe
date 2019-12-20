defmodule Caffe.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Caffe.Accounts.Password

  defmodule Role do
    use Exnumerator, values: ~w[admin chef waitstaff customer]
  end

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :role, Role

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :name, :role])
    |> validate_required([:email, :password, :name, :role])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/)
    |> unique_constraint(:email)
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    update_change(changeset, :password, &Password.hash/1)
  end
end
