defmodule Caffe.Orders.Commands.BeginFoodPreparation do
  use Caffe.Command

  embedded_schema do
    field :tab_id, :binary_id
    field :item_ids, {:array, :integer}
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:tab_id, :item_ids])
    |> validate_required([:tab_id])
    |> validate_length(:item_ids, min: 1)
  end
end
