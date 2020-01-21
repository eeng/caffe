defmodule Caffe.Ordering.Queries.WaitstaffOrdersQueryTest do
  use Caffe.DataCase, async: true

  alias Caffe.Ordering

  setup do
    [
      fish: %{menu_item_name: "Fish", state: "pending", is_drink: false},
      wine: %{menu_item_name: "Wine", state: "pending", is_drink: true}
    ]
  end

  test "returns all open orders", %{fish: fish} do
    o1 = insert!(:order, state: "pending", items: [fish])
    insert!(:order, state: "paid", items: [fish])
    insert!(:order, state: "cancelled", items: [fish])
    o4 = insert!(:order, state: "served", items: [fish])
    assert [o1.id, o4.id] == Ordering.waitstaff_orders() |> Enum.map(& &1.id)
  end

  test "sorts the items putting drinks first and then the food", %{fish: fish, wine: wine} do
    insert!(:order, items: [fish, wine])
    insert!(:order, items: [wine, fish])

    assert [
             %{items: [%{menu_item_name: "Wine"}, %{menu_item_name: "Fish"}]},
             %{items: [%{menu_item_name: "Wine"}, %{menu_item_name: "Fish"}]}
           ] = Ordering.waitstaff_orders()
  end
end
