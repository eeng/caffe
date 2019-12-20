defmodule Caffe.OrderingTest do
  use Caffe.EventStoreCase
  alias Caffe.{Ordering, Repo}
  alias Caffe.Ordering.Projections.Order

  @moduletag :integration

  test "placing an order" do
    %{id: cust_id} = insert!(:user, role: "customer")

    wine = insert!(:drink, name: "Wine")
    fish = insert!(:food, name: "Fish", price: 40)
    salad = insert!(:food, name: "Salad")

    {:ok, order_id} =
      Ordering.place_order(%{
        user_id: cust_id,
        customer_id: cust_id,
        items: [
          %{menu_item_id: wine.id, quantity: 2},
          %{menu_item_id: fish.id, notes: "ns"},
          %{menu_item_id: salad.id}
        ]
      })

    assert %Order{customer_id: ^cust_id, items: [item1, item2, item3]} =
             Repo.get(Order, order_id) |> Repo.preload(:items)

    assert %{menu_item_id: wine.id, menu_item_name: "Wine", quantity: 2, notes: nil} ==
             Map.take(item1, ~w[menu_item_id menu_item_name quantity notes]a)

    assert %{menu_item_id: fish.id, price: Decimal.new(40), quantity: 1, notes: "ns"} ==
             Map.take(item2, ~w[menu_item_id price quantity notes]a)
  end
end
