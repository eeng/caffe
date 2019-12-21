defmodule Caffe.Ordering.Commands.PayOrder do
  use Caffe.Command

  embedded_schema do
    field :order_id, :binary_id
    field :amount_paid, :decimal
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:order_id, :amount_paid])
    |> validate_required([:order_id, :amount_paid])
    |> validate_number(:amount_paid, greater_than_or_equal_to: 0)
  end
end
