defmodule Caffe.Ordering.UseCases.PlaceOrderTest do
  use Caffe.UseCaseCase
  use Caffe.EventStoreCase

  alias Caffe.Ordering.UseCases.PlaceOrder
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Accounts.User

  describe "execute" do
    test "as a customer" do
      %{id: customer_id} = user = insert!(:customer)

      wine = insert!(:drink, name: "Wine")
      fish = insert!(:food, name: "Fish", price: 40)

      {:ok, order} =
        place_order(
          %{items: [%{menu_item_id: wine.id, quantity: 2}, %{menu_item_id: fish.id}]},
          user
        )

      assert %Order{customer_id: ^customer_id, items: [item1, item2]} = order

      assert %{menu_item_id: wine.id, menu_item_name: "Wine", quantity: 2} ==
               Map.take(item1, ~w[menu_item_id menu_item_name quantity]a)

      assert %{menu_item_id: fish.id, price: Decimal.new(40), quantity: 1} ==
               Map.take(item2, ~w[menu_item_id price quantity]a)
    end

    test "as an employee" do
      user = insert!(:user, role: "cashier")
      wine = insert!(:drink, name: "Wine")

      {:ok, order} =
        place_order(
          %{
            customer_name: "Mary",
            items: [%{menu_item_id: wine.id}]
          },
          user
        )

      assert %Order{customer_id: nil, customer_name: "Mary", items: [_]} = order
    end

    test "authorizes the command" do
      assert {:error, :unauthorized} = place_order(%{}, nil)
    end

    def place_order(params, user) do
      %PlaceOrder{user: user, params: params} |> Mediator.dispatch()
    end
  end

  describe "authorize" do
    test "any authenticated user can place an order" do
      assert Authorizer.authorize?(%PlaceOrder{user: %User{}})
      refute Authorizer.authorize?(%PlaceOrder{user: nil})
    end
  end
end
