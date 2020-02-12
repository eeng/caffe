defmodule Caffe.Ordering.UseCases.GetKitchenOrdersTest do
  use Caffe.UseCaseCase

  alias Caffe.Ordering.UseCases.GetKitchenOrders
  alias Caffe.Accounts.User

  describe "execute" do
    setup do
      [
        fish: %{menu_item_name: "Fish", state: "pending", is_drink: false},
        burger: %{menu_item_name: "Burger", state: "pending", is_drink: false},
        wine: %{menu_item_name: "Wine", state: "pending", is_drink: true}
      ]
    end

    test "returns the orders that have at least one food pending/preparing item", %{
      fish: fish,
      burger: burger,
      wine: wine
    } do
      o1 = insert!(:order, items: [%{fish | state: "pending"}, %{burger | state: "served"}])
      _o2 = insert!(:order, items: [%{burger | state: "served"}])
      _o3 = insert!(:order, items: [%{wine | state: "pending"}])
      o4 = insert!(:order, items: [%{fish | state: "preparing"}, %{burger | state: "preparing"}])

      assert_contain_exactly [o1, o4], kitchen_orders(), by: :id
    end

    test "preloads the filtered items as well", %{fish: fish, burger: burger, wine: wine} do
      insert!(:order, items: [fish, burger, wine])

      assert [%{items: [%{menu_item_name: "Burger"}, %{menu_item_name: "Fish"}]}] =
               kitchen_orders()
    end

    test "only open orders are fetched", %{fish: fish} do
      insert!(:order, state: "cancelled", items: [fish])
      assert [] == kitchen_orders()
    end

    defp kitchen_orders do
      with {:ok, orders} <- Caffe.Ordering.list_kitchen_orders(build(:admin)) do
        orders
      end
    end
  end

  describe "authorize" do
    test "all employees except the waitstaff can view the kitchen's orders" do
      assert Authorizer.authorize?(%GetKitchenOrders{user: %User{role: "chef"}})
      assert Authorizer.authorize?(%GetKitchenOrders{user: %User{role: "admin"}})
      refute Authorizer.authorize?(%GetKitchenOrders{user: %User{role: "customer"}})
      refute Authorizer.authorize?(%GetKitchenOrders{user: %User{role: "waitstaff"}})
    end
  end
end
