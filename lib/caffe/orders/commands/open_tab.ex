defmodule Caffe.Orders.Commands.OpenTab do
  use Caffe.Command

  alias Caffe.Orders.Projections.Tab
  alias Caffe.Repo

  embedded_schema do
    field :tab_id, :binary_id
    field :table_number, :integer
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:tab_id, :table_number])
    |> validate_required([:tab_id, :table_number])
    |> validate_number(:table_number, greater_than_or_equal_to: 0)
    |> validate_not_already_opened()
  end

  defp validate_not_already_opened(changeset) do
    validate_change(changeset, :table_number, fn :table_number, table_number ->
      q = from Tab, where: [table_number: ^table_number, status: "opened"], select: count()

      case Repo.one(q) do
        0 -> []
        _ -> [table_number: "table already has an open tab"]
      end
    end)
  end
end
