defmodule Caffe.Ordering.Projections.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Caffe.Ordering.Projections.Item
  alias Caffe.Accounts.User

  defmodule Status do
    use Exnumerator, values: ["pending", "paid"]
  end

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "orders" do
    belongs_to :customer, User
    field :customer_name, :string
    field :status, Status, default: "pending"
    field :amount_paid, :decimal, default: 0
    field :order_amount, :decimal, default: 0
    field :tip_amount, :decimal, default: 0
    field :notes, :string
    has_many :items, Item
    timestamps()
  end

  def changeset(order, params) do
    order
    |> cast(params, [
      :customer_id,
      :customer_name,
      :status,
      :amount_paid,
      :order_amount,
      :tip_amount,
      :notes
    ])
    |> cast_assoc(:items, with: &Item.changeset/2)
  end
end
