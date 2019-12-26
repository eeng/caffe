defmodule Caffe.Authorization.Policies.OrderingPolicyTest do
  use Caffe.DataCase, async: true

  alias Caffe.Authorization.Authorizer
  alias Caffe.Accounts.User
  alias Caffe.Ordering.Projections.Order

  describe "place_order" do
    test "any authenticated user can place an order" do
      assert Authorizer.authorize?(:place_order, %User{})
      refute Authorizer.authorize?(:place_order, nil)
    end
  end

  describe "cancel_order" do
    test "a customer can only cancel its orders" do
      user = %User{role: "customer", id: 1}
      assert Authorizer.authorize?(:cancel_order, user, %Order{customer_id: 1})
      refute Authorizer.authorize?(:cancel_order, user, %Order{customer_id: 2})
    end

    test "employees can cancel all orders" do
      user = %User{role: "waitstaff", id: 1}
      assert Authorizer.authorize?(:cancel_order, user, %Order{customer_id: 2})
    end

    test "if params is a map with the order_id it should retrieve the order from the DB" do
      user = insert!(:customer)
      %{id: order_id} = insert!(:order, customer_id: user.id)
      assert Authorizer.authorize?(:cancel_order, user, %{order_id: order_id})
    end
  end
end
