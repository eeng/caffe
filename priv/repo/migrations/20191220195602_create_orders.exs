defmodule Caffe.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :customer_id, references(:users)
      add :customer_name, :string
      add :status, :string
      add :amount_paid, :decimal
      add :order_amount, :decimal
      add :tip_amount, :decimal
      timestamps()
    end

    create table(:order_items, primary_key: false) do
      add :order_id, references(:orders, type: :uuid)
      add :menu_item_id, :integer
      add :menu_item_name, :string
      add :price, :decimal
      add :status, :string
      add :notes, :string
      add :quantity, :integer
      timestamps()
    end
  end
end
