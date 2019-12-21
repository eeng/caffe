defmodule Caffe.Ordering.Commands.MarkFoodPrepared do
  use Caffe.Command

  embedded_schema do
    field :order_id, :binary_id
    field :item_ids, {:array, :integer}
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:order_id, :item_ids])
    |> validate_required([:order_id])
    |> validate_length(:item_ids, min: 1)
  end
end
