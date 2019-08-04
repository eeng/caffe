defmodule Caffe.Orders.Aggregates.Tab do
  defstruct [:id, :table_number, items: []]

  use Caffe.Orders.Aliases

  def execute(%Tab{id: nil}, %OpenTab{} = command) do
    struct(TabOpened, Map.from_struct(command))
  end

  def execute(%Tab{}, %OpenTab{}), do: {:error, :tab_already_opened}

  def execute(%Tab{id: nil}, %PlaceOrder{}), do: {:error, :tab_not_opened}

  def execute(%Tab{id: id}, %PlaceOrder{tab_id: id, items: []}),
    do: {:error, :must_order_something}

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
    errors =
      cmd.item_ids
      |> Enum.map(&find_item_by_id(&1, tab.items))
      |> Enum.map(&attempt_serve/1)
      |> Enum.reject(&(&1 == :ok))

    case errors do
      [] -> %ItemsServed{tab_id: tab_id, item_ids: cmd.item_ids}
      [error | _] -> error
    end
  end

  defp find_item_by_id(id, items) do
    Enum.find(items, &(&1.menu_item_id == id))
  end

  defp attempt_serve(%{is_drink: true, status: "pending"}), do: :ok
  defp attempt_serve(%{is_drink: false, status: "prepared"}), do: :ok
  defp attempt_serve(%{is_drink: false, status: "pending"}), do: {:error, :food_must_be_prepared}
  defp attempt_serve(nil), do: {:error, :item_not_ordered}
  defp attempt_serve(_), do: {:error, :item_already_served}

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
    update_in(tab.items, fn items ->
      Enum.map(items, fn item ->
        if Enum.member?(item_ids, item.menu_item_id) do
          put_in(item.status, "served")
        else
          item
        end
      end)
    end)
  end
end
