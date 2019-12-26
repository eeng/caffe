defmodule Caffe.Authorization.Policies.AccountsPolicyTest do
  use ExUnit.Case, async: true

  alias Caffe.Authorization.Authorizer
  alias Caffe.Accounts.User

  test "only admins can list users" do
    assert Authorizer.authorize?(:list_users, %User{role: "admin"})
    refute Authorizer.authorize?(:list_users, %User{role: "customer"})
    refute Authorizer.authorize?(:list_users, %User{role: "waitstaff"})
  end
end
