defmodule Caffe.Ordering.Queries.KitchenOrdersQueryTest do
  use Caffe.DataCase, async: true

  alias Caffe.Ordering

  setup do
    [
      fish: %{menu_item_name: "Fish", state: "pending", is_drink: false},
      burger: %{menu_item_name: "Burger", state: "pending", is_drink: false},
      wine: %{menu_item_name: "Wine", state: "pending", is_drink: true}
    ]
  end

  test "returns the orders that have at least one food pending/preparing item", %{
    fish: fish,
    burger: burger,
    wine: wine
  } do
    o1 = insert!(:order, items: [%{fish | state: "pending"}, %{burger | state: "served"}])
    _o2 = insert!(:order, items: [%{burger | state: "served"}])
    _o3 = insert!(:order, items: [%{wine | state: "pending"}])
    o4 = insert!(:order, items: [%{fish | state: "preparing"}, %{burger | state: "preparing"}])

    assert_contain_exactly [o1, o4], kitchen_orders(), by: :id
  end

  test "preloads the filtered items as well", %{fish: fish, burger: burger, wine: wine} do
    insert!(:order, items: [fish, burger, wine])

    assert [%{items: [%{menu_item_name: "Burger"}, %{menu_item_name: "Fish"}]}] = kitchen_orders()
  end

  test "only open orders are fetched", %{fish: fish} do
    insert!(:order, state: "cancelled", items: [fish])
    assert [] == kitchen_orders()
  end

  defp kitchen_orders do
    Ordering.list_kitchen_orders(build(:admin))
  end
end
