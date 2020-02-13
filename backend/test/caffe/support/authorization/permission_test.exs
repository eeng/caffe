defmodule Caffe.Authorization.PermissionTest do
  use ExUnit.Case, async: true
  import Caffe.Support.CustomAssertions
  alias Caffe.Authorization.Permission
  alias Caffe.Accounts.User

  describe "available_for" do
    test "returns a list of atoms representing authorized use cases" do
      assert_contain_exactly(
        ~w[place_order pay_order list_orders]a,
        Permission.available_for(%User{role: "customer"})
      )

      assert_contain_all(
        ~w[place_order list_orders list_kitchen_orders list_waitstaff_orders list_users get_activity_feed]a,
        Permission.available_for(%User{role: "admin"})
      )
    end
  end
end
