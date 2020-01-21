defmodule Caffe.Ordering.Projections.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Caffe.Ordering.Projections.Order

  defmodule State do
    use Exnumerator, values: ["pending", "preparing", "prepared", "served"]
  end

  schema "order_items" do
    belongs_to :order, Order, type: :binary_id
    field :menu_item_id, :integer
    field :menu_item_name, :string
    field :state, State, default: "pending"
    field :price, :decimal
    field :quantity, :integer
  end

  def changeset(item, params) do
    item
    |> cast(params, [:menu_item_id, :menu_item_name, :price, :quantity, :state])
  end
end
