defmodule Caffe.Orders.Aggregates.Tab do
  defstruct [:id, :table_number, open: true, items: []]

  use Caffe.Orders.Aliases

  def execute(%Tab{id: nil}, %OpenTab{} = command) do
    struct(TabOpened, Map.from_struct(command))
  end

  def execute(%Tab{}, %OpenTab{}), do: {:error, :tab_already_opened}

  def execute(%Tab{id: nil}, %PlaceOrder{}), do: {:error, :tab_not_opened}

  def execute(%Tab{id: id}, %PlaceOrder{tab_id: id, items: items}) do
    items
    |> Enum.group_by(fn item -> item.is_drink end)
    |> Enum.reverse()
    |> Enum.map(fn
      {true, items} -> %DrinksOrdered{tab_id: id, items: items}
      {false, items} -> %FoodOrdered{tab_id: id, items: items}
    end)
  end

  def execute(%Tab{id: tab_id} = tab, %MarkItemsServed{tab_id: tab_id} = cmd) do
    execute_validating_multiple_items(
      tab,
      cmd.item_ids,
      &validate_mark_item_served/1,
      ItemsServed
    )
  end

  def execute(%Tab{id: tab_id} = tab, %BeginFoodPreparation{tab_id: tab_id} = cmd) do
    execute_validating_multiple_items(
      tab,
      cmd.item_ids,
      &validate_begin_food_preparation/1,
      FoodBeingPrepared
    )
  end

  def execute(%Tab{id: tab_id} = tab, %MarkFoodPrepared{tab_id: tab_id} = cmd) do
    execute_validating_multiple_items(
      tab,
      cmd.item_ids,
      &validate_mark_food_prepared/1,
      FoodPrepared
    )
  end

  def execute(%Tab{id: tab_id, open: true} = tab, %CloseTab{tab_id: tab_id} = cmd) do
    served_value = calculate_served_value(tab)

    cond do
      Decimal.equal?(served_value, 0) ->
        {:error, :nothing_to_pay}

      Decimal.cmp(cmd.amount_paid, served_value) == :lt ->
        {:error, :must_pay_enough}

      true ->
        %TabClosed{
          tab_id: tab_id,
          amount_paid: cmd.amount_paid,
          order_amount: served_value,
          tip_amount: Decimal.sub(cmd.amount_paid, served_value)
        }
    end
  end

  def execute(%Tab{open: false}, %CloseTab{}), do: {:error, :already_closed}

  def apply(%Tab{}, %TabOpened{tab_id: id}) do
    %Tab{id: id}
  end

  def apply(%Tab{id: id} = tab, %DrinksOrdered{tab_id: id} = evt) do
    %{tab | items: tab.items ++ evt.items}
  end

  def apply(%Tab{id: id} = tab, %FoodOrdered{tab_id: id} = evt) do
    %{tab | items: tab.items ++ evt.items}
  end

  def apply(%Tab{id: id} = tab, %ItemsServed{tab_id: id, item_ids: item_ids}) do
    update_in(tab.items, &set_items_status(&1, item_ids, "served"))
  end

  def apply(%Tab{id: id} = tab, %FoodBeingPrepared{tab_id: id, item_ids: item_ids}) do
    update_in(tab.items, &set_items_status(&1, item_ids, "preparing"))
  end

  def apply(%Tab{id: id} = tab, %FoodPrepared{tab_id: id, item_ids: item_ids}) do
    update_in(tab.items, &set_items_status(&1, item_ids, "prepared"))
  end

  def apply(%Tab{id: id} = tab, %TabClosed{tab_id: id}) do
    put_in(tab.open, false)
  end

  defp find_item_by_id(id, items) do
    Enum.find(items, &(&1.menu_item_id == id))
  end

  defp execute_validating_multiple_items(tab, item_ids, validation_fn, event_module) do
    errors =
      item_ids
      |> Enum.map(&find_item_by_id(&1, tab.items))
      |> Enum.map(validation_fn)
      |> Enum.reject(&(&1 == :ok))

    case errors do
      [] -> struct(event_module, %{tab_id: tab.id, item_ids: item_ids})
      [error | _] -> error
    end
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
      %{is_drink: false, status: "preparing"} -> :ok
      %{is_drink: false, status: "pending"} -> {:error, :must_begin_preparation_beforehand}
      %{is_drink: false} -> {:error, :item_already_prepared}
      nil -> {:error, :item_not_ordered}
    end
  end

  defp set_items_status(all_items, ids_to_update, status) do
    Enum.map(all_items, fn item ->
      if Enum.member?(ids_to_update, item.menu_item_id) do
        put_in(item.status, status)
      else
        item
      end
    end)
  end

  defp calculate_served_value(%Tab{items: items}) do
    items
    |> Enum.filter(&(&1.status == "served"))
    |> Enum.map(& &1.price)
    |> Enum.reduce(Decimal.new(0), &Decimal.add/2)
  end
end
