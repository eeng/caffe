defmodule Caffe.Ordering.Commands.OrderedItem do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder
  @primary_key false

  embedded_schema do
    field :menu_item_id, :integer
    field :menu_item_name, :string
    field :is_drink, :boolean
    field :price, :decimal
    field :quantity, :integer, default: 1
  end

  def changeset(schema, params) do
    schema
    |> cast(params, ~w[menu_item_id menu_item_name is_drink price quantity]a)
    |> validate_required([:menu_item_name, :is_drink])
    |> validate_number(:quantity, greater_than: 0)
  end
end
