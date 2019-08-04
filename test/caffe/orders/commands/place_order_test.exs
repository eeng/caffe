defmodule Caffe.Orders.Commands.PlaceOrderTest do
  use Caffe.CommandCase

  alias Caffe.Orders.Commands.PlaceOrder

  describe "validations" do
    test "should have at least one item" do
      assert PlaceOrder.new(items: []) |> has_error_on?(:items)
      refute PlaceOrder.new(items: [%{}]) |> has_error_on?(:items)
    end

    test "should validate the items" do
      assert PlaceOrder.new(items: [%{quantity: -1}]) |> has_error_on?(:items)
    end
  end
end
