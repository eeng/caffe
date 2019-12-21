defmodule Caffe.OrderingTest do
  use Caffe.EventStoreCase
  alias Caffe.Ordering
  alias Caffe.Ordering.Projections.Order

  describe "placing an order" do
    test "as a customer" do
      %{id: customer_id} = insert!(:user, role: "customer")

      wine = insert!(:drink, name: "Wine")
      fish = insert!(:food, name: "Fish", price: 40)

      {:ok, order} =
        Ordering.place_order(%{
          user_id: customer_id,
          items: [
            %{menu_item_id: wine.id, quantity: 2},
            %{menu_item_id: fish.id}
          ]
        })

      assert %Order{customer_id: ^customer_id, items: [item1, item2]} = order

      assert %{menu_item_id: wine.id, menu_item_name: "Wine", quantity: 2} ==
               Map.take(item1, ~w[menu_item_id menu_item_name quantity]a)

      assert %{menu_item_id: fish.id, price: Decimal.new(40), quantity: 1} ==
               Map.take(item2, ~w[menu_item_id price quantity]a)
    end

    test "as an employee" do
      %{id: employee_id} = insert!(:user, role: "cashier")
      wine = insert!(:drink, name: "Wine")

      {:ok, order} =
        Ordering.place_order(%{
          user_id: employee_id,
          customer_name: "Mary",
          items: [%{menu_item_id: wine.id}]
        })

      assert %Order{customer_id: nil, customer_name: "Mary", items: [_]} = order
    end
  end

  test "cooking, serving and paying an order" do
    user = insert!(:user, role: "customer")
    wine = insert!(:drink, name: "Wine", price: 10)
    fish = insert!(:food, name: "Fish", price: 20)

    {:ok, %{id: order_id}} =
      Ordering.place_order(%{
        user_id: user.id,
        items: [%{menu_item_id: wine.id}, %{menu_item_id: fish.id}]
      })

    :ok = Ordering.mark_items_served(%{order_id: order_id, item_ids: [wine.id]})
    :ok = Ordering.begin_food_preparation(%{order_id: order_id, item_ids: [fish.id]})
    :ok = Ordering.mark_food_prepared(%{order_id: order_id, item_ids: [fish.id]})
    :ok = Ordering.mark_items_served(%{order_id: order_id, item_ids: [fish.id]})

    {:error, :must_pay_enough} = Ordering.pay_order(%{order_id: order_id, amount_paid: 29})
    :ok = Ordering.pay_order(%{order_id: order_id, amount_paid: 30})
  end
end
