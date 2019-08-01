defmodule Caffe.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :position, :integer, null: false
      timestamps()
    end

    create index(:categories, :name, unique: true)

    create table(:menu_items) do
      add :name, :string, null: false
      add :description, :string
      add :category_id, references(:categories)
      add :price, :decimal, null: false
      add :is_drink, :boolean, null: false
      timestamps()
    end

    create index(:menu_items, :name, unique: true)
  end
end
