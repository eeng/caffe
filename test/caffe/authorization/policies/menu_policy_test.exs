defmodule Caffe.Authorization.Policies.MenuPolicyTest do
  use ExUnit.Case, async: true

  alias Caffe.Authorization.Authorizer
  alias Caffe.Accounts.User

  test "only admins can create menu items" do
    assert Authorizer.authorize?(:create_menu_item, %User{role: "admin"})
    refute Authorizer.authorize?(:create_menu_item, %User{role: "customer"})
    refute Authorizer.authorize?(:create_menu_item, %User{role: "waitstaff"})
    refute Authorizer.authorize?(:create_menu_item, nil)
  end

  test "only admins can update menu items" do
    assert Authorizer.authorize?(:update_menu_item, %User{role: "admin"})
    refute Authorizer.authorize?(:update_menu_item, %User{role: "customer"})
    refute Authorizer.authorize?(:update_menu_item, %User{role: "waitstaff"})
  end

  test "only admins can delete menu items" do
    assert Authorizer.authorize?(:delete_menu_item, %User{role: "admin"})
    refute Authorizer.authorize?(:delete_menu_item, %User{role: "customer"})
    refute Authorizer.authorize?(:delete_menu_item, %User{role: "waitstaff"})
  end
end
