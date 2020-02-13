defmodule Caffe.Ordering.UseCases.GetOrderTest do
  use Caffe.UseCaseCase
  alias Caffe.Ordering
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Ordering.UseCases.GetOrder
  alias Caffe.Accounts.User

  describe "execute" do
    test "returns the order" do
      %{id: order_id} = insert!(:order)
      assert {:ok, %{id: ^order_id}} = Ordering.get_order(order_id, build(:admin))
    end

    test "must authorize the command" do
      [cust1, cust2] = insert!(2, :customer)
      %{id: order_id} = insert!(:order, customer_id: cust1.id)
      assert {:error, :unauthorized} = Ordering.get_order(order_id, cust2)
    end
  end

  describe "authorize" do
    test "customers can only view their orders" do
      user = %User{role: "customer", id: 1}
      assert Authorizer.authorize?(%GetOrder{user: user, order: %Order{customer_id: 1}})
      refute Authorizer.authorize?(%GetOrder{user: user, order: %Order{customer_id: 2}})
    end
  end
end
