defmodule Caffe.Ordering.UseCases.CancelOrderTest do
  use Caffe.UseCaseCase
  use Caffe.EventStoreCase

  alias Caffe.Ordering.UseCases.CancelOrder
  alias Caffe.Ordering
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Accounts.User

  describe "execute" do
    test "must change the order state" do
      cust = insert!(:customer)
      %{id: order_id} = place_order_as(cust)
      assert {:ok, _} = cancel_order(order_id, cust)
      assert %{state: "cancelled"} = Repo.get(Order, order_id)
    end

    test "must authorize the command" do
      [cust1, cust2] = insert!(2, :customer)
      %{id: order_id} = insert!(:order, customer_id: cust1.id)
      assert {:error, :unauthorized} = cancel_order(order_id, cust2)
    end

    def cancel_order(id, user) do
      %CancelOrder{user: user, id: id} |> Mediator.dispatch()
    end

    defp place_order_as(user, order_args \\ %{items: [%{menu_item_id: insert!(:drink).id}]}) do
      {:ok, order} = Ordering.place_order(order_args, user)
      order
    end
  end

  describe "authorization" do
    test "a customer can only cancel its orders" do
      user = %User{role: "customer", id: 1}
      assert Authorizer.authorize?(%CancelOrder{user: user, order: %Order{customer_id: 1}})
      refute Authorizer.authorize?(%CancelOrder{user: user, order: %Order{customer_id: 2}})
    end

    test "employees can cancel all orders" do
      user = %User{role: "waitstaff", id: 1}
      assert Authorizer.authorize?(%CancelOrder{user: user, order: %Order{customer_id: 2}})
    end

    test "only pending orders can be cancelled" do
      user = build(:admin)
      refute Authorizer.authorize?(%CancelOrder{user: user, order: %Order{state: "cancelled"}})
      refute Authorizer.authorize?(%CancelOrder{user: user, order: %Order{state: "paid"}})
    end
  end
end
