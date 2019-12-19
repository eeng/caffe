defmodule Caffe.Orders.Commands.PlaceOrder do
  use Caffe.Command

  alias Caffe.Orders.Commands.OrderedItem

  embedded_schema do
    field :tab_id, :binary_id
    embeds_many :items, OrderedItem
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:tab_id])
    |> validate_required([:tab_id])
    |> cast_embed(:items, with: &OrderedItem.changeset/2, required: true)
  end
end
