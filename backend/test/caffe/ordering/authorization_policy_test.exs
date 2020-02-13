defmodule Caffe.Ordering.AuthorizationPolicyTest do
  use ExUnit.Case, async: true

  import Caffe.Factory
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
    test "only the waitstaff and admin can do it" do
      assert Authorizer.authorize?(:mark_items_served, %User{role: "waitstaff"}, %Order{})
      assert Authorizer.authorize?(:mark_items_served, %User{role: "admin"}, %Order{})
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

    test "only pending orders can be cancelled" do
      user = build(:admin)
      refute Authorizer.authorize?(:cancel_order, user, %Order{state: "cancelled"})
      refute Authorizer.authorize?(:cancel_order, user, %Order{state: "paid"})
    end
  end

  describe "list_orders" do
    test "only logged-in users view orders" do
      assert Authorizer.authorize?(:list_orders, %User{})
      refute Authorizer.authorize?(:list_orders, nil)
    end
  end

  describe "list_kitchen_orders" do
    test "all employees except the waitstaff can view the kitchen's orders" do
      assert Authorizer.authorize?(:list_kitchen_orders, %User{role: "chef"})
      assert Authorizer.authorize?(:list_kitchen_orders, %User{role: "admin"})
      refute Authorizer.authorize?(:list_kitchen_orders, %User{role: "customer"})
      refute Authorizer.authorize?(:list_kitchen_orders, %User{role: "waitstaff"})
    end
  end

  describe "list_waitstaff_orders" do
    test "all employees except the chefs can view the waitstaff's orders" do
      refute Authorizer.authorize?(:list_waitstaff_orders, %User{role: "chef"})
      assert Authorizer.authorize?(:list_waitstaff_orders, %User{role: "admin"})
      refute Authorizer.authorize?(:list_waitstaff_orders, %User{role: "customer"})
      assert Authorizer.authorize?(:list_waitstaff_orders, %User{role: "waitstaff"})
    end
  end

  describe "serve_item" do
    test "a drink can be served on pending state" do
      user = %User{role: "waitstaff"}
      assert Authorizer.authorize?(:serve_item, user, %{is_drink: true, state: "pending"})
      refute Authorizer.authorize?(:serve_item, user, %{is_drink: true, state: "served"})
    end

    test "a food can be served on prepared state" do
      user = %User{role: "waitstaff"}
      assert Authorizer.authorize?(:serve_item, user, %{is_drink: false, state: "prepared"})
      refute Authorizer.authorize?(:serve_item, user, %{is_drink: false, state: "preparing"})
      refute Authorizer.authorize?(:serve_item, user, %{is_drink: false, state: "pending"})
      refute Authorizer.authorize?(:serve_item, user, %{is_drink: false, state: "served"})
    end
  end

  describe "get_stats" do
    test "customers can't view the stats" do
      assert Authorizer.authorize?(:get_stats, %User{role: "admin"})
      refute Authorizer.authorize?(:get_stats, %User{role: "customer"})
      refute Authorizer.authorize?(:get_stats, nil)
    end
  end

  describe "get_activity_feed" do
    test "customers and guests can't view activities" do
      refute Authorizer.authorize?(:get_activity_feed, %User{role: "customer"})
      refute Authorizer.authorize?(:get_activity_feed, nil)
    end

    test "employees can view them" do
      assert Authorizer.authorize?(:get_activity_feed, %User{role: "cashier"})
      assert Authorizer.authorize?(:get_activity_feed, %User{role: "admin"})
    end
  end
end
