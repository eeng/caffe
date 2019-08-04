defmodule Caffe.Orders.Projections.Tab do
  use Caffe.Schema
  alias Caffe.Orders.Projections.TabItem

  defmodule Status do
    use Exnumerator, values: ["opened", "closed"]
  end

  schema "tabs" do
    field :table_number, :integer
    field :status, Status, default: "opened"
    field :amount_paid, :decimal
    field :order_amount, :decimal
    field :tip_amount, :decimal
    has_many :items, TabItem
    timestamps()
  end
end
