defmodule Caffe.Ordering.Projections.Item do
  use Caffe.Schema
  import Ecto.Changeset
  alias Caffe.Ordering.Projections.Order

  defmodule Status do
    use Exnumerator, values: ["pending", "preparing", "prepared", "served"]
  end

  @primary_key false

  schema "order_items" do
    belongs_to :order, Order
    field :menu_item_id, :integer
    field :menu_item_name, :string
    field :status, Status, default: "pending"
    field :price, :decimal
    field :quantity, :integer
  end

  def changeset(item, params) do
    item
    |> cast(params, [:menu_item_id, :menu_item_name, :price, :quantity, :status])
  end
end
