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

  describe "mark_items_served" do
    test "only the waitstaff can do it" do
      assert Authorizer.authorize?(:mark_items_served, %User{role: "waitstaff"}, %Order{})
      refute Authorizer.authorize?(:mark_items_served, %User{role: "customer"}, %Order{})
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

  describe "list_orders" do
    test "only logged-in users view orders" do
      assert Authorizer.authorize?(:list_orders, %User{})
      refute Authorizer.authorize?(:list_orders, nil)
    end
  end

  describe "get_stats" do
    test "customers can't view the stats" do
      assert Authorizer.authorize?(:get_stats, %User{role: "admin"})
      refute Authorizer.authorize?(:get_stats, %User{role: "customer"})
      refute Authorizer.authorize?(:get_stats, nil)
    end
  end
end
