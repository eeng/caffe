defmodule Caffe.Ordering.Commands.PlaceOrder do
  use Caffe.Command

  alias Caffe.Ordering.Commands.OrderedItem

  embedded_schema do
    field :order_id, :binary_id
    field :user_id, :integer
    field :customer_id, :integer
    field :customer_name, :string
    embeds_many :items, OrderedItem
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:order_id, :user_id, :customer_id, :customer_name])
    |> validate_required([:order_id, :user_id])
    |> cast_embed(:items, with: &OrderedItem.changeset/2, required: true)
  end
end
