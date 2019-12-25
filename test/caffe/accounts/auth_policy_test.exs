defmodule Caffe.Accounts.AuthPolicyTest do
  use ExUnit.Case, async: true

  alias Caffe.Accounts.{User, AuthPolicy}
  alias Caffe.Support.Authorizer

  test "only admins can list users" do
    assert Authorizer.authorize?(AuthPolicy, :list_users, %User{role: "admin"})
    refute Authorizer.authorize?(AuthPolicy, :list_users, %User{role: "customer"})
    refute Authorizer.authorize?(AuthPolicy, :list_users, %User{role: "waitstaff"})
  end
end
