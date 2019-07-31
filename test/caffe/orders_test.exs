defmodule Caffe.OrdersTest do
  use Caffe.EventStoreCase

  alias Caffe.Orders

  setup :open_tab

  test "open tab", %{tab_id: tab_id} do
    assert tab_id
  end

  test "place order", %{tab_id: tab_id} do
    wine = insert!(:menu_item, name: "Wine", is_drink: true)
    fish = insert!(:menu_item, name: "Fish", is_drink: false)

    :ok =
      Orders.place_order(%{
        tab_id: tab_id,
        items: [%{menu_item_id: wine.id}, %{menu_item_id: fish.id}]
      })

    # TODO check projections
  end

  defp open_tab(_context) do
    {:ok, tab_id} = Orders.open_tab(%{table_number: 3})
    %{tab_id: tab_id}
  end
end
