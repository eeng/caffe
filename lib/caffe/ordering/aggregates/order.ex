defmodule Caffe.Ordering.Aggregates.Order do
  defstruct [:id, items: []]

  alias Caffe.Ordering.Aggregates.Order
  alias Caffe.Ordering.Commands.{PlaceOrder}
  alias Caffe.Ordering.Events.{OrderPlaced}

  def execute(%Order{id: nil}, %PlaceOrder{} = command) do
    command
    |> Map.from_struct()
    |> update_in([:items, Access.all()], &map_to_event_item/1)
    |> OrderPlaced.new()
    |> calculate_order_amount()
  end

  def execute(_, %PlaceOrder{}), do: {:error, :order_already_placed}

  def apply(%Order{}, %OrderPlaced{order_id: id, items: items}) do
    %Order{id: id, items: items}
  end

  defp map_to_event_item(item) do
    item
    |> Map.take([:menu_item_id, :menu_item_name, :price, :quantity])
    |> Map.put(:status, "pending")
  end

  defp calculate_order_amount(%{items: items} = command) do
    total =
      items
      |> Enum.reduce(Decimal.new(0), fn item, acc ->
        Decimal.add(acc, Decimal.mult(item.price, item.quantity))
      end)

    %{command | order_amount: total}
  end
end
