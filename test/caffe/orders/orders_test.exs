defmodule Caffe.OrdersTest do
  use Caffe.EventStoreCase

  alias Caffe.Orders
  alias Caffe.Orders.Projections.{Tab, TabItem}

  setup :open_tab

  test "open tab", %{tab_id: tab_id} do
    assert tab_id
    assert Repo.get(Tab, tab_id).table_number == 3
  end

  test "place order", %{tab_id: tab_id} do
    wine = insert!(:drink, name: "Wine")
    fish = insert!(:food, name: "Fish", price: 40)
    salad = insert!(:food, name: "Salad")

    :ok =
      Orders.place_order(%{
        tab_id: tab_id,
        items: [
          %{menu_item_id: wine.id, quantity: 2},
          %{menu_item_id: fish.id, notes: "ns"},
          %{menu_item_id: salad.id}
        ]
      })

    assert %Tab{items: [%TabItem{} = item1, %TabItem{} = item2, %TabItem{} = item3]} =
             Orders.get_tab(tab_id)

    assert %{menu_item_id: wine.id, menu_item_name: "Wine", quantity: 2, notes: nil} ==
             Map.take(item1, [:menu_item_id, :menu_item_name, :quantity, :notes])

    assert %{menu_item_id: fish.id, price: Decimal.new(40), quantity: 1, notes: "ns"} ==
             Map.take(item2, [:menu_item_id, :price, :quantity, :notes])
  end

  defp open_tab(_context) do
    {:ok, tab_id} = Orders.open_tab(%{table_number: 3})
    %{tab_id: tab_id}
  end
end
