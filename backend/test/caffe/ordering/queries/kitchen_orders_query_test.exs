defmodule Caffe.Ordering.Queries.KitchenOrdersQueryTest do
  use Caffe.DataCase, async: true

  alias Caffe.Ordering

  setup do
    [
      fish: insert!(:menu_item, name: "Fish", is_drink: false).id,
      burger: insert!(:menu_item, name: "Burger", is_drink: false).id,
      wine: insert!(:menu_item, name: "Wine", is_drink: true).id
    ]
  end

  test "returns the orders that have at least one food pending/preparing item", %{
    fish: fish,
    burger: burger,
    wine: wine
  } do
    o1 =
      insert!(:order,
        items: [
          %{menu_item_id: fish, state: "pending"},
          %{menu_item_id: burger, state: "served"}
        ]
      )

    _o2 = insert!(:order, items: [%{menu_item_id: burger, state: "served"}])
    _o3 = insert!(:order, items: [%{menu_item_id: wine, state: "pending"}])

    o4 =
      insert!(:order,
        items: [
          %{menu_item_id: fish, state: "preparing"},
          %{menu_item_id: burger, state: "preparing"}
        ]
      )

    assert [o1.id, o4.id] == Ordering.kitchen_orders() |> Enum.map(& &1.id)
  end

  test "preloads the filtered items as well", %{fish: fish, burger: burger, wine: wine} do
    insert!(:order,
      items: [
        %{menu_item_id: fish, state: "pending"},
        %{menu_item_id: burger, state: "pending"},
        %{menu_item_id: wine, state: "pending"}
      ]
    )

    assert [%{items: [%{menu_item_id: fish}, %{menu_item_id: burger}]}] =
             Ordering.kitchen_orders()
  end

  test "only open orders are fetched", %{fish: fish} do
    insert!(:order, state: "cancelled", items: [%{menu_item_id: fish, state: "pending"}])
    assert [] == Ordering.kitchen_orders()
  end
end
