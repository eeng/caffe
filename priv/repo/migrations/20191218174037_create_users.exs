defmodule Caffe.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :fullname, :string, null: false
      add :password, :string, null: false
      add :role, :string, null: false

      timestamps()
    end
  end
end
