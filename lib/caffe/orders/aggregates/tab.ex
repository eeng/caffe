defmodule Caffe.Orders.Aggregates.Tab do
  defstruct [:id, :table_number, outstanding_items: []]

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

  def execute(
        %Tab{id: tab_id, outstanding_items: outstanding_items},
        %MarkDrinkServed{tab_id: tab_id, item_ids: item_ids}
      ) do
    if Enum.all?(item_ids, &(&1 in outstanding_items)) do
      %DrinksServed{tab_id: tab_id, item_ids: item_ids}
    else
      {:error, :drinks_not_outstanding}
    end
  end

  def apply(%Tab{}, %TabOpened{tab_id: id}) do
    %Tab{id: id}
  end

  def apply(
        %Tab{id: id, outstanding_items: outstanding_items} = tab,
        %DrinksOrdered{tab_id: id, items: items}
      ) do
    %{tab | outstanding_items: outstanding_items ++ Enum.map(items, & &1.menu_item_id)}
  end

  def apply(%Tab{id: id} = tab, %FoodOrdered{tab_id: id}) do
    tab
  end

  def apply(
        %Tab{id: id, outstanding_items: outstanding_items} = tab,
        %DrinksServed{tab_id: id, item_ids: item_ids}
      ) do
    %{tab | outstanding_items: Enum.reject(outstanding_items, &(&1 in item_ids))}
  end
end
