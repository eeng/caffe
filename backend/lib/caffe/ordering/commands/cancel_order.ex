defmodule Caffe.Ordering.Commands.CancelOrder do
  use Caffe.Command

  embedded_schema do
    field :order_id, :binary_id
    field :user_id, :integer
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:order_id, :user_id])
    |> validate_required([:order_id, :user_id])
  end
end
