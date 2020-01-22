defmodule Caffe.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :order_date, :utc_datetime
      add :customer_id, references(:users)
      add :customer_name, :string
      add :state, :string
      add :amount_paid, :decimal, null: false
      add :order_amount, :decimal, null: false
      add :tip_amount, :decimal, null: false
      add :notes, :string
      timestamps()
    end

    create index(:orders, [:order_date, :state])
    create index(:orders, :state)

    create table(:order_items) do
      add :order_id, references(:orders, type: :uuid)
      add :menu_item_id, :integer
      add :menu_item_name, :string
      add :is_drink, :boolean, null: false
      add :price, :decimal
      add :state, :string
      add :quantity, :integer
    end
  end
end
