defmodule Caffe.Ordering.Commands.MarkItemsServed do
  use Caffe.Command

  embedded_schema do
    field :order_id, :binary_id
    field :user_id, :integer
    field :item_ids, {:array, :integer}
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:order_id, :item_ids, :user_id])
    |> validate_required([:order_id, :user_id])
    |> validate_length(:item_ids, min: 1)
  end
end
