defmodule Caffe.Menu.AuthPolicyTest do
  use ExUnit.Case, async: true

  alias Caffe.Support.Authorizer
  alias Caffe.Accounts.User
  alias Caffe.Menu.AuthPolicy

  test "only admins can create menu items" do
    assert Authorizer.authorize?(AuthPolicy, :create_menu_item, %User{role: "admin"})
    refute Authorizer.authorize?(AuthPolicy, :create_menu_item, %User{role: "customer"})
    refute Authorizer.authorize?(AuthPolicy, :create_menu_item, %User{role: "waitstaff"})
    refute Authorizer.authorize?(AuthPolicy, :create_menu_item, nil)
  end

  test "only admins can update menu items" do
    assert Authorizer.authorize?(AuthPolicy, :update_menu_item, %User{role: "admin"})
    refute Authorizer.authorize?(AuthPolicy, :update_menu_item, %User{role: "customer"})
    refute Authorizer.authorize?(AuthPolicy, :update_menu_item, %User{role: "waitstaff"})
  end

  test "only admins can delete menu items" do
    assert Authorizer.authorize?(AuthPolicy, :delete_menu_item, %User{role: "admin"})
    refute Authorizer.authorize?(AuthPolicy, :delete_menu_item, %User{role: "customer"})
    refute Authorizer.authorize?(AuthPolicy, :delete_menu_item, %User{role: "waitstaff"})
  end
end
