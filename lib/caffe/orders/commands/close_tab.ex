defmodule Caffe.Orders.Commands.CloseTab do
  use Caffe.Command

  embedded_schema do
    field :tab_id, :binary_id
    field :amount_paid, :decimal
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:tab_id, :amount_paid])
    |> validate_required([:tab_id, :amount_paid])
    |> validate_number(:amount_paid, greater_than_or_equal_to: 0)
  end
end
