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
    wine = insert!(:drink, name: "Wine", price: 30)
    fish = insert!(:food, name: "Fish", price: 40)

    :ok =
      Orders.place_order(%{
        tab_id: tab_id,
        items: [
          %{menu_item_id: wine.id, quantity: 2},
          %{menu_item_id: fish.id, notes: "ns"}
        ]
      })

    assert %Tab{items: [item1, item2]} = Orders.get_tab(tab_id)
    assert %TabItem{menu_item_name: "Wine", quantity: 2, notes: nil} = item1
    assert item1.price == Decimal.new(30)
    assert %TabItem{menu_item_name: "Fish", quantity: 1, notes: "ns"} = item2
  end

  defp open_tab(_context) do
    {:ok, tab_id} = Orders.open_tab(%{table_number: 3})
    %{tab_id: tab_id}
  end
end
