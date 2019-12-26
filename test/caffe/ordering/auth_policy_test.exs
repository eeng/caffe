defmodule Caffe.Ordering.AuthPolicyTest do
  use ExUnit.Case, async: true

  alias Caffe.Accounts.User
  alias Caffe.Support.Authorizer
  alias Caffe.Ordering.AuthPolicy
  alias Caffe.Ordering.Projections.Order

  describe "cancel_order" do
    test "a customer can only cancel its orders" do
      user = %User{role: "customer", id: 1}
      assert authorize?(:cancel_order, user, %Order{customer_id: 1})
      refute authorize?(:cancel_order, user, %Order{customer_id: 2})
    end

    test "employees can cancel all orders" do
      assert authorize?(:cancel_order, %User{role: "waitstaff", id: 1}, %Order{customer_id: 2})
    end
  end

  defp authorize?(action, user, params) do
    Authorizer.authorize?(AuthPolicy, action, user, params)
  end
end
