defmodule Caffe.Ordering.Aggregates.Order do
  defstruct [:id, items: [], status: "pending", total_amount: 0]

  alias Caffe.Ordering.Aggregates.Order

  alias Caffe.Ordering.Commands.{
    PlaceOrder,
    BeginFoodPreparation,
    MarkFoodPrepared,
    MarkItemsServed,
    PayOrder
  }

  alias Caffe.Ordering.Events.{
    OrderPlaced,
    FoodBeingPrepared,
    FoodPrepared,
    ItemsServed,
    OrderPaid
  }

  def execute(%Order{id: nil}, %PlaceOrder{} = command) do
    command
    |> Map.from_struct()
    |> update_in([:items, Access.all()], &map_to_event_item/1)
    |> OrderPlaced.new()
    |> calculate_order_amount()
  end

  def execute(_, %PlaceOrder{}), do: {:error, :order_already_placed}

  def execute(%Order{id: order_id} = order, %MarkItemsServed{order_id: order_id} = cmd) do
    execute_validating_multiple_items(
      order,
      cmd.item_ids,
      &validate_mark_item_served/1,
      ItemsServed
    )
  end

  def execute(%Order{id: order_id} = order, %BeginFoodPreparation{order_id: order_id} = cmd) do
    execute_validating_multiple_items(
      order,
      cmd.item_ids,
      &validate_begin_food_preparation/1,
      FoodBeingPrepared
    )
  end

  def execute(%Order{id: order_id} = order, %MarkFoodPrepared{order_id: order_id} = cmd) do
    execute_validating_multiple_items(
      order,
      cmd.item_ids,
      &validate_mark_food_prepared/1,
      FoodPrepared
    )
  end

  def execute(
        %Order{id: order_id, status: status, total_amount: order_amount},
        %PayOrder{order_id: order_id, amount_paid: amount_paid}
      )
      when status != "closed" do
    cond do
      Decimal.cmp(amount_paid, order_amount) == :lt ->
        {:error, :must_pay_enough}

      true ->
        %OrderPaid{
          order_id: order_id,
          amount_paid: amount_paid,
          order_amount: order_amount,
          tip_amount: Decimal.sub(amount_paid, order_amount)
        }
    end
  end

  def execute(%Order{status: "closed"}, _), do: {:error, :order_closed}

  defp execute_validating_multiple_items(order, item_ids, validation_fn, event_module) do
    errors =
      item_ids
      |> Enum.map(&find_item_by_id(&1, order.items))
      |> Enum.map(validation_fn)
      |> Enum.reject(&(&1 == :ok))

    case errors do
      [] -> struct(event_module, %{order_id: order.id, item_ids: item_ids})
      [error | _] -> error
    end
  end

  defp find_item_by_id(id, items) do
    Enum.find(items, &(&1.menu_item_id == id))
  end

  defp validate_mark_item_served(item) do
    case item do
      %{is_drink: true, status: "pending"} -> :ok
      %{is_drink: false, status: "prepared"} -> :ok
      %{status: "served"} -> {:error, :item_already_served}
      %{is_drink: false} -> {:error, :food_must_be_prepared}
      nil -> {:error, :item_not_ordered}
    end
  end

  defp validate_begin_food_preparation(item) do
    case item do
      %{is_drink: true} -> {:error, :drinks_dont_need_preparation}
      %{is_drink: false, status: "pending"} -> :ok
      %{is_drink: false} -> {:error, :item_already_prepared}
      nil -> {:error, :item_not_ordered}
    end
  end

  defp validate_mark_food_prepared(item) do
    case item do
      %{is_drink: true} -> {:error, :drinks_dont_need_preparation}
      %{is_drink: false, status: "pending"} -> :ok
      %{is_drink: false, status: "preparing"} -> :ok
      %{is_drink: false} -> {:error, :item_already_prepared}
      nil -> {:error, :item_not_ordered}
    end
  end

  defp map_to_event_item(item) do
    item
    |> Map.from_struct()
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

  def apply(%Order{}, %OrderPlaced{order_id: id, items: items, order_amount: order_amount}) do
    %Order{id: id, items: items, total_amount: order_amount}
  end

  def apply(%Order{id: id} = order, %FoodBeingPrepared{order_id: id, item_ids: item_ids}) do
    set_items_status(order, item_ids, "preparing")
  end

  def apply(%Order{id: id} = order, %FoodPrepared{order_id: id, item_ids: item_ids}) do
    set_items_status(order, item_ids, "prepared")
  end

  def apply(%Order{id: id} = order, %ItemsServed{order_id: id, item_ids: item_ids}) do
    set_items_status(order, item_ids, "served")
  end

  def apply(%Order{id: id} = order, %OrderPaid{order_id: id}) do
    put_in(order.status, "closed")
  end

  defp set_items_status(order, ids_to_update, status) do
    should_change? = fn item -> Enum.member?(ids_to_update, item.menu_item_id) end

    put_in(
      order,
      [Access.key(:items), Access.filter(should_change?), Access.key(:status)],
      status
    )
  end
end
