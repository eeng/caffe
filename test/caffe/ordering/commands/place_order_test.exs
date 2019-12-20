defmodule Caffe.Ordering.Commands.PlaceOrderTest do
  use ExUnit.Case, async: true

  import Caffe.Support.Validation
  alias Caffe.Ordering.Commands.PlaceOrder

  describe "validations" do
    test "the user who places the order is required" do
      assert %{user_id: ["can't be blank"]} = errors_on(PlaceOrder, %{user_id: nil})
    end

    test "should have at least one item" do
      assert %{items: ["can't be blank"]} = errors_on(PlaceOrder, %{items: []})
    end

    test "should validate the items" do
      errors = errors_on(PlaceOrder, %{items: [%{quantity: 1}, %{quantity: 0}]})
      assert %{items: [%{}, %{quantity: ["must be greater than 0"]}]} = errors
    end
  end
end
