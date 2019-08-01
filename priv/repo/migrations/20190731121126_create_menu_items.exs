defmodule Caffe.Repo.Migrations.CreateMenuItems do
  use Ecto.Migration

  def change do
    create table(:menu_items, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :description, :string
      add :category, :string
      add :price, :decimal
      add :is_drink, :boolean, null: false

      timestamps()
    end

    create index(:menu_items, :name, unique: true)
  end
end
