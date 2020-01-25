defmodule Caffe.Accounts.AuthorizationPolicyTest do
  use ExUnit.Case, async: true

  alias Caffe.Authorization.Authorizer
  alias Caffe.Accounts.User

  test "logged in users can see their profiles" do
    assert Authorizer.authorize?(:me, %User{role: "customer"})
    refute Authorizer.authorize?(:me, nil)
  end

  test "only admins can list users" do
    assert Authorizer.authorize?(:list_users, %User{role: "admin"})
    refute Authorizer.authorize?(:list_users, %User{role: "customer"})
    refute Authorizer.authorize?(:list_users, %User{role: "waitstaff"})
  end
end
