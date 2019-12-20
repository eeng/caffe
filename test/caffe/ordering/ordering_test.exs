defmodule Caffe.OrderingTest do
  use Caffe.EventStoreCase
  alias Caffe.Ordering
  alias Caffe.Ordering.Projections.Order

  describe "place_order" do
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
          items: [%{menu_item_id: wine.id}]
        })

      assert %Order{customer_id: nil, items: [_]} = order
    end
  end
end
