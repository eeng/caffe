defmodule Caffe.OrderingTest do
  use Caffe.DataCase
  use Caffe.EventStoreCase

  alias Caffe.Ordering

  test "cooking, serving and paying an order" do
    cust = insert!(:customer)
    waitstaff = insert!(:waitstaff)
    chef = insert!(:chef)
    cashier = insert!(:cashier)

    wine = insert!(:drink, name: "Wine", price: 10)
    fish = insert!(:food, name: "Fish", price: 20)

    {:ok, %{id: order_id}} =
      Ordering.place_order(
        %{items: [%{menu_item_id: wine.id}, %{menu_item_id: fish.id}]},
        cust
      )

    {:ok, _} = Ordering.mark_items_served(%{order_id: order_id, item_ids: [wine.id]}, waitstaff)
    {:ok, _} = Ordering.begin_food_preparation(%{order_id: order_id, item_ids: [fish.id]}, chef)
    {:ok, _} = Ordering.mark_food_prepared(%{order_id: order_id, item_ids: [fish.id]}, chef)
    {:ok, _} = Ordering.mark_items_served(%{order_id: order_id, item_ids: [fish.id]}, waitstaff)

    {:error, :must_pay_enough} =
      Ordering.pay_order(%{order_id: order_id, amount_paid: 29}, cashier)

    {:ok, _} = Ordering.pay_order(%{order_id: order_id, amount_paid: 30}, cashier)
  end
end
