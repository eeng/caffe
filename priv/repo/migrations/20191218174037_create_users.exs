defmodule Caffe.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :name, :string
      add :password, :string, null: false
      add :role, :string, null: false

      timestamps()
    end

    create index(:users, :email, unique: true)
  end
end
