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
    assert_contain_exactly [o1, o4], waitstaff_orders(), by: :id
  end

  test "sorts the items putting drinks first and then the food", %{fish: fish, wine: wine} do
    insert!(:order, items: [fish, wine])
    insert!(:order, items: [wine, fish])

    assert [
             %{items: [%{menu_item_name: "Wine"}, %{menu_item_name: "Fish"}]},
             %{items: [%{menu_item_name: "Wine"}, %{menu_item_name: "Fish"}]}
           ] = waitstaff_orders()
  end

  defp waitstaff_orders do
    Ordering.list_waitstaff_orders(build(:admin))
  end
end
