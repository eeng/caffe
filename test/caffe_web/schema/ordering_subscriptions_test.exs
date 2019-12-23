defmodule CaffeWeb.Schema.OrderingSubscriptionsTest do
  use CaffeWeb.SubscriptionCase

  @subscription """
  subscription {
    newOrder { id }
  }
  """
  @mutation """
  mutation ($items: [OrderItemInput]) {
    placeOrder(items: $items) { id }
  }
  """
  describe "newOrder subscription" do
    test "should trigger the subscription every time an order is placed" do
      user = insert!(:waitstaff)
      {:ok, %{subscriptionId: subscription_id}} = subscribe_as(user, @subscription)

      {:ok, %{data: %{"placeOrder" => %{"id" => order_id}}}} = place_order(user)

      assert_push "subscription:data", %{
        result: %{data: %{"newOrder" => %{"id" => ^order_id}}},
        subscriptionId: ^subscription_id
      }
    end

    test "customers can't see other customer orders" do
      cust1 = insert!(:customer)
      cust2 = insert!(:customer)
      subscribe_as(cust1, @subscription)

      place_order(cust1)
      assert_push "subscription:data", _

      place_order(cust2)
      refute_receive _
    end

    test "non-authenticated users can't see any orders" do
      assert {:error, %{errors: [%{message: :unauthorized}]}} =
               subscribe_as(:guest, @subscription)
    end

    defp place_order(user) do
      Absinthe.run(@mutation, CaffeWeb.Schema,
        context: %{current_user: user},
        variables: %{"items" => [%{"menu_item_id" => insert!(:drink).id, "quantity" => 1}]}
      )
    end
  end
end
