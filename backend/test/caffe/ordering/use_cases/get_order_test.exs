defmodule Caffe.Ordering.UseCases.GetOrderTest do
  use Caffe.UseCaseCase

  alias Caffe.Ordering

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
end
