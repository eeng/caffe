defmodule Caffe.Repo.Migrations.CreateTabs do
  use Ecto.Migration

  def change do
    create table(:tabs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :table_number, :integer
      timestamps()
    end

    create table(:tab_items, primary_key: false) do
      add :tab_id, references(:tabs, type: :uuid)
      add :menu_item_name, :string
      add :price, :decimal
      # TODO
      add :status, :string
      add :notes, :string
      add :quantity, :integer
      timestamps()
    end
  end
end
